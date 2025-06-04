package com.example.ecommerce.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.ecommerce.model.Toy;
import com.example.ecommerce.repository.ToyRepository;

@Service
public class ToyService {

    @Autowired
    private ToyRepository toyRepository;

    public List<Toy> getAllToy() {
        return toyRepository.findAll();
    }

    public Toy getToyById(Long id) {
        return toyRepository.findById(id).orElse(null);
    }
}
