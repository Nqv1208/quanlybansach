package com.quanlybansach.controller.user;

import com.quanlybansach.dao.BookDAO;
import com.quanlybansach.dao.CustomerDAO;
import com.quanlybansach.dao.OrderDAO;
import com.quanlybansach.model.Book;
import com.quanlybansach.model.Customer;
import com.quanlybansach.model.Order;
import com.quanlybansach.model.OrderDetail;
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
import java.util.List;

@WebServlet("/orders/*")
public class OrderServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private CustomerDAO customerDAO;
    private BookDAO bookDAO;

    public void init() {
        orderDAO = new OrderDAO();
        customerDAO = new CustomerDAO();
        bookDAO = new BookDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String action = pathInfo != null ? pathInfo : "";
        
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
        Customer customer = (Customer) session.getAttribute("user");
        
        if (customer == null) {
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
        
        List<Order> orders = orderDAO.getAllOrders(); // Simplified for now, replace with proper implementation
        int totalOrders = orders.size();
        int totalPages = (int) Math.ceil((double) totalOrders / recordsPerPage);
        
        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/orders.jsp");
        dispatcher.forward(request, response);
    }

    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("user");
        
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int orderId = Integer.parseInt(request.getParameter("id"));
        // Replace with appropriate implementation - for now use sample data
        Order order = new Order(); // In real implementation, use orderDAO.getOrderById(orderId);
        order.setOrderId(orderId);
        order.setCustomerId(customer.getCustomerId());
        
        // Verify the order belongs to the logged-in customer
        if (order.getCustomerId() != customer.getCustomerId()) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        
        request.setAttribute("order", order);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/orders/detail.jsp");
        dispatcher.forward(request, response);
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("user");
        
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        // Replace with appropriate implementation
        Order order = new Order(); // In real implementation, use orderDAO.getOrderById(orderId);
        order.setOrderId(orderId);
        order.setCustomerId(customer.getCustomerId());
        order.setStatus("pending");
        
        // Verify the order belongs to the logged-in customer and is in pending status
        if (order.getCustomerId() != customer.getCustomerId() || !order.getStatus().equals("pending")) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        
        order.setStatus("cancelled");
        // In a real implementation, add methods to Order class to handle cancellation details
        // order.setCancelledDate(new Date());
        // order.setCancelReason("Hủy bởi khách hàng");
        
        // In real implementation, use orderDAO.updateOrder(order);
        
        // Return to order details page
        response.sendRedirect(request.getContextPath() + "/orders/detail?id=" + orderId);
    }

    private void showReviewForm(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("user");
        
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int orderId = Integer.parseInt(request.getParameter("id"));
        // Replace with appropriate implementation
        Order order = new Order(); // In real implementation, use orderDAO.getOrderById(orderId);
        order.setOrderId(orderId);
        order.setCustomerId(customer.getCustomerId());
        order.setStatus("delivered");
        
        // Verify the order belongs to the logged-in customer and is delivered
        if (order.getCustomerId() != customer.getCustomerId() || !order.getStatus().equals("delivered")) {
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
        Customer customer = (Customer) session.getAttribute("user");
        
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int orderId = Integer.parseInt(request.getParameter("id"));
        // Replace with appropriate implementation
        Order order = new Order(); // In real implementation, use orderDAO.getOrderById(orderId);
        order.setOrderId(orderId);
        order.setCustomerId(customer.getCustomerId());
        
        // Verify the order belongs to the logged-in customer
        if (order.getCustomerId() != customer.getCustomerId()) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        
        // Add items from the order back to the cart - simplified implementation
        // In a real implementation, you'd get the actual order details
        List<OrderDetail> items = order.getOrderDetails();
        if (items != null) {
            SessionUtil.clearCart(session);
            
            for (OrderDetail item : items) {
                // This would need to be implemented correctly in OrderDetail
                Book book = bookDAO.getBookById(item.getBookId());
                if (book != null) {
                    SessionUtil.addToCart(session, book, item.getQuantity());
                }
            }
        }
        
        // Redirect to cart page
        response.sendRedirect(request.getContextPath() + "/cart");
    }
} 