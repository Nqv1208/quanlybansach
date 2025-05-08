package com.quanlybansach.service;

import com.quanlybansach.dao.BookDAO;
import com.quanlybansach.dao.CartDAO;
import com.quanlybansach.model.Book;
import com.quanlybansach.model.Cart;
import com.quanlybansach.model.CartItem;
import com.quanlybansach.model.CartSummary;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Service để quản lý giỏ hàng, kết hợp giữa lưu trong Session và Database
 */
public class CartService {
    private static final String SESSION_CART_KEY = "shopping_cart";
    private CartDAO cartDAO;
    private BookDAO bookDAO;
    
    public CartService() {
        this.cartDAO = new CartDAO();
        this.bookDAO = new BookDAO();
    }
    
    /**
     * Lấy giỏ hàng từ session hoặc database dựa vào trạng thái đăng nhập
     * @param request HTTP request
     * @return Giỏ hàng
     */
    public Cart getCart(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customer_id");
        
        if (customerId != null) {
            // Người dùng đã đăng nhập, lấy giỏ hàng từ database
            Cart cart = cartDAO.getCartByCustomerId(customerId);
            return cart;
        } else {
            // Người dùng chưa đăng nhập, lấy giỏ hàng từ session
            Cart cart = (Cart) session.getAttribute(SESSION_CART_KEY);
            if (cart == null) {
                cart = new Cart();
                session.setAttribute(SESSION_CART_KEY, cart);
            }
            return cart;
        }
    }
    
    /**
     * Thêm sách vào giỏ hàng
     * @param request HTTP request
     * @param bookId ID của sách
     * @param quantity Số lượng
     * @return true nếu thêm thành công
     */
    public boolean addToCart(HttpServletRequest request, int bookId, int quantity) {
        // Kiểm tra số lượng
        if (quantity <= 0) {
            return false;
        }
        
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customer_id");
        
        // Lấy thông tin sách
        Book book = bookDAO.getBookById(bookId);
        if (book == null || book.getStockQuantity() < quantity) {
            return false;
        }
        
        if (customerId != null) {
            // Người dùng đã đăng nhập, lưu vào database
            Cart cart = cartDAO.getCartByCustomerId(customerId);
            CartItem item = new CartItem(cart.getCartId(), bookId, quantity);
            return cartDAO.addItemToCart(item);
        } else {
            // Người dùng chưa đăng nhập, lưu vào session
            Cart cart = (Cart) session.getAttribute(SESSION_CART_KEY);
            if (cart == null) {
                cart = new Cart();
                session.setAttribute(SESSION_CART_KEY, cart);
            }
            
            // Kiểm tra xem sách đã có trong giỏ hàng chưa
            CartItem item = new CartItem(bookId, quantity);
            item.setBook(book);
            cart.addItem(item);
            
            session.setAttribute(SESSION_CART_KEY, cart);
            return true;
        }
    }
    
    /**
     * Cập nhật số lượng mục trong giỏ hàng
     * @param request HTTP request
     * @param bookId ID của sách
     * @param quantity Số lượng mới
     * @return true nếu cập nhật thành công
     */
    public boolean updateCartItem(HttpServletRequest request, int bookId, int quantity) {
        // Kiểm tra số lượng
        if (quantity <= 0) {
            return false;
        }
        
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customer_id");
        
        // Lấy thông tin sách
        Book book = bookDAO.getBookById(bookId);
        if (book == null || book.getStockQuantity() < quantity) {
            return false;
        }
        
        if (customerId != null) {
            // Người dùng đã đăng nhập, cập nhật trong database
            Cart cart = cartDAO.getCartByCustomerId(customerId);
            CartItem item = cartDAO.getCartItemByBookId(cart.getCartId(), bookId);
            if (item != null) {
                return cartDAO.updateCartItemQuantity(item.getCartItemId(), quantity);
            }
            return false;
        } else {
            // Người dùng chưa đăng nhập, cập nhật trong session
            Cart cart = (Cart) session.getAttribute(SESSION_CART_KEY);
            if (cart != null) {
                boolean updated = cart.updateItemQuantity(bookId, quantity);
                if (updated) {
                    session.setAttribute(SESSION_CART_KEY, cart);
                    return true;
                }
            }
            return false;
        }
    }
    
