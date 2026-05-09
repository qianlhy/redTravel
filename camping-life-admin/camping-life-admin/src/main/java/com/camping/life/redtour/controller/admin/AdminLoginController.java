package com.camping.life.redtour.controller.admin;

import com.camping.life.common.Result;
import com.camping.life.admin.domain.AdminUser;
import com.camping.life.redtour.service.AdminUserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 管理员登录接口（对外）
 */
@RestController
@RequestMapping("/api/admin")
public class AdminLoginController {

    @Autowired
    private AdminUserService adminUserService;

    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody Map<String, String> params, HttpServletRequest request) {
        String username = params.get("username");
        String password = params.get("password");
        if (!org.springframework.util.StringUtils.hasText(username) || !org.springframework.util.StringUtils.hasText(password)) {
            return Result.error(400, "账号和密码不能为空");
        }
        AdminUser user = adminUserService.login(username, password);
        Map<String, Object> data = new HashMap<>();
        data.put("token", username + "_token_" + user.getId());
        data.put("userId", user.getId());
        data.put("username", user.getUsername());
        data.put("realName", user.getRealName());
        data.put("role", user.getRole());
        return Result.success(data, "登录成功");
    }

    @PostMapping("/info")
    public Result<Map<String, Object>> info(@RequestHeader(value = "X-Admin-Id", required = false) Long adminId) {
        if (adminId == null) {
            return Result.error(401, "请先登录");
        }
        AdminUser user = adminUserService.getInfoById(adminId);
        if (user == null) {
            return Result.error(404, "用户不存在");
        }
        Map<String, Object> data = new HashMap<>();
        data.put("id", user.getId());
        data.put("username", user.getUsername());
        data.put("realName", user.getRealName());
        data.put("role", user.getRole());
        data.put("phone", user.getPhone());
        return Result.success(data);
    }

    @PostMapping("/logout")
    public Result<Void> logout() {
        return Result.success(null, "退出成功");
    }
}
