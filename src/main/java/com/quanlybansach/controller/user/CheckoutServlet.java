package com.quanlybansach.controller.user;

import com.quanlybansach.dao.OrderDAO;
import com.quanlybansach.model.Customer;
import com.quanlybansach.model.Order;
import com.quanlybansach.model.OrderItem;
import com.quanlybansach.model.ShippingAddress;
import com.quanlybansach.model.CartItem;
import com.quanlybansach.model.CartSummary;
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
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.text.SimpleDateFormat;

@WebServlet("/checkout/*")
public class CheckoutServlet extends HttpServlet {
    private OrderDAO orderDAO;

    public void init() {
        orderDAO = new OrderDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();
        
        try {
            switch (action) {
                case "/user/checkout":
                    showCheckoutPage(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/user/cart");
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();
        
        try {
            switch (action) {
                case "/user/checkout/place-order":
                    placeOrder(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/user/cart");
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void showCheckoutPage(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("user");
        
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        List<CartItem> cart = SessionUtil.getCart(session);
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user/cart");
            return;
        }
        
        // Calculate cart summary
        CartSummary cartSummary = SessionUtil.getCartSummary(session);
        
        // Generate order code for reference in bank transfer
        String orderCode = generateOrderCode();
        session.setAttribute("orderCode", orderCode);
        
        request.setAttribute("cart", cart);
        request.setAttribute("cartSummary", cartSummary);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/checkout/index.jsp");
        dispatcher.forward(request, response);
    }

    private void placeOrder(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("user");
        
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        List<CartItem> cart = SessionUtil.getCart(session);
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user/cart");
            return;
        }
        
        // Get form data
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String province = request.getParameter("province");
        String district = request.getParameter("district");
        String ward = request.getParameter("ward");
        String shippingMethod = request.getParameter("shippingMethod");
        String paymentMethod = request.getParameter("paymentMethod");
        
        // Create shipping address
        ShippingAddress shippingAddress = new ShippingAddress();
        shippingAddress.setFullName(fullName);
        shippingAddress.setPhone(phone);
        shippingAddress.setEmail(email);
        shippingAddress.setAddress(address);
        shippingAddress.setProvince(province);
        shippingAddress.setDistrict(district);
        shippingAddress.setWard(ward);
        
        // Set province text based on code
        switch (province) {
            case "HN":
                shippingAddress.setProvinceText("Hà Nội");
                break;
            case "HCM":
                shippingAddress.setProvinceText("TP. Hồ Chí Minh");
                break;
            case "DN":
                shippingAddress.setProvinceText("Đà Nẵng");
                break;
            case "HP":
                shippingAddress.setProvinceText("Hải Phòng");
                break;
            case "CT":
                shippingAddress.setProvinceText("Cần Thơ");
                break;
            default:
                shippingAddress.setProvinceText(province);
        }
        
        // Create order - Using existing Order class
        Order order = new Order();
        order.setCustomerId(customer.getCustomerId());
        order.setOrderDate(new Date());
        order.setStatus("pending");
        
        // The following lines need to be commented out if the Order class doesn't have these methods
        // Handle shipping address - in real implementation, convert the object to formatted string
        String shippingAddressStr = String.format("%s, %s, %s, %s - %s", 
            shippingAddress.getAddress(),
            shippingAddress.getWard(),
            shippingAddress.getDistrict(),
            shippingAddress.getProvinceText(),
            shippingAddress.getPhone());
        order.setShippingAddress(shippingAddressStr);
        
        // Set payment method
        order.setPaymentMethod(paymentMethod);
        
        // Calculate shipping fee based on method
        double shippingFee = 30000; // Default standard shipping
        if ("fast".equals(shippingMethod)) {
            shippingFee = 50000;
        } else if ("express".equals(shippingMethod)) {
            shippingFee = 80000;
        }
        
        // Calculate total amount
        CartSummary cartSummary = SessionUtil.getCartSummary(session);
        BigDecimal subtotal = BigDecimal.valueOf(cartSummary.getSubtotal());
        BigDecimal discount = BigDecimal.valueOf(cartSummary.getDiscount());
        BigDecimal totalAmount = subtotal.add(BigDecimal.valueOf(shippingFee)).subtract(discount);
        
        order.setTotalAmount(totalAmount);
        
        // In a real implementation, order details would be saved to the database
        // For now, we'll create a sample order
        
        // Clear cart after successful order
        SessionUtil.clearCart(session);
        
        // Add tracking code for display
        String trackingCode = generateTrackingCode();
        
        // Set estimated delivery date based on shipping method
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        if ("standard".equals(shippingMethod)) {
            calendar.add(Calendar.DAY_OF_MONTH, 3);
        } else if ("fast".equals(shippingMethod)) {
            calendar.add(Calendar.DAY_OF_MONTH, 2);
        } else if ("express".equals(shippingMethod)) {
            calendar.add(Calendar.DAY_OF_MONTH, 1);
        }
        Date estimatedDeliveryDate = calendar.getTime();
        
        // Set these additional properties through request attributes
        request.setAttribute("order", order);
        request.setAttribute("trackingCode", trackingCode);
        request.setAttribute("estimatedDeliveryDate", estimatedDeliveryDate);
        request.setAttribute("shippingAddress", shippingAddress);
        
        // Forward to confirmation page
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/checkout/confirmation.jsp");
        dispatcher.forward(request, response);
    }
    
    private String generateOrderCode() {
        // Generate a random order code with format: ORD-YYYYMMDD-XXXX
        String dateString = new SimpleDateFormat("yyyyMMdd").format(new Date());
        String randomPart = String.format("%04d", (int) (Math.random() * 10000));
        return "ORD-" + dateString + "-" + randomPart;
    }
    
    private String generateTrackingCode() {
        // Generate a random tracking code
        return "TRK" + UUID.randomUUID().toString().substring(0, 10).toUpperCase();
    }
} 