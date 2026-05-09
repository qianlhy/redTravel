package com.camping.life.redtour.domain;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 轮播图配置实体
 */
@Data
@TableName("banner_config")
public class BannerConfig implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private String title;
    private String imageUrl;
    /** 跳转类型：attraction-景点, route-路线, custom-自定义URL, None-不跳转 */
    private String linkType;
    private String linkValue;
    private Integer sort;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer isDelete;
}
