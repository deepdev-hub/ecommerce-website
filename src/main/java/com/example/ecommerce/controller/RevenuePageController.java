package com.example.ecommerce.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.ecommerce.service.RevenueService;

@Controller
public class RevenuePageController {

    @Autowired
    private RevenueService revenueService;

    @GetMapping("/revenue")
    public String showRevenuePage(Model model) {
        model.addAttribute("totalRevenue", revenueService.getTotalRevenue());
        model.addAttribute("totalOrders", revenueService.getTotalOrders());
        model.addAttribute("topProduct", revenueService.getTopProduct());
        model.addAttribute("monthlyRevenue", revenueService.getMonthlyRevenue());

        return "revenue";
    }
}
