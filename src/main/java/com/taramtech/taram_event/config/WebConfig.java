package com.taramtech.taram_event.config;

import java.nio.file.Paths;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import gg.jte.ContentType;
import gg.jte.TemplateEngine;
import gg.jte.resolve.DirectoryCodeResolver;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Bean
    public TemplateEngine jteTemplateEngine() {
        if (isDevelopmentMode()) {
            // Development mode - templates are resolved from file system
            DirectoryCodeResolver codeResolver =
                    new DirectoryCodeResolver(Paths.get("src", "main", "jte"));
            return TemplateEngine.create(codeResolver, ContentType.Html);
        } else {
            // Production mode - use precompiled templates
            return TemplateEngine.createPrecompiled(ContentType.Html);
        }
    }

    private boolean isDevelopmentMode() {
        return "development".equals(System.getProperty("spring.profiles.active", "development"));
    }
}