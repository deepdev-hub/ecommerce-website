package com.example.ecommerce.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.ecommerce.service.SalesReportService;

@Controller
public class ReportController {

    @Autowired
    private SalesReportService salesService;

    @GetMapping("/sales-report")
    public String showReport(Model model) {
        model.addAttribute("salesList", salesService.getMonthlySales());
        return "sales-report";
    }
}

