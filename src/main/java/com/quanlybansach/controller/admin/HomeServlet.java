package com.quanlybansach.controller.admin;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.quanlybansach.dao.BookDAO;
import com.quanlybansach.dao.CustomerDAO;
import com.quanlybansach.dao.OrderDAO;
import com.quanlybansach.model.Book;
import com.quanlybansach.model.Order;

@WebServlet(urlPatterns = {"/admin/home"})
public class HomeServlet extends HttpServlet {
   private OrderDAO  orderDAO;
   private BookDAO bookDAO;
   private CustomerDAO customers;
   private static final long serialVersionUID = 1L;

   @Override
   public void init() {
      // Initialize the servlet and load recent orders
      orderDAO = new OrderDAO();
      bookDAO = new BookDAO();
      customers = new CustomerDAO();
   }

   @Override
   public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      // Handle GET requests
      List<Order> recentOrders = orderDAO.getRecenOrders();
      List<Book> bestSellBooks = bookDAO.getBestSellBooks();
      List<Book> lowStockBooks = bookDAO.getLowStockBooks();
      int totalBooks = bookDAO.getTotalBooks();
      int totalOrders = orderDAO.getTotalTodayOrders();
      int totalCustomers = customers.getTotalCustomers();
      BigDecimal totalRevenue = orderDAO.getMonthlyRevenue();

      request.setAttribute("recentOrders", recentOrders);
      request.setAttribute("bestSellBooks", bestSellBooks);
      request.setAttribute("lowStockBooks", lowStockBooks);
      request.setAttribute("totalBooks", totalBooks);
      request.setAttribute("totalOrders", totalOrders);
      request.setAttribute("totalCustomers", totalCustomers);
      request.setAttribute("totalRevenue", totalRevenue);
      request.getRequestDispatcher("/WEB-INF/views/admin/home.jsp").forward(request, response);
   }
}
