package com.example.ecommerce.service;

import java.util.List;
import java.util.Optional;

import org.hibernate.annotations.FlushModeType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.ecommerce.model.Book;
import com.example.ecommerce.model.Product;
import com.example.ecommerce.repository.BookRepository;

@Service
public class BookService {
    @Autowired
    private BookRepository bookRepository;
    public List<Book> getAllBook(){
        return bookRepository.findAll();
    }
    public Book getBookById(Long id){
        return bookRepository.findById(id).orElse(null);
    }
    @Transactional
    public Book saveProduct(Product product) {
        Book book;
        if(product.getId() == null) {
            book = new Book();
            copyProductFields(book, product);
            return bookRepository.save((Book) product);
        }
        else {
            book = bookRepository.findById(product.getId()).orElse(new Book());
            copyProductFields(book, product);
            return bookRepository.save((Book) product);
        }

    }

    public void copyProductFields(Book target, Product source) {
        target.setName(source.getName());
        target.setDescription(source.getDescription());
        target.setSellprice(source.getSellprice());
        target.setQuantity(source.getQuantity());
        target.setImage(source.getImage());
        target.setTax(source.getTax());
        target.setStatus(source.getStatus());
        target.setImportprice(source.getImportprice());
        //target.setId(source.getId());
    // thêm nếu cần
    }
}
