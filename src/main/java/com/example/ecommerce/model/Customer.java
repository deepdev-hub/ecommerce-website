package com.example.ecommerce.model;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.Entity;
import jakarta.persistence.OneToMany;
import jakarta.persistence.PrimaryKeyJoinColumn;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
@Entity
@EqualsAndHashCode(callSuper=false)
@Data
@NoArgsConstructor
@AllArgsConstructor
@PrimaryKeyJoinColumn(name = "customerid") 

public class Customer extends People{

    String username;
    String password;
    String gender;
    String cardnumber;
    String phone;
    String email;
    String address;
    @OneToMany(mappedBy="customer")
    List<CartItem> cart = new ArrayList<>();

    public Customer(Long peopleid, String name, String username, String password) {
        super(peopleid, name);
        this.username = username;
        this.password = password;
    }
    public Customer(String username, String password) {
        this.username = username;
        this.password = password;
    }   
    
}
