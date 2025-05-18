package com.example.ecommerce.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.ecommerce.model.Customer;
import com.example.ecommerce.service.CustomerService;

@Controller
public class SignupController {
    @Autowired
    private CustomerService customerService;

    @GetMapping("/signup")
    public String showLoginForm(Model model) {
        model.addAttribute("customer", new Customer() );
        return "signup";
    }
    @PostMapping("/signup")
    public String doLogin(@ModelAttribute("customer") Customer customerForm, Model model) {
        model.addAttribute("customer", new Customer());
        if(!customerService.existCustomer(customerForm.getUsername())){
            customerService.saveCustomer(customerForm);
            model.addAttribute("message", "success signup ");
            return "redirect:/login";
            } 
        model.addAttribute("message", "signup failed!");
        return "redirect:/signup";

    }
    
}
