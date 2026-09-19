package com.redtourism.controller;

import com.redtourism.common.Constants;
import com.redtourism.common.Result;
import com.redtourism.entity.SpotStamp;
import com.redtourism.entity.User;
import com.redtourism.service.StampService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/stamp")
public class StampController {

    @Autowired
    private StampService stampService;

    /** 打卡盖章：到访景点自动记录到访时间；重复到访只保留一枚章与原始到访时间 */
    @GetMapping("/checkin")
    public Result<Map<String, Object>> checkin(@RequestParam Long spotId, HttpSession session) {
        User current = (User) session.getAttribute(Constants.SESSION_USER);
        if (current == null) return Result.error(401, "未登录");
        SpotStamp stamp = stampService.checkin(current.getId(), spotId);
        Map<String, Object> data = new HashMap<>();
        data.put("spotId", stamp.getSpotId());
        data.put("spotName", stamp.getSpotName());
        data.put("theme", stamp.getTheme());
        data.put("visitTime", stamp.getVisitTime());
        data.put("isNew", Boolean.TRUE.equals(stamp.getNewStamp()));
        data.put("totalStamps", stampService.countUserStamps(current.getId()));
        String msg = Boolean.TRUE.equals(stamp.getNewStamp())
                ? "打卡成功，已盖章"
                : "该景点已盖章，保留首次到访时间";
        return Result.success(msg, data);
    }

    /** 查询当前用户在指定景点是否已盖章 */
    @GetMapping("/check")
    public Result<Map<String, Object>> check(@RequestParam Long spotId, HttpSession session) {
        User current = (User) session.getAttribute(Constants.SESSION_USER);
        if (current == null) return Result.error(401, "未登录");
        SpotStamp stamp = stampService.getStamp(current.getId(), spotId);
        Map<String, Object> data = new HashMap<>();
        data.put("stamped", stamp != null);
        data.put("visitTime", stamp != null ? stamp.getVisitTime() : null);
        return Result.success(data);
    }

    /** 我的盖章记录列表 */
    @GetMapping("/my")
    public Result<List<SpotStamp>> my(HttpSession session) {
        User current = (User) session.getAttribute(Constants.SESSION_USER);
        if (current == null) return Result.error(401, "未登录");
        return Result.success(stampService.listUserStamps(current.getId()));
    }

    /** 我的盖章总数（与后台用户列表的盖章数同一统计口径） */
    @GetMapping("/count")
    public Result<Long> count(HttpSession session) {
        User current = (User) session.getAttribute(Constants.SESSION_USER);
        if (current == null) return Result.error(401, "未登录");
        return Result.success(stampService.countUserStamps(current.getId()));
    }

    /** 按主题的集章进度（未完成主题含 remaining=还差几个） */
    @GetMapping("/progress")
    public Result<List<Map<String, Object>>> progress(HttpSession session) {
        User current = (User) session.getAttribute(Constants.SESSION_USER);
        if (current == null) return Result.error(401, "未登录");
        return Result.success(stampService.getThemeProgress(current.getId()));
    }

    /** 导出主题纪念册：format=image 导出图片，format=zip 打包下载 */
    @GetMapping("/album/export")
    public Result<Map<String, Object>> exportAlbum(@RequestParam String theme,
                                                   @RequestParam(required = false, defaultValue = "image") String format,
                                                   HttpSession session) {
        User current = (User) session.getAttribute(Constants.SESSION_USER);
        if (current == null) return Result.error(401, "未登录");
        String url = stampService.exportAlbum(current.getId(), theme, format);
        Map<String, Object> data = new HashMap<>();
        data.put("url", url);
        return Result.success("纪念册已生成", data);
    }

    /** 我的纪念册列表（已集满主题及其已生成的导出文件） */
    @GetMapping("/album/list")
    public Result<List<Map<String, Object>>> albums(HttpSession session) {
        User current = (User) session.getAttribute(Constants.SESSION_USER);
        if (current == null) return Result.error(401, "未登录");
        return Result.success(stampService.listAlbums(current.getId()));
    }
}
