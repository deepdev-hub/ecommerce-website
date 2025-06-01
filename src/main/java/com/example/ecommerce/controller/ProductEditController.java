package com.example.ecommerce.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.ecommerce.model.Product;
import com.example.ecommerce.service.ProductService;

@Controller
@RequestMapping("/products")
public class ProductEditController {
    @Autowired
    private ProductService productService;
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Long id, Model model) {
        Product product = productService.getProductById(id);
        model.addAttribute("product", product);
        return "product-edit";
    }

    @PostMapping("/update")
    public String updateProduct(@ModelAttribute("product") Product product) {
        System.out.println(".()");
        System.out.println(".()");
        System.out.println(".()");
        System.out.println(".()");
        System.out.println(".()");
        System.out.println(".()");
        System.out.println(".()");
        System.out.println(".()");
        System.out.println(".()");
        System.out.println(".()");
        System.out.println(".()");
        productService.saveProduct(product);
        return "redirect:/admin/inventory";  // chuyển về danh sách sản phẩm
    }
}
