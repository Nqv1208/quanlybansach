package com.quanlybansach.service;

import com.quanlybansach.dao.OrderDAO;
import com.quanlybansach.dao.BookDAO;
import com.quanlybansach.model.Book;
import com.quanlybansach.model.Order;
import com.quanlybansach.model.OrderDetail;
import com.quanlybansach.model.CartItem;
import com.quanlybansach.model.CartSummary;
import com.quanlybansach.model.ShippingAddress;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
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
        // Trong thực tế, bạn sẽ gọi hàm tương ứng từ OrderDAO
        // và có thể thực hiện thêm logic nghiệp vụ ở đây
        List<Order> orders = orderDAO.getAllOrders();
        
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
        order.setStatus("cancelled");
        // Trong OrderDAO cần thêm các trường cancelledDate và cancelReason 
        // hoặc lưu thông tin cancel vào một bảng riêng
        
        // orderDAO.updateOrder(order);
        return true;
    }
    
    /**
     * Tạo mới đơn hàng từ giỏ hàng
     */
    public Order createOrder(int customerId, List<CartItem> cartItems, ShippingAddress shippingAddress,
                           String shippingMethod, String paymentMethod, CartSummary cartSummary) throws SQLException {
        // Tạo đơn hàng mới
        Order order = new Order();
        order.setCustomerId(customerId);
        order.setOrderDate(new Date());
        order.setStatus("pending");
        
        // Xử lý địa chỉ giao hàng
        String shippingAddressStr = String.format("%s, %s, %s, %s - %s", 
            shippingAddress.getAddress(),
            shippingAddress.getWard(), 
            shippingAddress.getDistrict(),
            shippingAddress.getProvinceText(),
            shippingAddress.getPhone());
        order.setShippingAddress(shippingAddressStr);
        
        // Xử lý phương thức thanh toán
        order.setPaymentMethod(paymentMethod);
        
        // Tính toán phí vận chuyển
        double shippingFee = 30000; // Mặc định
        if ("fast".equals(shippingMethod)) {
            shippingFee = 50000;
        } else if ("express".equals(shippingMethod)) {
            shippingFee = 80000;
        }
        
        // Tính tổng tiền
        BigDecimal subtotal = BigDecimal.valueOf(cartSummary.getSubtotal());
        BigDecimal discount = BigDecimal.valueOf(cartSummary.getDiscount());
        BigDecimal totalAmount = subtotal.add(BigDecimal.valueOf(shippingFee)).subtract(discount);
        
        order.setTotalAmount(totalAmount);
        
        // Lưu đơn hàng vào database để lấy ID
        // order = orderDAO.createOrder(order);
        
        // Tạo mã đơn hàng
        String orderCode = generateOrderCode();
        
        // Tạo mã vận đơn
        String trackingCode = generateTrackingCode();
        
        // Lưu thông tin chi tiết đơn hàng
        List<OrderDetail> orderDetails = new ArrayList<>();
        for (CartItem cartItem : cartItems) {
            OrderDetail orderDetail = new OrderDetail();
            // orderDetail.setOrderId(order.getOrderId());
            orderDetail.setBookId(cartItem.getBook().getBookId());
            orderDetail.setQuantity(cartItem.getQuantity());
            orderDetail.setUnitPrice(cartItem.getBook().getPrice());
            orderDetail.setDiscount(BigDecimal.ZERO); // Có thể áp dụng giảm giá nếu cần
            
            // orderDAO.createOrderDetail(orderDetail);
            orderDetails.add(orderDetail);
        }
        
        // Thiết lập các thuộc tính khác
        order.setOrderDetails(orderDetails);
        
        return order;
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
    public String generateTrackingCode() {
        return "TRK" + UUID.randomUUID().toString().substring(0, 10).toUpperCase();
    }
    
    /**
     * Tính ngày giao hàng dự kiến
     */
    public Date calculateEstimatedDeliveryDate(String shippingMethod) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        
        if ("standard".equals(shippingMethod)) {
            calendar.add(Calendar.DAY_OF_MONTH, 3);
        } else if ("fast".equals(shippingMethod)) {
            calendar.add(Calendar.DAY_OF_MONTH, 2);
        } else if ("express".equals(shippingMethod)) {
            calendar.add(Calendar.DAY_OF_MONTH, 1);
        }
        
        return calendar.getTime();
    }
} 