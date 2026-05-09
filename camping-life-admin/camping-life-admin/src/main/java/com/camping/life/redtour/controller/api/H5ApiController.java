package com.camping.life.redtour.controller.api;

import com.camping.life.common.Result;
import com.camping.life.redtour.domain.BannerConfig;
import com.camping.life.redtour.domain.RedAttraction;
import com.camping.life.redtour.domain.TravelRoute;
import com.camping.life.redtour.service.BannerService;
import com.camping.life.redtour.service.RedAttractionService;
import com.camping.life.redtour.service.TeamBookingService;
import com.camping.life.redtour.service.TravelRouteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * H5小程序公开接口（无需登录）
 * 前缀：/api/h5
 */
@RestController
@RequestMapping("/api/h5")
public class H5ApiController {

    @Autowired
    private BannerService bannerService;
    @Autowired
    private RedAttractionService redAttractionService;
    @Autowired
    private TravelRouteService travelRouteService;
    @Autowired
    private TeamBookingService teamBookingService;

    // ===== 首页接口 =====

    /** 轮播图列表 */
    @GetMapping("/banner/list")
    public Result<List<BannerConfig>> bannerList() {
        return Result.success(bannerService.listEnabled());
    }

    /** 首页推荐景点列表 */
    @GetMapping("/attraction/recommend")
    public Result<List<RedAttraction>> recommendAttractions() {
        return Result.success(redAttractionService.listEnabled());
    }

    /** 首页推荐路线列表 */
    @GetMapping("/route/recommend")
    public Result<List<TravelRoute>> recommendRoutes() {
        return Result.success(travelRouteService.listEnabled());
    }

    // ===== 景点接口 =====

    /** 景点详情 */
    @GetMapping("/attraction/detail/{id}")
    public Result<Object> attractionDetail(@PathVariable Long id) {
        return Result.success(redAttractionService.getDetail(id));
    }

    /** 景点列表（支持搜索） */
    @GetMapping("/attraction/list")
    public Result<List<RedAttraction>> attractionList(
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "20") Integer pageSize) {
        return Result.success(redAttractionService.pageList(keyword, pageNum, pageSize));
    }

    // ===== 路线接口 =====

    /** 路线详情（含行程安排） */
    @GetMapping("/route/detail/{id}")
    public Result<Object> routeDetail(@PathVariable Long id) {
        return Result.success(travelRouteService.getDetail(id));
    }

    /** 路线列表（支持筛选） */
    @GetMapping("/route/list")
    public Result<List<TravelRoute>> routeList(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String theme,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "20") Integer pageSize) {
        return Result.success(travelRouteService.pageList(keyword, theme, pageNum, pageSize));
    }

    // ===== 团队预约接口 =====

    /** 提交团队预约 */
    @PostMapping("/booking/submit")
    public Result<Map<String, Object>> submitBooking(@RequestBody Map<String, Object> params) {
        Long id = teamBookingService.submit(params);
        Map<String, Object> result = new java.util.HashMap<>();
        result.put("bookingId", id);
        result.put("orderNo", "TB" + java.time.LocalDateTime.now().format(
            java.time.format.DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
        return Result.success(result, "预约提交成功，请等待管理员确认");
    }

    /** 查询预约状态（根据手机号） */
    @GetMapping("/booking/query")
    public Result<Object> queryBooking(@RequestParam(required = false) String phone,
                                      @RequestParam(required = false) Long id) {
        if (id != null) {
            // 按ID查询单条
            Map<String, Object> detail = teamBookingService.getDetail(id);
            return Result.success(detail);
        }
        // 按手机号查询列表
        if (!StringUtils.hasText(phone)) {
            return Result.success(java.util.Collections.emptyList());
        }
        return Result.success(teamBookingService.pageListByPhone(phone));
    }
}
