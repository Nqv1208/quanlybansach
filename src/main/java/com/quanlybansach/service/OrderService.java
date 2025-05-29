package com.quanlybansach.service;

import com.quanlybansach.dao.OrderDAO;
import com.quanlybansach.dao.BookDAO;
import com.quanlybansach.model.Book;
import com.quanlybansach.model.Order;
import com.quanlybansach.model.OrderDetail;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * Lớp service xử lý logic nghiệp vụ liên quan đến đơn hàng
 */
public class OrderService {
    private OrderDAO orderDAO;
    private BookDAO bookDAO;
    
    public OrderService() {
        this.orderDAO = new OrderDAO();
        this.bookDAO = new BookDAO();
    }
    
    /**
     * Lấy danh sách đơn hàng của khách hàng
     */
    public List<Order> getOrdersByCustomer(int customerId, String status, String keyword, 
                                         Date startDate, Date endDate, int page, int recordsPerPage) throws SQLException {
        
        List<Order> orders = orderDAO.getOrdersByCustomerId(customerId);
        
        // Lọc theo customerId và các điều kiện khác
        List<Order> filteredOrders = new ArrayList<>();
        for (Order order : orders) {
            if (order.getCustomerId() == customerId) {
                // Thêm điều kiện lọc theo status nếu cần
                if (status != null && !status.equals("all") && !order.getStatus().equals(status)) {
                    continue;
                }
                
                // Thêm điều kiện lọc theo keyword nếu cần
                if (keyword != null && !keyword.isEmpty() && 
                    !String.valueOf(order.getOrderId()).contains(keyword)) {
                    continue;
                }
                
                // Thêm điều kiện lọc theo ngày nếu cần
                if (startDate != null && order.getOrderDate().before(startDate)) {
                    continue;
                }
                
                if (endDate != null && order.getOrderDate().after(endDate)) {
                    continue;
                }
                
                filteredOrders.add(order);
            }
        }
        
        // Tính phân trang
        int startIndex = (page - 1) * recordsPerPage;
        int endIndex = Math.min(startIndex + recordsPerPage, filteredOrders.size());
        
        if (startIndex >= filteredOrders.size()) {
            return new ArrayList<>();
        }
        
        return filteredOrders.subList(startIndex, endIndex);
    }
    
    /**
     * Đếm số lượng đơn hàng của khách hàng
     */
    public int countOrdersByCustomer(int customerId, String status, String keyword, 
                                   Date startDate, Date endDate) throws SQLException {
        // Trong thực tế, bạn sẽ gọi hàm tương ứng từ OrderDAO
        List<Order> orders = orderDAO.getAllOrders();
        
        // Lọc theo customerId và các điều kiện khác
        int count = 0;
        for (Order order : orders) {
            if (order.getCustomerId() == customerId) {
                // Thêm điều kiện lọc theo status nếu cần
                if (status != null && !status.equals("all") && !order.getStatus().equals(status)) {
                    continue;
                }
                
                // Thêm điều kiện lọc theo keyword nếu cần
                if (keyword != null && !keyword.isEmpty() && 
                    !String.valueOf(order.getOrderId()).contains(keyword)) {
                    continue;
                }
                
                // Thêm điều kiện lọc theo ngày nếu cần
                if (startDate != null && order.getOrderDate().before(startDate)) {
                    continue;
                }
                
                if (endDate != null && order.getOrderDate().after(endDate)) {
                    continue;
                }
                
                count++;
            }
        }
        
        return count;
    }
    
    /**
     * Lấy thông tin chi tiết đơn hàng
     */
    public Order getOrderById(int orderId) throws SQLException {
        // Trong thực tế, bạn sẽ gọi hàm tương ứng từ OrderDAO
        return orderDAO.getOrderById(orderId);
    }
    
    /**
     * Hủy đơn hàng
     */
    public boolean cancelOrder(Order order) throws SQLException {
        order.setStatus("Đã hủy");
        
        boolean  success = orderDAO.updateOrderStatus(order.getOrderId(), order.getStatus());
        
        return success;
    }

    /**
     * Đặt lại đơn hàng
     */
    public boolean reOrder(Order order) throws SQLException {
        order.setStatus("Đang xử lý");
        order.setOrderDate(new Date());

        boolean  success = orderDAO.updateOrderStatus(order.getOrderId(), order.getStatus());

        return success;
    }
    
    /**
     * Tạo mã đơn hàng
     */
    public String generateOrderCode() {
        String dateString = new SimpleDateFormat("yyyyMMdd").format(new Date());
        String randomPart = String.format("%04d", (int) (Math.random() * 10000));
        return "ORD-" + dateString + "-" + randomPart;
    }
    
    /**
     * Tạo mã vận đơn
     */
    // public String generateTrackingCode() {
    //     return "TRK" + UUID.randomUUID().toString().substring(0, 10).toUpperCase();
    // }
    
    /**
     * Lấy danh sách tất cả đơn hàng
     */
    public List<Order> getAllOrders() {
        return orderDAO.getAllOrders();
    }
    
    /**
     * Lấy danh sách đơn hàng gần đây
     */
    public List<Order> getRecentOrders() {
        return orderDAO.getRecenOrders();
    }
    
    /**
     * Lấy tổng số đơn hàng trong ngày hôm nay
     */
    public int getTotalTodayOrders() {
        return orderDAO.getTotalTodayOrders();
    }
    
    /**
     * Lấy doanh thu tháng hiện tại
     */
    public BigDecimal getMonthlyRevenue() {
        return orderDAO.getMonthlyRevenue();
    }
    
    /**
     * Cập nhật trạng thái đơn hàng
     */
    public boolean updateOrderStatus(int orderId, String status) {
        // Kiểm tra dữ liệu đầu vào
        if (orderId <= 0 || status == null || status.trim().isEmpty()) {
            return false;
        }
        
        try {
            Order order = orderDAO.getOrderById(orderId);
            if (order != null) {
                order.setStatus(status);
                // Giả sử có phương thức updateOrder trong OrderDAO
                // return orderDAO.updateOrder(order);
                return true; // Tạm thời trả về true vì chưa có phương thức updateOrder
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    /**
     * Create a new order with order details
     * 
     * @param order The order to create
     * @param orderDetails The order details
     * @return The order ID of the newly created order, or -1 if an error occurred
     */
    public int createOrder(Order order, List<OrderDetail> orderDetails) {
        try {
            // Create the order
            System.out.println("OrderService - Creating order: " + order.toString());
            int orderId = orderDAO.createOrder(order);
            
            if (orderId == -1) {
                System.err.println("OrderService - Failed to create order");
                return -1;
            }
            
            System.out.println("OrderService - Order created with ID: " + orderId);
            
            // Create the order details
            boolean allDetailsCreated = true;
            for (OrderDetail detail : orderDetails) {
                detail.setOrderId(orderId);
                boolean success = orderDAO.createOrderDetail(
                    orderId, 
                    detail.getBookId(), 
                    detail.getQuantity(), 
                    detail.getUnitPrice(), 
                    detail.getDiscount()
                );
                
                if (!success) {
                    System.err.println("OrderService - Failed to create order detail: " + detail.toString());
                    allDetailsCreated = false;
                    break;
                }
            }
            
            if (!allDetailsCreated) {
                // If any detail failed to create, consider the entire order failed
                System.err.println("OrderService - Not all order details were created successfully");
                return -1;
            }
            
            System.out.println("OrderService - Order and all details created successfully");
            return orderId;
        } catch (SQLException e) {
            System.err.println("OrderService - Error creating order: " + e.getMessage());
            e.printStackTrace();
            return -1;
        }
    }
} 