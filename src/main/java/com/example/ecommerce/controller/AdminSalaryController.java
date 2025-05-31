package com.example.ecommerce.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.ecommerce.model.Product;
import com.example.ecommerce.model.StoreStaff;
import com.example.ecommerce.service.StaffService;

@Controller 
public class AdminSalaryController {
        @Autowired
        StaffService staffService;

        @GetMapping("/admin/salary-summary")
        public String getSalarySummary(Model model) {
            List<StoreStaff> staffs = staffService.getAllStaff();
            model.addAttribute("staffs", staffs);
            return "admin-salary-summary";
        }
        
}
