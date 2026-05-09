package com.camping.life.redtour;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@MapperScan("com.camping.life.**.mapper")
@SpringBootApplication
public class RedTourismApplication {

    public static void main(String[] args) {
        SpringApplication.run(RedTourismApplication.class, args);
    }

}
