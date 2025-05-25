package com.example.ecommerce.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.ecommerce.model.Orderlines;


@Repository
public interface OrderlineRepository extends JpaRepository<Orderlines, Long> {
    // Orderlines  findByCustomerid(Long customerid);
}


