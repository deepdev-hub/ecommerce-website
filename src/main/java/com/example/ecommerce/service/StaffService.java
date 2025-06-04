package com.example.ecommerce.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.ecommerce.model.StoreStaff;
import com.example.ecommerce.repository.StaffRepository;

@Service
public class StaffService {
    @Autowired
    private StaffRepository staffRepository;

    public StoreStaff getStaffbyId(Long id) {
        return staffRepository.findById(id).orElse(null);
    }

    public List<StoreStaff> getAllStaff() {
        return staffRepository.findAll();
    }
}
