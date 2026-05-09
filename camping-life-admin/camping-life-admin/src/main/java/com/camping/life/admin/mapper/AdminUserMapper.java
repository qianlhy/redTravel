package com.camping.life.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.camping.life.admin.domain.AdminUser;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface AdminUserMapper extends BaseMapper<AdminUser> {

    @Select("SELECT * FROM admin_user WHERE username = #{username} AND is_delete = 0 LIMIT 1")
    AdminUser selectByUsername(@Param("username") String username);
}
