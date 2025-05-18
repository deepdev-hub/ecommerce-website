package com.example.ecommerce.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.ecommerce.model.Book;
import com.example.ecommerce.model.Product;
import com.example.ecommerce.model.Stationary;
import com.example.ecommerce.model.Toy;
import com.example.ecommerce.service.BookService;
import com.example.ecommerce.service.ProductService;
import com.example.ecommerce.service.StationaryService;
import com.example.ecommerce.service.ToyService;



@Controller
public class AdminProductController {
    @Autowired
    ProductService productService;
    @Autowired
    BookService bookService;
    @Autowired
    StationaryService stationaryService;
    @Autowired
    ToyService toyService;

    @GetMapping("/admin/products/add")
    public String showAddForm(Model model) {
        model.addAttribute("product", new Product());
        return "admin-add-product";
    }

    @PostMapping("/admin/products/save")
public String saveProduct(
    @RequestParam("category") String category,
    @RequestParam("name") String name,
    @RequestParam("description") String description,
    @RequestParam("price") Double price,
    // Các trường riêng:
    @RequestParam(required = false) String isbn,
    @RequestParam(required = false) String author,
    @RequestParam(required = false) String publisher,
    @RequestParam(required = false) String brand,
    @RequestParam(required = false) String type,
    @RequestParam(required = false) String suitableage
) {
    System.out.println(category);
    System.out.println(name);
    System.out.println(description);
    System.out.println(price);
    System.out.println("Added to product table");

    switch (category) {
        case "book":
            Book book = new Book();
            book.setName(name);
            book.setDescription(description);
            book.setSellPrice(price);
            book.setIsbn(isbn);
            book.setAuthor(author);
            book.setPublisher(publisher);
            bookService.saveProduct(book);
            System.out.println("Added to book table");
            break;
        case "stationary":
            Stationary stationary = new Stationary();
            stationary.setName(name);
            stationary.setDescription(description);
            stationary.setSellPrice(price);
            stationary.setBrand(brand);
            stationary.setType(type);
            stationaryService.saveProduct(stationary);
            System.out.println("Added to stationary table");
            break;
        case "toy":
            Toy toy = new Toy();
            toy.setName(name);
            toy.setDescription(description);
            toy.setSellPrice(price);
            toy.setBrand(brand);
            toy.setSuitableage(suitableage);
            toyService.saveProduct(toy);
            System.out.println("Added to toy table");
            break;
    }

    return "redirect:/admin/products";
}


    @GetMapping("admin/products/edit/{id}")
    public String editProduct(@PathVariable Long id, Model model) {
    Product product = productService.getProductById(id);  // Trả về đúng thực thể con: Book, Toy, Stationary
    System.out.println("Fount product with id " + id + ": " + product.getName());
    
    model.addAttribute("product", product);
    return "admin-edit-product"; // Trỏ tới templates/admin/edit-product.html
}

    @GetMapping("/delete/{id}")
    public String deleteProduct(@PathVariable Long id) {
        productService.deleteProduct(id);
        return "redirect:/products";
    }
    @GetMapping("/admin/products")
    public String listProducts(Model model) {
        model.addAttribute("products", productService.getAllProducts());
        return "products"; // phải có file này trong templates/admin/
    }
}
