package com.quanlybansach.controller.admin;

import javax.servlet.annotation.WebServlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.quanlybansach.dao.AuthorDAO;
import com.quanlybansach.model.Author;

@WebServlet(urlPatterns = {"/admin/authors/*"})
public class AuthorServlet extends HttpServlet {
   private AuthorDAO authorDAO;

   @Override
   public void init() {
   authorDAO = new AuthorDAO();
   }

   @Override
   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      String action = request.getPathInfo();
      
      if (action == null) {
         action = "/list";
      }

      switch (action) {
         case "/list":
            listAuthors(request, response);
            break;
         case "/show":
            showAuthor(request, response);
            break;
         default:
            listAuthors(request, response);
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
            createAuthor(request, response);
            break;
         case "/update":
            updateAuthor(request, response);
            break;
         case "/delete":
            deleteAuthor(request, response);
            break;
         case "/search":
            searchAuthors(request, response);
            break;
         default:
            listAuthors(request, response);
            break;
      }
   }

   private void searchAuthors(HttpServletRequest request, HttpServletResponse response) {
      String keyword = request.getParameter("keyword");
      if (keyword == null) {
         keyword = "";
      }
      String country = request.getParameter("country");
      if (country == null || country.trim().isEmpty()) {
         country = "tất cả";
      }

      List<Author> authors = authorDAO.getAuthorsByParameters(keyword, country);
      List<String> countries = authorDAO.getAllCountries();

      request.setAttribute("countries", countries);
      request.setAttribute("authors", authors);
      
      try {
         request.getRequestDispatcher("/WEB-INF/views/authors.jsp").forward(request, response);
      } catch (ServletException | IOException e) {
         e.printStackTrace();
      }
   }

   private void deleteAuthor(HttpServletRequest request, HttpServletResponse response) {
      int authorId = Integer.parseInt(request.getParameter("authorId"));
      boolean isDeleted = authorDAO.deleteAuthor(authorId);
      
      if (isDeleted) {
         request.setAttribute("message", "Author deleted successfully.");
      } else {
         request.setAttribute("message", "Failed to delete author.");
      }
      
      listAuthors(request, response);
   }

   private void updateAuthor(HttpServletRequest request, HttpServletResponse response) {
      int authorId = Integer.parseInt(request.getParameter("authorId"));
      String name = request.getParameter("name");
      String bio = request.getParameter("bio");
      String image = request.getParameter("image");
      Integer birthYear = null;
      if (request.getParameter("birthYear") != null && !request.getParameter("birthYear").isEmpty()) {
         birthYear = Integer.parseInt(request.getParameter("birthYear"));
      }
      String country = request.getParameter("country");

      Author author = new Author(authorId, image, name, bio, birthYear, country);
      boolean isUpdated = authorDAO.updateAuthor(author);

      if (isUpdated) {
         request.setAttribute("message", "Author updated successfully.");
      } else {
         request.setAttribute("message", "Failed to update author.");
      }

      listAuthors(request, response);
   }

   private void createAuthor(HttpServletRequest request, HttpServletResponse response) {
      String name = request.getParameter("name");
      String bio = request.getParameter("bio");
      String image = request.getParameter("image");
      Integer birthYear = null;
      if (request.getParameter("birthYear") != null && !request.getParameter("birthYear").isEmpty()) {
         birthYear = Integer.parseInt(request.getParameter("birthYear"));
      }
      String country = request.getParameter("country");

      Author author = new Author(0, image, name, bio, birthYear, country);
      boolean isCreated = authorDAO.addAuthor(author);

      if (isCreated) {
         request.setAttribute("message", "Author created successfully.");
      } else {
         request.setAttribute("message", "Failed to create author.");
      }

      listAuthors(request, response);
   }

   private void showAuthor(HttpServletRequest request, HttpServletResponse response) {
      // TODO Auto-generated method stub
      throw new UnsupportedOperationException("Unimplemented method 'showAuthor'");
   }

   private void listAuthors(HttpServletRequest request, HttpServletResponse response) {
      List<Author> authors = authorDAO.getAllAuthors();
      List<String> countries = authorDAO.getAllCountries();
      request.setAttribute("countries", countries);
      request.setAttribute("authors", authors);
      
      try {
         request.getRequestDispatcher("/WEB-INF/views/admin/authors.jsp").forward(request, response);
      } catch (ServletException | IOException e) {
         e.printStackTrace();
      }
   }

}
