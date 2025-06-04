package com.example.ecommerce.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.ecommerce.model.Stationary;
import com.example.ecommerce.service.StationaryService;

@Controller
public class StationaryController {

    @Autowired
    private StationaryService stationaryService;

    @GetMapping("/stationary")
    public String showStationaries(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        List<Stationary> stationaries = (keyword != null && !keyword.isBlank())
            ? stationaryService.searchStationaryByName(keyword)
            : stationaryService.getAllStationary();

        model.addAttribute("stationaries", stationaries);
        return "stationary";
    }

    @GetMapping("/stationary/{id}")
    public String showStationaryDetail(@PathVariable Long id, Model model) {
        Stationary stationary = stationaryService.getStationaryById(id);
        if (stationary == null) {
            model.addAttribute("error", "Item not found");
        }
        model.addAttribute("stationary", stationary);
        return "stationary-detail";
    }

    @GetMapping("/stationary-detail")
    public String showStationaryDetailByParam(@RequestParam("id") Long id, Model model) {
        Stationary stationary = stationaryService.getStationaryById(id);
        if (stationary == null) {
            model.addAttribute("error", "Item not found");
        }
        model.addAttribute("stationary", stationary);
        return "stationary-detail";
    }

    @GetMapping("/api/stationary")
    @ResponseBody
    public List<Stationary> getAllStationaryApi() {
        return stationaryService.getAllStationary();
    }

    @GetMapping("/api/stationary/{id}")
    @ResponseBody
    public Stationary getStationaryByIdApi(@PathVariable Long id) {
        return stationaryService.getStationaryById(id);
    }
}
