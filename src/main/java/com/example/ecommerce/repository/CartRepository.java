package com.example.ecommerce.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.example.ecommerce.model.CartItem;
import com.example.ecommerce.model.Customer;


@Repository
@Transactional
public interface  CartRepository extends JpaRepository<CartItem, Long>{
    CartItem  findByCustomer(Customer customer);
}
