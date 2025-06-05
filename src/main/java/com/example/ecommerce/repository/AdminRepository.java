package com.example.ecommerce.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.ecommerce.model.Admin;
@Repository
public interface AdminRepository extends JpaRepository<Admin, Long> {
    Admin findByStorestaffusername(String adminusername);
}