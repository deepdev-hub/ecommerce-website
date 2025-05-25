package com.example.ecommerce.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.ecommerce.repository.OrderRepository;
import com.example.ecommerce.model.*;

@Service
public class OrderService {
    @Autowired
    OrderRepository orderRepository;

    public List<Orders> findAllOrders(Customer customer) {
        return orderRepository.findByCustomerid(customer.getCustomerid());
    }

    public List<Orders> findAllConfirmedOrders(Customer customer) {
        return orderRepository.findByCustomerAndStatus(customer, "confirmed");
    }

    public List<Orders> findAllPendingOrders(Customer customer) {
        return orderRepository.findByCustomerAndStatus(customer, "pending");
    }

    public List<Orders> findAllCancelledOrders(Customer customer) {
        return orderRepository.findByCustomerAndStatus(customer, "cancelled");
    }
}
