package com.example.ecommerce.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.ecommerce.model.Product;
import com.example.ecommerce.service.ProductService;


@Controller
public class AdminInventoryController {
    @Autowired
    private ProductService productService;
    @GetMapping("/admin/inventory")
    public String getMethodName(Model model) {
        List<Product> allProducts = productService.getAllProducts();
        model.addAttribute("products", allProducts);
        return "admin-inventory";
    }
}
