package com.camping.life.redtour.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.camping.life.redtour.domain.RedAttraction;
import com.camping.life.redtour.domain.TravelRoute;
import com.camping.life.redtour.mapper.RedAttractionMapper;
import com.camping.life.redtour.mapper.TravelRouteMapper;
import com.camping.life.redtour.service.RedAttractionService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.*;

@Service
public class RedAttractionServiceImpl implements RedAttractionService {

    @Autowired
    private RedAttractionMapper redAttractionMapper;
    @Autowired
    private TravelRouteMapper travelRouteMapper;

    private static final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public List<RedAttraction> listEnabled() {
        LambdaQueryWrapper<RedAttraction> q = new LambdaQueryWrapper<>();
        q.eq(RedAttraction::getStatus, 1)
         .orderByDesc(RedAttraction::getSort)
         .orderByDesc(RedAttraction::getCreateTime);
        return redAttractionMapper.selectList(q);
    }

    @Override
    public Map<String, Object> getDetail(Long id) {
        RedAttraction attraction = redAttractionMapper.selectById(id);
        if (attraction == null) {
            return null;
        }
        Map<String, Object> map = toMap(attraction);
        // 查询关联路线数
        LambdaQueryWrapper<TravelRoute> q = new LambdaQueryWrapper<>();
        q.like(TravelRoute::getSummary, attraction.getName())
         .or()
         .like(TravelRoute::getHighlights, attraction.getName());
        map.put("routeCount", travelRouteMapper.selectCount(q));
        return map;
    }

    @Override
    public List<RedAttraction> pageList(String keyword, Integer pageNum, Integer pageSize) {
        Page<RedAttraction> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<RedAttraction> q = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) {
            q.and(w -> w.like(RedAttraction::getName, keyword)
                       .or().like(RedAttraction::getProvince, keyword)
                       .or().like(RedAttraction::getCity, keyword));
        }
        q.orderByDesc(RedAttraction::getSort).orderByDesc(RedAttraction::getCreateTime);
        return redAttractionMapper.selectPage(page, q).getRecords();
    }

    @Override
    public boolean save(RedAttraction attraction) {
        attraction.setCreateTime(java.time.LocalDateTime.now());
        attraction.setUpdateTime(java.time.LocalDateTime.now());
        return redAttractionMapper.insert(attraction) > 0;
    }

    @Override
    public boolean updateById(RedAttraction attraction) {
        attraction.setUpdateTime(java.time.LocalDateTime.now());
        return redAttractionMapper.updateById(attraction) > 0;
    }

    @Override
    public boolean deleteById(Long id) {
        return redAttractionMapper.deleteById(id) > 0;
    }

    private Map<String, Object> toMap(RedAttraction a) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", a.getId());
        m.put("name", a.getName());
        m.put("coverImage", a.getCoverImage());
        m.put("images", parseJson(a.getImages(), new TypeReference<List<String>>() {}));
        m.put("province", a.getProvince());
        m.put("city", a.getCity());
        m.put("district", a.getDistrict());
        m.put("address", a.getAddress());
        m.put("latitude", a.getLatitude());
        m.put("longitude", a.getLongitude());
        m.put("openTime", a.getOpenTime());
        m.put("ticketPrice", a.getTicketPrice());
        m.put("description", a.getDescription());
        m.put("historyStory", a.getHistoryStory());
        m.put("sort", a.getSort());
        m.put("status", a.getStatus());
        m.put("createTime", a.getCreateTime());
        return m;
    }

    private <T> T parseJson(String json, TypeReference<T> typeRef) {
        if (!StringUtils.hasText(json)) return null;
        try { return objectMapper.readValue(json, typeRef); }
        catch (Exception e) { return null; }
    }
}
