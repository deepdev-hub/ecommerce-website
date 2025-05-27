package com.example.ecommerce.model;
import java.util.Date;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name="storestaff")
public class StoreStaff {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long storestaffid;
    private String staffname;
    private String email;
    private String phone;
    private String gender;
    private String position;
    private String address;
    private Date startdate;
    private int workhour;
    private double hesoluong;
}