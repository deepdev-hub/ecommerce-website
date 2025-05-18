package com.example.ecommerce.model;

import jakarta.persistence.*;

@Entity
@PrimaryKeyJoinColumn(name = "product_id")
public class Stationary extends Product {

    String brand;
    String type;

    public Stationary() {super();}


    public Stationary(String brand, String type) {
        this.brand = brand;
        this.type = type;
    }


    public Stationary(Long id, String name, int  quantity, Double importprice, Double sellprice, String image,
            Double tax, String status, String description, Long categoryid, 
            String brand, String type) {
        super(id, name, quantity, importprice, sellprice, image, tax, status, description, categoryid);
        this.brand = brand;
        this.type = type;
    }


    public void displayImformation(){
        System.out.println("name: "+this.name);
        System.out.println("category: "+this.type);
        System.out.println("brand: "+this.brand);
        //System.out.println("color: "+this.color);
        //System.out.printf("cost: %d\n", this.sellPrice);
    }

    public String getBrand() {
        return brand;
    }


    public void setBrand(String brand) {
        this.brand = brand;
    }


    public String getType() {
        return type;
    }


    public void setType(String type) {
        this.type = type;
    }
    
}
