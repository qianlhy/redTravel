package com.camping.life.redtour.controller.admin;

import com.camping.life.common.Result;
import com.camping.life.redtour.domain.ContentBlock;
import com.camping.life.redtour.service.ContentBlockService;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 内容模块管理接口（后台）
 */
@RestController
@RequestMapping("/admin/content-block")
public class ContentBlockAdminController {

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

    /** 分页列表 */
    @GetMapping("/list")
    public Result<IPage<ContentBlock>> list(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        IPage<ContentBlock> page = contentBlockService.pageList(category, keyword, pageNum, pageSize);
        return Result.success(page);
    }

    /** 详情 */
    @GetMapping("/detail/{id}")
    public Result<ContentBlock> detail(@PathVariable Long id) {
        return Result.success(contentBlockService.getDetail(id));
    }

    /** 保存/更新 */
    @PostMapping("/save")
    public Result<Void> save(@RequestBody ContentBlock block) {
        contentBlockService.saveOrUpdate(block);
        return Result.success();
    }

    /** 删除 */
    @PostMapping("/delete/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        contentBlockService.deleteById(id);
        return Result.success();
    }

    /** 切换状态 */
    @PostMapping("/status/{id}")
    public Result<Void> changeStatus(@PathVariable Long id, @RequestParam Integer status) {
        ContentBlock block = new ContentBlock();
        block.setId(id);
        block.setStatus(status);
        contentBlockService.saveOrUpdate(block);
        return Result.success();
    }
}
