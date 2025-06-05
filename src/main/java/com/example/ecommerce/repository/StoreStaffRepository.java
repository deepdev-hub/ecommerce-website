package com.example.ecommerce.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.ecommerce.model.StoreStaff;

@Repository
public interface StoreStaffRepository extends JpaRepository<StoreStaff, Long> {
    StoreStaff findByPeopleid(Long storestaffid);
}
