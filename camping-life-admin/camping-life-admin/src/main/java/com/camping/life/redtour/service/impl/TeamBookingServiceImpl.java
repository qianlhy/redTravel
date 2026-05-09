package com.camping.life.redtour.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.camping.life.redtour.domain.TeamBooking;
import com.camping.life.redtour.domain.TravelRoute;
import com.camping.life.redtour.mapper.TeamBookingMapper;
import com.camping.life.redtour.mapper.TravelRouteMapper;
import com.camping.life.redtour.service.TeamBookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class TeamBookingServiceImpl implements TeamBookingService {

    @Autowired
    private TeamBookingMapper teamBookingMapper;
    @Autowired
    private TravelRouteMapper travelRouteMapper;

    private static final DateTimeFormatter ORDER_FMT =
        DateTimeFormatter.ofPattern("yyyyMMddHHmmss");

    @Override
    public Map<String, Object> pageList(String status, String keyword, Integer pageNum, Integer pageSize) {
        Page<TeamBooking> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<TeamBooking> q = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(status) && !"all".equals(status)) {
            q.eq(TeamBooking::getStatus, Integer.valueOf(status));
        }
        if (StringUtils.hasText(keyword)) {
            q.and(w -> w.like(TeamBooking::getTeamName, keyword)
                       .or().like(TeamBooking::getContactName, keyword)
                       .or().like(TeamBooking::getContactPhone, keyword)
                       .or().like(TeamBooking::getOrderNo, keyword));
        }
        q.orderByDesc(TeamBooking::getCreateTime);
        Page<TeamBooking> result = teamBookingMapper.selectPage(page, q);

        // 填充路线名称
        for (TeamBooking b : result.getRecords()) {
            if (b.getRouteId() != null) {
                TravelRoute route = travelRouteMapper.selectById(b.getRouteId());
                if (route != null) {
                    b.setRoute(route);
                    b.setRouteName(route.getName());
                }
            }
        }

        Map<String, Object> resp = new LinkedHashMap<>();
        resp.put("list", result.getRecords());
        resp.put("total", result.getTotal());
        resp.put("pageNum", pageNum);
        resp.put("pageSize", pageSize);
        resp.put("pages", result.getPages());
        return resp;
    }

    @Override
    public Map<String, Object> getDetail(Long id) {
        TeamBooking booking = teamBookingMapper.selectById(id);
        if (booking == null) return null;
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", booking.getId());
        m.put("orderNo", booking.getOrderNo());
        m.put("routeId", booking.getRouteId());
        m.put("teamName", booking.getTeamName());
        m.put("contactName", booking.getContactName());
        m.put("contactPhone", booking.getContactPhone());
        m.put("contactIdCard", booking.getContactIdCard());
        m.put("teamSize", booking.getTeamSize());
        m.put("travelDate", booking.getTravelDate());
        m.put("durationDays", booking.getDurationDays());
        m.put("meetingAddress", booking.getMeetingAddress());
        m.put("meetingTime", booking.getMeetingTime());
        m.put("remark", booking.getRemark());
        m.put("status", booking.getStatus());
        m.put("statusRemark", booking.getStatusRemark());
        m.put("confirmTime", booking.getConfirmTime());
        m.put("createTime", booking.getCreateTime());
        if (booking.getRouteId() != null) {
            TravelRoute route = travelRouteMapper.selectById(booking.getRouteId());
            if (route != null) {
                m.put("route", route);
                m.put("routeName", route.getName());
            }
        }
        return m;
    }

    @Override
    public boolean confirm(Long id, String remark) {
        TeamBooking booking = new TeamBooking();
        booking.setId(id);
        booking.setStatus(1);
        booking.setConfirmTime(LocalDateTime.now());
        if (StringUtils.hasText(remark)) booking.setStatusRemark(remark);
        return teamBookingMapper.updateById(booking) > 0;
    }

    @Override
    public boolean reject(Long id, String remark) {
        TeamBooking booking = new TeamBooking();
        booking.setId(id);
        booking.setStatus(2);
        booking.setStatusRemark(remark);
        return teamBookingMapper.updateById(booking) > 0;
    }

    @Override
    public boolean complete(Long id) {
        TeamBooking booking = new TeamBooking();
        booking.setId(id);
        booking.setStatus(3);
        return teamBookingMapper.updateById(booking) > 0;
    }

    @Override
    public boolean cancel(Long id) {
        TeamBooking booking = new TeamBooking();
        booking.setId(id);
        booking.setStatus(4);
        return teamBookingMapper.updateById(booking) > 0;
    }

    @Override
    public Map<String, Object> pageListByPhone(String phone) {
        LambdaQueryWrapper<TeamBooking> q = new LambdaQueryWrapper<>();
        q.eq(TeamBooking::getContactPhone, phone)
         .orderByDesc(TeamBooking::getCreateTime);
        List<TeamBooking> records = teamBookingMapper.selectList(q);

        for (TeamBooking b : records) {
            if (b.getRouteId() != null) {
                TravelRoute route = travelRouteMapper.selectById(b.getRouteId());
                if (route != null) {
                    b.setRoute(route);
                    b.setRouteName(route.getName());
                }
            }
        }

        Map<String, Object> resp = new LinkedHashMap<>();
        resp.put("list", records);
        resp.put("total", records.size());
        return resp;
    }

    @Override
    public Long submit(Map<String, Object> params) {
        String teamName = (String) params.get("teamName");
        String contactName = (String) params.get("contactName");
        String contactPhone = (String) params.get("contactPhone");
        Integer teamSize = params.get("teamSize") != null
            ? Integer.valueOf(params.get("teamSize").toString()) : 0;

        if (!StringUtils.hasText(teamName) || !StringUtils.hasText(contactName)
            || !StringUtils.hasText(contactPhone)) {
            throw new com.camping.life.common.BizException(400, "请填写完整信息");
        }

        TeamBooking booking = new TeamBooking();
        booking.setOrderNo("TB" + LocalDateTime.now().format(ORDER_FMT));
        booking.setTeamName(teamName);
        booking.setContactName(contactName);
        booking.setContactPhone(contactPhone);
        if (params.get("contactIdCard") != null)
            booking.setContactIdCard((String) params.get("contactIdCard"));
        booking.setTeamSize(teamSize);
        if (params.get("travelDate") != null)
            booking.setTravelDate(java.time.LocalDate.parse(params.get("travelDate").toString()));
        if (params.get("meetingAddress") != null)
            booking.setMeetingAddress((String) params.get("meetingAddress"));
        if (params.get("meetingTime") != null)
            booking.setMeetingTime((String) params.get("meetingTime"));
        if (params.get("remark") != null)
            booking.setRemark((String) params.get("remark"));
        if (params.get("routeId") != null)
            booking.setRouteId(Long.valueOf(params.get("routeId").toString()));
        if (params.get("durationDays") != null)
            booking.setDurationDays(Integer.valueOf(params.get("durationDays").toString()));
        booking.setStatus(0);
        booking.setCreateTime(LocalDateTime.now());
        teamBookingMapper.insert(booking);
        return booking.getId();
    }
}
