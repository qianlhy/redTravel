package com.camping.life.redtour.service;

import com.camping.life.admin.domain.AdminUser;

public interface AdminUserService {

    AdminUser login(String username, String password);

    AdminUser getInfoById(Long id);
}
