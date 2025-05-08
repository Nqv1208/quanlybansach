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
 * Filter kiểm tra quyền truy cập dựa trên vai trò
 */
@WebFilter(urlPatterns = {"/admin/*", "/staff/*"})
public class AuthorizationFilter implements Filter {

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
        String requestPath = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
        
        // Kiểm tra đường dẫn và phân quyền
        boolean isLoggedIn = (session != null && session.getAttribute("account") != null);
        boolean isAdmin = isLoggedIn && "Admin".equals(session.getAttribute("role"));
        boolean isStaff = isLoggedIn && "Staff".equals(session.getAttribute("role"));
        
        // Xác định quyền truy cập
        boolean accessAllowed = false;
        
        if (requestPath.startsWith("/admin/")) {
            // Chỉ Admin mới có quyền truy cập vào trang admin
            accessAllowed = isAdmin;
        } else if (requestPath.startsWith("/staff/")) {
            // Admin và Staff có quyền truy cập vào trang staff
            accessAllowed = isAdmin || isStaff;
        }
        
        if (accessAllowed) {
            // Cho phép truy cập
            chain.doFilter(request, response);
        } else {
            // Không có quyền truy cập
            if (isLoggedIn) {
                // Đã đăng nhập nhưng không đủ quyền
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/access-denied.jsp");
            } else {
                // Chưa đăng nhập, chuyển hướng đến trang đăng nhập
                httpRequest.getSession().setAttribute("loginRedirect", httpRequest.getRequestURI());
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/home?showLogin=true");
            }
        }
    }

    @Override
    public void destroy() {
        // Dọn dẹp tài nguyên
    }
} 