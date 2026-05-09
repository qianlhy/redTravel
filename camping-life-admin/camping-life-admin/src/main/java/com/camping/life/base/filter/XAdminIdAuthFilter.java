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

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        String adminIdHeader = request.getHeader("X-Admin-Id");

        if (adminIdHeader != null && !adminIdHeader.isBlank()) {
            try {
                Long adminId = Long.parseLong(adminIdHeader.trim());
                AdminUser adminUser = adminUserDetailsService.getAdminUserById(adminId);
                if (adminUser != null && adminUser.getStatus() != null && adminUser.getStatus() == 1) {
                    String role = "ADMIN".equalsIgnoreCase(adminUser.getRole()) ? "ADMIN" : "OPERATOR";
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
            } catch (NumberFormatException ignored) {
                // 非数字的 header 值，忽略，继续过滤器链
            }
        }

        filterChain.doFilter(request, response);
    }
}
