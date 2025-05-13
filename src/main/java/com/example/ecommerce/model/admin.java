package com.example.ecommerce.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;
@Getter
@Setter
@Entity
public class Admin {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    Long adminid;
    @NotBlank(message = "truong nay khong duoc de trong")
    String adminusername;
    @NotBlank(message = "truong nay khong duoc de trong")
    String adminpassword;

    String adminname;
    String email;
    String phone;
    String gender;

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

    public Admin(Long adminid, String adminusername, String adminpassword, String adminname, String email, String phone,
            String gender) {
        this.adminid = adminid;
        this.adminusername = adminusername;
        this.adminpassword = adminpassword;
        this.adminname = adminname;
        this.email = email;
        this.phone = phone;
        this.gender = gender;
    }
    public Admin( String adminusername, String adminpassword) {
        this.adminusername = adminusername;
        this.adminpassword = adminpassword;
    }
    
}
