package com.example.ecommerce.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.ecommerce.model.StoreStaff;
@Repository
public interface StaffRepository extends JpaRepository<StoreStaff, Long> {
}
