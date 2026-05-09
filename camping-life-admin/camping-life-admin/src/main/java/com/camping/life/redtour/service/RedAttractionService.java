package com.camping.life.redtour.service;

import com.camping.life.redtour.domain.RedAttraction;
import java.util.List;
import java.util.Map;

public interface RedAttractionService {

    List<RedAttraction> listEnabled();

    Map<String, Object> getDetail(Long id);

    List<RedAttraction> pageList(String keyword, Integer pageNum, Integer pageSize);

    boolean save(RedAttraction attraction);

    boolean updateById(RedAttraction attraction);

    boolean deleteById(Long id);
}
