package com.example.ecommerce.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
@Getter
@Setter
@Entity
@NoArgsConstructor
@AllArgsConstructor
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
}
