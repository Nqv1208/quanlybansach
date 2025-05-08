package com.quanlybansach.controller.admin;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.quanlybansach.dao.CategoryDAO;
import com.quanlybansach.model.Category;

@WebServlet(urlPatterns = {"/admin/categories/*"})
public class CategoryServlet extends HttpServlet {
   private static final long serialVersionUID = 1L;
   private CategoryDAO categoryDAO;

   public void init() throws ServletException {
      categoryDAO = new CategoryDAO();
   }

   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      String action = request.getPathInfo();

      if (action == null) {
            action = "/list";
      }

      switch (action) {
            case "/list":
               listCategories(request, response);
               break;
            case "/add":
               showAddForm(request, response);
               break;
            case "/insert":
               insertCategory(request, response);
               break;
            case "/edit":
               showAddForm(request, response);
               break;
            case "/update":
               updateCategory(request, response);
               break;
            case "/delete":
               updateCategory(request, response);
               break;
            default:
               listCategories(request, response);
               break;
      }
   }

   private void updateCategory(HttpServletRequest request, HttpServletResponse response) {
      // TODO Auto-generated method stub
      throw new UnsupportedOperationException("Unimplemented method 'updateCategory'");
   }

   private void insertCategory(HttpServletRequest request, HttpServletResponse response) {
      // TODO Auto-generated method stub
      throw new UnsupportedOperationException("Unimplemented method 'insertCategory'");
   }

   private void showAddForm(HttpServletRequest request, HttpServletResponse response) {
      // TODO Auto-generated method stub
      throw new UnsupportedOperationException("Unimplemented method 'showAddForm'");
   }

   private void listCategories(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      List<Category> categories = categoryDAO.getAllCategories();
      request.setAttribute("categories", categories);
      request.getRequestDispatcher("/WEB-INF/views/admin/categories.jsp").forward(request, response);
   }
   
}
