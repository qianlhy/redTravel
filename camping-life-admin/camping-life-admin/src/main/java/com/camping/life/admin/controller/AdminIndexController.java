package com.camping.life.admin.controller;

import com.camping.life.common.Result;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/admin")
public class AdminIndexController {

    @GetMapping("/index")
    public Result<String> adminIndex() {
        return Result.success("欢迎进入红色旅游管理后台！");
    }
}
