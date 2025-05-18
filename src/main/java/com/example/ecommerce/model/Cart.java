// package com.example.ecommerce.model;

// import java.util.ArrayList;
// import java.util.List;

// import com.example.ecommerce.entity.CartItem;

// import jakarta.persistence.CascadeType;
// import jakarta.persistence.Entity;
// import jakarta.persistence.GeneratedValue;
// import jakarta.persistence.GenerationType;
// import jakarta.persistence.Id;
// import jakarta.persistence.OneToMany;
// import jakarta.persistence.Table;
// import lombok.AllArgsConstructor;
// import lombok.Data;
// import lombok.NoArgsConstructor;
// @Entity
// @Data
// @NoArgsConstructor
// @AllArgsConstructor
// @Table(name="cart")
// public class Cart {
//     @Id
//     @GeneratedValue(strategy=GenerationType.IDENTITY)
//     Long cartid;
//     Customer customer;
//     @OneToMany(mappedBy = "cart", cascade = CascadeType.ALL, orphanRemoval = true)
//     List<CartItem> cartItems =new ArrayList<>();
//     public void addProduct(Product p) {
//     }

//     public void deleteProduct(Product p) {
//     }

//     public double totalCost() {
//         double sum = 0;
//         // for (Product item : itemsOrdered) {
//         //     sum+= item.getSellprice();
//         // }
//         return sum;
//     }
// }

