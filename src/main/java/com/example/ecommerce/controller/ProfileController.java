package com.example.ecommerce.controller;

import java.security.Principal;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import ch.qos.logback.core.model.Model;


@Controller
public class ProfileController {
    // CustomerRepository customerRepository;
    @GetMapping("/profile")
    public String showProfile(Model model, Principal principal) {

        String username = principal.getName();
        // Customer customer = customerRepository.finByUsername(username);
        return "profile";
    }
    
}
