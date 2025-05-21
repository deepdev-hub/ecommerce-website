package com.example.ecommerce.model;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
@Entity
@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Customer {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    Long customerid;
    String username;
    String password;
    String firstname;
    String lastname;
    String gender;
    String cardnumber;
    String phone;
    String email;
    String address;
    @OneToMany(mappedBy="customer")
    List<CartItem> cart = new ArrayList<>();
    public Customer(Long customerid, String username, String password, String firstname,
            String lastname) {
        this.customerid = customerid;
        this.username = username;
        this.password = password;
        this.firstname = firstname;
        this.lastname = lastname;
    }   
}
