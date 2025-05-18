package com.example.ecommerce.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.ecommerce.model.Customer;
import com.example.ecommerce.repository.CustomerRepository;

@Service
public class CustomerService {
    @Autowired
    private CustomerRepository customerRepository;
    public Customer getCustomerByCustomerUsername(String username){ 
        return customerRepository.findByUsername(username);
    }
    public Optional<Customer> getCustomerByCustomerId(Long customerid){
        return customerRepository.findById(customerid);
    }
    public void saveCustomer(Customer customer){
        customerRepository.save(customer);
    }
    public boolean existCustomer(String username){
        return customerRepository.findByUsername(username)!=null;
    }
    public List<Customer> getAllCustomer(){
        return customerRepository.findAll();
    } 

}
