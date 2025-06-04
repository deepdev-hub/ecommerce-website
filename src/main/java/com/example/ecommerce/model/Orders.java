package com.example.ecommerce.model;

import java.util.Date;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "orders") // nếu tên bảng trong DB là "orders"
public class Orders {

    @Id
    private Long orderid;

    private Date orderdate;
    private double taxvat;
    private double netamount;
    private double totalamount;
    private Long storestaffid;
    private Long customerid;

    public Orders() {
        // JPA yêu cầu constructor mặc định
    }

    public Orders(Long orderid, Date orderdate, double taxvat, double netamount, double totalamount,
                  Long storestaffid, Long customerid) {
        this.orderid = orderid;
        this.orderdate = orderdate;
        this.taxvat = taxvat;
        this.netamount = netamount;
        this.totalamount = totalamount;
        this.storestaffid = storestaffid;
        this.customerid = customerid;
    }

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

    public void setTotalamount(double totalamount) {
        this.totalamount = totalamount;
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
}
