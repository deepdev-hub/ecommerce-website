package com.example.ecommerce.model;

public interface HaveSalary {
    public double calculateSalary();
    public boolean   increaseSalary(double step);
    public boolean   decreaseSalary(double step);
}
