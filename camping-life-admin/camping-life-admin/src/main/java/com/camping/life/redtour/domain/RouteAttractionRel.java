package com.camping.life.redtour.domain;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 路线景点关联实体
 */
@Data
@TableName("route_attraction_rel")
public class RouteAttractionRel implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long routeId;
    private Long attractionId;
    /** 第几天 */
    private Integer dayIndex;
    /** 当天第几个景点 */
    private Integer visitOrder;
    private String visitTime;
    /** 停留时长（分钟） */
    private Integer stayDuration;
    private String memo;
    private LocalDateTime createTime;

    // ===== 非数据库字段 =====
    /** 关联的景点详情（JOIN查询时使用） */
    @TableField(exist = false)
    private RedAttraction attraction;
}
