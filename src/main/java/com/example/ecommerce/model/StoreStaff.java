package com.example.ecommerce.model;

import java.util.Date;

public class StoreStaff {
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
    public Long getStorestaffid() {
        return storestaffid;
    }
    public void setStorestaffid(Long storestaffid) {
        this.storestaffid = storestaffid;
    }
    public Long getAdminid() {
        return adminid;
    }
    public void setAdminid(Long adminid) {
        this.adminid = adminid;
    }
    public StoreStaff(Long storestaffid, String storestaffname, String email, String phone, String gender,
            String position, String address, Date startdate, int workhour, Long adminid) {
        this.storestaffid = storestaffid;
        this.storestaffname = storestaffname;
        this.email = email;
        this.phone = phone;
        this.gender = gender;
        this.position = position;
        this.address = address;
        this.startdate = startdate;
        this.workhour = workhour;
        this.adminid = adminid;
    }
}