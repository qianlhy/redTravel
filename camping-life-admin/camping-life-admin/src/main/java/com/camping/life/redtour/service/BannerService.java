package com.camping.life.redtour.service;

import com.camping.life.redtour.domain.BannerConfig;
import java.util.List;

public interface BannerService {

    List<BannerConfig> listEnabled();

    boolean save(BannerConfig banner);

    boolean updateById(BannerConfig banner);

    boolean deleteById(Long id);
}
