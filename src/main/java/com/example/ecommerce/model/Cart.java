package com.example.ecommerce.model;

import java.util.ArrayList;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.MapsId;
import jakarta.persistence.OneToOne;

@Entity
public class Cart {
    @Id
    Long id; 
    
    @OneToOne
    @MapsId
    @JoinColumn(name = "id")
    private Customer customer;

    ArrayList<Product> itemsOrdered;

    public Cart() {
        itemsOrdered = new ArrayList<>(); 
    }

    public void addProduct(Product p) {
        if(itemsOrdered.indexOf(p) == -1) itemsOrdered.add(p);
    }

    public void deleteProduct(Product p) {
        if(itemsOrdered.indexOf(p) != -1) itemsOrdered.remove(p);
    }

    public double totalCost() {
        double sum = 0;
        for (Product item : itemsOrdered) {
        }
        return sum;
    }

    public ArrayList<Product> getItemsOrdered() {
        return itemsOrdered;
    }

    

    public void setItemsOrdered(ArrayList<Product> itemsOrdered) {
        this.itemsOrdered = itemsOrdered;
    } 
    

}

