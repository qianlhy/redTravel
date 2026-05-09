package com.camping.life.redtour.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.camping.life.redtour.domain.TeamBooking;
import com.camping.life.redtour.domain.TravelRoute;
import com.camping.life.redtour.mapper.TeamBookingMapper;
import com.camping.life.redtour.mapper.TravelRouteMapper;
import com.camping.life.redtour.service.DashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
public class DashboardServiceImpl implements DashboardService {

    @Autowired
    private TeamBookingMapper teamBookingMapper;
    @Autowired
    private TravelRouteMapper travelRouteMapper;

    @Override
    public Map<String, Object> getStats() {
        Map<String, Object> stats = new LinkedHashMap<>();

        // 今日新增预约数
        LocalDateTime todayStart = LocalDate.now().atStartOfDay();
        long todayBookings = teamBookingMapper.selectCount(
            new LambdaQueryWrapper<TeamBooking>()
                .ge(TeamBooking::getCreateTime, todayStart));
        stats.put("todayBookings", todayBookings);

        // 全部预约数
        long totalBookings = teamBookingMapper.selectCount(null);
        stats.put("totalBookings", totalBookings);

        // 待处理预约数（状态=0待确认）
        long pendingBookings = teamBookingMapper.selectCount(
            new LambdaQueryWrapper<TeamBooking>()
                .eq(TeamBooking::getStatus, 0));
        stats.put("pendingBookings", pendingBookings);

        // 已确认预约数（状态=1）
        long confirmedBookings = teamBookingMapper.selectCount(
            new LambdaQueryWrapper<TeamBooking>()
                .eq(TeamBooking::getStatus, 1));
        stats.put("confirmedBookings", confirmedBookings);

        // 已完成预约数（状态=3）
        long completedBookings = teamBookingMapper.selectCount(
            new LambdaQueryWrapper<TeamBooking>()
                .eq(TeamBooking::getStatus, 3));
        stats.put("completedBookings", completedBookings);

        // 已拒绝数（状态=2）
        long rejectedBookings = teamBookingMapper.selectCount(
            new LambdaQueryWrapper<TeamBooking>()
                .eq(TeamBooking::getStatus, 2));
        stats.put("rejectedBookings", rejectedBookings);

        // 已取消数（状态=4）
        long cancelledBookings = teamBookingMapper.selectCount(
            new LambdaQueryWrapper<TeamBooking>()
                .eq(TeamBooking::getStatus, 4));
        stats.put("cancelledBookings", cancelledBookings);

        // 路线总数
        long totalRoutes = travelRouteMapper.selectCount(null);
        stats.put("totalRoutes", totalRoutes);

        // 上架路线数
        long activeRoutes = travelRouteMapper.selectCount(
            new LambdaQueryWrapper<TravelRoute>()
                .eq(TravelRoute::getStatus, 1));
        stats.put("activeRoutes", activeRoutes);

        return stats;
    }

    @Override
    public List<Map<String, Object>> getBookingTrend(Integer days) {
        if (days == null || days <= 0) days = 7;
        List<Map<String, Object>> trend = new ArrayList<>();
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("MM-dd");
        for (int i = days - 1; i >= 0; i--) {
            LocalDate date = LocalDate.now().minusDays(i);
            LocalDateTime start = date.atStartOfDay();
            LocalDateTime end = date.plusDays(1).atStartOfDay();
            long count = teamBookingMapper.selectCount(
                new LambdaQueryWrapper<TeamBooking>()
                    .ge(TeamBooking::getCreateTime, start)
                    .lt(TeamBooking::getCreateTime, end));
            Map<String, Object> dayData = new LinkedHashMap<>();
            dayData.put("date", date.format(fmt));
            dayData.put("count", count);
            trend.add(dayData);
        }
        return trend;
    }
}
