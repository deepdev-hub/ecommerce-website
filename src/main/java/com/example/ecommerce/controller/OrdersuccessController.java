package com.example.ecommerce.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
public class OrdersuccessController {
    @GetMapping("/ordersuccess")
    public String getMethodName() {
        return "ordersuccess";
    }
    

}
