package com.camping.life.redtour.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.camping.life.redtour.domain.BannerConfig;
import com.camping.life.redtour.mapper.BannerConfigMapper;
import com.camping.life.redtour.service.BannerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BannerServiceImpl implements BannerService {

    @Autowired
    private BannerConfigMapper bannerConfigMapper;

    @Override
    public List<BannerConfig> listEnabled() {
        LambdaQueryWrapper<BannerConfig> q = new LambdaQueryWrapper<>();
        q.eq(BannerConfig::getStatus, 1)
         .orderByAsc(BannerConfig::getSort)
         .orderByDesc(BannerConfig::getCreateTime);
        return bannerConfigMapper.selectList(q);
    }

    @Override
    public boolean save(BannerConfig banner) {
        banner.setCreateTime(java.time.LocalDateTime.now());
        banner.setUpdateTime(java.time.LocalDateTime.now());
        return bannerConfigMapper.insert(banner) > 0;
    }

    @Override
    public boolean updateById(BannerConfig banner) {
        banner.setUpdateTime(java.time.LocalDateTime.now());
        return bannerConfigMapper.updateById(banner) > 0;
    }

    @Override
    public boolean deleteById(Long id) {
        return bannerConfigMapper.deleteById(id) > 0;
    }
}
