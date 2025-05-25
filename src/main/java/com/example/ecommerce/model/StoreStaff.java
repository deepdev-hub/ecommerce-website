package com.example.ecommerce.model;


import jakarta.persistence.*;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class StoreStaff {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    Long storestaffid;
    String staffname;
    String email;
    String phone;
    String gender;
    // String position;
    // String address;
    // Date startdate;
    // int workhour;
    // Long adminid;

}