package com.example.ecommerce.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
public class paidController {
    @GetMapping("/paid")
    public String getPath( ) {
        return "paid";
    }
    
}
