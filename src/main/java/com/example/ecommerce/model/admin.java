package com.example.ecommerce.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Entity
public class Admin {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    Long adminid;
    String adminusername;
    String adminpassword;
    String adminname;
    String email;
    String phone;
    String gender;   

    public Admin() {
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

    public String getAdminusername() {
        return adminusername;
    }

    public void setAdminusername(String adminusername) {
        this.adminusername = adminusername;
    }

    public String getAdminpassword() {
        return adminpassword;
    }

    public void setAdminpassword(String adminpassword) {
        this.adminpassword = adminpassword;
    }
    
}
