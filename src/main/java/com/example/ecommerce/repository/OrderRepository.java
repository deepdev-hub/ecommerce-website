package com.example.ecommerce.repository;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.ecommerce.model.Order;

import jakarta.transaction.Transactional;
@Repository
@Transactional
public interface OrderRepository extends JpaRepository<Order, Long> {
        List<Order> findByStatus(String status);

}
