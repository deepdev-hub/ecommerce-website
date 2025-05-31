package com.example.ecommerce.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.example.ecommerce.model.Product;
import com.example.ecommerce.model.StoreStaff;
import com.example.ecommerce.service.StaffService;

@Controller
public class StaffSalaryController {
    @Autowired
    StaffService staffService;

    @GetMapping("/salary")
    public String getSalarybyId(@PathVariable Long id, Model model){
        StoreStaff staff = staffService.getStaffbyId(id);
        model.addAttribute("staff", staff);
        return "salary";
    }
}
