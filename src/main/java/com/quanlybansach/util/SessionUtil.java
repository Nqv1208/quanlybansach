package com.quanlybansach.util;

import com.quanlybansach.model.Book;
import com.quanlybansach.model.CartItem;
import com.quanlybansach.model.CartSummary;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class SessionUtil {

    private static final String CART_SESSION_KEY = "cart";

    /**
     * Get the cart from session or create a new one if it doesn't exist
     */
    @SuppressWarnings("unchecked")
    public static List<CartItem> getCart(HttpSession session) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute(CART_SESSION_KEY);
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute(CART_SESSION_KEY, cart);
        }
        return cart;
    }

    /**
     * Add a book to the cart
     */
    public static void addToCart(HttpSession session, Book book, int quantity) {
        List<CartItem> cart = getCart(session);
        
        // Check if the book is already in the cart
        boolean bookExists = false;
        for (CartItem item : cart) {
            if (item.getBook().getBookId() == book.getBookId()) {
                item.setQuantity(item.getQuantity() + quantity);
                bookExists = true;
                break;
            }
        }
        
        // If the book is not in the cart, add it
        if (!bookExists) {
            CartItem item = new CartItem(book.getBookId(), quantity);
            item.setBook(book);
            cart.add(item);
        }
        
        // Update the cart in the session
        session.setAttribute(CART_SESSION_KEY, cart);
    }

    /**
     * Update the quantity of a book in the cart
     */
    public static void updateCartItem(HttpSession session, int bookId, int quantity) {
        List<CartItem> cart = getCart(session);
        
        if (quantity <= 0) {
            // If the quantity is 0 or negative, remove the item
            removeFromCart(session, bookId);
            return;
        }
        
        // Update the quantity
        for (CartItem item : cart) {
            if (item.getBook().getBookId() == bookId) {
                item.setQuantity(quantity);
                break;
            }
        }
        
        // Update the cart in the session
        session.setAttribute(CART_SESSION_KEY, cart);
    }

    /**
     * Remove a book from the cart
     */
    public static void removeFromCart(HttpSession session, int bookId) {
        List<CartItem> cart = getCart(session);
        
        // Remove the item from the cart
        cart.removeIf(item -> item.getBook().getBookId() == bookId);
        
        // Update the cart in the session
        session.setAttribute(CART_SESSION_KEY, cart);
    }

    /**
     * Clear the cart
     */
    public static void clearCart(HttpSession session) {
        session.removeAttribute(CART_SESSION_KEY);
    }

    /**
     * Calculate the cart summary
     */
    public static CartSummary getCartSummary(HttpSession session) {
        List<CartItem> cart = getCart(session);
        CartSummary summary = new CartSummary();
        
        BigDecimal subtotal = BigDecimal.ZERO;
        int itemCount = 0;
        
        for (CartItem item : cart) {
            subtotal = subtotal.add(item.getSubtotal());
            itemCount += item.getQuantity();
        }
        
        summary.setSubtotal(subtotal.doubleValue());
        summary.setItemCount(itemCount);
        summary.calculateTotal();
        
        return summary;
    }
} 