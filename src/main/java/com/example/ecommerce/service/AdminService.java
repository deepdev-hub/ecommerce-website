package com.example.ecommerce.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.ecommerce.model.Admin;
import com.example.ecommerce.repository.AdminRepository;
@Service
public class AdminService {
    @Autowired
    private AdminRepository adminRepository;
    public Admin getAdminByAdminUsername(String adminusername){ 
        return adminRepository.findByAdminusername(adminusername);

    }
    public Optional<Admin> getAdminByAdminId(Long adminid){
        return adminRepository.findById(adminid);
    }
    public void saveAdmin(Admin admin){
        adminRepository.save(admin);
    }
    public boolean existAdmin(String adminusername){
        return adminRepository.findByAdminusername(adminusername)!=null;
    }

    
}
