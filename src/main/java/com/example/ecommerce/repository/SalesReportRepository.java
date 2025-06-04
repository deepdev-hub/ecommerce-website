package com.example.ecommerce.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.Repository;

import com.example.ecommerce.model.Order;

public interface SalesReportRepository extends Repository<Order, Long> {

    @Query(value = """
        SELECT 
            DATE_TRUNC('month', o.orderdate) AS month,
            COUNT(DISTINCT o.orderid) AS totalOrders,
            SUM(o.totalamount) AS totalRevenue,
            SUM(o.taxvat) AS totalTax,
            SUM(ol.quantity) AS totalProductsSold
        FROM orders o
        JOIN orderlines ol ON o.orderid = ol.orderid
        GROUP BY DATE_TRUNC('month', o.orderdate)
        ORDER BY month
        """, nativeQuery = true)
    List<Object[]> getMonthlySalesRaw();
}

