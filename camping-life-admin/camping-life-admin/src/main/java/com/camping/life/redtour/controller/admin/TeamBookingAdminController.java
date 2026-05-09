package com.camping.life.redtour.controller.admin;

import com.camping.life.common.Result;
import com.camping.life.redtour.service.TeamBookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 团队预约管理接口（后台）
 */
@RestController
@RequestMapping("/admin/team-booking")
public class TeamBookingAdminController {

    @Autowired
    private TeamBookingService teamBookingService;

    @GetMapping("/list")
    public Result<Map<String, Object>> list(
            @RequestParam(required = false, defaultValue = "all") String status,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.success(teamBookingService.pageList(status, keyword, pageNum, pageSize));
    }

    @GetMapping("/detail/{id}")
    public Result<Object> detail(@PathVariable Long id) {
        return Result.success(teamBookingService.getDetail(id));
    }

    @PostMapping("/confirm/{id}")
    public Result<Void> confirm(@PathVariable Long id, @RequestParam(required = false) String remark) {
        teamBookingService.confirm(id, remark);
        return Result.success();
    }

    @PostMapping("/reject/{id}")
    public Result<Void> reject(@PathVariable Long id, @RequestParam String remark) {
        teamBookingService.reject(id, remark);
        return Result.success();
    }

    @PostMapping("/complete/{id}")
    public Result<Void> complete(@PathVariable Long id) {
        teamBookingService.complete(id);
        return Result.success();
    }

    @PostMapping("/cancel/{id}")
    public Result<Void> cancel(@PathVariable Long id) {
        teamBookingService.cancel(id);
        return Result.success();
    }
}
