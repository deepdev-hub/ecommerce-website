package com.example.ecommerce.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.ecommerce.model.Orderlines;

public interface OrderlinesRepository extends JpaRepository<Orderlines, Long> {}
