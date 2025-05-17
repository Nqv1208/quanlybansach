package com.quanlybansach.controller.user;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.quanlybansach.dao.BookDAO;
import com.quanlybansach.service.BookService;


@WebServlet("/home/*")
public class HomeServlet extends HttpServlet {

   private BookDAO bookDAO;

   @Override
   public void init() throws ServletException {
      super.init();
      // Initialize the book service or any other resources needed for this servlet
      bookDAO = new BookDAO();
   }
   
   @Override
   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      String action = request.getPathInfo();
      System.out.println(action);
      
      if (action == null) {
         action = "/home";
      }

      if (action.equals("/home")) {
         // Handle the request for the home page
         request.setAttribute("books", bookDAO.getAllBooks());
         request.getRequestDispatcher("/WEB-INF/views/user/home.jsp").forward(request, response);
      } else if (action.equals("/search")) {
         // Handle the search action
         String keyword = request.getParameter("keyword");
         request.setAttribute("books", bookDAO.searchBooks(keyword));
         request.getRequestDispatcher("/WEB-INF/views/user/searchResults.jsp").forward(request, response);
      } else {
         // Handle other actions or show an error page
         response.sendError(HttpServletResponse.SC_NOT_FOUND);
      }
   }

   
   @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       
   }
}
