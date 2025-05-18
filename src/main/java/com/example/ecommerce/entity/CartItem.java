// package com.example.ecommerce.entity;

// import com.example.ecommerce.model.Cart;
// import com.example.ecommerce.model.Product;

// import jakarta.persistence.Entity;
// import jakarta.persistence.Id;
// import jakarta.persistence.IdClass;
// import jakarta.persistence.ManyToOne;
// import jakarta.persistence.MapsId;
// import jakarta.persistence.Table;
// import lombok.AllArgsConstructor;
// import lombok.Data;
// import lombok.Getter;
// import lombok.NoArgsConstructor;
// import lombok.Setter;

// @Entity
// @Data
// @AllArgsConstructor
// @NoArgsConstructor
// @Getter
// @Setter
// @Table(name="cart_items")
// @IdClass(CartItem.class)
// public class CartItem {
//     @Id
//     @ManyToOne
//     @MapsId("cartid")
//     private Cart cart;
//     @Id
//     @ManyToOne
//     @MapsId("productid")
//     private Product product;

//     private Integer quantity;
    

// }
