package com.example.ecommerce.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.ecommerce.model.Stationary;

@Repository
public interface StationaryRepository extends JpaRepository<Stationary, Long>{

}
