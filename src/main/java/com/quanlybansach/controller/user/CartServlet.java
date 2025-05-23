package com.quanlybansach.controller.user;

import com.google.gson.Gson;
import com.quanlybansach.dao.BookDAO;
import com.quanlybansach.model.Cart;
import com.quanlybansach.model.CartSummary;
import com.quanlybansach.service.CartService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet xử lý các thao tác liên quan đến giỏ hàng
 */
@WebServlet(urlPatterns = "/cart/*")
@MultipartConfig
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
        
        System.out.println("Servlet path: " + request.getServletPath());
        System.out.println("Path info: " + request.getPathInfo());
        System.out.println("Request URI: " + request.getRequestURI());
        
        if (pathInfo == null) {
            pathInfo = "/";
        }

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

        System.out.println("Servlet path: " + request.getServletPath());
        System.out.println("Path info: " + request.getPathInfo());
        System.out.println("Request URI: " + request.getRequestURI());
        
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
    
    // Debug: In thông tin giỏ hàng
    System.out.println("Cart items count: " + (cart != null && cart.getItems() != null ? cart.getItems().size() : 0));
    
    // Kiểm tra xem giỏ hàng có tồn tại không
    if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
        // Nếu giỏ hàng trống, đặt attribute cart là null để hiện thông báo "giỏ hàng trống"
        request.setAttribute("cart", null);
        
        // Vẫn cần tạo CartSummary với giá trị mặc định
        CartSummary emptySummary = new CartSummary();
        emptySummary.setItemCount(0);
        emptySummary.setSubtotal(0);
        emptySummary.setShippingFee(0);
        emptySummary.setDiscount(0);
        emptySummary.calculateTotal();
        request.setAttribute("cartSummary", emptySummary);
    } else {
        // In debug thông tin chi tiết từng item
        for (com.quanlybansach.model.CartItem item : cart.getItems()) {
            System.out.println("Book ID: " + item.getBookId() + ", Quantity: " + item.getQuantity());
        }
        
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
        
        request.setAttribute("cart", cart);
        request.setAttribute("cartSummary", cartSummary);
    }
    
    try {
        request.getRequestDispatcher("/WEB-INF/views/user/cart.jsp").forward(request, response);
    } catch (Exception e) {
        System.err.println("Lỗi khi forward đến cart.jsp: " + e.getMessage());
        e.printStackTrace();
        // Có thể xử lý lỗi tại đây, ví dụ chuyển hướng đến trang lỗi
        response.sendRedirect(request.getContextPath() + "/error");
    }
}
    
    /**
     * Thêm sản phẩm vào giỏ hàng
     */
    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String bookIdParam = request.getParameter("bookId");
        String quantityParam = request.getParameter("quantity");
        
        System.out.println("AddToCart - bookId: " + bookIdParam + ", quantity: " + quantityParam);
        
        try {
            int bookId = Integer.parseInt(bookIdParam);
            int quantity = quantityParam != null ? Integer.parseInt(quantityParam) : 1;
            
            boolean success = cartService.addToCart(request, bookId, quantity);
            if(success) {
                // Cập nhật lại giỏ hàng trong session để header hiển thị đúng số lượng
                request.getSession().setAttribute("cart", cartService.getCart(request));
                System.out.println("AddToCart - success: " + success);
            }
            else {
                throw new Exception("Thêm sản phẩm vào giỏ hàng thất bại");
            }
            
            // Debug giỏ hàng sau khi thêm
            Cart cart = cartService.getCart(request);
            System.out.println("Cart after add - items count: " + (cart != null && cart.getItems() != null ? cart.getItems().size() : 0));
            
            // Chuyển hướng về trang hiện tại hoặc trang giỏ hàng
            String referer = request.getHeader("Referer");
            String redirectUrl = success ? (referer != null ? referer : request.getContextPath() + "/cart") 
                                        : request.getContextPath() + "/shop";
            
            response.sendRedirect(redirectUrl);
        } catch (NumberFormatException e) {
            System.out.println("AddToCart - Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/shop");
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
    
    /**
     * Cập nhật số lượng sản phẩm trong giỏ hàng
     */
    private void updateCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        java.util.Map<String, Object> jsonResponse = new java.util.HashMap<>();
        
        String bookIdParam = request.getParameter("bookId");
        String quantityParam = request.getParameter("quantity");
        // Debug xem bookId và quantity có hợp lệ không
        System.out.println("UpdateCart - bookId: " + bookIdParam + ", quantity: " + quantityParam);
        
        try {
            int bookId = Integer.parseInt(bookIdParam);
            int quantity = Integer.parseInt(quantityParam);
            
            boolean updated = cartService.updateCartItem(request, bookId, quantity);
            if(updated) {
                // Cập nhật lại giỏ hàng trong session để header hiển thị đúng số lượng
                request.getSession().setAttribute("cart", cartService.getCart(request));
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Cập nhật số lượng thành công");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Cập nhật số lượng thất bại");
            }
        } catch (NumberFormatException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Mã sản phẩm hoặc số lượng không hợp lệ");
        } catch (Exception e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Đã xảy ra lỗi: " + e.getMessage());
        }

        String json = new Gson().toJson(jsonResponse);
        response.getWriter().write(json);
    }
    
    /**
     * Xóa sản phẩm khỏi giỏ hàng
     */
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        java.util.Map<String, Object> jsonResponse = new java.util.HashMap<>();
        
        String bookIdParam = request.getParameter("bookId");
        System.out.println("RemoveFromCart - bookId: " + bookIdParam);
        
        try {
            int bookId = Integer.parseInt(bookIdParam);
            
            boolean removed = cartService.removeFromCart(request, bookId);
            if (removed) {
                // Cập nhật lại giỏ hàng trong session để header hiển thị đúng số lượng
                request.getSession().setAttribute("cart", cartService.getCart(request));
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Sản phẩm đã được xóa khỏi giỏ hàng");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Sản phẩm không tồn tại trong giỏ hàng");
            }
        } catch (NumberFormatException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Mã sản phẩm không hợp lệ");
        }

        String json = new Gson().toJson(jsonResponse);
        response.getWriter().write(json);
    }
    
    /**
     * Xóa toàn bộ giỏ hàng
     */
    private void clearCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        cartService.clearCart(request);
        
        response.setContentType("application/json");

        java.util.Map<String, Object> jsonResponse = new java.util.HashMap<>();

        String cartIdParam = request.getParameter("cartId");
        System.out.println("ClearCart - cartId: " + cartIdParam);

        try {
            boolean cleared = cartService.clearCart(request);
            if (cleared) {
                // Cập nhật lại giỏ hàng trong session để header hiển thị đúng số lượng
                request.getSession().setAttribute("cart", cartService.getCart(request));
                jsonResponse.put("success", true);
                jsonResponse.put("message", "Giỏ hàng đã được xóa");
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Giỏ hàng không tồn tại");
            }
        } catch (NumberFormatException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Mã giỏ hàng không hợp lệ");
        } catch (Exception e) {
            // TODO: handle exception
        }
        // Chuyển đổi đối tượng jsonResponse thành chuỗi JSON
        String json = new Gson().toJson(jsonResponse);
        response.getWriter().write(json);

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