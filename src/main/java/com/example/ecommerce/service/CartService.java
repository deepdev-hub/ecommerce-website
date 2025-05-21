package com.example.ecommerce.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.ecommerce.DTO.CartItemDTO;
import com.example.ecommerce.model.CartItem;
import com.example.ecommerce.model.Customer;
import com.example.ecommerce.repository.CartRepository;
import com.example.ecommerce.repository.CustomerRepository;
import com.example.ecommerce.repository.ProductRepository;

@Service
public class CartService {
    @Autowired
    private CartRepository cartRepository;
    @Autowired
    private CustomerRepository customerRepository;
    @Autowired
    private ProductRepository productRepository;
    @Transactional
    public List<CartItemDTO> getcartItemDTOsByCustomerid(Long customerid){
        Customer customer = customerRepository.findByCustomerid(customerid).orElseThrow(()-> new RuntimeException("customer not found"));
        List<CartItem> cart = customer.getCart();
        for (CartItem elem : cart) {
            System.out.println(elem.getCart_itemsid());
        }
        List<CartItemDTO> cartItemDTOs = cart.stream().map(product -> {
            CartItemDTO cartItemDTO = new CartItemDTO();

            cartItemDTO.setName(product.getProduct().getName());
            cartItemDTO.setImage(product.getProduct().getImage());
            cartItemDTO.setSellprice(product.getProduct().getSellprice());
            cartItemDTO.setQuantity(product.getQuantity());
            
            return cartItemDTO;
        }).toList();
        return cartItemDTOs;
    }
}
