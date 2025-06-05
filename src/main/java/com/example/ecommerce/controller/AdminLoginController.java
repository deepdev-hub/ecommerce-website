package com.example.ecommerce.controller;

import java.util.List;

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
public class AdminLoginController {
    @Autowired
    private AdminService adminService;
    @GetMapping("/admin/login")
    public String showLoginForm(Model model) {
        
        model.addAttribute("admin", new Admin() );
        return "admin-login";
    }
    @PostMapping("/admin/login")
    public String doLogin(@ModelAttribute("admin") Admin adminForm, Model model, HttpSession session) {
        model.addAttribute("admin", new Admin());
        List<Admin> allAdmin = adminService.getAllAdmin();
        for(Admin adminsignuped: allAdmin){
            if(adminsignuped.getStorestaffusername().equals(adminForm.getStorestaffusername())&&adminsignuped.getStorestaffpassword().equals(adminForm.getStorestaffpassword())){
                session.setAttribute("currentadmin", adminsignuped);
                model.addAttribute("message", "success login ");
                return "redirect:/";
            } 
        }
        model.addAttribute("message", "login failed!");
        return "redirect:/admin/login";
    }
}
