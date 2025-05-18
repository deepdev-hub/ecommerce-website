package com.example.ecommerce.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.ecommerce.model.Product;

@Controller 
public class AdminController {
        @PostMapping("/admin/products/add")
        public String addProduct(
            @RequestParam("name") String name,
            @RequestParam("description") String description,
            @RequestParam("price") double price,
            @RequestParam("category") String category,
            @RequestParam("image") MultipartFile imageFile
        ) {
            System.out.println("Tên: " + name);
                System.out.println("Mô tả: " + description);
                System.out.println("Giá: " + price);
                System.out.println("Danh mục: " + category);
                System.out.println("File ảnh: " + imageFile.getOriginalFilename());
            return "redirect:/admin/products";
        }
}
