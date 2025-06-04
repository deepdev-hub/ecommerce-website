package com.example.ecommerce.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.ecommerce.model.Toy;
import com.example.ecommerce.service.ToyService;

@Controller
public class ToyController {

    @Autowired
    private ToyService toyService;

    @GetMapping("/toy")
    public String showToyList(Model model) {
        List<Toy> list = toyService.getAllToy();
        model.addAttribute("toys", list);
        return "toy"; // maps to templates/toy.html
    }

    @GetMapping("/toy/{id}")
    public String showToyDetail(@PathVariable Long id, Model model) {
        Toy toy = toyService.getToyById(id);
        if (toy == null) {
            model.addAttribute("error", "Toy not found");
        }
        model.addAttribute("toy", toy);
        return "toy-detail";
    }

    @GetMapping("/toy-detail")
    public String showToyDetailByParam(@RequestParam("id") Long id, Model model) {
        Toy toy = toyService.getToyById(id);
        if (toy == null) {
            model.addAttribute("error", "Toy not found");
        }
        model.addAttribute("toy", toy);
        return "toy-detail";
    }
}
