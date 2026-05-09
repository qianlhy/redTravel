package com.camping.life.redtour.controller.api;

import com.camping.life.common.Result;
import com.camping.life.redtour.domain.ContentBlock;
import com.camping.life.redtour.service.ContentBlockService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 内容模块 H5 端 API
 */
@RestController
@RequestMapping("/api/h5/content")
public class H5ContentController {

    @Autowired
    private ContentBlockService contentBlockService;

    /** 获取六个分类的配置 */
    @GetMapping("/categories")
    public Result<List<Map<String, String>>> getCategories() {
        List<Map<String, String>> categories = List.of(
            Map.of("code", "zkaju", "name", "走看聚"),
            Map.of("code", "qflz", "name", "清风廉政"),
            Map.of("code", "yffl", "name", "与法同行"),
            Map.of("code", "szxc", "name", "数字乡村"),
            Map.of("code", "yxyp", "name", "一县一片"),
            Map.of("code", "swxl", "name", "室外线路")
        );
        return Result.success(categories);
    }

    /** 按分类获取列表（不含分页，用于首页展示） */
    @GetMapping("/list/{category}")
    public Result<List<ContentBlock>> listByCategory(
            @PathVariable String category,
            @RequestParam(required = false) Integer limit) {
        List<ContentBlock> list = contentBlockService.listByCategory(category, limit);
        return Result.success(list);
    }

    /** 分页列表（用于列表页） */
    @GetMapping("/page")
    public Result<List<ContentBlock>> pageList(
            @RequestParam String category,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        var page = contentBlockService.pageList(category, keyword, pageNum, pageSize);
        return Result.success(page.getRecords());
    }

    /** 详情 */
    @GetMapping("/detail/{id}")
    public Result<ContentBlock> detail(@PathVariable Long id) {
        return Result.success(contentBlockService.getDetail(id));
    }
}
