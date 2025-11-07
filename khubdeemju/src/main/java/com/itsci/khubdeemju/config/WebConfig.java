package com.itsci.khubdeemju.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/img_news/**")
                .addResourceLocations("file:/app/img/img_news/");
        
        registry.addResourceHandler("/img_activity/**")
                .addResourceLocations("file:/app/img/img_activity/");
    }
}
