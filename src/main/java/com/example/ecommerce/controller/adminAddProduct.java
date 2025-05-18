// package com.example.ecommerce.controller;

// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.stereotype.Controller;
// import org.springframework.ui.Model;
// import org.springframework.web.bind.annotation.GetMapping;
// import org.springframework.web.bind.annotation.ModelAttribute;
// import org.springframework.web.bind.annotation.PostMapping;

// import com.example.ecommerce.model.Product;
// import com.example.ecommerce.repository.ProductRepository;

// @Controller
// public class AdminAddProduct {

//     @Autowired
//     private ProductRepository productRepository;

//     // Hiển thị form
//     @GetMapping("/admin/products/add")
//     public String showProductForm(Model model) {
//         model.addAttribute("product", new Product());
//         return "admin-add-product";
//     }

//     // Lưu dữ liệu
//     @PostMapping("/products/add")
//     public String saveProduct(@ModelAttribute("product") Product product) {
//         productRepository.save(product);
//         return "redirect:/admin/products/add"; // hoặc hiển thị thông báo thành công
//     }
// }

