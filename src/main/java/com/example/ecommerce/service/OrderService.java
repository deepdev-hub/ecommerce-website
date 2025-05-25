package com.example.ecommerce.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.ecommerce.model.CartItem;
import com.example.ecommerce.model.Customer;
import com.example.ecommerce.model.Order;
import com.example.ecommerce.model.OrderLine;
import com.example.ecommerce.model.Product;
import com.example.ecommerce.model.StoreStaff;
import com.example.ecommerce.repository.OrderRepository;

import jakarta.transaction.Transactional;

@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;
    @Transactional
    public Order placeOrder(List<CartItem> cart, Customer customer, StoreStaff storeStaff) {
        Order order = new Order();
        order.setOrderdate(LocalDateTime.now());
        order.setCustomer(customer);
        order.setStoreStaff(storeStaff);
        order.setStatus("Processing");

        double netAmount = 0;
        for ( CartItem cartItem : cart) {
            OrderLine orderline = new OrderLine();
            orderline.setProduct(cartItem.getProduct());
            orderline.setQuantity(cartItem.getQuantity());
            orderline.setOrder(order); // set quan hệ
            order.getOrderLines().add(orderline);
            netAmount += cartItem.getProduct().getSellprice() * cartItem.getQuantity();
        }
        
        order.setNetamount(netAmount);
        double tax = netAmount * 0.1; // ví dụ 10% VAT
        order.setTaxvat(tax);
        order.setTotalamount(netAmount + tax);
        return orderRepository.save(order); // sẽ lưu luôn cả order_lines
    }
}
