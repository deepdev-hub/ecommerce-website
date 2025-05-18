package com.example.ecommerce.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.ecommerce.model.Product;
import com.example.ecommerce.model.Toy;
import com.example.ecommerce.repository.BookRepository;
import com.example.ecommerce.repository.ToyRepository;

@Service
public class ToyService {

    private final BookRepository bookRepository;
    @Autowired
    private ToyRepository toyRepository;

    ToyService(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }
    public List<Toy> getAllToy(){
        return toyRepository.findAll();
    }
    public Toy getToyById(Long id){
        return toyRepository.findById(id).orElse(null);
    }
    public Toy saveProduct(Product product) {
        return toyRepository.save((Toy) product);
    }
}
