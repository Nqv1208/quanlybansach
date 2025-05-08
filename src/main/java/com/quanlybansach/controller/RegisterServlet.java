package com.quanlybansach.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.quanlybansach.dao.AccountDAO;
import com.quanlybansach.model.Account;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Forward to register page
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Lấy dữ liệu từ form
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        // Kiểm tra mật khẩu xác nhận
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        
        // Tạo đối tượng tài khoản
        Account account = new Account();
        account.setUsername(username);
        account.setPasswordHash(password); // Sẽ được hash trong DAO
        account.setEmail(email);
        account.setRoleId(3); // Mặc định là User role
        account.setActive(true);
        
        // Đăng ký tài khoản
        AccountDAO accountDAO = new AccountDAO();
        Account registeredAccount = accountDAO.registerAccount(account, name, phone, address);
        
        if (registeredAccount != null) {
            // Đăng ký thành công - tự động đăng nhập
            HttpSession session = request.getSession();
            session.setAttribute("account", registeredAccount);
            session.setAttribute("role", "User");
            session.setAttribute("customerId", registeredAccount.getCustomerId());
            session.setAttribute("customerName", registeredAccount.getCustomerName());
            
            // Chuyển hướng đến trang chủ
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            // Đăng ký thất bại
            request.setAttribute("errorMessage", "Đăng ký không thành công. Tên đăng nhập hoặc email đã tồn tại.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
} 