package com.quanlybansach.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Filter kiểm tra đăng nhập cho các trang yêu cầu người dùng đăng nhập
 */
@WebFilter(urlPatterns = {"/account/*", "/cart/*", "/checkout", "/wishlist/*", "/order/*"})
public class UserAreaFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Lấy đường dẫn được yêu cầu
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Kiểm tra đăng nhập
        boolean isLoggedIn = (session != null && session.getAttribute("account") != null);
        
        if (isLoggedIn) {
            // Đã đăng nhập, cho phép truy cập
            chain.doFilter(request, response);
        } else {
            // Chưa đăng nhập, lưu URL hiện tại và chuyển hướng đến trang đăng nhập
            String targetURL = requestURI.substring(contextPath.length());
            session = httpRequest.getSession(true);
            session.setAttribute("loginRedirect", targetURL);
            httpResponse.sendRedirect(contextPath + "/home?showLogin=true");
        }
    }

    @Override
    public void destroy() {
        // Dọn dẹp tài nguyên
    }
} 