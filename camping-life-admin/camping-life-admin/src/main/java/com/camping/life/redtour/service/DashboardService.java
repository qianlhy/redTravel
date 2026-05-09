package com.camping.life.redtour.service;

import java.util.List;
import java.util.Map;

public interface DashboardService {

    Map<String, Object> getStats();

    List<Map<String, Object>> getBookingTrend(Integer days);
}
