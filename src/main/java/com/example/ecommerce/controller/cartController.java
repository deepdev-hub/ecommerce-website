package com.example.ecommerce.controller;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.ecommerce.DTO.CartItemDTO;
import com.example.ecommerce.model.Customer;
import com.example.ecommerce.service.CartService;

import jakarta.servlet.http.HttpSession;


@Controller
// @RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @GetMapping("/cart")
    // @Transactional
    public String viewCart(Model model, HttpSession session) {
        Customer customer = (Customer)session.getAttribute("currentcustomer");
        List<CartItemDTO> cartItemDTOs  = cartService.getcartItemDTOsByCustomerid(customer.getPeopleid());
        model.addAttribute("cartitems", cartItemDTOs );
        return "cart";
    }

    
    @PostMapping("/cart")
    public String doOrder(@RequestParam(name="cartselected") List<Long> cartselected, HttpSession session, Model model) {
        Customer customer = (Customer)session.getAttribute("currentcustomer");
        List<CartItemDTO> cartItem  = cartService.getcartItemDTOsByCustomerid(customer.getPeopleid());
        List<CartItemDTO> selectedItems = new ArrayList<>();
        for(CartItemDTO item: cartItem){
            for(Long selectedItem: cartselected){
                if(item.getProductid().equals(selectedItem)){
                    selectedItems.add(item);
                }
            }
        }
        session.setAttribute("selecteditems", selectedItems);
        
        return "redirect:/order/place";
    }
    
}

