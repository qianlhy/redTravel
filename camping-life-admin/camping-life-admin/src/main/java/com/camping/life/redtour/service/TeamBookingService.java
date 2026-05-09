package com.camping.life.redtour.service;

import com.camping.life.redtour.domain.TeamBooking;
import java.util.List;
import java.util.Map;

public interface TeamBookingService {

    Map<String, Object> pageList(String status, String keyword, Integer pageNum, Integer pageSize);

    Map<String, Object> pageListByPhone(String phone);

    Map<String, Object> getDetail(Long id);

    boolean confirm(Long id, String remark);

    boolean reject(Long id, String remark);

    boolean complete(Long id);

    boolean cancel(Long id);

    Long submit(Map<String, Object> params);
}
