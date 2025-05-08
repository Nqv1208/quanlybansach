package com.quanlybansach.service;

import com.quanlybansach.dao.BookDAO;
import com.quanlybansach.dao.CategoryDAO;
import com.quanlybansach.model.Book;
import com.quanlybansach.model.Category;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 * Lớp service xử lý logic nghiệp vụ liên quan đến sách
 */
public class BookService {
    private BookDAO bookDAO;
    private CategoryDAO categoryDAO;
    
    public BookService() {
        this.bookDAO = new BookDAO();
        this.categoryDAO = new CategoryDAO();
    }
    
    /**
     * Lấy danh sách tất cả sách
     */
    public List<Book> getAllBooks() throws SQLException {
        return bookDAO.getAllBooks();
    }
    
    /**
     * Lấy thông tin chi tiết một cuốn sách
     */
    public Book getBookById(int bookId) throws SQLException {
        return bookDAO.getBookById(bookId);
    }
    
    /**
     * Lấy danh sách sách theo danh mục
     */
    public List<Book> getBooksByCategory(int categoryId) throws SQLException {
        return bookDAO.getBooksByCategory(categoryId);
    }
    
    /**
     * Tìm kiếm sách theo từ khóa
     */
    public List<Book> searchBooks(String keyword) throws SQLException {
        // Trong thực tế, bạn sẽ gọi phương thức tương ứng từ BookDAO
        List<Book> allBooks = bookDAO.getAllBooks();
        List<Book> result = new ArrayList<>();
        
        if (keyword == null || keyword.trim().isEmpty()) {
            return allBooks;
        }
        
        keyword = keyword.toLowerCase();
        
        for (Book book : allBooks) {
            if (book.getTitle().toLowerCase().contains(keyword) || 
                (book.getAuthorName() != null && book.getAuthorName().toLowerCase().contains(keyword)) ||
                (book.getDescription() != null && book.getDescription().toLowerCase().contains(keyword))) {
                result.add(book);
            }
        }
        
        return result;
    }
    
    /**
     * Lấy danh sách sách mới nhất
     */
    public List<Book> getNewArrivals(int limit) throws SQLException {
        List<Book> allBooks = bookDAO.getAllBooks();
        
        // Sắp xếp sách theo ngày xuất bản (giảm dần)
        Collections.sort(allBooks, new Comparator<Book>() {
            @Override
            public int compare(Book b1, Book b2) {
                if (b1.getPublicationDate() == null || b2.getPublicationDate() == null) {
                    return 0;
                }
                return b2.getPublicationDate().compareTo(b1.getPublicationDate());
            }
        });
        
        // Lấy số lượng sách cần thiết
        return allBooks.subList(0, Math.min(limit, allBooks.size()));
    }
    
    /**
     * Lấy danh sách sách bán chạy nhất
     */
    public List<Book> getBestSellers(int limit) throws SQLException {
        List<Book> allBooks = bookDAO.getAllBooks();
        
        // Sắp xếp sách theo số lượng đã bán (giảm dần)
        Collections.sort(allBooks, new Comparator<Book>() {
            @Override
            public int compare(Book b1, Book b2) {
                return Integer.compare(b2.getTotalSold(), b1.getTotalSold());
            }
        });
        
        // Lấy số lượng sách cần thiết
        return allBooks.subList(0, Math.min(limit, allBooks.size()));
    }
    
    /**
     * Lấy danh sách sách được đánh giá cao nhất
     */
    public List<Book> getTopRatedBooks(int limit) throws SQLException {
        List<Book> allBooks = bookDAO.getAllBooks();
        
        // Sắp xếp sách theo đánh giá trung bình (giảm dần)
        Collections.sort(allBooks, new Comparator<Book>() {
            @Override
            public int compare(Book b1, Book b2) {
                return Float.compare(b2.getAvgRating(), b1.getAvgRating());
            }
        });
        
        // Lấy số lượng sách cần thiết
        return allBooks.subList(0, Math.min(limit, allBooks.size()));
    }
    
    /**
     * Lấy danh sách danh mục
     */
    public List<Category> getAllCategories() throws SQLException {
        return categoryDAO.getAllCategories();
    }
    
    /**
     * Lấy thông tin chi tiết một danh mục
     */
    public Category getCategoryById(int categoryId) throws SQLException {
        // Trong thực tế, bạn sẽ gọi phương thức tương ứng từ CategoryDAO
        List<Category> allCategories = categoryDAO.getAllCategories();
        
        for (Category category : allCategories) {
            if (category.getCategoryId() == categoryId) {
                return category;
            }
        }
        
        return null;
    }
    
    /**
     * Phân trang danh sách sách
     */
    public List<Book> getBooksPaginated(List<Book> books, int page, int pageSize) {
        int totalBooks = books.size();
        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalBooks);
        
        if (startIndex >= totalBooks) {
            return new ArrayList<>();
        }
        
        return books.subList(startIndex, endIndex);
    }
    
    /**
     * Tính tổng số trang
     */
    public int getTotalPages(int totalBooks, int pageSize) {
        return (int) Math.ceil((double) totalBooks / pageSize);
    }
} 