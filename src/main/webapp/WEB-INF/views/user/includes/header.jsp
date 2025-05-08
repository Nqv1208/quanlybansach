<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Link to main CSS that includes header component CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">

<header>
    <nav class="navbar navbar-expand-lg navbar-light sticky-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/user/home">
                <i class="fas fa-book-open me-2"></i>
                Nhà Sách Online
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/home">Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/shop">Cửa hàng</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Danh mục
                        </a>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/orders">Đơn hàng</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Liên hệ</a>
                    </li>
                </ul>
                <div class="d-flex align-items-center">
                    <a href="${pageContext.request.contextPath}/user/cart" class="btn btn-outline-primary position-relative me-3">
                        <i class="fas fa-shopping-cart"></i>
                        <c:if test="${not empty sessionScope.cart && sessionScope.cart.size() > 0}">
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                ${sessionScope.cart.size()}
                            </span>
                        </c:if>
                    </a>
                    <c:choose>
                        <c:when test="${empty sessionScope.user}">
                            <button type="button" class="btn btn-outline-primary me-2" data-bs-toggle="modal" data-bs-target="#loginModal">Đăng nhập</button>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Đăng ký</a>
                        </c:when>
                        <c:otherwise>
                            <div class="dropdown">
                                <button class="btn btn-outline-primary dropdown-toggle" type="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fas fa-user-circle me-1"></i> ${sessionScope.user.fullName}
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/account/profile"><i class="fas fa-id-card me-2"></i>Hồ sơ</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/orders"><i class="fas fa-shopping-bag me-2"></i>Đơn hàng</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                                </ul>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>
</header> 