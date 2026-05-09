package com.camping.life.redtour.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.camping.life.redtour.domain.RedAttraction;
import com.camping.life.redtour.domain.RouteAttractionRel;
import com.camping.life.redtour.domain.TravelRoute;
import com.camping.life.redtour.mapper.RedAttractionMapper;
import com.camping.life.redtour.mapper.RouteAttractionRelMapper;
import com.camping.life.redtour.mapper.TravelRouteMapper;
import com.camping.life.redtour.service.TravelRouteService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class TravelRouteServiceImpl implements TravelRouteService {

    @Autowired
    private TravelRouteMapper travelRouteMapper;
    @Autowired
    private RouteAttractionRelMapper routeAttractionRelMapper;
    @Autowired
    private RedAttractionMapper redAttractionMapper;

    private static final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public List<TravelRoute> listEnabled() {
        LambdaQueryWrapper<TravelRoute> q = new LambdaQueryWrapper<>();
        q.eq(TravelRoute::getStatus, 1)
         .orderByDesc(TravelRoute::getSort)
         .orderByDesc(TravelRoute::getCreateTime);
        return travelRouteMapper.selectList(q);
    }

    @Override
    public Map<String, Object> getDetail(Long id) {
        TravelRoute route = travelRouteMapper.selectById(id);
        if (route == null) return null;
        Map<String, Object> map = toMap(route);
        // 查询关联景点
        List<Map<String, Object>> attractions = getRouteAttractions(id);
        map.put("attractions", attractions);
        return map;
    }

    @Override
    public List<Map<String, Object>> getRouteAttractions(Long routeId) {
        LambdaQueryWrapper<RouteAttractionRel> q = new LambdaQueryWrapper<>();
        q.eq(RouteAttractionRel::getRouteId, routeId)
         .orderByAsc(RouteAttractionRel::getDayIndex)
         .orderByAsc(RouteAttractionRel::getVisitOrder);
        List<RouteAttractionRel> rels = routeAttractionRelMapper.selectList(q);

        List<Map<String, Object>> result = new ArrayList<>();
        for (RouteAttractionRel rel : rels) {
            RedAttraction attraction = redAttractionMapper.selectById(rel.getAttractionId());
            if (attraction != null) {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("relId", rel.getId());
                m.put("attractionId", attraction.getId());
                m.put("name", attraction.getName());
                m.put("coverImage", attraction.getCoverImage());
                m.put("province", attraction.getProvince());
                m.put("city", attraction.getCity());
                m.put("address", attraction.getAddress());
                m.put("dayIndex", rel.getDayIndex());
                m.put("visitOrder", rel.getVisitOrder());
                m.put("visitTime", rel.getVisitTime());
                m.put("stayDuration", rel.getStayDuration());
                m.put("memo", rel.getMemo());
                result.add(m);
            }
        }
        return result;
    }

    @Override
    public List<TravelRoute> pageList(String keyword, String theme, Integer pageNum, Integer pageSize) {
        Page<TravelRoute> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<TravelRoute> q = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) {
            q.and(w -> w.like(TravelRoute::getName, keyword)
                       .or().like(TravelRoute::getSummary, keyword));
        }
        if (StringUtils.hasText(theme)) {
            q.eq(TravelRoute::getTheme, theme);
        }
        q.orderByDesc(TravelRoute::getSort).orderByDesc(TravelRoute::getCreateTime);
        return travelRouteMapper.selectPage(page, q).getRecords();
    }

    @Override
    public boolean save(TravelRoute route) {
        route.setCreateTime(java.time.LocalDateTime.now());
        route.setUpdateTime(java.time.LocalDateTime.now());
        if (route.getViewCount() == null) route.setViewCount(0);
        if (route.getCollectCount() == null) route.setCollectCount(0);
        return travelRouteMapper.insert(route) > 0;
    }

    @Override
    public boolean updateById(TravelRoute route) {
        route.setUpdateTime(java.time.LocalDateTime.now());
        return travelRouteMapper.updateById(route) > 0;
    }

    @Override
    public boolean deleteById(Long id) {
        // 先删除关联
        routeAttractionRelMapper.delete(new LambdaQueryWrapper<RouteAttractionRel>()
            .eq(RouteAttractionRel::getRouteId, id));
        return travelRouteMapper.deleteById(id) > 0;
    }

    private Map<String, Object> toMap(TravelRoute r) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", r.getId());
        m.put("name", r.getName());
        m.put("coverImage", r.getCoverImage());
        m.put("images", parseJson(r.getImages(), new TypeReference<List<String>>() {}));
        m.put("theme", r.getTheme());
        m.put("durationDays", r.getDurationDays());
        m.put("groupSize", r.getGroupSize());
        m.put("price", r.getPrice());
        m.put("originalPrice", r.getOriginalPrice());
        m.put("summary", r.getSummary());
        m.put("highlights", parseJson(r.getHighlights(), new TypeReference<List<String>>() {}));
        m.put("included", parseJson(r.getIncluded(), new TypeReference<List<String>>() {}));
        m.put("excluded", parseJson(r.getExcluded(), new TypeReference<List<String>>() {}));
        m.put("tips", r.getTips());
        m.put("startLocation", r.getStartLocation());
        m.put("endLocation", r.getEndLocation());
        m.put("meetingAddress", r.getMeetingAddress());
        m.put("meetingTime", r.getMeetingTime());
        m.put("status", r.getStatus());
        m.put("sort", r.getSort());
        m.put("viewCount", r.getViewCount());
        m.put("collectCount", r.getCollectCount());
        m.put("createTime", r.getCreateTime());
        return m;
    }

    private <T> T parseJson(String json, TypeReference<T> typeRef) {
        if (!StringUtils.hasText(json)) return null;
        try { return objectMapper.readValue(json, typeRef); }
        catch (Exception e) { return null; }
    }
}
