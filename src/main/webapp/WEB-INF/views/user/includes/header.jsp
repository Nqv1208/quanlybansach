<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<header class="site-header">
    <nav class="navbar navbar-expand-lg navbar-light sticky-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                <i class="fas fa-book-open me-2"></i>
                Nhà Sách Online
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link ${pageContext.request.servletPath.endsWith('/home.jsp') ? 'active' : ''}" href="${pageContext.request.contextPath}/home">Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${pageContext.request.servletPath.endsWith('/shop.jsp') ? 'active' : ''}" href="${pageContext.request.contextPath}/shop">Cửa hàng</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false" href="#">Danh mục</a>
                        <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/shop?category=1">Văn học Việt Nam</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/shop?category=2">Văn học nước ngoài</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/shop?category=3">Sách thiếu nhi</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/shop?category=4">Kỹ năng sống</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/shop">Tất cả danh mục</a></li>
                        </ul>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${pageContext.request.servletPath.endsWith('/authors.jsp') ? 'active' : ''}" href="${pageContext.request.contextPath}/authors">Tác giả</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${pageContext.request.servletPath.endsWith('/contact.jsp') ? 'active' : ''}" href="${pageContext.request.contextPath}/contact">Liên hệ</a>
                    </li>
                    
                </ul>
                <div class="d-flex align-items-center">
                    <!-- Giỏ hàng - Luôn hiển thị nhưng chỉ có chức năng khi đăng nhập -->
                    <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-secondary me-2">
                        <i class="fas fa-shopping-cart"></i>
                        <span class="badge bg-danger rounded-pill cart-count">
                            <c:if test="${not empty sessionScope.cart and sessionScope.cart.getItems().size() != null}">${sessionScope.cart.getItems().size()}</c:if>
                            <c:if test="${empty sessionScope.cart}">0</c:if>
                        </span>
                    </a>
                    
                    <!-- Đã đăng nhập: Hiển thị thông tin người dùng -->
                    <c:if test="${not empty sessionScope.account}">
                        <div class="dropdown user-dropdown">
                            <a href="#" class="dropdown-toggle" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <div class="user-avatar">
                                    ${fn:substring(sessionScope.account.username, 0, 1).toUpperCase()}
                                </div>
                                <span>${sessionScope.account.username}
                                    <c:choose>
                                        <c:when test="${sessionScope.role == 'Admin'}">
                                            <span class="role-badge role-admin">Admin</span>
                                        </c:when>
                                        <c:when test="${sessionScope.role == 'Staff'}">
                                            <span class="role-badge role-staff">Staff</span>
                                        </c:when>
                                        <c:when test="${sessionScope.role == 'User'}">
                                            <span class="role-badge role-user">User</span>
                                        </c:when>
                                    </c:choose>
                                </span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                <li class="dropdown-header">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.customerName}">
                                            ${sessionScope.customerName}
                                        </c:when>
                                        <c:otherwise>
                                            ${sessionScope.account.username}
                                        </c:otherwise>
                                    </c:choose>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/account/profile">
                                    <i class="fas fa-user"></i> Thông tin tài khoản
                                </a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/account/orders">
                                    <i class="fas fa-clipboard-list"></i> Đơn hàng của tôi
                                </a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/account/wishlist">
                                    <i class="fas fa-heart"></i> Sản phẩm yêu thích
                                </a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                                </a></li>
                            </ul>
                        </div>
                    </c:if>
                    
                    <!-- Chưa đăng nhập: Hiển thị nút đăng nhập/đăng ký -->
                    <c:if test="${empty sessionScope.account}">
                        <button type="button" class="btn btn-primary me-2" data-bs-toggle="modal" data-bs-target="#loginModal">
                            <i class="fas fa-sign-in-alt"></i> Đăng nhập
                        </button>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-primary">
                            <i class="fas fa-user-plus"></i> Đăng ký
                        </a>
                    </c:if>
                </div>
            </div>
        </div>
    </nav>
</header> 