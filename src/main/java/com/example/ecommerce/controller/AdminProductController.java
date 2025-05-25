package com.example.ecommerce.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.ecommerce.model.Book;
import com.example.ecommerce.model.Product;
import com.example.ecommerce.repository.ProductRepository;
import com.example.ecommerce.service.BookService;
import com.example.ecommerce.service.ProductService;

// import com.example.ecommerce.service.StationaryService;
// import com.example.ecommerce.service.ToyService;



@Controller
public class AdminProductController {

    private final ProductRepository productRepository;
    @Autowired
    ProductService productService;
    @Autowired
    BookService bookService;

    AdminProductController(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }
    // @Autowired
    // StationaryService stationaryService;
    // @Autowired
    // ToyService toyService;

    @GetMapping("/admin/products/add")
    public String showAddForm(Model model) {
        model.addAttribute("product", new Product());
        return "admin-add-product";
    }

    @PostMapping("/admin/products/add")
    public String addProduct(@ModelAttribute("product") Product product, @RequestParam("category") String category, Model model) {
        if(!productService.getProductByName(product.getName()).isEmpty()) {
            model.addAttribute("error", "Product existed");
            return "redirect:/product-existed";
        }
        System.out.println(category);
        System.out.println("Added to product table");

        switch (category) {
            case "book":
                Book book = new Book();
                bookService.saveProduct(book);
                System.out.println("Added to book table");
                break;
            // case "stationary":
            //     Stationary stationary = new Stationary();
            //     stationary.setName(name);
            //     stationary.setDescription(description);
            //     stationary.setImportprice(importprice);
            //     stationary.setSellprice(sellprice);
            //     stationary.setBrand(brand);
            //     stationary.setType(type);
            //     stationaryService.saveProduct(stationary);
            //     System.out.println("Added to stationary table");
            //     break;
            // case "toy":
            //     Toy toy = new Toy();
            //     toy.setName(name);
            //     toy.setDescription(description);
            //     toy.setImportprice(importprice);
            //     toy.setSellprice(sellprice);
            //     toy.setBrand(brand);
            //     toy.setSuitableage(suitableage);
            //     toyService.saveProduct(toy);
            //     System.out.println("Added to toy table");
            //     break;
        }

        return "redirect:/admin/products";
    }


    @GetMapping("admin/products/edit/{id}")
    public String editProduct(@PathVariable Long id, Model model) {
        Product product = productService.getProductById(id);  // Trả về đúng thực thể con: Book, Toy, Stationary
        // System.out.println("Fount product with id " + id + ": " + product.getName());
        if (product instanceof Book) {
            model.addAttribute("product", (Book) product);
        // } else if (product instanceof Toy) {
        //     model.addAttribute("product", (Toy) product);
        // } else if (product instanceof Stationary) {
        //     model.addAttribute("product", (Stationary) product);
        } else {
            model.addAttribute("product", product);
        }

        return "admin-edit-product"; // Trỏ tới templates/admin/edit-product.html
    }

    @PostMapping("/admin/products/save")
public String saveProduct(@ModelAttribute("product") Product product) {
    System.out.println(product.toString());
    String category = product.getProductType();
    switch (category) {
        case "Book":
        product.setId(productService.getProductByName(product.getName()).get(0).getId());
            bookService.saveProduct(product);
            break;
        // case "Toy":
        //     Toy toy = new Toy();
        //     copyProductFields(product, toy);
        //     fullProduct = toy;
        //     break;
        // case "Stationary":
        //     Stationary stationary = new Stationary();
        //     copyProductFields(product, stationary);
        //     fullProduct = stationary;
        //     break;
        // default:
        //     fullProduct = product;
    }

    return "redirect:/admin/products";
}


    @GetMapping("admin/products/delete/{id}")
    public String deleteProduct(@PathVariable Long id) {
        productService.deleteProduct(id);
        return "redirect:/products";
    }
    @GetMapping("/admin/products")
    public String listProducts(Model model) {
        model.addAttribute("products", productService.getAllProducts());
        return "products"; // phải có file này trong templates/admin/
    }

    
    public void copyProductFields(Product target, Product source) {
        target.setName(source.getName());
        target.setDescription(source.getDescription());
        target.setSellprice(source.getSellprice());
        target.setQuantity(source.getQuantity());
        target.setImage(source.getImage());
        target.setTax(source.getTax());
        target.setStatus(source.getStatus());
        target.setImportprice(source.getImportprice());
        target.setId(source.getId());
    // thêm nếu cần
    }
}
