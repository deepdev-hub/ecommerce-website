package com.example.ecommerce.controller;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.ecommerce.DTO.CartItemDTO;
import com.example.ecommerce.model.CartItem;
import com.example.ecommerce.model.Customer;
import com.example.ecommerce.model.Order;
import com.example.ecommerce.service.CartService;
import com.example.ecommerce.service.OrderService;

import jakarta.servlet.http.HttpSession;


@Controller
public class OrderController {

    @Autowired
    private OrderService orderService;
    @Autowired
    private CartService cartService;

    @GetMapping("/order/place")
    public String showOrderForm(Model model, HttpSession session) {
        Customer customer = (Customer)session.getAttribute("currentcustomer");
        List<CartItemDTO> selecteditems = (List<CartItemDTO>)session.getAttribute("selecteditems");
        model.addAttribute("selecteditems", selecteditems );
        return "order";
    }

    @PostMapping("/order/place")
    public String placeOrder(Model model, HttpSession session) {
        Customer customer = (Customer)session.getAttribute("currentcustomer");
        List<CartItemDTO> cart = (List<CartItemDTO>)session.getAttribute("selecteditems");
        if (customer == null || cart == null || cart.isEmpty()) {
            return "redirect:/order/place?error=empty";
        }
        Order order = orderService.placeOrder(cart, customer);

        // model.addAttribute("order", order);
        return "redirect:/ordersuccess";
    }
}

