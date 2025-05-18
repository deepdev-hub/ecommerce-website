package com.example.ecommerce.model;

import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.PrimaryKeyJoinColumn;

@Entity
@PrimaryKeyJoinColumn(name = "product_id")
public class Toy extends  Product{
    
    String brand;
    String suitableage;

    

    public Toy() {
    }

    

    public Toy(String brand, String suitableage) {
        this.brand = brand;
        this.suitableage = suitableage;
    }



    public Toy(Long id, String name, int quantity, Double importprice, Double sellprice, String image, Double tax,
            String status, String description, Long categoryid, String brand, String suitableage) {
        super(id, name, quantity, importprice, sellprice, image, tax, status, description, categoryid);
        this.brand = brand;
        this.suitableage = suitableage;
    }



    public void displayImformation (){
        System.out.println("title: "+this.name);
        //System.out.println("category: "+this.category);
        System.out.println("suitable age: "+this.suitableage);
        //System.out.printf("cost: %.2f\n", this.cost);
    }

    public String getBrand() {
        return brand;
    }



    public void setBrand(String brand) {
        this.brand = brand;
    }



    public String getSuitableage() {
        return suitableage;
    }



    public void setSuitableage(String suitableage) {
        this.suitableage = suitableage;
    }
    
}


