package com.example.ecommerce.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.ecommerce.model.Product;
import com.example.ecommerce.service.ProductService;


@RestController
public class ProductController {
    @Autowired
    private ProductService productService;
    @GetMapping("/products/list")
    public String showAllProducts(Model model) {
        List<Product> products = productService.getAllProducts();
        for(Product product: products){
            System.out.println(".()"+product.getName());
        }
        model.addAttribute("products", products);
        return "products"; 
    }

    // @GetMapping("/products/{id}")
    // public Product getProductById(@PathVariable Long id){
    //     return productService.getProductById(id);
    // }
    
}

