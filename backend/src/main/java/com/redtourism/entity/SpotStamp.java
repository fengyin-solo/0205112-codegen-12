package com.redtourism.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.io.Serializable;
import java.util.Date;

@Data
@TableName("spot_stamp")
public class SpotStamp implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long spotId;
    private String theme;
    /** 首次到访时间（原始到访时间，重复打卡不更新） */
    private Date visitTime;
    @TableField(fill = FieldFill.INSERT)
    private Date createTime;

    /** 本次打卡是否为新盖章（false=重复到访，沿用原记录） */
    @TableField(exist = false)
    private Boolean newStamp;
    @TableField(exist = false)
    private String spotName;
    @TableField(exist = false)
    private String coverImage;
    @TableField(exist = false)
    private String region;
}
