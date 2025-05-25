package com.example.ecommerce.repository;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.ecommerce.model.Customer;
import com.example.ecommerce.model.Orders;
@Repository
public interface OrderRepository extends JpaRepository<Orders, Long> {
    List<Orders> findByCustomerid(Long customerid);
    List<Orders> findByCustomerAndStatus(Customer customer, String status);
}
