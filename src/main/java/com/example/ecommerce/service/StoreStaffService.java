package com.example.ecommerce.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.ecommerce.model.StoreStaff;
import com.example.ecommerce.repository.StoreStaffRepository;

@Service
public class StoreStaffService {
    @Autowired
    private StoreStaffRepository storeStaffRepository;
    public StoreStaff getStoreStaffById(Long storeStaffId){
        return storeStaffRepository.findByPeopleid(storeStaffId);
    }
}
