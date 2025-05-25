package com.example.ecommerce.model;


import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.MapsId;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
@Entity
// @Table(name="order")
public class Orders {

    Long orderid;
    Date orderdate;
    double taxvat;
    double netamount;
    double totalamount;
    Long storestaffid;
    Long customerid;
    String status;

    @OneToMany(
        mappedBy = "order"
    )
    List<Orderlines> orderedItems = new ArrayList<>();
    

    public Long getOrderid() {
        return orderid;
    }

    public void setOrderid(Long orderid) {
        this.orderid = orderid;
    }

    public Date getOrderdate() {
        return orderdate;
    }

    public void setOrderdate(Date orderdate) {
        this.orderdate = orderdate;
    }

    public double getTaxvat() {
        return taxvat;
    }

    public void setTaxvat(double taxvat) {
        this.taxvat = taxvat;
    }

    public double getNetamount() {
        return netamount;
    }

    public void setNetamount(double netamount) {
        this.netamount = netamount;
    }

    public double getTotalamount() {
        return totalamount;
    }

    public void setTotalamount(double totalAmount) {
        this.totalamount = totalAmount;
    }

    

    public Long getStorestaffid() {
        return storestaffid;
    }

    public void setStorestaffid(Long storestaffid) {
        this.storestaffid = storestaffid;
    }

    public Long getCustomerid() {
        return customerid;
    }

    public void setCustomerid(Long customerid) {
        this.customerid = customerid;
    }

    public Orders(Long orderid, Date orderdate, double taxvat, double netamount, double totalamount, Long storestaffid,
            Long customerid) {
        this.orderid = orderid;
        this.orderdate = orderdate;
        this.taxvat = taxvat;
        this.netamount = netamount;
        this.totalamount = totalamount;
        this.storestaffid = storestaffid;
        this.customerid = customerid;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<Orderlines> getOrderedItems() {
        return orderedItems;
    }

    public void setOrderedItems(List<Orderlines> orderedItems) {
        this.orderedItems = orderedItems;
    }

    
}
