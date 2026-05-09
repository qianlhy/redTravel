package com.camping.life.redtour.service;

import com.camping.life.redtour.domain.TravelRoute;
import java.util.List;
import java.util.Map;

public interface TravelRouteService {

    List<TravelRoute> listEnabled();

    Map<String, Object> getDetail(Long id);

    List<TravelRoute> pageList(String keyword, String theme, Integer pageNum, Integer pageSize);

    boolean save(TravelRoute route);

    boolean updateById(TravelRoute route);

    boolean deleteById(Long id);

    List<Map<String, Object>> getRouteAttractions(Long routeId);
}
