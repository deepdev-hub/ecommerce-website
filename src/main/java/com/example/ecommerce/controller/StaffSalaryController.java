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


    @GetMapping("/staff/salary")
    public String viewSalaryPage(HttpSession session, Model model) {
        // StoreStaff current = (StoreStaff) session.getAttribute("currentstorestaff");
        StoreStaff current = staffService.getStaffbyId(16L);

        if (current == null) {
            return "redirect:/login";
        }

        double calculatedSalary = current.calculateSalary();
        model.addAttribute("staff", current);
        model.addAttribute("calculatedSalary", calculatedSalary);

        return "salary";
    }
}

