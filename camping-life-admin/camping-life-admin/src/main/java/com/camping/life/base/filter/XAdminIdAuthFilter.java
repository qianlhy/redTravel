package com.camping.life.base.filter;

import com.camping.life.admin.domain.AdminUser;
import com.camping.life.admin.service.AdminUserDetailsService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;

/**
 * 基于 X-Admin-Id 请求头的认证过滤器
 * 前端登录后将 token 和 userId 存入 localStorage，
 * 每次请求带上 X-Admin-Id header，后端据此建立 Spring Security 认证上下文
 */
@Component
public class XAdminIdAuthFilter extends OncePerRequestFilter {

    @Autowired
    private AdminUserDetailsService adminUserDetailsService;

    /**
     * 放行公开接口（H5端不需要认证）
     */
    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();
        return path.startsWith("/api/h5/");  // H5公开接口直接放行
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        Long adminId = extractAdminId(request);

        if (adminId != null) {
            try {
                AdminUser adminUser = adminUserDetailsService.getAdminUserById(adminId);
                if (adminUser != null && adminUser.getStatus() != null && adminUser.getStatus() == 1) {
                    String rawRole = adminUser.getRole();
        String role = (rawRole != null && "ADMIN".equalsIgnoreCase(rawRole.trim())) ? "ADMIN" : "OPERATOR";
                    UserDetails userDetails = new User(
                            adminUser.getUsername(),
                            adminUser.getPassword(),
                            true, true, true, true,
                            Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + role))
                    );
                    UsernamePasswordAuthenticationToken authentication =
                            new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                }
            } catch (Exception ignored) {
                // 认证失败，继续过滤器链
            }
        }

        filterChain.doFilter(request, response);
    }

    /**
     * 从请求中提取管理员ID
     * 优先从 X-Admin-Id header 获取，如果没有则从 Authorization header 解析
     */
    private Long extractAdminId(HttpServletRequest request) {
        // 1. 尝试从 X-Admin-Id 获取
        String adminIdHeader = request.getHeader("X-Admin-Id");
        if (adminIdHeader != null && !adminIdHeader.isBlank()) {
            try {
                return Long.parseLong(adminIdHeader.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        // 2. 尝试从 Authorization header 解析，格式: Bearer username_token_userId
        String authorization = request.getHeader("Authorization");
        if (authorization != null && authorization.startsWith("Bearer ")) {
            String token = authorization.substring(7);
            try {
                String[] parts = token.split("_");
                if (parts.length >= 3) {
                    return Long.parseLong(parts[parts.length - 1]);
                }
            } catch (Exception ignored) {
            }
        }

        return null;
    }
}
