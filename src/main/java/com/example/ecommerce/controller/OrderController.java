package com.example.ecommerce.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import com.example.ecommerce.model.Customer;
import com.example.ecommerce.model.Order;
import com.example.ecommerce.service.OrderService;
import com.example.ecommerce.service.StoreStaffService;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
public class OrderController {

    @Autowired
    private OrderService orderService;
    @Autowired
    private StoreStaffService storeStaffService;
    
    @GetMapping("/order/place")
    public String showOrderForm() {
        return "order";
    }

    @PostMapping("/order/place")
    public String placeOrder(Model model, HttpSession session) {
        Customer customer = (Customer)session.getAttribute("currentcustomer");
        Order order = orderService.placeOrder(customer.getCart(), customer, storeStaffService.getStoreStaffById(1L));
        model.addAttribute("order", order);
        return "redirect: /orderSuccess";
    }
}

