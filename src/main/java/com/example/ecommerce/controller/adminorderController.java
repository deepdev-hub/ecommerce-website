package com.example.ecommerce.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import com.example.ecommerce.model.Orderlines;
import com.example.ecommerce.model.Orders;
import com.example.ecommerce.model.Product;
import com.example.ecommerce.service.ProductService;



@Controller
public class adminorderController {
    @Autowired
    // OrderService orderService;
    // OrderlinesService orderlinesService;
    ProductService productService;
    @GetMapping("/admin-order")
    public String adminOrder() {
        return "admin-order";
    }   
    // @PostMapping("admin/orders/{id}/approved")
    // public String updateInventory(@RequestBody Orders order) {
    //     List<Orderlines> orderitems = orderlinesService.findByOrderId(order.getOrderid);
    //     for(Orderlines o : orderitems) {
    //         Product p = productService.getProductById(o.getProductid());
    //         p.setQuantity(p.getQuantity()-o.getQuantity());
    //         productService.saveProduct(p);
    //     }
        
    //     return "admin-order";
    // }
    
}
