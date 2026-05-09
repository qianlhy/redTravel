package com.camping.life.redtour.domain;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 旅游路线实体
 */
@Data
@TableName("travel_route")
public class TravelRoute implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private String name;
    private String coverImage;
    private String images;
    private String theme;
    /** 行程天数 */
    private Integer durationDays;
    /** 建议人数 */
    private Integer groupSize;
    /** 价格（元/人） */
    private BigDecimal price;
    private BigDecimal originalPrice;
    private String summary;
    /** JSON数组格式存储路线亮点 */
    private String highlights;
    /** JSON数组格式存储费用包含 */
    private String included;
    /** JSON数组格式存储费用不含 */
    private String excluded;
    /** 温馨提示 */
    private String tips;
    private String startLocation;
    private String endLocation;
    private String meetingAddress;
    private String meetingTime;
    private Integer status;
    private Integer sort;
    private Integer viewCount;
    private Integer collectCount;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer isDelete;
}
