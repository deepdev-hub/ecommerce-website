package com.example.ecommerce.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.ecommerce.model.StoreStaff;
import com.example.ecommerce.service.StaffService;

import jakarta.servlet.http.HttpSession;

@Controller
public class StaffSalaryController {
    @Autowired
    private StaffService staffService;

    @GetMapping("/salary")
    public String showSalary(HttpSession session, Model model) {
        session.setAttribute("currentcustomer", staffService.getStaffbyId(1L));
        StoreStaff currentUser = (StoreStaff) session.getAttribute("currentcustomer");
        if (currentUser == null) {
            return "redirect:/login"; // chưa đăng nhập
        }
        model.addAttribute("staff", currentUser);
        model.addAttribute("salary", currentUser.getWorkhour()*50000);
        return "salary";
    }
}
