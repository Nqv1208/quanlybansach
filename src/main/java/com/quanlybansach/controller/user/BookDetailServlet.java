package com.quanlybansach.controller.user;

import com.quanlybansach.dao.BookDAO;
import com.quanlybansach.dao.CategoryDAO;
import com.quanlybansach.model.Book;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/book-detail")
public class BookDetailServlet extends HttpServlet {
    private BookDAO bookDAO;
    private CategoryDAO categoryDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        bookDAO = new BookDAO();
        categoryDAO = new CategoryDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get book ID from request parameter
            String bookIdParam = request.getParameter("id");
            
            if (bookIdParam == null || bookIdParam.isEmpty()) {
                // If no book ID is provided, redirect to shop page
                response.sendRedirect(request.getContextPath() + "/shop");
                return;
            }
            
            int bookId = Integer.parseInt(bookIdParam);
            
            // Fetch the book details
            Book book = bookDAO.getBookById(bookId);
            
            if (book == null) {
                // If book not found, redirect to shop page
                response.sendRedirect(request.getContextPath() + "/shop");
                return;
            }
            
            // Fetch related books (books in the same category)
            List<Book> relatedBooks = bookDAO.getRelatedBooks(bookId, book.getCategoryId(), 4);
            
            // Set attributes for the JSP
            request.setAttribute("book", book);
            request.setAttribute("relatedBooks", relatedBooks);
            
            // Forward to the book detail JSP
            request.getRequestDispatcher("/WEB-INF/views/user/book-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            // If book ID is not a valid number, redirect to shop page
            response.sendRedirect(request.getContextPath() + "/shop");
        } catch (Exception e) {
            e.printStackTrace();
            // Handle other exceptions
            response.sendRedirect(request.getContextPath() + "/error");
        }
    }
}
