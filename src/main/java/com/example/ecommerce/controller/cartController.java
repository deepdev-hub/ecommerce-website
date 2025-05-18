// package com.example.ecommerce.controller;
// import java.util.List;

// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.stereotype.Controller;
// import org.springframework.ui.Model;
// import org.springframework.web.bind.annotation.GetMapping;
// import org.springframework.web.bind.annotation.RequestMapping;

// import com.example.ecommerce.entity.CartItem;
// import com.example.ecommerce.model.Customer;
// import com.example.ecommerce.service.CartService;

// import jakarta.servlet.http.HttpSession;

// @Controller
// @RequestMapping("/cart")
// public class CartController {

//     @Autowired
//     private CartService cartService;

//     @GetMapping
//     public String viewCart(Model model, HttpSession session) {
//         Customer customer = (Customer)session.getAttribute("currentCustomer");
//         List<CartItem> cartItems = cartService.getCartItems(customer.getCustomerid());
//         model.addAttribute("cartitem", cartItems );
//         return "cart";  
//     }
// }

