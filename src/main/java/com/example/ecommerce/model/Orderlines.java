package com.example.ecommerce.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "orderlines") 
public class Orderlines {

    @Id
    private Long orderlineid;

    private Long productid;
    private Long orderid;
    private int quantity;

    public Orderlines() {
        // Constructor mặc định cần thiết cho JPA
    }

    public Orderlines(Long productid, Long orderid, Long orderlineid, int quantity) {
        this.productid = productid;
        this.orderid = orderid;
        this.orderlineid = orderlineid;
        this.quantity = quantity;
    }

    public Long getProductid() {
        return productid;
    }

    public void setProductid(Long productid) {
        this.productid = productid;
    }

    public Long getOrderid() {
        return orderid;
    }

    public void setOrderid(Long orderid) {
        this.orderid = orderid;
    }

    public Long getOrderlineid() {
        return orderlineid;
    }

    public void setOrderlineid(Long orderlineid) {
        this.orderlineid = orderlineid;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
