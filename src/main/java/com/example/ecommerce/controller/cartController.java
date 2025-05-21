package com.example.ecommerce.controller;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.ecommerce.DTO.CartItemDTO;
import com.example.ecommerce.model.Customer;
import com.example.ecommerce.service.CartService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @GetMapping
    @Transactional
    public String viewCart(Model model, HttpSession session) {
        Customer customer = (Customer)session.getAttribute("currentcustomer");
        List<CartItemDTO> cartItemDTOs  = cartService.getcartItemDTOsByCustomerid(customer.getCustomerid());
        model.addAttribute("cartitems", cartItemDTOs );
        return "cart";
    }
}

