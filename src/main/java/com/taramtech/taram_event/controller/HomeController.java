package com.taramtech.taram_event.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.taramtech.taram_event.config.CurrentUser;
import com.taramtech.taram_event.dto.CustomUserDetails;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home() {

        return "redirect:events/all";
    }

    @GetMapping("/dashboard")
    public String home(Model model, @CurrentUser CustomUserDetails user) {

        model.addAttribute("user", user);

        return "index";
    }
}
