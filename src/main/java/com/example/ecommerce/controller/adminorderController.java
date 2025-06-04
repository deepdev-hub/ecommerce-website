package com.example.ecommerce.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
public class AdminOrderController {
    @GetMapping("/admin-order")
    public String adminOrder() {
        return "admin-order";
    }   
    
}
