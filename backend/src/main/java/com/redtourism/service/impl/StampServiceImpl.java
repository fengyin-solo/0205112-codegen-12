package com.redtourism.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.redtourism.common.Constants;
import com.redtourism.entity.ScenicSpot;
import com.redtourism.entity.SpotStamp;
import com.redtourism.entity.User;
import com.redtourism.mapper.ScenicSpotMapper;
import com.redtourism.mapper.SpotStampMapper;
import com.redtourism.mapper.UserMapper;
import com.redtourism.service.StampService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;
import org.springframework.util.StringUtils;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.AtomicMoveNotSupportedException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

@Slf4j
@Service
public class StampServiceImpl implements StampService {

    @Autowired
    private SpotStampMapper stampMapper;
    @Autowired
    private ScenicSpotMapper spotMapper;
    @Autowired
    private UserMapper userMapper;

    @Value("${upload.path}")
    private String uploadPath;

    /** 纪念册导出目录（位于 uploads 下，可通过 /uploads/albums/ 访问） */
    private static final String ALBUM_DIR = "albums";

    // ==================== 打卡盖章 ====================

    @Override
    public SpotStamp checkin(Long userId, Long spotId) {
        ScenicSpot spot = spotMapper.selectById(spotId);
        if (spot == null) {
            throw new RuntimeException("景点不存在");
        }
        SpotStamp existing = findStamp(userId, spotId);
        if (existing != null) {
            // 重复到访同一景点只保留一枚章，保留原始到访时间
            existing.setNewStamp(false);
            fillSpotInfo(existing, spot);
            return existing;
        }
        SpotStamp stamp = new SpotStamp();
        stamp.setUserId(userId);
        stamp.setSpotId(spotId);
        stamp.setTheme(spot.getTheme());
        stamp.setVisitTime(new Date());
        try {
            stampMapper.insert(stamp);
        } catch (DuplicateKeyException e) {
            // 并发重复打卡由唯一索引兜底：返回已存在记录，原始到访时间不变
            SpotStamp again = findStamp(userId, spotId);
            if (again != null) {
                again.setNewStamp(false);
                fillSpotInfo(again, spot);
                return again;
            }
            throw e;
        }
        stamp.setNewStamp(true);
        fillSpotInfo(stamp, spot);
        return stamp;
    }

    @Override
    public boolean hasStamped(Long userId, Long spotId) {
        return findStamp(userId, spotId) != null;
    }

    @Override
    public SpotStamp getStamp(Long userId, Long spotId) {
        SpotStamp stamp = findStamp(userId, spotId);
        if (stamp != null) {
            fillSpotInfo(stamp, spotMapper.selectById(spotId));
        }
        return stamp;
    }

