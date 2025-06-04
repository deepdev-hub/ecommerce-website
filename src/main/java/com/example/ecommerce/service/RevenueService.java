package com.example.ecommerce.service;

import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.TreeMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.ecommerce.model.Orderlines;
import com.example.ecommerce.model.Product;
import com.example.ecommerce.repository.OrderRepository;
import com.example.ecommerce.repository.OrderlinesRepository;
import com.example.ecommerce.repository.ProductRepository;

@Service
public class RevenueService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderlinesRepository orderlinesRepository;

    @Autowired
    private ProductRepository productRepository;

    public double getTotalRevenue() {
        double totalRevenue = 0.0;

        for (Orderlines ol : orderlinesRepository.findAll()) {
            Optional<Product> productOpt = productRepository.findById(ol.getProductid());

            if (productOpt.isPresent()) {
                Product product = productOpt.get();
                double revenuePerItem = (product.getSellprice() - product.getImportprice()) * ol.getQuantity();
                totalRevenue += revenuePerItem;
            }
        }

        return totalRevenue;
    }

    public int getTotalOrders() {
        return orderRepository.findAll().size();
    }

    public String getTopProduct() {
        Map<Long, Integer> productSales = new HashMap<>();
        for (Orderlines ol : orderlinesRepository.findAll()) {
            productSales.merge(ol.getProductid(), ol.getQuantity(), Integer::sum);
        }
        if (productSales.isEmpty()) return "No data";

        Long topProductId = Collections.max(productSales.entrySet(), Map.Entry.comparingByValue()).getKey();
        return productRepository.findById(topProductId)
                .map(Product::getName)
                .orElse("Unknown");
    }

    public Map<String, Double> getMonthlyRevenue() {
        Map<String, Double> monthlyRevenue = new TreeMap<>();

        // Khởi tạo 12 tháng năm 2025 mặc định = 0
        for (int month = 1; month <= 12; month++) {
            String monthKey = String.format("%02d-2025", month);
            monthlyRevenue.put(monthKey, 0.0);
        }

        for (Orderlines ol : orderlinesRepository.findAll()) {
            Optional<Product> productOpt = productRepository.findById(ol.getProductid());
            Optional<java.util.Date> orderDateOpt = orderRepository.findById(ol.getOrderid())
                    .map(o -> o.getOrderdate());

            if (productOpt.isPresent() && orderDateOpt.isPresent()) {
                Product product = productOpt.get();
                java.util.Date orderDate = orderDateOpt.get();

                Calendar calendar = Calendar.getInstance();
                calendar.setTime(orderDate);
                int month = calendar.get(Calendar.MONTH) + 1;
                int year = calendar.get(Calendar.YEAR);

                if (year == 2025) {
                    String monthKey = String.format("%02d-%d", month, year);
                    double revenue = (product.getSellprice() - product.getImportprice()) * ol.getQuantity();
                    monthlyRevenue.merge(monthKey, revenue, Double::sum);
                }
            }
        }

        return monthlyRevenue;
    }
}
