package com.quanlybansach.controller.user;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.quanlybansach.dao.BookDAO;
import com.quanlybansach.model.Book;
import com.quanlybansach.service.BookService;


@WebServlet({"/home", "/home/*"})
public class HomeServlet extends HttpServlet {

   private BookDAO bookDAO;
   private BookService bookService;

   @Override
   public void init() throws ServletException {
      super.init();
      // Initialize the book service or any other resources needed for this servlet
      bookDAO = new BookDAO();
      bookService = new BookService();
   }
   
   @Override
   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      String action = request.getPathInfo();
      
      if (action == null) {
         // Handle the request for the home page
         try {
            // Get data for homepage
            List<Book> allBooks = bookDAO.getAllBooks();
            List<Book> newArrivals = bookService.getNewArrivals(8); // Get 8 new arrivals
            
            // Set attributes for the JSP
            request.setAttribute("books", allBooks);
            request.setAttribute("newArrivals", newArrivals);
            
            // Forward to the JSP
            request.getRequestDispatcher("/WEB-INF/views/user/home.jsp").forward(request, response);
         } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
         }
      } else if (action.equals("/search")) {
         // Handle the search action
         String keyword = request.getParameter("keyword");
         try {
            request.setAttribute("books", bookDAO.searchBooks(keyword));
            request.getRequestDispatcher("/WEB-INF/views/user/searchResults.jsp").forward(request, response);
         } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
         }
      } else {
         // Handle other actions or show an error page
         response.sendError(HttpServletResponse.SC_NOT_FOUND);
      }
   }

   
   @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       
   }
}
