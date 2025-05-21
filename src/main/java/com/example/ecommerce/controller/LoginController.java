package com.example.ecommerce.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.ecommerce.model.Customer;
import com.example.ecommerce.service.CustomerService;

import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {
    @Autowired
    private CustomerService customerService;
    @GetMapping("/login")
    public String showLoginForm(Model model) {
        model.addAttribute("customer", new Customer() );
        return "login";
    }
    @PostMapping("/login")
    public String doLogin(@ModelAttribute("customer") Customer customerForm, Model model, HttpSession session) {
        model.addAttribute("customer", new Customer());
        if(customerService.getCustomerByCustomerUsername(customerForm.getUsername()).getPassword().equals(customerForm.getPassword())){
            session.setAttribute("currentcustomer", customerService.getCustomerByCustomerUsername(customerForm.getUsername()));
            model.addAttribute("message", "success login ");
            return "redirect:/";
            } 
        model.addAttribute("message", "login failed!");
        return "redirect:/login";
    }
}
