package com.camping.life.base.config;

import org.springframework.context.annotation.Configuration;

/**
 * 跨域配置已迁移到 SecurityConfig
 * 避免与 Spring Security 的 CORS 配置冲突
 */
@Configuration
public class CorsConfig {
    // CORS 配置统一在 SecurityConfig 中管理
}
