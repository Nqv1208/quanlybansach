package com.quanlybansach.controller.user;

import com.quanlybansach.dao.CustomerDAO;
import com.quanlybansach.dao.OrderDAO;
import com.quanlybansach.dao.ReviewDAO;
import com.quanlybansach.dao.WishlistDAO;
import com.quanlybansach.dao.AddressDAO;
import com.quanlybansach.model.Account;
import com.quanlybansach.model.Customer;
import com.quanlybansach.model.Order;
import com.quanlybansach.util.ServletUtils;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.text.SimpleDateFormat;

@WebServlet("/account/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 5,   // 5 MB
    maxRequestSize = 1024 * 1024 * 10 // 10 MB
)
public class AccountServlet extends HttpServlet {
    private CustomerDAO customerDAO;
    private OrderDAO orderDAO;
    private WishlistDAO wishlistDAO;
    private ReviewDAO reviewDAO;
    private AddressDAO addressDAO;
    
    public void init() {
        customerDAO = new CustomerDAO();
        orderDAO = new OrderDAO();
        wishlistDAO = new WishlistDAO();
        reviewDAO = new ReviewDAO();
        addressDAO = new AddressDAO();
    }
    
    @SuppressWarnings("unused")
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String action = pathInfo != null ? pathInfo : "";
        
        try {
            // Kiểm tra người dùng đã đăng nhập chưa
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute("account");
            Customer customer = customerDAO.getCustomerById(account.getCustomerId());
            System.out.println("Customer: " + customer.toString());
            
            session.setAttribute("customer", customer);
            
            if (account == null) {
                response.sendRedirect(request.getContextPath() + "/login?redirect=" + request.getRequestURI());
                return;
            }
            
            switch (action) {
                case "/profile":
                    showProfile(request, response, customer);
                    break;
                case "/addresses":
                    showAddresses(request, response, customer);
                    break;
                case "/wishlist":
                    showWishlist(request, response, customer);
                    break;
                case "/reviews":
                    showReviews(request, response, customer);
                    break;
                case "/change-password":
                    showChangePassword(request, response);
                    break;
                default:
                    showProfile(request, response, customer);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String action = pathInfo != null ? pathInfo : "";
        
        try {
            // Kiểm tra người dùng đã đăng nhập chưa
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute("account");
            Customer customer = customerDAO.getCustomerById(account.getCustomerId());
            
            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/login?redirect=" + request.getRequestURI());
                return;
            }
            
            switch (action) {
                case "/update-profile":
                    updateProfile(request, response, customer);
                    break;
                case "/add-address":
                    addAddress(request, response, customer);
                    break;
                case "/update-address":
                    updateAddress(request, response, customer);
                    break;
                case "/delete-address":
                    deleteAddress(request, response, customer);
                    break;
                case "/change-password":
                    changePassword(request, response, customer);
                    break;
                case "/add-to-wishlist":
                    addToWishlist(request, response, customer);
                    break;
                case "/remove-from-wishlist":
                    removeFromWishlist(request, response, customer);
                    break;
                default:
                    showProfile(request, response, customer);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
    
    private void showProfile(HttpServletRequest request, HttpServletResponse response, Customer customer) throws SQLException, ServletException, IOException {
        // Lấy danh sách đơn hàng gần đây
        List<Order> recentOrders = orderDAO.getRecentOrdersByCustomer(customer.getCustomerId(), 5);
        System.out.println("\ncustomerId: " + customer.getCustomerId());
        System.out.println("Recent Orders: " + recentOrders.size());
        
        // Lấy thống kê tài khoản
        int orderCount = orderDAO.getOrderCountByCustomer(customer.getCustomerId());
        // int wishlistCount = wishlistDAO.getWishlistCountByCustomer(customer.getCustomerId());
        int reviewCount = reviewDAO.getReviewCountByCustomer(customer.getCustomerId());
        // int addressCount = addressDAO.getAddressCountByCustomer(customer.getCustomerId());
        
        // Đặt thuộc tính vào request
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("orderCount", orderCount);
        // request.setAttribute("wishlistCount", wishlistCount);
        request.setAttribute("reviewCount", reviewCount);
        // request.setAttribute("addressCount", addressCount);
        
        // Chuyển hướng đến trang profile
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/account/profile.jsp");
        dispatcher.forward(request, response);
    }
    
    private void updateProfile(HttpServletRequest request, HttpServletResponse response, Customer customer) throws SQLException, IOException, ServletException {
        // Lấy dữ liệu từ form
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        // Cập nhật thông tin khách hàng
        customer.setName(fullName);
        customer.setEmail(email);
        customer.setPhone(phone);
        customer.setAddress(address);
        
        // Xử lý upload avatar (không hỗ trợ trong model hiện tại)
        // Lưu ý: Trong ứng dụng thực tế, bạn sẽ cần thêm trường avatarUrl vào model Customer
        
        // Lưu thông tin khách hàng vào database
        customerDAO.updateCustomer(customer);
        
        // Cập nhật thông tin trong session
        // HttpSession session = request.getSession();
        // session.setAttribute("user", customer);
        
        // Thêm thông báo thành công
        // session.setAttribute("successMessage", "Cập nhật thông tin tài khoản thành công!");
        
        // Chuyển hướng về trang profile
        response.sendRedirect(request.getContextPath() + "/account/profile");
    }
    
    private void showChangePassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/account/change-password.jsp");
        dispatcher.forward(request, response);
    }
    
    private void changePassword(HttpServletRequest request, HttpServletResponse response, Customer customer) throws SQLException, IOException, ServletException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        HttpSession session = request.getSession();
        
        // Kiểm tra mật khẩu hiện tại - giả định username là email
        if (!customerDAO.checkPassword(customer.getEmail(), currentPassword)) {
            session.setAttribute("errorMessage", "Mật khẩu hiện tại không đúng!");
            response.sendRedirect(request.getContextPath() + "/account/change-password");
            return;
        }
        
        // Kiểm tra mật khẩu mới và xác nhận mật khẩu
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("errorMessage", "Mật khẩu mới và xác nhận mật khẩu không khớp!");
            response.sendRedirect(request.getContextPath() + "/account/change-password");
            return;
        }
        
        // Cập nhật mật khẩu mới
        customerDAO.updatePassword(customer.getEmail(), newPassword);
        
        // Thêm thông báo thành công
        session.setAttribute("successMessage", "Đổi mật khẩu thành công!");
        
        // Chuyển hướng về trang đổi mật khẩu
        response.sendRedirect(request.getContextPath() + "/account/change-password");
    }
    
