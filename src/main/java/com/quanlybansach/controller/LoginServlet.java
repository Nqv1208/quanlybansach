package com.quanlybansach.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Cookie;

import com.quanlybansach.dao.AccountDAO;
import com.quanlybansach.dao.CartDAO;
import com.quanlybansach.model.Account;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

   @Override
   protected void doGet(HttpServletRequest request, HttpServletResponse response) 
               throws ServletException, IOException {
      // Set character encoding
      request.setCharacterEncoding("UTF-8");
      response.setCharacterEncoding("UTF-8");
      response.setContentType("text/html; charset=UTF-8");
      
      // Check if user is coming from a protected page, so we know where to redirect after login
      String referer = request.getHeader("Referer");
      if (referer != null && !referer.contains("/login")) {
            request.getSession().setAttribute("loginRedirect", referer);
      }
      
      // Redirect to home page with showLogin parameter to display login modal
      response.sendRedirect(request.getContextPath() + "/home?showLogin=true");
   }

   @SuppressWarnings("unused")
   @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response) 
               throws ServletException, IOException {
      // Set character encoding
      request.setCharacterEncoding("UTF-8");
      response.setCharacterEncoding("UTF-8");
      response.setContentType("text/html; charset=UTF-8");
      
      String username = request.getParameter("username");
      String password = request.getParameter("password");
      String rememberMe = request.getParameter("rememberMe");
      String role = request.getParameter("roleUI");
      
      // Sử dụng AccountDAO để xác thực đăng nhập
      AccountDAO accountDAO = new AccountDAO();
      Account account = accountDAO.login(username, password);
      
      // Kiểm tra null trước khi gọi toString()
      if (account != null) {
         System.out.println(account.toString());
         
         // Đăng nhập thành công
         HttpSession session = request.getSession();
         
         // Lưu thông tin tài khoản vào session
         session.setAttribute("account", account);
         
         // Lưu thông tin phân quyền
         session.setAttribute("role", account.getRoleName());

         CartDAO cartDAO = new CartDAO();
         
         // Lưu thông tin khách hàng nếu có
         if (account.getCustomerId() != null) {
            session.setAttribute("customerId", account.getCustomerId());
            session.setAttribute("customerName", account.getCustomerName());
            // Lưu thông tin giỏ hàng vào session
            session.setAttribute("cart", cartDAO.getCartByCustomerId(account.getCustomerId()));
         }
         
         // Handle "Remember me" functionality
         if (rememberMe != null) {
            Cookie usernameCookie = new Cookie("username", username);
            usernameCookie.setMaxAge(60 * 60 * 24); // 1 day
            response.addCookie(usernameCookie);
         } else {
            // Remove any existing cookie
            Cookie usernameCookie = new Cookie("username", "");
            usernameCookie.setMaxAge(0);
            response.addCookie(usernameCookie);
         }
         
         // Redirect to intended page or default depending on role
         String redirectURL = (String) session.getAttribute("loginRedirect");
         if (redirectURL != null) {
            session.removeAttribute("loginRedirect");
            response.sendRedirect(redirectURL);
         } else {
            // Chuyển hướng dựa trên vai trò
            if ("Admin".equals(account.getRoleName())) {
               response.sendRedirect(request.getContextPath() + "/admin/home");
            } else if ("Staff".equals(account.getRoleName())) {
               response.sendRedirect(request.getContextPath() + "/staff/dashboard");
            } else {
               // Người dùng thông thường
               response.sendRedirect(request.getContextPath() + "/home");
            }
         }
      } else {
         // Đăng nhập thất bại
         request.getSession().setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng");
         response.sendRedirect(request.getContextPath() + "/home?loginError=true");
      }
   }
}