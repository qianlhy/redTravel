package com.camping.life.redtour.domain;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 内容模块实体类 — 统一管理六个分类内容
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@TableName("content_block")
public class ContentBlock implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 主键ID */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 分类编码: zkaju|qflz|yffl|szxc|yxyp|swxl */
    private String category;

    /** 分类名称 */
    private String categoryName;

    /** 内容标题 */
    private String title;

    /** 副标题/简介 */
    private String subtitle;

    /** 富文本/详细内容 */
    private String content;

    /** 封面图片URL */
    private String coverImage;

    /** 多图JSON数组 */
    private String images;

    /** 作者/来源 */
    private String author;

    /** 来源单位 */
    private String source;

    /** 发布日期 */
    private LocalDate publishDate;

    /** 浏览量 */
    private Integer viewCount;

    /** 排序 */
    private Integer sort;

    /** 状态: 0=禁用, 1=启用 */
    private Integer status;

    /** 创建时间 */
    private LocalDateTime createTime;

    /** 更新时间 */
    private LocalDateTime updateTime;

    /** 逻辑删除: 0=未删除, 1=已删除 */
    @TableLogic
    private Integer isDelete;
}
