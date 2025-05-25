package com.example.ecommerce.model;

import jakarta.persistence.FetchType;
import jakarta.persistence.ManyToOne;

public class Orderlines {
    Long productid;

    @ManyToOne
    Long orderid;
    
    Long orderlineid;
    int quantity;    
    
    public Long getProductid() {
        return productid;
    }
    public void setProductid(Long id) {
        this.productid = id;
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
    
    public Orderlines(Long id, Long orderid, Long orderlineid, int quantity, Long customerid
) {
        this.productid = id;
        this.orderid = orderid;
        this.orderlineid = orderlineid;
        this.quantity = quantity;
        
    }
}
