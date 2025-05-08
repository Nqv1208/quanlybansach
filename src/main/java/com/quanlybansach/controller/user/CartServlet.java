package com.quanlybansach.controller.user;

import com.quanlybansach.dao.BookDAO;
import com.quanlybansach.model.Cart;
import com.quanlybansach.model.CartSummary;
import com.quanlybansach.service.CartService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet xử lý các thao tác liên quan đến giỏ hàng
 */
@WebServlet("/cart/*")
public class CartServlet extends HttpServlet {
    private CartService cartService;
    private BookDAO bookDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        cartService = new CartService();
        bookDAO = new BookDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/view")) {
            // Hiển thị giỏ hàng
            viewCart(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null) {
            pathInfo = "/";
        }
        
        switch (pathInfo) {
            case "/add":
                addToCart(request, response);
                break;
            case "/update":
                updateCart(request, response);
                break;
            case "/remove":
                removeFromCart(request, response);
                break;
            case "/clear":
                clearCart(request, response);
                break;
            case "/apply-coupon":
                applyCoupon(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/cart");
                break;
        }
    }
    
    /**
     * Hiển thị giỏ hàng
     */
    private void viewCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Cart cart = cartService.getCart(request);
        
        // Tạo CartSummary từ dữ liệu trong giỏ hàng
        CartSummary cartSummary = new CartSummary();
        cartSummary.setItemCount(cart.getTotalItems());
        cartSummary.setSubtotal(cart.getTotalAmount().doubleValue());
        
        // Tính phí vận chuyển (miễn phí nếu đơn hàng > 200.000đ)
        double shippingFee = cart.getTotalAmount().doubleValue() >= 200000 ? 0 : 30000;
        cartSummary.setShippingFee(shippingFee);
        
        // Áp dụng giảm giá nếu có
        double discount = 0; // Tạm thời chưa có logic giảm giá
        cartSummary.setDiscount(discount);
        
        // Tính tổng cộng
        cartSummary.calculateTotal();
        
        request.setAttribute("cart", cart.getItems());
        request.setAttribute("cartSummary", cartSummary);
        
        request.getRequestDispatcher("/WEB-INF/views/user/cart.jsp").forward(request, response);
    }
    
    /**
     * Thêm sản phẩm vào giỏ hàng
     */
    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String bookIdParam = request.getParameter("bookId");
        String quantityParam = request.getParameter("quantity");
        
        try {
            int bookId = Integer.parseInt(bookIdParam);
            int quantity = quantityParam != null ? Integer.parseInt(quantityParam) : 1;
            
            boolean success = cartService.addToCart(request, bookId, quantity);
            
            // Chuyển hướng về trang hiện tại hoặc trang giỏ hàng
            String referer = request.getHeader("Referer");
            String redirectUrl = success ? (referer != null ? referer : request.getContextPath() + "/cart") 
                                        : request.getContextPath() + "/shop";
            
            response.sendRedirect(redirectUrl);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/shop");
        }
    }
    
    /**
     * Cập nhật số lượng sản phẩm trong giỏ hàng
     */
    private void updateCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String bookIdParam = request.getParameter("bookId");
        String quantityParam = request.getParameter("quantity");
        
        try {
            int bookId = Integer.parseInt(bookIdParam);
            int quantity = Integer.parseInt(quantityParam);
            
            cartService.updateCartItem(request, bookId, quantity);
            
            response.sendRedirect(request.getContextPath() + "/cart");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
    
    /**
     * Xóa sản phẩm khỏi giỏ hàng
     */
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String bookIdParam = request.getParameter("bookId");
        
        try {
            int bookId = Integer.parseInt(bookIdParam);
            
            cartService.removeFromCart(request, bookId);
            
            response.sendRedirect(request.getContextPath() + "/cart");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
    
    /**
     * Xóa toàn bộ giỏ hàng
     */
    private void clearCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        cartService.clearCart(request);
        
        response.sendRedirect(request.getContextPath() + "/cart");
    }
    
    /**
     * Áp dụng mã giảm giá
     */
    private void applyCoupon(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String couponCode = request.getParameter("couponCode");
        
        // Xử lý áp dụng mã giảm giá (chức năng này sẽ được triển khai sau)
        
        response.sendRedirect(request.getContextPath() + "/cart");
    }
} 