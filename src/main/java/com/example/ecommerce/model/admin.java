package com.example.ecommerce.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
public class Admin {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long adminid;
    @NotBlank(message = "truong nay khong duoc de trong")
    String adminusername;
    @NotBlank(message = "truong nay khong duoc de trong")
    private String adminpassword;
    private String adminname;
    private String email;
    private String phone;
    private String gender;  
}