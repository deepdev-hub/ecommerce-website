package com.example.ecommerce.DTO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CartItemDTO{


    public Long productid;
    public String name;
    public String image;
    public Double sellprice;
    public int quantity;

}