    private SpotStamp findStamp(Long userId, Long spotId) {
        LambdaQueryWrapper<SpotStamp> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SpotStamp::getUserId, userId).eq(SpotStamp::getSpotId, spotId);
        return stampMapper.selectOne(wrapper);
    }

    @Override
    public List<SpotStamp> listUserStamps(Long userId) {
        LambdaQueryWrapper<SpotStamp> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SpotStamp::getUserId, userId).orderByAsc(SpotStamp::getVisitTime);
        List<SpotStamp> stamps = stampMapper.selectList(wrapper);
        if (!stamps.isEmpty()) {
            Set<Long> spotIds = stamps.stream().map(SpotStamp::getSpotId).collect(Collectors.toSet());
            Map<Long, ScenicSpot> spotMap = spotMapper.selectBatchIds(spotIds).stream()
                    .collect(Collectors.toMap(ScenicSpot::getId, Function.identity()));
            stamps.forEach(s -> fillSpotInfo(s, spotMap.get(s.getSpotId())));
        }
        return stamps;
    }

    private void fillSpotInfo(SpotStamp stamp, ScenicSpot spot) {
        if (spot == null) {
            return;
        }
        stamp.setSpotName(spot.getName());
        stamp.setCoverImage(spot.getCoverImage());
        stamp.setRegion(spot.getRegion());
        if (StringUtils.hasText(spot.getTheme())) {
            stamp.setTheme(spot.getTheme());
        }
    }

    // ==================== 统计（个人中心与后台共用同一口径：spot_stamp 表 COUNT） ====================

    @Override
    public long countUserStamps(Long userId) {
        LambdaQueryWrapper<SpotStamp> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SpotStamp::getUserId, userId);
        return stampMapper.selectCount(wrapper);
    }

    @Override
    public Map<Long, Long> countStampsGroupByUser() {
        QueryWrapper<SpotStamp> wrapper = new QueryWrapper<>();
        wrapper.select("user_id AS userId, COUNT(*) AS cnt").groupBy("user_id");
        List<Map<String, Object>> rows = stampMapper.selectMaps(wrapper);
        Map<Long, Long> result = new HashMap<>();
        for (Map<String, Object> row : rows) {
            Object uid = row.get("userId");
            Object cnt = row.get("cnt");
            if (uid instanceof Number && cnt instanceof Number) {
                result.put(((Number) uid).longValue(), ((Number) cnt).longValue());
            }
        }
        return result;
    }

    // ==================== 主题集章进度 ====================

    @Override
    public List<Map<String, Object>> getThemeProgress(Long userId) {
        // 上架景点按主题分组（主题全集以景点表现行为准，新增主题自动生效）
        LambdaQueryWrapper<ScenicSpot> spotQuery = new LambdaQueryWrapper<>();
        spotQuery.eq(ScenicSpot::getStatus, Constants.STATUS_ENABLED)
                .isNotNull(ScenicSpot::getTheme)
                .ne(ScenicSpot::getTheme, "");
        List<ScenicSpot> spots = spotMapper.selectList(spotQuery);

        Map<String, List<ScenicSpot>> byTheme = new TreeMap<>();
        for (ScenicSpot s : spots) {
            byTheme.computeIfAbsent(s.getTheme(), k -> new ArrayList<>()).add(s);
        }

        LambdaQueryWrapper<SpotStamp> stampQuery = new LambdaQueryWrapper<>();
        stampQuery.eq(SpotStamp::getUserId, userId);
        List<SpotStamp> stamps = stampMapper.selectList(stampQuery);
        Map<Long, Date> visitMap = new HashMap<>();
        for (SpotStamp st : stamps) {
            visitMap.put(st.getSpotId(), st.getVisitTime());
        }

        List<Map<String, Object>> result = new ArrayList<>();
        for (Map.Entry<String, List<ScenicSpot>> entry : byTheme.entrySet()) {
            List<ScenicSpot> themeSpots = entry.getValue();
            int total = themeSpots.size();
            int stamped = 0;
            List<Map<String, Object>> spotList = new ArrayList<>();
            for (ScenicSpot sp : themeSpots) {
                Date visit = visitMap.get(sp.getId());
                Map<String, Object> item = new LinkedHashMap<>();
                item.put("spotId", sp.getId());
                item.put("name", sp.getName());
                item.put("coverImage", sp.getCoverImage());
                item.put("stamped", visit != null);
                item.put("visitTime", visit);
                if (visit != null) {
                    stamped++;
                }
                spotList.add(item);
            }
            Map<String, Object> themeInfo = new LinkedHashMap<>();
            themeInfo.put("theme", entry.getKey());
            themeInfo.put("total", total);
            themeInfo.put("stamped", stamped);
            themeInfo.put("remaining", total - stamped);
            themeInfo.put("complete", total > 0 && stamped >= total);
            themeInfo.put("spots", spotList);
            result.add(themeInfo);
        }
        return result;
    }

    // ==================== 纪念册导出 ====================

    @Override
    public String exportAlbum(Long userId, String theme, String format) {
        if (!StringUtils.hasText(theme)) {
            throw new RuntimeException("主题不能为空");
        }
        boolean zip = "zip".equalsIgnoreCase(format);

        Map<String, Object> progress = null;
        for (Map<String, Object> p : getThemeProgress(userId)) {
            if (theme.equals(p.get("theme"))) {
                progress = p;
                break;
            }
        }
        if (progress == null) {
            throw new RuntimeException("主题不存在");
        }
        if (!Boolean.TRUE.equals(progress.get("complete"))) {
            throw new RuntimeException("「" + theme + "」主题还差 " + progress.get("remaining") + " 个景点未打卡，集满后才能生成纪念册");
        }

        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }

        // 该主题下已盖章的景点（按首次到访时间升序，与进度统计口径一致：按景点当前主题归属过滤）
        Set<Long> themeSpotIds = new HashSet<>();
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> progressSpots = (List<Map<String, Object>>) progress.get("spots");
        for (Map<String, Object> sp : progressSpots) {
            Object id = sp.get("spotId");
            if (id instanceof Number) {
                themeSpotIds.add(((Number) id).longValue());
            }
        }
        List<SpotStamp> themeStamps = listUserStamps(userId).stream()
                .filter(s -> themeSpotIds.contains(s.getSpotId()))
                .collect(Collectors.toList());

        String fileName = albumFileName(userId, theme, zip);
        try {
            Path dir = albumDir();
            Files.createDirectories(dir);
            Path target = dir.resolve(fileName);
            // 先写临时文件，完成后原子替换：导出中断不会留下损坏的目标文件，重新导出覆盖上一次结果
            Path tmp = Files.createTempFile(dir, ".tmp_", "_" + fileName);
            try {
                if (zip) {
                    writeAlbumZip(tmp, user, theme, themeStamps);
                } else {
                    ImageIO.write(renderAlbumImage(user, theme, themeStamps), "png", tmp.toFile());
                }
                moveAtomically(tmp, target);
            } catch (Exception e) {
                try {
                    Files.deleteIfExists(tmp);
                } catch (IOException ignore) {
                    // 临时文件清理失败不影响主流程
                }
                throw e;
            }
            log.info("纪念册导出成功: userId={}, theme={}, file={}", userId, theme, target);
            return "/uploads/" + ALBUM_DIR + "/" + fileName;
        } catch (IOException e) {
            log.error("纪念册导出失败: userId={}, theme={}, error={}", userId, theme, e.getMessage(), e);
            throw new RuntimeException("纪念册生成失败，请重试");
        }
    }

    @Override
    public List<Map<String, Object>> listAlbums(Long userId) {
        List<Map<String, Object>> albums = new ArrayList<>();
        Path dir = albumDir();
        for (Map<String, Object> p : getThemeProgress(userId)) {
            if (!Boolean.TRUE.equals(p.get("complete"))) {
                continue;
            }
            String theme = (String) p.get("theme");
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("theme", theme);
            String pngName = albumFileName(userId, theme, false);
            String zipName = albumFileName(userId, theme, true);
            putFileInfo(item, dir.resolve(pngName), "imageUrl", "imageTime", pngName);
            putFileInfo(item, dir.resolve(zipName), "zipUrl", "zipTime", zipName);
            albums.add(item);
        }
        return albums;
    }

    private void putFileInfo(Map<String, Object> item, Path file, String urlKey, String timeKey, String fileName) {
        if (Files.exists(file)) {
            item.put(urlKey, "/uploads/" + ALBUM_DIR + "/" + fileName);
            try {
                // 毫秒时间戳：前端既用于展示，也作为 URL 版本参数绕过静态资源缓存
                item.put(timeKey, Files.getLastModifiedTime(file).toMillis());
            } catch (IOException e) {
                item.put(timeKey, null);
            }
        }
    }

    /** 纪念册文件名固定（同一用户同一主题同一格式）：重新导出即覆盖上一次结果 */
    private String albumFileName(Long userId, String theme, boolean zip) {
        String themeHash = DigestUtils.md5DigestAsHex(theme.getBytes(StandardCharsets.UTF_8)).substring(0, 16);
        return "album_u" + userId + "_" + themeHash + (zip ? ".zip" : ".png");
    }

    private Path albumDir() {
        return Paths.get(uploadPath).toAbsolutePath().normalize().resolve(ALBUM_DIR);
    }

    private void moveAtomically(Path tmp, Path target) throws IOException {
        try {
            Files.move(tmp, target, StandardCopyOption.ATOMIC_MOVE, StandardCopyOption.REPLACE_EXISTING);
        } catch (AtomicMoveNotSupportedException e) {
            Files.move(tmp, target, StandardCopyOption.REPLACE_EXISTING);
        }
    }

    // ==================== 纪念册图片绘制 ====================

    private void writeAlbumZip(Path out, User owner, String theme, List<SpotStamp> stamps) throws IOException {
        ByteArrayOutputStream pngBytes = new ByteArrayOutputStream();
        ImageIO.write(renderAlbumImage(owner, theme, stamps), "png", pngBytes);

        String ownerName = displayName(owner);
        SimpleDateFormat dayFmt = new SimpleDateFormat("yyyy-MM-dd");
        StringBuilder txt = new StringBuilder();
        txt.append("贵州红色旅游 · 集章纪念册\r\n");
        txt.append("主题名称：").append(theme).append("\r\n");
        txt.append("持有者：").append(ownerName).append("\r\n");
        txt.append("导出时间：").append(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())).append("\r\n");
        txt.append("----------------------------------------\r\n");
        txt.append("景点列表（共 ").append(stamps.size()).append(" 个）\r\n");
        int i = 1;
        for (SpotStamp s : stamps) {
            txt.append(i++).append(". ").append(s.getSpotName() == null ? "" : s.getSpotName())
                    .append("    到访日期：").append(s.getVisitTime() != null ? dayFmt.format(s.getVisitTime()) : "--")
                    .append("\r\n");
        }

        try (ZipOutputStream zos = new ZipOutputStream(Files.newOutputStream(out), StandardCharsets.UTF_8)) {
            zos.putNextEntry(new ZipEntry("album.png"));
            zos.write(pngBytes.toByteArray());
            zos.closeEntry();
            zos.putNextEntry(new ZipEntry("album.txt"));
            zos.write(("\uFEFF" + txt.toString()).getBytes(StandardCharsets.UTF_8));
            zos.closeEntry();
        }
    }

    private BufferedImage renderAlbumImage(User owner, String theme, List<SpotStamp> stamps) {
        int width = 1080;
        int margin = 60;
        int bannerH = 200;
        int themeBlockH = 180;
        int rowH = 140;
        int footerH = 90;
        int height = bannerH + themeBlockH + rowH * stamps.size() + footerH;

        BufferedImage img = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = img.createGraphics();
        try {
            g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            g.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);

            // 米白纸张背景
            g.setColor(new Color(0xFC, 0xF9, 0xF2));
            g.fillRect(0, 0, width, height);

            // 顶部红色横幅
            g.setColor(new Color(0xC4, 0x1A, 0x1A));
            g.fillRect(0, 0, width, bannerH);
            g.setColor(new Color(0x8B, 0x1A, 0x1A));
            g.fillRect(0, bannerH - 12, width, 12);
            g.setColor(Color.WHITE);
            drawCentered(g, "贵州红色旅游 · 集章纪念册", width / 2, bannerH / 2 - 8, albumFont(Font.BOLD, 46));
            g.setColor(new Color(0xFF, 0xE0, 0xB2));
            drawCentered(g, "RED TOURISM STAMP ALBUM", width / 2, bannerH / 2 + 42, albumFont(Font.PLAIN, 20));

            // 主题与持有者
            int y = bannerH + 72;
            g.setColor(new Color(0x8B, 0x1A, 0x1A));
            drawCentered(g, "「" + theme + "」主题集章完成", width / 2, y, albumFont(Font.BOLD, 42));
            y += 54;
            g.setColor(new Color(0x55, 0x55, 0x55));
            SimpleDateFormat dayFmt = new SimpleDateFormat("yyyy-MM-dd");
            drawCentered(g, "持有者：" + displayName(owner) + "    完成日期：" + dayFmt.format(new Date()),
                    width / 2, y, albumFont(Font.PLAIN, 24));

            // 分隔线
            y += 34;
            g.setColor(new Color(0xE0, 0xD5, 0xC1));
            g.setStroke(new BasicStroke(2f));
            g.drawLine(margin, y, width - margin, y);

            // 景点印章列表：印章 + 景点名 + 到访日期
            int rowTop = y + 10;
            for (int i = 0; i < stamps.size(); i++) {
                SpotStamp s = stamps.get(i);
                int cy = rowTop + i * rowH + rowH / 2;
                drawStamp(g, margin + 70, cy, s.getSpotName(), s.getSpotId());
                g.setColor(new Color(0x33, 0x33, 0x33));
                g.setFont(albumFont(Font.BOLD, 30));
                g.drawString(s.getSpotName() == null ? "" : s.getSpotName(), margin + 160, cy - 6);
                g.setColor(new Color(0x88, 0x88, 0x88));
                g.setFont(albumFont(Font.PLAIN, 24));
                g.drawString("到访日期：" + (s.getVisitTime() != null ? dayFmt.format(s.getVisitTime()) : "--"),
                        margin + 160, cy + 34);
            }

            // 底部红色条
            g.setColor(new Color(0xC4, 0x1A, 0x1A));
            g.fillRect(0, height - footerH, width, footerH);
            g.setColor(Color.WHITE);
            drawCentered(g, "贵州红色文化旅游景点信息管理系统 · 生成于 "
                            + new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date()),
                    width / 2, height - footerH / 2 + 8, albumFont(Font.PLAIN, 22));
        } finally {
            g.dispose();
        }
        return img;
    }

    /** 绘制一枚圆形印章（红色双环 + 景点名，按景点 ID 微旋转模拟真实盖章） */
    private void drawStamp(Graphics2D g, int cx, int cy, String name, Long seed) {
        Graphics2D g2 = (Graphics2D) g.create();
        try {
            double angle = (((seed == null ? 7 : seed) * 37) % 21 - 10) * Math.PI / 180.0;
            g2.rotate(angle, cx, cy);
            int r = 52;
            g2.setColor(new Color(0xC4, 0x1A, 0x1A, 225));
            g2.setStroke(new BasicStroke(4f));
            g2.drawOval(cx - r, cy - r, r * 2, r * 2);
            g2.setStroke(new BasicStroke(1.5f));
            g2.drawOval(cx - r + 7, cy - r + 7, (r - 7) * 2, (r - 7) * 2);

            String text = name == null ? "" : name;
            if (text.length() > 4) {
                text = text.substring(0, 4);
            }
            int fs = text.length() <= 2 ? 30 : 24;
            g2.setFont(albumFont(Font.BOLD, fs));
            FontMetrics fm = g2.getFontMetrics();
            if (text.length() <= 2) {
                g2.drawString(text, cx - fm.stringWidth(text) / 2, cy + fm.getAscent() / 2 - 2);
            } else {
                String l1 = text.substring(0, (text.length() + 1) / 2);
                String l2 = text.substring((text.length() + 1) / 2);
                g2.drawString(l1, cx - fm.stringWidth(l1) / 2, cy - 2);
                g2.drawString(l2, cx - fm.stringWidth(l2) / 2, cy + fm.getHeight() - 10);
            }
        } finally {
            g2.dispose();
        }
    }

    private void drawCentered(Graphics2D g, String text, int cx, int cy, Font font) {
        g.setFont(font);
        FontMetrics fm = g.getFontMetrics();
        g.drawString(text, cx - fm.stringWidth(text) / 2, cy);
    }

    private String displayName(User user) {
        return StringUtils.hasText(user.getNickname()) ? user.getNickname() : user.getUsername();
    }

    // ==================== 中文字体（容器内无中文字体时自动回退） ====================

    private static volatile String cjkFontFamily;

    private static Font albumFont(int style, int size) {
        return new Font(cjkFontFamily(), style, size);
    }

    private static String cjkFontFamily() {
        String f = cjkFontFamily;
        if (f == null) {
            synchronized (StampServiceImpl.class) {
                f = cjkFontFamily;
                if (f == null) {
                    f = detectCjkFontFamily();
                    cjkFontFamily = f;
                }
            }
        }
        return f;
    }

    private static String detectCjkFontFamily() {
        String[] candidates = {
                "Noto Sans CJK SC", "Noto Serif CJK SC", "Noto Sans SC", "Source Han Sans SC",
                "WenQuanYi Micro Hei", "WenQuanYi Zen Hei",
                "Microsoft YaHei", "SimHei", "SimSun", "PingFang SC", "Hiragino Sans GB"
        };
        Set<String> available = new HashSet<>(Arrays.asList(
                GraphicsEnvironment.getLocalGraphicsEnvironment().getAvailableFontFamilyNames()));
        for (String c : candidates) {
            if (available.contains(c)) {
                return c;
            }
        }
        return Font.SANS_SERIF;
    }
}
