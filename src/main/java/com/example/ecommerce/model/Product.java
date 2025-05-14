package com.example.ecommerce.model;
import jakarta.persistence.Entity;
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
}



