package com.example.ecommerce.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import com.example.ecommerce.model.Inventory;
import com.example.ecommerce.service.InventoryService;


@RestController
public class InventoryController {
    @Autowired
    private InventoryService inventoryService;
    @GetMapping("/inventory")
    public List<Inventory>getAllInventories(){
        return inventoryService.getAllInventory();
    }
    @GetMapping("/inventory/{id}")
    public List<Inventory> getProductInventories(@PathVariable Long id){
        return inventoryService.getProductInventory(id);
    }
    
}
