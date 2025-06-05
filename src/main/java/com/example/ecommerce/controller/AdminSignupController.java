package com.example.ecommerce.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.ecommerce.model.Admin;
import com.example.ecommerce.service.AdminService;

import jakarta.validation.Valid;


@Controller
public class AdminSignupController {
    @Autowired
    private AdminService adminService;
    @GetMapping("/admin/signup")
    public String showSignupPage(Model model) {
        model.addAttribute("admin", new Admin());
        return "admin-signup";
    }

    @PostMapping("/admin/signup")
    public String dosignup(@ModelAttribute("admin") @Valid Admin admin, BindingResult result, Model model ){
        if(adminService.existAdmin(admin.getStorestaffusername())){
            result.rejectValue("adminusername", "error.admin", "username already exist");
        }
        if(result.hasErrors()){
            return "admin-signup";
        }
        adminService.saveAdmin(admin);
        model.addAttribute("message", "signup successful");
        return "redirect:admin/login";
    }

}
