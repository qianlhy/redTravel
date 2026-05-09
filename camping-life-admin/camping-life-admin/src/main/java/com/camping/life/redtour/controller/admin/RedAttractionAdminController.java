package com.camping.life.redtour.controller.admin;

import com.camping.life.common.Result;
import com.camping.life.redtour.domain.RedAttraction;
import com.camping.life.redtour.service.RedAttractionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 红色景点管理接口（后台）
 */
@RestController
@RequestMapping("/admin/red-attraction")
public class RedAttractionAdminController {

    @Autowired
    private RedAttractionService redAttractionService;

    @GetMapping("/list")
    public Result<List<RedAttraction>> list(
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        List<RedAttraction> list = redAttractionService.pageList(keyword, pageNum, pageSize);
        return Result.success(list);
    }

    @GetMapping("/detail/{id}")
    public Result<Object> detail(@PathVariable Long id) {
        return Result.success(redAttractionService.getDetail(id));
    }

    @PostMapping("/save")
    public Result<Void> save(@RequestBody RedAttraction attraction) {
        if (attraction.getId() != null) {
            redAttractionService.updateById(attraction);
        } else {
            redAttractionService.save(attraction);
        }
        return Result.success();
    }

    @PostMapping("/delete/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        redAttractionService.deleteById(id);
        return Result.success();
    }

    @PostMapping("/status/{id}")
    public Result<Void> changeStatus(@PathVariable Long id, @RequestParam Integer status) {
        RedAttraction a = new RedAttraction();
        a.setId(id);
        a.setStatus(status);
        redAttractionService.updateById(a);
        return Result.success();
    }
}
