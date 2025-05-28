package com.example.ecommerce.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.ecommerce.DTO.CartItemDTO;
import com.example.ecommerce.model.CartItem;
import com.example.ecommerce.model.Customer;
import com.example.ecommerce.model.Order;
import com.example.ecommerce.model.OrderLine;
import com.example.ecommerce.repository.OrderRepository;
import com.example.ecommerce.repository.ProductRepository;

import jakarta.transaction.Transactional;

@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;
    @Autowired
    private ProductRepository productRepository;
    @Autowired
    private ProductService productService;
    @Transactional
    public Order placeOrder(List<CartItemDTO> cart, Customer customer) {
        for(CartItemDTO cartItem: cart){
            System.out.println(cartItem.getProductid());
            System.out.println(cartItem.getProductid());
            System.out.println(cartItem.getProductid());
            //xu ly tru san pham trong cart

        }
        Order order = new Order();
        order.setOrderdate(LocalDateTime.now());
        order.setCustomer(customer);
        order.setStatus("Processing");

        double netAmount = 0;
        for ( CartItemDTO cartItem : cart) {
            OrderLine orderline = new OrderLine();
            orderline.setProduct(productService.getProductById(cartItem.getProductid()));
            orderline.setQuantity(cartItem.getQuantity());
            orderline.setOrder(order); // set quan hệ
            order.getOrderLines().add(orderline);
            netAmount += productService.getProductById(cartItem.getProductid()).getSellprice() * cartItem.getQuantity();
        }

        order.setNetamount(netAmount);
        double tax = netAmount * 0.1; // ví dụ 10% VAT
        // xu ly thue lay tu product
        order.setTaxvat(tax);
        order.setTotalamount(netAmount + tax);
        return orderRepository.save(order); // sẽ lưu luôn cả order_lines
    }
    // @Transactional
    // public 
}
