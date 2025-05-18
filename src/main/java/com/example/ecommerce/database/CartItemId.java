// package com.example.ecommerce.database;

// import java.io.Serializable;
// import java.util.Objects;

// import jakarta.persistence.Embeddable;
// import lombok.AllArgsConstructor;
// import lombok.Data;
// import lombok.NoArgsConstructor;
// @Data
// @NoArgsConstructor
// @AllArgsConstructor
// @Embeddable
// public class CartItemId implements Serializable{
//     private Long cart;
//     private Long product;

//     @Override
//     public boolean equals(Object o) {
//         if (this == o) return true;
//         if (!(o instanceof CartItemId)) return false;
//         CartItemId that = (CartItemId) o;
//         return Objects.equals(cart, that.cart) &&
//                Objects.equals(product, that.product);
//     }

//     @Override
//     public int hashCode() {
//         return Objects.hash(cart, product);
//     }
// }
