package com.example.ecommerce.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.ecommerce.model.OrderLine;

import jakarta.transaction.Transactional;


@Repository
@Transactional
public interface OrderlineRepository extends JpaRepository<OrderLine, Long> {
    // OrderLine  findByCustomerid(Long customerid);
}


