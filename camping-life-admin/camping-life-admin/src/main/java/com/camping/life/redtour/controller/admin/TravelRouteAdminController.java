package com.camping.life.redtour.controller.admin;

import com.camping.life.common.Result;
import com.camping.life.redtour.domain.TravelRoute;
import com.camping.life.redtour.service.TravelRouteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 旅游路线管理接口（后台）
 */
@RestController
@RequestMapping("/admin/travel-route")
public class TravelRouteAdminController {

    @Autowired
    private TravelRouteService travelRouteService;

    @GetMapping("/list")
    public Result<List<TravelRoute>> list(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String theme,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.success(travelRouteService.pageList(keyword, theme, pageNum, pageSize));
    }

    @GetMapping("/detail/{id}")
    public Result<Object> detail(@PathVariable Long id) {
        return Result.success(travelRouteService.getDetail(id));
    }

    @PostMapping("/save")
    public Result<Void> save(@RequestBody TravelRoute route) {
        if (route.getId() != null) {
            travelRouteService.updateById(route);
        } else {
            travelRouteService.save(route);
        }
        return Result.success();
    }

    @PostMapping("/delete/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        travelRouteService.deleteById(id);
        return Result.success();
    }

    @PostMapping("/status/{id}")
    public Result<Void> changeStatus(@PathVariable Long id, @RequestParam Integer status) {
        TravelRoute r = new TravelRoute();
        r.setId(id);
        r.setStatus(status);
        travelRouteService.updateById(r);
        return Result.success();
    }

    @GetMapping("/attractions/{routeId}")
    public Result<List<Map<String, Object>>> attractions(@PathVariable Long routeId) {
        return Result.success(travelRouteService.getRouteAttractions(routeId));
    }
}
