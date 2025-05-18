package com.example.ecommerce.model;


public class admin {
    Long adminid;
    String adminname;
    String email;
    String phone;
    String gender;

    public admin() {
    }

    public Long getAdminid() {
        return adminid;
    }

    public void setAdminid(Long managerid) {
        this.adminid = managerid;
    }

    public String getAdminname() {
        return adminname;
    }

    public void setAdminname(String managername) {
        this.adminname = managername;
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
    
}
