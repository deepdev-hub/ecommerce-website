package com.example.ecommerce.model;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Inheritance;
import jakarta.persistence.InheritanceType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Inheritance(strategy=InheritanceType.JOINED)
public class Product {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    Long productid;
    String name ;
    int quantity;  
    Double importprice;
    Double sellprice;
    String image;
    Double tax ;
    String status;
    String description;
    Long categoryid;
    public Product(String name, int quantity, Double importprice, Double sellprice, String image, Double tax,
            String status, String description, Long categoryid) {
        this.name = name;
        this.quantity = quantity;
        this.importprice = importprice;
        this.sellprice = sellprice;
        this.image = image;
        this.tax = tax;
        this.status = status;
        this.description = description;
        this.categoryid = categoryid;
    }
}