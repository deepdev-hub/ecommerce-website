package com.example.ecommerce.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
@Table(name="orderlines")
public class OrderLine {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    Long orderlineid;
    @JoinColumn(name="orderid")
    @ManyToOne
    Order order;
    @OneToOne
    @JoinColumn(name="productid")
    Product product;
    Integer quantity;    
    
    }
