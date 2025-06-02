package com.quanlybansach.service;

import com.quanlybansach.dao.BookDAO;
import com.quanlybansach.dao.CategoryDAO;
import com.quanlybansach.model.Book;
import com.quanlybansach.model.Category;

import java.math.BigDecimal;
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
    @SuppressWarnings("null")
    public List<Book> searchBooks(String keyword, String[] categories, String price, String[] authors, String rating) throws SQLException {
    List<Book> allBooks = bookDAO.getAllBooks();
    List<Book> result = new ArrayList<>();

    if ((keyword == null || isNullOrEmptyString(keyword)) && (categories == null || isNullOrEmptyArray(categories)) && (authors == null || isNullOrEmptyArray(authors)) && (rating == null || isNullOrEmptyString(rating)) && (price == null || isNullOrEmptyString(rating))) {
        return allBooks;
    }

    for (Book book : allBooks) {
        // 1. Từ khóa (title, author name, description)
        if (keyword != null && !keyword.isEmpty()) {

            String kw = keyword.toLowerCase();
            if ((book.getTitle() != null && book.getTitle().toLowerCase().contains(kw)) ||
                (book.getAuthorName() != null && book.getAuthorName().toLowerCase().contains(kw)) ||
                (book.getDescription() != null && book.getDescription().toLowerCase().contains(kw))) {
                result.add(book);
                continue;
            }
        }

        // 2. Danh mục
        if (categories != null && categories.length > 0) {
            for (String category : categories) {
                if (category != null && category.equalsIgnoreCase(String.valueOf(book.getCategoryId()))) {
                    result.add(book);
                    continue;
                }
            }
        }

        // 3. Giá
        if (price != null && !price.isEmpty()) {
            String[] range = price.split(",");
            if (range.length == 2) {
                try {
                    BigDecimal min = new BigDecimal(range[0]);
                    BigDecimal max = new BigDecimal(range[1]);
                    BigDecimal bookPrice = book.getPrice();

                    if (bookPrice != null) {
                        if ((min.compareTo(BigDecimal.ZERO) == 0 && bookPrice.compareTo(max) <= 0) ||
                            (max.compareTo(BigDecimal.ZERO) == 0 && bookPrice.compareTo(min) >= 0) ||
                            (bookPrice.compareTo(min) >= 0 && bookPrice.compareTo(max) <= 0)) {
                            result.add(book);
                            continue;
                        }
                    }
                } catch (NumberFormatException e) {
                    // Bỏ qua nếu sai định dạng
                }
            }
        }

        // 4. Tác giả
        if (authors != null && authors.length > 0) {
            for (String author : authors) {
                if (author != null && author.equalsIgnoreCase(String.valueOf(book.getAuthorId()))) {
                    result.add(book);
                    continue;
                }
            }
        }

        // 5. Rating
        if (rating != null && !rating.isEmpty()) {
            try {
                float minRating = Float.parseFloat(rating);
                if (book.getAvgRating() >= minRating) {
                    result.add(book);
                    continue;
                }
            } catch (NumberFormatException e) {
                // Bỏ qua
            }
        }
    }

    return result;
}

    public static void main(String[] args) throws SQLException {
        BookService bookService = new BookService();
        String[] authors = {""};
        List<Book> resultl = bookService.searchBooks("", args, null, authors, null);

        for (Book book : resultl) {
            System.out.println(book.toString());
        }
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

    public static boolean isNullOrEmptyArray(String[] arr) {
        if (arr == null || arr.length == 0) return true;

        for (String s : arr) {
            if (s != null && !s.trim().isEmpty()) return false; // có ít nhất 1 phần tử có giá trị
        }

        return true; // toàn bộ phần tử null hoặc ""
    }
    public static boolean isNullOrEmptyString(String str) {
        return str == null || str.trim().isEmpty();
    }
} 