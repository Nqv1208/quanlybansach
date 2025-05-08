package com.quanlybansach.dao;

import com.quanlybansach.model.Book;
import com.quanlybansach.model.Cart;
import com.quanlybansach.model.CartItem;
import com.quanlybansach.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object cho giỏ hàng
 */
public class CartDAO {
    private BookDAO bookDAO;
    
    public CartDAO() {
        this.bookDAO = new BookDAO();
    }
    
    /**
     * Lấy giỏ hàng của khách hàng từ database
     * @param customerId ID của khách hàng
     * @return Giỏ hàng cùng các mục bên trong
     */
    public Cart getCartByCustomerId(int customerId) {
        Cart cart = null;
        String sql = "SELECT * FROM CARTS WHERE customer_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, customerId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    cart = mapResultSetToCart(rs);
                    // Lấy các mục trong giỏ hàng
                    cart.setItems(getCartItemsByCartId(cart.getCartId()));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Nếu không tìm thấy giỏ hàng, tạo mới
        if (cart == null) {
            cart = new Cart(customerId);
            createCart(cart);
        }
        
        return cart;
    }
    
    /**
     * Tạo giỏ hàng mới trong database
     * @param cart Giỏ hàng cần tạo
     * @return true nếu tạo thành công
     */
    public boolean createCart(Cart cart) {
        String sql = "INSERT INTO CARTS (customer_id, created_date, last_modified) VALUES (?, GETDATE(), GETDATE())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, cart.getCustomerId());
            
            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        cart.setCartId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Thêm một mục vào giỏ hàng trong database
     * @param cartItem Mục cần thêm
     * @return true nếu thêm thành công
     */
    public boolean addItemToCart(CartItem cartItem) {
        // Kiểm tra xem sách đã có trong giỏ hàng chưa
        CartItem existingItem = getCartItemByBookId(cartItem.getCartId(), cartItem.getBookId());
        
        if (existingItem != null) {
            // Cập nhật số lượng nếu sách đã có trong giỏ hàng
            return updateCartItemQuantity(existingItem.getCartItemId(), existingItem.getQuantity() + cartItem.getQuantity());
        } else {
            // Thêm mới nếu sách chưa có trong giỏ hàng
            String sql = "INSERT INTO CART_ITEMS (cart_id, book_id, quantity, added_date) VALUES (?, ?, ?, GETDATE())";
            
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                
                pstmt.setInt(1, cartItem.getCartId());
                pstmt.setInt(2, cartItem.getBookId());
                pstmt.setInt(3, cartItem.getQuantity());
                
                int affectedRows = pstmt.executeUpdate();
                if (affectedRows > 0) {
                    try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            cartItem.setCartItemId(generatedKeys.getInt(1));
                            return true;
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return false;
    }
    
    /**
     * Cập nhật số lượng của một mục trong giỏ hàng
     * @param cartItemId ID của mục cần cập nhật
     * @param quantity Số lượng mới
     * @return true nếu cập nhật thành công
     */
    public boolean updateCartItemQuantity(int cartItemId, int quantity) {
        String sql = "UPDATE CART_ITEMS SET quantity = ? WHERE cart_item_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, cartItemId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Xóa một mục khỏi giỏ hàng
     * @param cartItemId ID của mục cần xóa
     * @return true nếu xóa thành công
     */
    public boolean removeCartItem(int cartItemId) {
        String sql = "DELETE FROM CART_ITEMS WHERE cart_item_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, cartItemId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Xóa tất cả mục trong giỏ hàng
     * @param cartId ID của giỏ hàng cần xóa tất cả mục
     * @return true nếu xóa thành công
     */
    public boolean clearCart(int cartId) {
        String sql = "DELETE FROM CART_ITEMS WHERE cart_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, cartId);
            
            pstmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Lấy tất cả mục trong giỏ hàng
     * @param cartId ID của giỏ hàng
     * @return Danh sách các mục trong giỏ hàng
     */
    public List<CartItem> getCartItemsByCartId(int cartId) {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT * FROM CART_ITEMS WHERE cart_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, cartId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    CartItem item = mapResultSetToCartItem(rs);
                    // Lấy thông tin sách tương ứng
                    Book book = bookDAO.getBookById(item.getBookId());
                    item.setBook(book);
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return items;
    }
    
    /**
     * Lấy mục trong giỏ hàng theo ID sách
     * @param cartId ID của giỏ hàng
     * @param bookId ID của sách
     * @return Mục trong giỏ hàng, null nếu không tìm thấy
     */
    public CartItem getCartItemByBookId(int cartId, int bookId) {
        String sql = "SELECT * FROM CART_ITEMS WHERE cart_id = ? AND book_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, cartId);
            pstmt.setInt(2, bookId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    CartItem item = mapResultSetToCartItem(rs);
                    // Lấy thông tin sách tương ứng
                    Book book = bookDAO.getBookById(item.getBookId());
                    item.setBook(book);
                    return item;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Helper methods to map ResultSet to objects
    private Cart mapResultSetToCart(ResultSet rs) throws SQLException {
        Cart cart = new Cart();
        cart.setCartId(rs.getInt("cart_id"));
        cart.setCustomerId(rs.getInt("customer_id"));
        cart.setCreatedDate(rs.getTimestamp("created_date"));
        cart.setLastModified(rs.getTimestamp("last_modified"));
        return cart;
    }
    
    private CartItem mapResultSetToCartItem(ResultSet rs) throws SQLException {
        CartItem item = new CartItem();
        item.setCartItemId(rs.getInt("cart_item_id"));
        item.setCartId(rs.getInt("cart_id"));
        item.setBookId(rs.getInt("book_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setAddedDate(rs.getTimestamp("added_date"));
        return item;
    }
} 