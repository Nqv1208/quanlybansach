package com.quanlybansach.controller.admin;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.quanlybansach.dao.CustomerDAO;
import com.quanlybansach.model.Author;
import com.quanlybansach.model.Book;
import com.quanlybansach.model.Category;
import com.quanlybansach.model.Customer;

@WebServlet(urlPatterns = {"/admin/customers/*"})
public class CustomerServlet extends HttpServlet {
   private static final long serialVersionUID = 1L;
   private CustomerDAO customerDAO;

   @Override
   public void init() throws ServletException {
      customerDAO = new CustomerDAO();
      // Initialization code here
   }

   @Override
   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      String action = request.getPathInfo();
      if (action == null) {
         action = "/list";
      }
      
      switch (action) {
         case "/list":
            listCustomers(request, response);
            break;
         case "/show":
            showCustomer(request, response);
            break;
         case "/new":
            showNewForm(request, response);
            break;
         case "/edit":
            showNewForm(request, response);
            break;
         case "/delete":
            deleteCustomer(request, response);
            break;
         default:
            listCustomers(request, response);
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
            createCustomer(request, response);
            break;
         case "/update":
            updateCustomer(request, response);
            break;
         case "/search":
            searchCustomers(request, response);
            break;
         default:
            listCustomers(request, response);
            break;
      }
   }

   private void searchCustomers(HttpServletRequest request, HttpServletResponse response) {
      // TODO Auto-generated method stub
      throw new UnsupportedOperationException("Unimplemented method 'searchCustomers'");
   }

   private void updateCustomer(HttpServletRequest request, HttpServletResponse response) {
      // TODO Auto-generated method stub
      throw new UnsupportedOperationException("Unimplemented method 'updateCustomer'");
   }

   private void createCustomer(HttpServletRequest request, HttpServletResponse response) {
      // TODO Auto-generated method stub
      throw new UnsupportedOperationException("Unimplemented method 'createCustomer'");
   }

   private void deleteCustomer(HttpServletRequest request, HttpServletResponse response) {
      // TODO Auto-generated method stub
      throw new UnsupportedOperationException("Unimplemented method 'deleteCustomer'");
   }

   private void showNewForm(HttpServletRequest request, HttpServletResponse response) {
      // TODO Auto-generated method stub
      throw new UnsupportedOperationException("Unimplemented method 'showNewForm'");
   }

   private void showCustomer(HttpServletRequest request, HttpServletResponse response) {
      // TODO Auto-generated method stub
      throw new UnsupportedOperationException("Unimplemented method 'showCustomer'");
   }

   private void listCustomers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      List<Customer> customers = customerDAO.getAllCustomers();
      request.setAttribute("customers", customers);
        
      request.getRequestDispatcher("/WEB-INF/views/admin/customers.jsp").forward(request, response);
   }
   
}
