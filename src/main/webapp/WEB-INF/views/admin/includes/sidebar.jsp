<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Get current page for active menu highlighting -->
<%
    String currentPage = request.getRequestURI();
    currentPage = currentPage.substring(currentPage.lastIndexOf("/") + 1);
    if (currentPage.isEmpty()) currentPage = "index.jsp";
    request.setAttribute("currentPage", currentPage);
%>

<!-- Sidebar -->
<div id="sidebar" class="col-md-2 sidebar bg-dark text-white">
    <div class="sidebar-sticky">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link ${currentPage == 'index' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/home">
                    <i class="fas fa-tachometer-alt"></i> <span>Tổng quan</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentPage == 'books' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/books">
                    <i class="fas fa-book"></i> <span>Quản lý sách</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentPage == 'authors' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/authors">
                    <i class="fas fa-user-edit"></i> <span>Tác giả</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentPage == 'categories' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/categories">
                    <i class="fas fa-tag"></i> <span>Danh mục</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentPage == 'publishers' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/publishers">
                    <i class="fas fa-building"></i> <span>Nhà xuất bản</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentPage == 'customers' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/customers">
                    <i class="fas fa-users"></i> <span>Khách hàng</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentPage == 'orders' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/orders">
                    <i class="fas fa-shopping-cart"></i> <span>Đơn hàng</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentPage == 'inventory' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/inventory">
                    <i class="fas fa-warehouse"></i> <span>Kho sách</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentPage == 'reports' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reports">
                    <i class="fas fa-chart-bar"></i> <span>Báo cáo</span>
                </a>
            </li>
        </ul>
    </div>
</div>

<!-- Sidebar Toggle Button -->
<button id="sidebarToggler" class="sidebar-toggler">
    <i class="fas fa-bars"></i>
</button> 