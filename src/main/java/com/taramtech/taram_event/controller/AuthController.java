package com.taramtech.taram_event.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.taramtech.taram_event.config.CurrentUser;
import com.taramtech.taram_event.dto.CreateUserDTO;
import com.taramtech.taram_event.dto.CustomUserDetails;
import com.taramtech.taram_event.service.ReferentielService;
import com.taramtech.taram_event.service.UserService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
public class AuthController {
    private final ReferentielService referentielService;
    private final UserService userService;

    @GetMapping("/login")
    public String loginPage(
            @RequestParam(value = "error", required = false) String error,
            @RequestParam(value = "logout", required = false) String logout,
            Model model) {

        Map<String, String> alerts = new HashMap<>();
        if (error != null) {
            alerts.put("danger", "Nom d'utilisateur ou mot de passe incorrect.");
        }
        if (logout != null) {
            alerts.put("success", "Vous avez été déconnecté avec succès.");
        }
        model.addAttribute("alerts", alerts);
        return "auth/login";
    }

    // @PostMapping("/login")
    // public String login(
    // @RequestParam String email,
    // @RequestParam String password,
    // Model model) {

    // Map<String, String> alerts = new HashMap<>();

    // if (email.equals("test@test.com") && password.equals("1234")) {
    // alerts.put("success", "Connexion réussie !");
    // model.addAttribute("alerts", alerts);
    // return "redirect:/";
    // }

    // alerts.put("danger", "Email ou mot de passe incorrect !");
    // model.addAttribute("alerts", alerts);
    // return "auth/login";
    // }

    @GetMapping("/register")
    public String registerForm(Model model) {
        model.addAttribute("roles", referentielService.findAllRoles());
        return "auth/register";
    }

    @PostMapping("/register")
    public String registerUser(
            @ModelAttribute CreateUserDTO registerRequest,
            RedirectAttributes redirectAttributes,
            Model model) {

        try {
            userService.registerUser(registerRequest);
            redirectAttributes.addFlashAttribute(
                    "alerts",
                    Map.of("success", "Inscription réussie ! Vous pouvez maintenant vous connecter."));
            return "redirect:/auth/login";
        } catch (IllegalArgumentException e) {
            model.addAttribute("alerts", Map.of("danger", e.getMessage()));
            return "redirect:/auth/register";
        }
    }

    @GetMapping("/logout")
    public String deconnexion(Model model) {
        return "auth/login";
    }

    @GetMapping("/account")
    public String home(Model model, @CurrentUser CustomUserDetails user) {

        model.addAttribute("user", user);

        return "auth/account";
    }
}
