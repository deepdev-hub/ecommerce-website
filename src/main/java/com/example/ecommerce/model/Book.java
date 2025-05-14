package com.example.ecommerce.model;

import jakarta.persistence.Entity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Book extends Product {    
    String isbn;
    String author;
    String publisher;    
    public void displayBook(){
        System.out.println("title: "+this.name);
        //System.out.println("category: "+this.category);
        System.out.println("price: "+this.sellprice);
        System.out.println("quantity: "+this.quantity);
        System.out.println("author: "+this.author);
    } 
}



