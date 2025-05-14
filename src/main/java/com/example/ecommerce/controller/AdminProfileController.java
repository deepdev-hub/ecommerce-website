package com.example.ecommerce.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.ecommerce.model.Admin;

import jakarta.servlet.http.HttpSession;


@Controller
public class AdminProfileController {
    @GetMapping("/admin/profile")
    public String showProfile(Model model, HttpSession session) {
        Admin currentAdmin = (Admin)session.getAttribute("currentAdmin") ;
        model.addAttribute("currentadmin", currentAdmin);
        return "admin-profile";
    }
    
}