    /**
     * Xóa mục khỏi giỏ hàng
     * @param request HTTP request
     * @param bookId ID của sách cần xóa
     * @return true nếu xóa thành công
     */
    public boolean removeFromCart(HttpServletRequest request, int bookId) {
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customer_id");
        
        if (customerId != null) {
            // Người dùng đã đăng nhập, xóa từ database
            Cart cart = cartDAO.getCartByCustomerId(customerId);
            CartItem item = cartDAO.getCartItemByBookId(cart.getCartId(), bookId);
            if (item != null) {
                return cartDAO.removeCartItem(item.getCartItemId());
            }
            return false;
        } else {
            // Người dùng chưa đăng nhập, xóa từ session
            Cart cart = (Cart) session.getAttribute(SESSION_CART_KEY);
            if (cart != null) {
                boolean removed = cart.removeItem(bookId);
                if (removed) {
                    session.setAttribute(SESSION_CART_KEY, cart);
                    return true;
                }
            }
            return false;
        }
    }
    
    /**
     * Xóa toàn bộ giỏ hàng
     * @param request HTTP request
     * @return true nếu xóa thành công
     */
    public boolean clearCart(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customer_id");
        
        if (customerId != null) {
            // Người dùng đã đăng nhập, xóa từ database
            Cart cart = cartDAO.getCartByCustomerId(customerId);
            return cartDAO.clearCart(cart.getCartId());
        } else {
            // Người dùng chưa đăng nhập, xóa từ session
            Cart cart = (Cart) session.getAttribute(SESSION_CART_KEY);
            if (cart != null) {
                cart.clear();
                session.setAttribute(SESSION_CART_KEY, cart);
            }
            return true;
        }
    }
    
    /**
     * Tạo đối tượng CartSummary để hiển thị trên trang giỏ hàng
     * @param cart Giỏ hàng cần tạo tóm tắt
     * @return Đối tượng CartSummary
     */
    public CartSummary createCartSummary(Cart cart) {
        CartSummary summary = new CartSummary();
        
        summary.setTotalItems(cart.getTotalItems());
        
        BigDecimal subtotal = cart.getTotalAmount();
        summary.setSubtotal(subtotal);
        
        // Tính phí vận chuyển (ví dụ: 30.000đ nếu tổng đơn hàng < 200.000đ, miễn phí nếu >= 200.000đ)
        BigDecimal shippingFee = subtotal.compareTo(new BigDecimal(200000)) < 0 ? 
                                  new BigDecimal(30000) : BigDecimal.ZERO;
        summary.setShippingFee(shippingFee);
        
        // Áp dụng giảm giá nếu có
        BigDecimal discount = BigDecimal.ZERO;
        summary.setDiscount(discount);
        
        // Tính tổng cộng
        BigDecimal total = subtotal.add(shippingFee).subtract(discount);
        summary.setTotal(total);
        
        return summary;
    }
    
    /**
     * Lớp để lưu trữ thông tin tóm tắt giỏ hàng
     */
    public static class CartSummary {
        private int totalItems;
        private BigDecimal subtotal;
        private BigDecimal shippingFee;
        private BigDecimal discount;
        private BigDecimal total;
        
        public CartSummary() {
            this.totalItems = 0;
            this.subtotal = BigDecimal.ZERO;
            this.shippingFee = BigDecimal.ZERO;
            this.discount = BigDecimal.ZERO;
            this.total = BigDecimal.ZERO;
        }

        public int getTotalItems() {
            return totalItems;
        }

        public void setTotalItems(int totalItems) {
            this.totalItems = totalItems;
        }

        public BigDecimal getSubtotal() {
            return subtotal;
        }

        public void setSubtotal(BigDecimal subtotal) {
            this.subtotal = subtotal;
        }

        public BigDecimal getShippingFee() {
            return shippingFee;
        }

        public void setShippingFee(BigDecimal shippingFee) {
            this.shippingFee = shippingFee;
        }

        public BigDecimal getDiscount() {
            return discount;
        }

        public void setDiscount(BigDecimal discount) {
            this.discount = discount;
        }

        public BigDecimal getTotal() {
            return total;
        }

        public void setTotal(BigDecimal total) {
            this.total = total;
        }
    }
    
    /**
     * Khi người dùng đăng nhập, chuyển giỏ hàng từ session sang database
     * @param request HTTP request
     * @param customerId ID của khách hàng đăng nhập
     */
    public void mergeCartOnLogin(HttpServletRequest request, int customerId) {
        HttpSession session = request.getSession();
        Cart sessionCart = (Cart) session.getAttribute(SESSION_CART_KEY);
        
        if (sessionCart != null && !sessionCart.getItems().isEmpty()) {
            Cart dbCart = cartDAO.getCartByCustomerId(customerId);
            
            // Chuyển các mục từ session sang database
            for (CartItem item : sessionCart.getItems()) {
                CartItem dbItem = new CartItem(dbCart.getCartId(), item.getBookId(), item.getQuantity());
                cartDAO.addItemToCart(dbItem);
            }
            
            // Xóa giỏ hàng trong session
            session.removeAttribute(SESSION_CART_KEY);
        }
    }
} 