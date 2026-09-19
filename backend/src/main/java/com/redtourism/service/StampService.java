package com.redtourism.service;

import com.redtourism.entity.SpotStamp;

import java.util.List;
import java.util.Map;

public interface StampService {

    /**
     * 打卡盖章（幂等）：同一用户同一景点只盖一枚章。
     * 重复到访返回已存在的记录，保留原始 visitTime 不变。
     */
    SpotStamp checkin(Long userId, Long spotId);

    boolean hasStamped(Long userId, Long spotId);

    /** 查询用户在指定景点的盖章记录（未盖章返回 null，附带景点信息） */
    SpotStamp getStamp(Long userId, Long spotId);

    /** 我的盖章记录（按首次到访时间升序，附带景点名称/封面/地区） */
    List<SpotStamp> listUserStamps(Long userId);

    /** 用户盖章总数（个人中心与后台列表共用同一统计口径） */
    long countUserStamps(Long userId);

    /** 全部用户的盖章数分组统计（后台用户列表用） */
    Map<Long, Long> countStampsGroupByUser();

    /**
     * 按主题的集章进度：
     * [{theme, total, stamped, remaining, complete, spots:[{spotId, name, coverImage, stamped, visitTime}]}]
     */
    List<Map<String, Object>> getThemeProgress(Long userId);

    /**
     * 生成主题纪念册（需已集满该主题）。
     * 先写临时文件再原子替换目标文件：导出中断不会留下损坏文件，重新导出覆盖上一次结果。
     *
     * @param format image=PNG 图片 / zip=打包下载
     * @return 可访问的文件 URL（/uploads/albums/...）
     */
    String exportAlbum(Long userId, String theme, String format);

    /** 已集满主题的纪念册导出状态（文件是否已生成、生成时间） */
    List<Map<String, Object>> listAlbums(Long userId);
}
