package com.example.ecommerce.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.ecommerce.model.Admin;
import com.example.ecommerce.service.AdminService;

import jakarta.servlet.http.HttpSession;



@Controller
public class AdminProfileController {
    @Autowired
    private AdminService adminService;
    @GetMapping("/admin/profile")
    public String showProfile(Model model, HttpSession session) {
        Admin currentadmin = (Admin)session.getAttribute("currentadmin") ;
        model.addAttribute("admin", currentadmin);
        return "admin-profile";
    }
    @PostMapping("/admin/profile")
    public String doEditProfile(@ModelAttribute("admin") Admin adminForm, Model model) {
        model.addAttribute("admin", adminForm);
        if(!adminService.existAdmin(adminForm.getAdminusername()))        {
            adminService.saveAdmin(adminForm);
        }
        return "redirect:/admin/profile";
    }
    
    
}
