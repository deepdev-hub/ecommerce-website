package com.example.ecommerce.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.ecommerce.model.Orders;

public interface OrderRepository extends JpaRepository<Orders, Long> {}
