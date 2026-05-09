package com.camping.life.admin.service;

import com.camping.life.admin.domain.AdminUser;
import com.camping.life.admin.mapper.AdminUserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collections;

@Service
public class AdminUserDetailsService implements UserDetailsService {

    @Autowired
    private AdminUserMapper adminUserMapper;

    public AdminUser getAdminUserById(Long id) {
        return adminUserMapper.selectById(id);
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        AdminUser adminUser = adminUserMapper.selectByUsername(username);
        if (adminUser == null) {
            throw new UsernameNotFoundException("管理员账号不存在或已禁用");
        }
        String roleStr = adminUser.getRole();
        String role = "ADMIN".equalsIgnoreCase(roleStr) ? "ADMIN" : "OPERATOR";
        return new User(
            adminUser.getUsername(),
            adminUser.getPassword(),
            adminUser.getStatus() != null && adminUser.getStatus() == 1,
            true, true, true,
            Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + role))
        );
    }
}
