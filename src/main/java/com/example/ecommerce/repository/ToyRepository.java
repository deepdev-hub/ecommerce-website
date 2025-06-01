package com.example.ecommerce.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.ecommerce.model.Toy;

@Repository
public interface ToyRepository extends JpaRepository<Toy , Long> {

}
