package com.example.ecommerce.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
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
    private Long orderlineid;
    @JoinColumn(name="orderid")
    @ManyToOne
    private Order order;

    @ManyToOne
    @JoinColumn(name="productid")
    private Product product;
 
    private Integer quantity;    
    
    }
