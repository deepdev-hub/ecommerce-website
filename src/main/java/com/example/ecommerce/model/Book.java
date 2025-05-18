package com.example.ecommerce.model;

import jakarta.persistence.*;

@Entity
@PrimaryKeyJoinColumn(name = "product_id")
public class Book extends Product {
    
    String isbn;
    String author;
    String publisher;
    
    public Book() {super();}

    


    public Book(Long id, String name, int quantity, Double importprice, Double sellprice, String image, Double tax,
            String status, String description, Long categoryid, Long id2, String isbn, String author,
            String publisher) {
        super(id, name, quantity, importprice, sellprice, image, tax, status, description, categoryid);
        id = id2;
        this.isbn = isbn;
        this.author = author;
        this.publisher = publisher;
    }




    public void displayBook(){
        System.out.println("title: "+this.name);
        //System.out.println("category: "+this.category);
        System.out.println("quantity: "+this.quantity);
        System.out.println("author: "+this.author);
    }


    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }




    public String getPublisher() {
        return publisher;
    }




    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }
    
}