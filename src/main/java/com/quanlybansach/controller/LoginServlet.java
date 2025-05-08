package com.quanlybansach.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Cookie;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

   @Override
   protected void doGet(HttpServletRequest request, HttpServletResponse response) 
               throws ServletException, IOException {
      // Check if user is coming from a protected page, so we know where to redirect after login
      String referer = request.getHeader("Referer");
      if (referer != null && !referer.contains("/login")) {
            request.getSession().setAttribute("loginRedirect", referer);
      }
      
      // Redirect to home page with showLogin parameter to display login modal
      response.sendRedirect(request.getContextPath() + "/user/home?showLogin=true");
   }

   @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response) 
               throws ServletException, IOException {
      String username = request.getParameter("username");
      String password = request.getParameter("password");
      String rememberMe = request.getParameter("rememberMe");
      
      // Authentication logic here...
      boolean isAuthenticated = authenticate(username, password);
      
      if (isAuthenticated) {
            // Set session attributes for authenticated user
            HttpSession session = request.getSession();
            
            // For demo, simple user object storage. In real app, get from DB
            User user = new User();
            user.setUsername(username);
            user.setFullName("Người dùng " + username);
            
            session.setAttribute("user", user);
            
            // Handle "Remember me" functionality
            if (rememberMe != null) {
               Cookie usernameCookie = new Cookie("username", username);
               usernameCookie.setMaxAge(60 * 60 * 24 * 30); // 30 days
               response.addCookie(usernameCookie);
            } else {
               // Remove any existing cookie
               Cookie usernameCookie = new Cookie("username", "");
               usernameCookie.setMaxAge(0);
               response.addCookie(usernameCookie);
            }
            
            // Redirect to intended page or default to home
            String redirectURL = (String) session.getAttribute("loginRedirect");
            if (redirectURL != null) {
               session.removeAttribute("loginRedirect");
               response.sendRedirect(redirectURL);
            } else {
               response.sendRedirect(request.getContextPath() + "/user/home");
            }
      } else {
            // Set error message and redirect back to home with parameters to show modal and error
            request.getSession().setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng");
            response.sendRedirect(request.getContextPath() + "/user/home?loginError=true");
      }
   }
   
   private boolean authenticate(String username, String password) {
      // Simple authentication for demo purposes
      // In a real application, this would check against a database
      return "demo".equals(username) && "password".equals(password) || 
               "admin".equals(username) && "admin".equals(password);
   }
   
   // Simple User class for demo
   public class User {
      private String username;
      private String fullName;
      
      public String getUsername() {
            return username;
      }
      
      public void setUsername(String username) {
            this.username = username;
      }
      
      public String getFullName() {
            return fullName;
      }
      
      public void setFullName(String fullName) {
            this.fullName = fullName;
      }
   }
}