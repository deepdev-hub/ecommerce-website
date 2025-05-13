package com.example.ecommerce.controller;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import com.example.ecommerce.model.Admin;
import com.example.ecommerce.repository.AdminRepository;


@RestController
public class AdminProfileController {
    @Autowired
    private AdminRepository adminRepository;
    @GetMapping("/admin/profile/{id}")
    public Optional<Admin> getAdminByid( @PathVariable Long id) {
        return adminRepository.findById(id);
    }
    
}
