package com.example.ecommerce.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.ecommerce.service.CartService;


@Controller
public class CartController {

    @Autowired
    private CartService cartService;

    @GetMapping("/{id}/cart")
    public String viewCart() {
        return "cart";  
    }
}

