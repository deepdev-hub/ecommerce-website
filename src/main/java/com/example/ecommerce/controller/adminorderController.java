package com.example.ecommerce.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.ecommerce.service.OrderService;

@Controller
@RequestMapping("/admin/orders")
public class AdminOrderController {
    @Autowired
    private OrderService orderService;

    @GetMapping("/processing")
    public String viewProcessingOrders(Model model) {
        model.addAttribute("orders", orderService.getProcessingOrders());
        return "admin-orders";
    }

    @PostMapping("/accept/{id}")
    public String acceptOrder(@PathVariable("id") Long id) {
        orderService.updateOrderStatus(id, "success");
        return "redirect:/admin/orders/processing";
    }

    @PostMapping("/deny/{id}")
    public String denyOrder(@PathVariable("id") Long id) {
        orderService.updateOrderStatus(id, "cancel");
        return "redirect:/admin/orders/processing";
    }
}

