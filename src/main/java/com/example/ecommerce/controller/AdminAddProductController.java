package com.example.ecommerce.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.ecommerce.model.Product;
import com.example.ecommerce.repository.ProductRepository;

@Controller
public class AdminAddProductController {

    @Autowired
    private ProductRepository productRepository;

    // Hiển thị form
    @GetMapping("/admin/products/add")
    public String showProductForm(Model model) {
        model.addAttribute("product", new Product());
        return "admin-add-product";
    }

    // Lưu dữ liệu
    @PostMapping("/admin/products/add")
    public String saveProduct(@ModelAttribute("product") Product product, @RequestParam("imageFile") MultipartFile imageFile) {
        try {
            if(!imageFile.isEmpty()){
                String fileName = imageFile.getOriginalFilename();
                String uploadDir="image/";
                File uploadPath =   new File(uploadDir);
                if(!uploadPath.exists()){
                    uploadPath.mkdirs();
                }
                Path filePath = Paths.get(uploadDir, fileName);
                Files.copy(imageFile.getInputStream() , filePath, StandardCopyOption.REPLACE_EXISTING);
                product.setImage(fileName);
            }
            productRepository.save(product);
            return "redirect:/admin/products/add"; // hoặc hiển thị thông báo thành công
        } catch (IOException e) {
            e.printStackTrace();
            return "error";
        }
    }
}

