package com.springmvc.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = "com.springmvc")
public class WebConfig implements WebMvcConfigurer {
    @Bean
    public ViewResolver viewResolver() {
        InternalResourceViewResolver viewResolver = new InternalResourceViewResolver();

        // หา file .jsp ที่ไหน
        viewResolver.setPrefix("/WEB-INF/jsp/");
        viewResolver.setSuffix(".jsp");

        return viewResolver;
    }

    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/assets/**").addResourceLocations("WEB-INF/assets/");
        registry.addResourceHandler("/img_news/**").addResourceLocations("WEB-INF/img/img_news/");
        registry.addResourceHandler("/img_officer/**").addResourceLocations("WEB-INF/img/img_officer/");
        registry.addResourceHandler("/img_student/**").addResourceLocations("WEB-INF/img/img_student/");
        registry.addResourceHandler("/picture_evidence/**").addResourceLocations("WEB-INF/img/picture_evidence/");
    }

}