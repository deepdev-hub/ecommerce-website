package com.example.ecommerce.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.ecommerce.model.Cart;
import com.example.ecommerce.model.Customer;
// @Repository
public interface  CartRepository extends JpaRepository<Cart, Long>{

}
