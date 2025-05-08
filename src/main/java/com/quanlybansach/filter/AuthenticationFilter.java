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

@WebFilter(urlPatterns = {
    "/user/orders/*",
    "/user/cart/*",
    "/user/checkout/*",
    "/user/account/*"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code, if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Check if user is logged in
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        
        if (isLoggedIn) {
            // User is authenticated, continue with the request
            chain.doFilter(request, response);
        } else {
            // Store the requested URL to redirect back after login
            String requestedUrl = httpRequest.getRequestURL().toString();
            if (httpRequest.getQueryString() != null) {
                requestedUrl += "?" + httpRequest.getQueryString();
            }
            
            session = httpRequest.getSession();
            session.setAttribute("loginRedirect", requestedUrl);
            
            // Redirect to home page with login modal
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/user/home?showLogin=true");
        }
    }

    @Override
    public void destroy() {
        // Cleanup code, if needed
    }
} 