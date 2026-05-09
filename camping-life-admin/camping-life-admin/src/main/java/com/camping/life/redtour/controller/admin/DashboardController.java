package com.camping.life.redtour.controller.admin;

import com.camping.life.common.Result;
import com.camping.life.redtour.service.DashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 数据看板接口（后台）
 */
@RestController
@RequestMapping("/admin/dashboard")
public class DashboardController {

    @Autowired
    private DashboardService dashboardService;

    @GetMapping("/stats")
    public Result<Map<String, Object>> stats() {
        return Result.success(dashboardService.getStats());
    }

    @GetMapping("/booking-trend")
    public Result<List<Map<String, Object>>> bookingTrend(
            @RequestParam(required = false, defaultValue = "7") Integer days) {
        return Result.success(dashboardService.getBookingTrend(days));
    }
}
