package com.example.ecommerce.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.ecommerce.model.Book;
import com.example.ecommerce.service.BookService;

@Controller
public class BookController {

    @Autowired
    private BookService bookService;

    @GetMapping("/book")
    public String showBookList(Model model) {
        List<Book> list = bookService.getAllBook();
        model.addAttribute("books", list);
        return "book";
    }

    @GetMapping("/book/{id}")
    public String showBookDetail(@PathVariable Long id, Model model) {
        Book book = bookService.getBookById(id);
        if (book == null) {
            model.addAttribute("error", "Book not found");
        }
        model.addAttribute("book", book);
        return "book-detail";
    }

    @GetMapping("/book-detail")
    public String showBookDetailByParam(@RequestParam("id") Long id, Model model) {
        Book book = bookService.getBookById(id);
        if (book == null) {
            model.addAttribute("error", "Book not found");
        }
        model.addAttribute("book", book);
        return "book-detail";
    }

    @GetMapping("/api/book")
    @ResponseBody
    public List<Book> getAllBooksApi() {
        return bookService.getAllBook();
    }

    @GetMapping("/api/book/{id}")
    @ResponseBody
    public Book getBookByIdApi(@PathVariable Long id) {
        return bookService.getBookById(id);
    }
}
