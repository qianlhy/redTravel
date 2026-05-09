package com.camping.life.redtour.domain;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 团队预约实体
 */
@Data
@TableName("team_booking")
public class TeamBooking implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private String orderNo;
    private Long routeId;
    private String teamName;
    private String contactName;
    private String contactPhone;
    private String contactIdCard;
    private Integer teamSize;
    private LocalDate travelDate;
    private Integer durationDays;
    private String meetingAddress;
    private String meetingTime;
    /** 备注/特殊需求 */
    private String remark;
    /** 状态：0-待确认，1-已确认，2-已拒绝，3-已完成，4-已取消 */
    private Integer status;
    private String statusRemark;
    private LocalDateTime confirmTime;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer isDelete;

    // ===== 非数据库字段 =====
    @TableField(exist = false)
    private TravelRoute route;

    @TableField(exist = false)
    private String routeName;
}
