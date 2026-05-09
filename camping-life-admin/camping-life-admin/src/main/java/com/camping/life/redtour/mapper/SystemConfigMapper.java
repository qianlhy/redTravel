package com.camping.life.redtour.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.camping.life.redtour.domain.SystemConfig;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface SystemConfigMapper extends BaseMapper<SystemConfig> {

    @Select("SELECT config_value FROM system_config WHERE config_key = #{configKey} AND status = 1 AND is_delete = 0 LIMIT 1")
    String selectValueByKey(@Param("configKey") String configKey);
}
