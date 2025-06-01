package com.example.ecommerce.DTO;
import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MonthlySalesDTO {

    private LocalDate month;
    private Long totalOrders;
    private Double totalRevenue;
    private Double totalTax;
    private Long totalProductsSold;

    // Constructors, Getters, Setters
}

