package com.quanlybansach.controller.user;

import com.quanlybansach.dao.OrderDAO;
import com.quanlybansach.model.Customer;
import com.quanlybansach.model.Order;
import com.quanlybansach.model.OrderDetail;
import com.quanlybansach.model.ShippingAddress;
import com.quanlybansach.model.Account;
import com.quanlybansach.model.Cart;
import com.quanlybansach.model.CartItem;
import com.quanlybansach.model.CartSummary;
import com.quanlybansach.service.CartService;
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
    private OrderService orderService;

    public void init() {
        orderDAO = new OrderDAO();
        orderService = new OrderService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();
        String pathInfo = request.getPathInfo();

        System.out.println("\nCheckoutServlet - Action: " + action);
        System.out.println("CheckoutServlet - Path Info: " + pathInfo);
        
        try {
            // Chuyển hướng dựa trên pathInfo
            if (pathInfo == null || pathInfo.equals("/")) {
                    showCheckoutPage(request, response);
            } else {
                    response.sendRedirect(request.getContextPath() + "/cart");
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();
        String pathInfo = request.getPathInfo();
        
        System.out.println("\nCheckoutServlet - POST Action: " + action);
        System.out.println("CheckoutServlet - Path Info: " + pathInfo);
        
        try {
            // Sử dụng pathInfo để xác định hành động
            if (pathInfo != null && pathInfo.equals("/place-order")) {
                placeOrder(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void showCheckoutPage(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        String itemsParam = request.getParameter("items");
        String itemsParam2 = request.getParameter("bookId");
        String quantityParam = request.getParameter("quantity");

        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Cart cart = SessionUtil.getCart(session);
        if (cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        System.out.println("CheckoutServlet - Cart: " + cart.toString());
        
        session.removeAttribute("checkoutCart");
        // Tạo một giỏ hàng mới để chứa các mục được chọn
        Cart checkoutCart = new Cart();
        
        if (itemsParam != null && !itemsParam.isEmpty()) {
            try {
                // Chuyển đổi tham số items thành mảng các ID
                String[] itemsArray = itemsParam.split(",");
                
                for (String itemIdStr : itemsArray) {
                    Integer itemId = Integer.parseInt(itemIdStr.trim());
                    
                    // Tìm kiếm trong giỏ hàng để lấy thông tin bookId và quantity
                    for (CartItem item : cart.getItems()) {
                        if (item.getBook() != null && itemId.equals(item.getBook().getBookId())) {
                            // Tạo CartItem mới với bookId và quantity
                            CartItem checkoutItem = new CartItem(item.getBook().getBookId(), item.getQuantity());
                            checkoutItem.setBook(item.getBook());
                            checkoutCart.getItems().add(checkoutItem);
                            break;
                        }
                    }
                }
                
                if (checkoutCart.getItems().isEmpty()) {
                    // Nếu không có item nào khớp, redirect về giỏ hàng
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }
            } catch (NumberFormatException e) {
                System.err.println("Error parsing item IDs: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
        } else {
            if (itemsParam2 != null && !itemsParam2.isEmpty()) {
                try {
                    // Chuyển đổi tham số bookId thành Integer
                    Integer bookId = Integer.parseInt(itemsParam2.trim());
                    Integer quantity = (quantityParam != null && !quantityParam.isEmpty()) ? Integer.parseInt(quantityParam) : 1;
                    
                    // Tạo một CartItem mới với bookId và quantity
                    CartItem checkoutItem = new CartItem(bookId, quantity);
                    checkoutCart.getItems().add(checkoutItem);
                    
                } catch (NumberFormatException e) {
                    System.err.println("Error parsing book ID: " + e.getMessage());
                    response.sendRedirect(request.getContextPath() + "/shop");
                    return;
                }
            } else {
                // Nếu không có tham số items, redirect về giỏ hàng
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
        }
        
        // Calculate cart summary for selected items
        CartSummary cartSummary = calculateCartSummary(checkoutCart);
        
        session.setAttribute("checkoutCart", checkoutCart);
        
        request.setAttribute("cart", checkoutCart);
        request.setAttribute("cartSummary", cartSummary);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/checkout.jsp");
        dispatcher.forward(request, response);
    }

    private void placeOrder(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");
        
        if (account == null) {
            System.out.println("CheckoutServlet - placeOrder: Account is null, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get the checkout cart from session
        Cart checkoutCart = (Cart) session.getAttribute("checkoutCart");
        System.out.println("CheckoutServlet - placeOrder: checkoutCart = " + (checkoutCart != null ? 
            "Items: " + checkoutCart.getItems().size() : "null"));
        
        if (checkoutCart == null || checkoutCart.getItems().isEmpty()) {
            System.out.println("CheckoutServlet - placeOrder: checkoutCart is null or empty, redirecting to cart");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        Customer customer = new Customer();
        customer.setCustomerId(account.getAccountId());
        
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
        
        // Cập nhật thông tin customer từ form
        customer.setName(fullName);
        customer.setPhone(phone);
        customer.setEmail(email);
        customer.setAddress(address);
        
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
        order.setCustomerId(account.getCustomerId());
        order.setOrderDate(new Date());
        order.setStatus("Chờ xử lý");
        
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
        CartSummary cartSummary = calculateCartSummary(checkoutCart);
        BigDecimal subtotal = BigDecimal.valueOf(cartSummary.getSubtotal());
        BigDecimal discount = BigDecimal.valueOf(cartSummary.getDiscount());
        BigDecimal totalAmount = subtotal.add(BigDecimal.valueOf(shippingFee)).subtract(discount);
        
        order.setTotalAmount(totalAmount);
        
        // Create order details from cart items
        List<OrderDetail> orderDetails = new ArrayList<>();
        for (CartItem item : checkoutCart.getItems()) {
            if (item.getBook() != null) {
                OrderDetail detail = new OrderDetail();
                detail.setBookId(item.getBook().getBookId());
                detail.setQuantity(item.getQuantity());
                detail.setBookTitle(item.getBook().getTitle());
                detail.setImageUrl(item.getBook().getImageUrl());
                
                // Handle different types for price
                Object price = item.getBook().getPrice();
                if (price instanceof BigDecimal) {
                    detail.setUnitPrice((BigDecimal) price);
                } else if (price instanceof Number) {
                    detail.setUnitPrice(BigDecimal.valueOf(((Number) price).doubleValue()));
                } else {
                    // Fallback if the price is not a number type
                    detail.setUnitPrice(BigDecimal.ZERO);
                }
                
                detail.setDiscount(BigDecimal.ZERO); // Set discount if applicable
                orderDetails.add(detail);
            }
        }

        order.setOrderDetails(orderDetails);
        System.out.println(order.toString());
        
        // Save order to database
        System.out.println("CheckoutServlet - Saving order to database with customer ID: " + order.getCustomerId());
        System.out.println("CheckoutServlet - Order details count: " + orderDetails.size());
        
        try {
            int orderId = orderService.createOrder(order, orderDetails);
            
            if (orderId == -1) {
                System.err.println("CheckoutServlet - Failed to create order");
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi đặt hàng. Vui lòng thử lại sau.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/checkout.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            System.out.println("CheckoutServlet - Order created successfully with ID: " + orderId);
            order.setOrderId(orderId);

            // Xóa các mục trong giỏ hàng sau khi đặt hàng thành công
            CartService cartService = new CartService();
            for (OrderDetail item : order.getOrderDetails()) {
                cartService.removeFromCart(request, item.getBookId());
            }
        
            // Update cart after successful order
            session.setAttribute("cart", cartService.getCart(request));
                
            // Remove the checkout cart from session
            session.removeAttribute("checkoutCart");
            
            // Set these additional properties through request attributes
            request.setAttribute("order", order);
            // request.setAttribute("estimatedDeliveryDate", estimatedDeliveryDate);
            request.setAttribute("shippingAddress", shippingAddress);
            
            // Forward to confirmation page
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/checkout/confirmation.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.err.println("CheckoutServlet - Error creating order: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi đặt hàng. Vui lòng thử lại sau.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/checkout.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    // Helper method to calculate cart summary for selected items
    private CartSummary calculateCartSummary(Cart cart) {
        CartSummary summary = new CartSummary();
        double subtotal = 0;
        
        for (CartItem item : cart.getItems()) {
            if (item.getBook() != null) {
                // Check if price is BigDecimal or double
                if (item.getBook().getPrice() instanceof BigDecimal) {
                    BigDecimal price = (BigDecimal) item.getBook().getPrice();
                    BigDecimal quantity = BigDecimal.valueOf(item.getQuantity());
                    BigDecimal itemTotal = price.multiply(quantity);
                    subtotal += itemTotal.doubleValue();
                } else {
                    double itemPrice = ((Number)item.getBook().getPrice()).doubleValue() * item.getQuantity();
                    subtotal += itemPrice;
                }
            }
        }
        
        summary.setSubtotal(subtotal);
        summary.setShippingFee(30000); // Default shipping fee
        summary.setDiscount(0); // Set discount if applicable
        summary.setTotal(subtotal + summary.getShippingFee() - summary.getDiscount());
        
        return summary;
    }
} 