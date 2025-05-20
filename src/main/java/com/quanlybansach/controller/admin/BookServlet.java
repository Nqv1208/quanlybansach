package com.quanlybansach.controller.admin;

import com.quanlybansach.dao.AuthorDAO;
import com.quanlybansach.dao.BookDAO;
import com.quanlybansach.dao.CategoryDAO;
import com.quanlybansach.dao.PublisherDAO;
import com.quanlybansach.model.Author;
import com.quanlybansach.model.Book;
import com.quanlybansach.model.Category;
import com.quanlybansach.model.Publisher;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/books/*"})
public class BookServlet extends HttpServlet {
    private BookDAO bookDAO;
    private AuthorDAO authorDAO;
    private CategoryDAO categoryDAO;
    private PublisherDAO publisherDAO;
    
    @Override
    public void init() {
        bookDAO = new BookDAO();
        authorDAO = new AuthorDAO();
        categoryDAO = new CategoryDAO();
        publisherDAO = new PublisherDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) {
            action = "/list";
        }
        
        switch (action) {
            case "/list":
                listBooks(request, response);
                break;
            case "/show":
                showBook(request, response);
                break;
            default:
                listBooks(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getPathInfo();

        System.out.println("Action: " + action);

        if (action == null) {
            action = "/list";
        }
        
        switch (action) {
            case "/create":
                createBook(request, response);
                break;
            case "/update":
                updateBook(request, response);
                break;
            case "/delete":
                deleteBook(request, response);
                break;
            case "/search":
                searchBooks(request, response);
                break;
            default:
                listBooks(request, response);
                break;
        }
    }
    
    private void listBooks(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Book> books = bookDAO.getAllBooks();
        List<Author> authors = authorDAO.getAllAuthors();
        List<Category> categories = categoryDAO.getAllCategories();
        List<Publisher> publishers = publisherDAO.getAllPublishers();
        
        request.setAttribute("books", books);
        request.setAttribute("authors", authors);
        request.setAttribute("categories", categories);
        request.setAttribute("publishers", publishers);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/books.jsp").forward(request, response);
    }
    
    private void showBook(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookId = Integer.parseInt(request.getParameter("id"));
        Book book = bookDAO.getBookById(bookId);
        
        if (book != null) {
            request.setAttribute("book", book);
            request.getRequestDispatcher("/WEB-INF/views/admin/books.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/books");
        }
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Author> authors = authorDAO.getAllAuthors();
        List<Category> categories = categoryDAO.getAllCategories();
        List<Publisher> publishers = publisherDAO.getAllPublishers();
        
        request.setAttribute("authors", authors);
        request.setAttribute("categories", categories);
        request.setAttribute("publishers", publishers);
        request.getRequestDispatcher("/WEB-INF/views/admin/books.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookId = Integer.parseInt(request.getParameter("id"));
        Book book = bookDAO.getBookById(bookId);
        
        if (book != null) {
            List<Author> authors = authorDAO.getAllAuthors();
            List<Category> categories = categoryDAO.getAllCategories();
            List<Publisher> publishers = publisherDAO.getAllPublishers();
            
            request.setAttribute("book", book);
            request.setAttribute("authors", authors);
            request.setAttribute("categories", categories);
            request.setAttribute("publishers", publishers);
            request.getRequestDispatcher("/WEB-INF/views/admin/books.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/books");
        }
    }
    
    private void createBook(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String title = request.getParameter("title");
        int authorId = Integer.parseInt(request.getParameter("authorId"));
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        int publisherId = Integer.parseInt(request.getParameter("publisherId"));
        String isbn = request.getParameter("isbn");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
        String publicationDateStr = request.getParameter("publicationDate");
        String description = request.getParameter("description");
        String imageUrl = request.getParameter("imageUrl");
        
        Book newBook = new Book();
        newBook.setTitle(title);
        newBook.setAuthorId(authorId);
        newBook.setCategoryId(categoryId);
        newBook.setPublisherId(publisherId);
        newBook.setIsbn(isbn);
        newBook.setPrice(price);
        newBook.setStockQuantity(stockQuantity);
        newBook.setDescription(description);
        newBook.setImageUrl(imageUrl);
        
        if (publicationDateStr != null && !publicationDateStr.isEmpty()) {
            try {
                java.util.Date parsedDate = new SimpleDateFormat("yyyy-MM-dd").parse(publicationDateStr);
                newBook.setPublicationDate(parsedDate);
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        
        if (bookDAO.addBook(newBook)) {
            response.sendRedirect(request.getContextPath() + "/admin/books");
            System.out.println("Thêm sách thành công!");
        } else {
            request.setAttribute("error", "Không thể thêm sách mới.");
            request.getRequestDispatcher("/WEB-INF/views/admin/books.jsp").forward(request, response);
            System.out.println("Thêm sách thất bại!");
        }
    }
    
    private void updateBook(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookIdParam = request.getParameter("bookId");
        if (bookIdParam == null || bookIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số id");
            return;
        }

        int bookId = Integer.parseInt(bookIdParam); // Chuyển đổi an toàn sau khi kiểm tra
        String title = request.getParameter("title");
        String authorIdParam = request.getParameter("authorId");
        String categoryIdParam = request.getParameter("categoryId");
        String priceParam = request.getParameter("price");
        String stockQuantityParam = request.getParameter("stockQuantity");
        String publicationDateStr = request.getParameter("publicationDate");
        String description = request.getParameter("description");
        String imageUrl = request.getParameter("imageUrl");

        // Kiểm tra các tham số khác
        if (title == null || title.isEmpty() || authorIdParam == null || authorIdParam.isEmpty() ||
            categoryIdParam == null || categoryIdParam.isEmpty() ||
            priceParam == null || priceParam.isEmpty() || stockQuantityParam == null || stockQuantityParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu thông tin cần thiết để cập nhật sách");
            return;
        }

        int authorId = Integer.parseInt(authorIdParam);
        int categoryId = Integer.parseInt(categoryIdParam);
        BigDecimal price = new BigDecimal(priceParam);
        int stockQuantity = Integer.parseInt(stockQuantityParam);

        // Lấy sách từ cơ sở dữ liệu
        Book book = bookDAO.getBookById(bookId);

        if (book != null) {
            book.setTitle(title);
            book.setAuthorId(authorId);
            book.setCategoryId(categoryId);
            book.setPrice(price);
            book.setStockQuantity(stockQuantity);
            book.setDescription(description);
            book.setImageUrl(imageUrl);

            if (publicationDateStr != null && !publicationDateStr.isEmpty()) {
                try {
                    java.util.Date parsedDate = new SimpleDateFormat("yyyy-MM-dd").parse(publicationDateStr);
                    book.setPublicationDate(parsedDate);
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }

            bookDAO.updateBook(book);
        }

        response.sendRedirect(request.getContextPath() + "/admin/books");
    }
    
    private void deleteBook(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy tham số từ form
    String bookIdParam = request.getParameter("bookId");

    // Kiểm tra nếu tham số không null
    if (bookIdParam != null) {
        int bookId = Integer.parseInt(bookIdParam); // Chuyển đổi sang kiểu số nguyên
        System.out.println("Book ID: " + bookId);

        // Xử lý logic xóa sách
        boolean isDeleted = bookDAO.deleteBook(bookId);
        if (isDeleted) {
            response.sendRedirect(request.getContextPath() + "/admin/books"); // Chuyển hướng về danh sách sách
        } else {
            request.setAttribute("error", "Không thể xóa sách.");
            request.getRequestDispatcher("/WEB-INF/views/admin/books.jsp").forward(request, response);
        }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số bookId");
        }
    }
    
    private void searchBooks(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }
    
        String category = request.getParameter("category");
        String author = request.getParameter("author");
        int categoryId;
        int authorId;
    
        // Xử lý category
        if (category == null || category.trim().isEmpty()) {
            categoryId = 0;
        } else {
            categoryId = Integer.parseInt(category);
        }
    
        // Xử lý author
        if (author == null || author.trim().isEmpty()) {
            authorId = 0;
        } else {
            authorId = Integer.parseInt(author);
        }
    
        List<Book> books = bookDAO.getBookByParemeters(keyword, categoryId, authorId, null, null, null);
        List<Author> authors = authorDAO.getAllAuthors();
        List<Category> categories = categoryDAO.getAllCategories();
    
        request.setAttribute("books", books);
        request.setAttribute("authors", authors);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/admin/books.jsp").forward(request, response);
    }
}