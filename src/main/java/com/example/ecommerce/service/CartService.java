// package com.example.ecommerce.service;

// import java.util.ArrayList;
// import java.util.List;
// import java.util.Optional;

// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.stereotype.Service;

// import com.example.ecommerce.database.CartItemId;
// import com.example.ecommerce.entity.CartItem;
// import com.example.ecommerce.model.Cart;
// import com.example.ecommerce.model.Customer;
// import com.example.ecommerce.model.Product;
// import com.example.ecommerce.repository.CartItemRepository;
// import com.example.ecommerce.repository.CartRepository;
// import com.example.ecommerce.repository.ProductRepository;

// @Service
// public class CartService {
//     @Autowired
//     private CartRepository cartRepository;

//     @Autowired
//     private ProductRepository productRepository;

//     @Autowired
//     private CartItemRepository cartItemRepository;
//     public Cart getOrCreateCart(Long customerId) {
//         Cart cart = cartRepository.findByCustomerid(customerId);
//         if (cart == null) {
//             cart = new Cart();
//             Customer customer = new Customer();
//             customer.setCustomerid(customerId);
//             cart.setCustomer(customer);
//             cartRepository.save(cart);
//         }
//         return cart;
//     }
//      public void addProductToCart(Long customerId, Long productId, int quantity) {
//         Cart cart = getOrCreateCart(customerId);
//         Product product = productRepository.findById(productId)
//                 .orElseThrow(() -> new RuntimeException("Product not found"));

//         CartItemId cartItemId = new CartItemId(cart.getCartid(), product.getProductid());
//         Optional<CartItem> existingItemOpt = cartItemRepository.findById(cartItemId);

//         CartItem item;
//         if (existingItemOpt.isPresent()) {
//             item = existingItemOpt.get();
//             item.setQuantity(item.getQuantity() + quantity);
//         } else {
//             item = new CartItem();
//             item.setCart(cart);
//             item.setProduct(product);
//             item.setQuantity(quantity);
//         }
//         cartItemRepository.save(item);
//     }
//      public List<CartItem> getCartItems(Long customerId) {
//         Cart cart = cartRepository.findByCustomerid(customerId);
//         if (cart == null) return new ArrayList<>();
//         return cart.getCartItems();
//     }


// }
