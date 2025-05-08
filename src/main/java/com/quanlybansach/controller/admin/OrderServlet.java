package com.quanlybansach.controller.admin;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.quanlybansach.dao.OrderDAO;
import com.quanlybansach.model.Customer;
import com.quanlybansach.model.Order;

@WebServlet(urlPatterns = {"/admin/orders/*"})
public class OrderServlet extends HttpServlet {
   private static final long serialVersionUID = 1L;
   private OrderDAO orderDAO;

   @Override
   public void init() throws ServletException {
      // Initialization code here
      orderDAO = new OrderDAO();
   }

   @Override
   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      String action = request.getPathInfo();
      if (action == null) {
         action = "/list";
      }
      
      switch (action) {
         case "/list":
            listOrders(request, response);
            break;
         case "/show":
            showOrder(request, response);
            break;
         case "/new":
            showNewForm(request, response);
            break;
         case "/edit":
            showNewForm(request, response);
            break;
         case "/delete":
            deleteOrder(request, response);
            break;
         default:
            listOrders(request, response);
            break;
      }
}

   private void deleteOrder(HttpServletRequest request, HttpServletResponse response) {
      // TODO Auto-generated method stub
      throw new UnsupportedOperationException("Unimplemented method 'deleteOrder'");
   }

   private void showNewForm(HttpServletRequest request, HttpServletResponse response) {
      // TODO Auto-generated method stub
      throw new UnsupportedOperationException("Unimplemented method 'showNewForm'");
   }

   private void showOrder(HttpServletRequest request, HttpServletResponse response) {
      // TODO Auto-generated method stub
      throw new UnsupportedOperationException("Unimplemented method 'showOrder'");
   }

   private void listOrders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      List<Order> orders = orderDAO.getAllOrders();
      request.setAttribute("orders", orders);
        
      request.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(request, response);
   }


   @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      request.setCharacterEncoding("UTF-8");
      String action = request.getPathInfo();

      if (action == null) {
         action = "/list";
      }
      
      switch (action) {
         case "/create":
            createOrder(request, response);
            break;
         case "/update":
            updateOrder(request, response);
            break;
         case "/search":
            searchOrders(request, response);
            break;
         default:
            listOrders(request, response);
            break;
      }
   }

   private void createOrder(HttpServletRequest request, HttpServletResponse response) {
      // TODO Auto-generated method stub
      throw new UnsupportedOperationException("Unimplemented method 'createOrder'");
   }

   private void updateOrder(HttpServletRequest request, HttpServletResponse response) {
      // TODO Auto-generated method stub
      throw new UnsupportedOperationException("Unimplemented method 'updateOrder'");
   }

   private void searchOrders(HttpServletRequest request, HttpServletResponse response) {
      // TODO Auto-generated method stub
      throw new UnsupportedOperationException("Unimplemented method 'searchOrders'");
   }
}