    private void showAddresses(HttpServletRequest request, HttpServletResponse response, Customer customer) throws SQLException, ServletException, IOException {
        // Lấy danh sách địa chỉ của khách hàng
        // List<Address> addresses = addressDAO.getAddressesByCustomer(customer.getCustomerId());
        
        // request.setAttribute("addresses", addresses);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/account/addresses.jsp");
        dispatcher.forward(request, response);
    }
    
    private void addAddress(HttpServletRequest request, HttpServletResponse response, Customer customer) throws SQLException, ServletException, IOException {
        // Xử lý thêm địa chỉ mới
        
        response.sendRedirect(request.getContextPath() + "/account/addresses");
    }
    
    private void updateAddress(HttpServletRequest request, HttpServletResponse response, Customer customer) throws SQLException, ServletException, IOException {
        // Xử lý cập nhật địa chỉ
        
        response.sendRedirect(request.getContextPath() + "/account/addresses");
    }
    
    private void deleteAddress(HttpServletRequest request, HttpServletResponse response, Customer customer) throws SQLException, ServletException, IOException {
        // Xử lý xóa địa chỉ
        
        response.sendRedirect(request.getContextPath() + "/account/addresses");
    }
    
    private void showWishlist(HttpServletRequest request, HttpServletResponse response, Customer customer) throws SQLException, ServletException, IOException {
        // Lấy danh sách sản phẩm yêu thích
        // List<Book> wishlist = wishlistDAO.getWishlistByCustomer(customer.getCustomerId());
        
        // request.setAttribute("wishlist", wishlist);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/account/wishlist.jsp");
        dispatcher.forward(request, response);
    }
    
    private void addToWishlist(HttpServletRequest request, HttpServletResponse response, Customer customer) throws SQLException, ServletException, IOException {
        // Xử lý thêm sản phẩm vào danh sách yêu thích
        
        response.sendRedirect(request.getContextPath() + "/account/wishlist");
    }
    
    private void removeFromWishlist(HttpServletRequest request, HttpServletResponse response, Customer customer) throws SQLException, ServletException, IOException {
        // Xử lý xóa sản phẩm khỏi danh sách yêu thích
        
        response.sendRedirect(request.getContextPath() + "/account/wishlist");
    }
    
    private void showReviews(HttpServletRequest request, HttpServletResponse response, Customer customer) throws SQLException, ServletException, IOException {
        // Lấy danh sách đánh giá của khách hàng
        // List<Review> reviews = reviewDAO.getReviewsByCustomer(customer.getCustomerId());
        
        // request.setAttribute("reviews", reviews);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/user/account/reviews.jsp");
        dispatcher.forward(request, response);
    }
} 