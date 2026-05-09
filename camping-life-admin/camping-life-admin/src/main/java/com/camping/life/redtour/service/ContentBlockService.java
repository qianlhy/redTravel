package com.camping.life.redtour.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.camping.life.redtour.domain.ContentBlock;
import com.camping.life.redtour.mapper.ContentBlockMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * 内容模块 Service
 */
@Service
public class ContentBlockService {

    @Autowired
    private ContentBlockMapper contentBlockMapper;

    /** 分页查询（支持分类筛选 + 关键词搜索） */
    public IPage<ContentBlock> pageList(String category, String keyword, Integer pageNum, Integer pageSize) {
        Page<ContentBlock> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<ContentBlock> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StringUtils.hasText(category), ContentBlock::getCategory, category)
               .eq(ContentBlock::getStatus, 1)
               .like(StringUtils.hasText(keyword), ContentBlock::getTitle, keyword)
               .orderByDesc(ContentBlock::getSort)
               .orderByDesc(ContentBlock::getCreateTime);
        IPage<ContentBlock> result = contentBlockMapper.selectPage(page, wrapper);
        // 确保 data 不为 null
        if (result.getRecords() == null) {
            result.setRecords(List.of());
        }
        return result;
    }

    /** 根据分类获取列表（不含分页，用于首页展示） */
    public List<ContentBlock> listByCategory(String category, Integer limit) {
        LambdaQueryWrapper<ContentBlock> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ContentBlock::getCategory, category)
               .eq(ContentBlock::getStatus, 1)
               .orderByDesc(ContentBlock::getSort)
               .orderByDesc(ContentBlock::getCreateTime);
        if (limit != null && limit > 0) {
            wrapper.last("LIMIT " + limit);
        }
        return contentBlockMapper.selectList(wrapper);
    }

    /** 获取详情（同时累加浏览量） */
    public ContentBlock getDetail(Long id) {
        ContentBlock block = contentBlockMapper.selectById(id);
        if (block != null) {
            block.setViewCount(block.getViewCount() == null ? 1 : block.getViewCount() + 1);
            contentBlockMapper.updateById(block);
        }
        return block;
    }

    /** 保存或更新 */
    public void saveOrUpdate(ContentBlock block) {
        if (block.getId() != null) {
            contentBlockMapper.updateById(block);
        } else {
            if (block.getSort() == null) block.setSort(0);
            if (block.getStatus() == null) block.setStatus(1);
            if (block.getViewCount() == null) block.setViewCount(0);
            contentBlockMapper.insert(block);
        }
    }

    /** 删除 */
    public void deleteById(Long id) {
        contentBlockMapper.deleteById(id);
    }

    /** 获取所有分类及数量统计 */
    public List<ContentBlock> getCategoriesWithCount() {
        return null; // 直接用静态常量即可
    }
}
