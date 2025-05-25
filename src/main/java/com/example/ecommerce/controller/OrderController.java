package com.example.ecommerce.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import com.example.ecommerce.service.OrderService;
import com.example.ecommerce.repository.*;
import com.example.ecommerce.database.*;
import com.example.ecommerce.model.Customer;
import com.example.ecommerce.model.Orders;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;



@Controller
public class OrderController {
    @Autowired
    OrderService orderService;
    CustomerRepository customerRepository;

    @GetMapping("/{id}/orders")
    public String getAllOrder(@PathVariable Long customerid, Model model) {
        List<Orders> orders = orderService.findAllOrders(customerRepository.findById(customerid).orElse(new Customer()));
        model.addAttribute("orders", orders);
        return "order-all";
    }
    
    @GetMapping("{id}/orders/confirmed")
    public String getAllConfirmedOrder(@PathVariable Long customerid, Model model) {
        List<Orders> orders = orderService.findAllConfirmedOrders(customerRepository.findById(customerid).orElse(new Customer()));
        model.addAttribute("orders", orders);
        return "order-confirmed";
    }

    @GetMapping("{id}/orders/pending")
    public String getAllPendingdOrder(@PathVariable Long customerid, Model model) {
        List<Orders> orders = orderService.findAllPendingOrders(customerRepository.findById(customerid).orElse(new Customer()));
        model.addAttribute("orders", orders);
        return "order-pending";
    }

    @GetMapping("{id}/orders/cancelled")
    public String getAllCancelleddOrder(@PathVariable Long customerid, Model model) {
        List<Orders> orders = orderService.findAllCancelledOrders(customerRepository.findById(customerid).orElse(new Customer()));
        model.addAttribute("orders", orders);
        return "order-cancelled";
    }
    
}
