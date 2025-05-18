package com.example.ecommerce.model;


import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
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
    String customername;
    String firstname;
    String lastname;
    String gender;
    String cardnumber;

    String phone;
    String email;
    String address;
    // @OneToOne(mappedBy = "customer", cascade = CascadeType.ALL, fetch = FetchType.LAZY)    
    // Cart cart;
    public Customer(Long customerid, String username, String password, String customername, String firstname,
            String lastname) {
        this.customerid = customerid;
        this.username = username;
        this.password = password;
        this.customername = customername;
        this.firstname = firstname;
        this.lastname = lastname;
    }   
    
    
}
