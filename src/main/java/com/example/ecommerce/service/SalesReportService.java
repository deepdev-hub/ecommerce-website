package com.example.ecommerce.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.ecommerce.DTO.MonthlySalesDTO;
import com.example.ecommerce.repository.SalesReportRepository;

@Service
public class SalesReportService {

    @Autowired
    private SalesReportRepository repo;

    public List<MonthlySalesDTO> getMonthlySales() {
        return repo.getMonthlySalesRaw().stream().map(row -> {
            MonthlySalesDTO dto = new MonthlySalesDTO();
            dto.setMonth(((java.sql.Timestamp) row[0]).toLocalDateTime().toLocalDate().withDayOfMonth(1));
            dto.setTotalOrders(((Number) row[1]).longValue());
            dto.setTotalRevenue(((Number) row[2]).doubleValue());
            dto.setTotalTax(((Number) row[3]).doubleValue());
            dto.setTotalProductsSold(((Number) row[4]).longValue());
            return dto;
        }).collect(Collectors.toList());
    }
}