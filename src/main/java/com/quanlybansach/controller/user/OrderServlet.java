package com.quanlybansach.controller.user;

import com.quanlybansach.dao.BookDAO;
import com.quanlybansach.dao.CustomerDAO;
import com.quanlybansach.dao.OrderDAO;
import com.quanlybansach.model.Account;
import com.quanlybansach.model.Book;
import com.quanlybansach.model.Customer;
import com.quanlybansach.model.Order;
import com.quanlybansach.model.OrderDetail;
import com.quanlybansach.service.OrderService;
import com.quanlybansach.util.SessionUtil;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;
import java.util.ArrayList;
import java.util.Calendar;

@WebServlet("/orders/*")
public class OrderServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private CustomerDAO customerDAO;
    private BookDAO bookDAO;
    private OrderService orderService;

    public void init() {
        orderDAO = new OrderDAO();
        customerDAO = new CustomerDAO();
        bookDAO = new BookDAO();
        orderService = new OrderService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String action = pathInfo != null ? pathInfo : "";

        System.out.println("Path info: " + action);
        
        try {
            switch (action) {
                case "/detail":
                    showOrderDetail(request, response);
                    break;
                case "/review":
                    showReviewForm(request, response);
                    break;
                case "/reorder":
                    reorder(request, response);
                    break;
                default:
                    listOrders(request, response);
                    break;
            }
        } catch (SQLException | ParseException ex) {
            throw new ServletException(ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String action = pathInfo != null ? pathInfo : "";
        
        try {
            switch (action) {
                case "/cancel":
                    cancelOrder(request, response);
                    break;
                case "/review/submit":
                    submitReview(request, response);
                    break;
                default:
                    listOrders(request, response);
                    break;
            }
        } catch (SQLException | ParseException ex) {
            throw new ServletException(ex);
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException, ParseException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        Integer customerId = (Integer) session.getAttribute("customerId");
        
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
                
        int page = 1;
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }
        
        int recordsPerPage = 10;
        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");
        
        Date startDate = null;
        Date endDate = null;
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        
        if (request.getParameter("startDate") != null && !request.getParameter("startDate").isEmpty()) {
            startDate = dateFormat.parse(request.getParameter("startDate"));
        }
        
        if (request.getParameter("endDate") != null && !request.getParameter("endDate").isEmpty()) {
            endDate = dateFormat.parse(request.getParameter("endDate"));
        }
        
        // Use OrderService to get orders by customer
        List<Order> orders = orderService.getOrdersByCustomer(
            customerId, 
            status, 
            keyword, 
            startDate, 
            endDate, 
            page, 
            recordsPerPage
        );
        
        // Get total count for pagination
        int totalOrders = orderService.countOrdersByCustomer(
            customerId, 
            status, 
            keyword, 
            startDate, 
            endDate
        );
        
        int totalPages = (int) Math.ceil((double) totalOrders / recordsPerPage);
        
        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/orders.jsp");
        dispatcher.forward(request, response);
    }

    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        Integer customerId = (Integer) session.getAttribute("customerId");
        
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
            
        int orderId = Integer.parseInt(request.getParameter("id"));
        Order order = orderService.getOrderById(orderId);
        
        // Xác minh đơn hàng thuộc về khách hàng đã đăng nhập
        if (order == null || order.getCustomerId() != customerId) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        
        request.setAttribute("order", order);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/orders/detail.jsp");
        dispatcher.forward(request, response);
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        Integer customerId = (Integer) session.getAttribute("customerId");

        System.out.println("\nCancel order request received");
        System.out.println("Customer ID: " + customerId);
        System.out.println("Account: " + (account != null ? account.getUsername() : "null"));       

        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        Order order = orderService.getOrderById(orderId);
        
        if (order == null || order.getCustomerId() != customerId || !order.getStatus().equals("Chờ xử lý")) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        
        // Cancel the order
        boolean success = orderService.cancelOrder(order);

        if (success) {
            System.out.println("Order " + orderId + " cancelled successfully.");
            response.sendRedirect(request.getContextPath() + "/orders");
        } else {
            // Return to order details page
            response.sendRedirect(request.getContextPath() + "/orders/detail?id=" + orderId);
        }
    }

    private void showReviewForm(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        
        int orderId = Integer.parseInt(request.getParameter("id"));
        Order order = orderService.getOrderById(orderId);
        
        // Verify the order belongs to the logged-in customer and is delivered
        if (order == null || order.getCustomerId() != customer.getCustomerId() || !order.getStatus().equals("delivered")) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        
        request.setAttribute("order", order);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/orders/review.jsp");
        dispatcher.forward(request, response);
    }

    private void submitReview(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        // Implementation for submitting reviews
        // This would handle the form submission from the review page
        // and save the reviews to the database
        
        // Redirect back to the order detail page
        response.sendRedirect(request.getContextPath() + "/orders/detail?id=" + request.getParameter("orderId"));
    }

    private void reorder(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        Integer customerId = (Integer) session.getAttribute("customerId");
        
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        
        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        Order order = orderService.getOrderById(orderId);
        
        // Xác nhận có người dùng
        if (order == null || order.getCustomerId() != customerId) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        // Cancel the order
        boolean success = orderService.cancelOrder(order);

        if (success) {
            System.out.println("Reorder successfully!!!");
            response.sendRedirect(request.getContextPath() + "/orders");
        } else {
            // Return to order details page
            response.sendRedirect(request.getContextPath() + "/orders/detail?id=" + orderId);
        }
        
        // Redirect to cart page
        response.sendRedirect(request.getContextPath() + "/orders");
    }
} 