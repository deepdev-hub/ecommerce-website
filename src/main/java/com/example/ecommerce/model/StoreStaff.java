package com.example.ecommerce.model;

import java.util.Date;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;

@Entity
public class StoreStaff {
    @Id
    
    Long storestaffid;
    
    String storestaffname;
    String email;
    String phone;
    String gender;
    String position;
    String address;
    Date startdate;
    int workhour;
    Long adminid;
    
    public String getStorestaffname() {
        return storestaffname;
    }
    public void setStorestaffname(String employeename) {
        this.storestaffname = employeename;
    }
    
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getPhone() {
        return phone;
    }
    public void setPhone(String phone) {
        this.phone = phone;
    }
    public String getGender() {
        return gender;
    }
    public void setGender(String gender) {
        this.gender = gender;
    }
    public String getPosition() {
        return position;
    }
    public void setPosition(String position) {
        this.position = position;
    }
    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }
    public Date getStartdate() {
        return startdate;
    }
    public void setStartdate(Date startdate) {
        this.startdate = startdate;
    }
    public int getWorkhour() {
        return workhour;
    }
    public void setWorkhour(int workhour) {
        this.workhour = workhour;
    }
    
    public StoreStaff() {}
    public StoreStaff(int employeeid, String employeename, String firstname, String lastname, String email,
            String phone, String gender, String position, String address, Date startdate, int workhour, int managerid) {
        this.storestaffname = employeename;
        this.email = email;
        this.phone = phone;
        this.gender = gender;
        this.position = position;
        this.address = address;
        this.startdate = startdate;
        this.workhour = workhour;
    }
    
}
