<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhà Sách Online - Trang chủ</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Main CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <!-- Page-specific CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/user/home.css">
    <style>
        /* Thêm style cho dropdown menu người dùng */
        .user-dropdown {
            margin-left: 1rem;
        }
        
        .user-dropdown .dropdown-toggle {
            display: flex;
            align-items: center;
            text-decoration: none;
            color: #333;
        }
        
        .user-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background-color: #4267B2;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 8px;
            font-weight: bold;
        }
        
        .user-dropdown .dropdown-menu {
            padding: 0;
        }
        
        .user-dropdown .dropdown-item {
            padding: 0.6rem 1rem;
        }
        
        .user-dropdown .dropdown-item i {
            width: 20px;
            margin-right: 8px;
            text-align: center;
        }
        
        .user-dropdown .dropdown-divider {
            margin: 0;
        }
        
        .dropdown-header {
            background-color: #f8f9fa;
            color: #6c757d;
            font-weight: bold;
        }
        
        .role-badge {
            font-size: 0.7rem;
            padding: 0.2rem 0.5rem;
            margin-left: 0.5rem;
            border-radius: 10px;
        }
        
        .role-admin {
            background-color: #dc3545;
            color: white;
        }
        
        .role-staff {
            background-color: #fd7e14;
            color: white;
        }
        
        .role-user {
            background-color: #0d6efd;
            color: white;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="site-header">
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <div class="container">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                    <i class="fas fa-book-open"></i> Nhà Sách Online
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarContent">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/home">Trang chủ</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/shop">Cửa hàng</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link dropdown-toggle" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false" href="${pageContext.request.contextPath}/categories">Danh mục</a>
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
                            <a class="nav-link" href="${pageContext.request.contextPath}/authors">Tác giả</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/contact">Liên hệ</a>
                        </li>
                        
                        <!-- Các mục menu chỉ dành cho Admin và Staff
                        <c:if test="${sessionScope.role == 'Admin' || sessionScope.role == 'Staff'}">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="adminDropdown" role="button" data-bs-toggle="dropdown">
                                    <i class="fas fa-cog"></i> Quản lý
                                </a>
                                <ul class="dropdown-menu">
                                    <c:if test="${sessionScope.role == 'Admin'}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard">
                                            <i class="fas fa-tachometer-alt"></i> Bảng điều khiển
                                        </a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/accounts">
                                            <i class="fas fa-users-cog"></i> Quản lý tài khoản
                                        </a></li>
                                        <li><hr class="dropdown-divider"></li>
                                    </c:if>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/books">
                                        <i class="fas fa-book"></i> Quản lý sách
                                    </a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/orders">
                                        <i class="fas fa-shopping-basket"></i> Quản lý đơn hàng
                                    </a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/customers">
                                        <i class="fas fa-user-friends"></i> Quản lý khách hàng
                                    </a></li>
                                </ul>
                            </li>
                        </c:if> -->
                    </ul>
                    
                    <div class="d-flex align-items-center">
                        <!-- Giỏ hàng - Luôn hiển thị nhưng chỉ có chức năng khi đăng nhập -->
                        <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-secondary me-2">
                            <i class="fas fa-shopping-cart"></i>
                            <span class="badge bg-danger rounded-pill cart-count">0</span>
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
    
    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="row">
                <div class="col-md-8 offset-md-2 text-center">
                    <h1 class="hero-title">Khám phá thế giới qua từng trang sách</h1>
                    <p class="hero-subtitle">Tìm kiếm tri thức, cảm xúc và niềm vui qua hàng ngàn đầu sách chất lượng</p>
                    <div class="hero-search">
                        <form action="${pageContext.request.contextPath}/shop" method="get">
                            <input type="text" name="keyword" class="hero-search-input" placeholder="Tìm kiếm tên sách, tác giả...">
                            <button type="submit" class="hero-search-button"><i class="fas fa-search"></i> Tìm</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- New Arrivals Section -->
    <section class="section">
        <div class="container">
            <h2 class="section-title">Sách mới</h2>
            <p class="section-subtitle">Những đầu sách vừa được cập nhật trong tuần qua</p>
            
            <div class="row">
                <c:forEach var="book" items="${newArrivals}">
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="card">
                            <div class="card-img-container">
                                <img src="${pageContext.request.contextPath}/assets/img/books/${book.image}" class="card-img-top" alt="${book.title}">
                            </div>
                            <div class="card-body">
                                <h5 class="card-title">${book.title}</h5>
                                <p class="card-author">${book.authorName}</p>
                                <div class="card-rating">
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${i <= book.avgRating}">
                                                <i class="fas fa-star"></i>
                                            </c:when>
                                            <c:when test="${i <= book.avgRating + 0.5}">
                                                <i class="fas fa-star-half-alt"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="far fa-star"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                                <p class="card-price">
                                    <fmt:formatNumber value="${book.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                </p>
                                <div class="card-actions">
                                    <a href="${pageContext.request.contextPath}/cart/add?bookId=${book.bookId}&quantity=1" class="btn btn-primary btn-cart"><i class="fas fa-shopping-cart"></i> Thêm vào giỏ</a>
                                    <a href="#" class="btn-wishlist"><i class="far fa-heart"></i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>
    
    <!-- Categories Section -->
    <section class="section categories-section">
        <div class="container">
            <h2 class="section-title">Danh mục sách</h2>
            <p class="section-subtitle">Khám phá sách theo sở thích và nhu cầu của bạn</p>
            
            <div class="row">
                <div class="col-lg-3 col-md-4 col-sm-6">
                    <a href="${pageContext.request.contextPath}/shop?category=1" class="category-card">
                        <div class="category-icon">
                            <i class="fas fa-book"></i>
                        </div>
                        <h3 class="category-title">Văn học Việt Nam</h3>
                        <p class="category-count">125 sách</p>
                    </a>
                </div>
                
                <div class="col-lg-3 col-md-4 col-sm-6">
                    <a href="${pageContext.request.contextPath}/shop?category=2" class="category-card">
                        <div class="category-icon">
                            <i class="fas fa-globe-americas"></i>
                        </div>
                        <h3 class="category-title">Văn học nước ngoài</h3>
                        <p class="category-count">243 sách</p>
                    </a>
                </div>
                
                <div class="col-lg-3 col-md-4 col-sm-6">
                    <a href="${pageContext.request.contextPath}/shop?category=3" class="category-card">
                        <div class="category-icon">
                            <i class="fas fa-child"></i>
                        </div>
                        <h3 class="category-title">Sách thiếu nhi</h3>
                        <p class="category-count">87 sách</p>
                    </a>
                </div>
                
                <div class="col-lg-3 col-md-4 col-sm-6">
                    <a href="${pageContext.request.contextPath}/shop?category=4" class="category-card">
                        <div class="category-icon">
                            <i class="fas fa-brain"></i>
                        </div>
                        <h3 class="category-title">Kỹ năng sống</h3>
                        <p class="category-count">65 sách</p>
                    </a>
                </div>
                
                <div class="col-lg-3 col-md-4 col-sm-6">
                    <a href="${pageContext.request.contextPath}/shop?category=5" class="category-card">
                        <div class="category-icon">
                            <i class="fas fa-laptop-code"></i>
                        </div>
                        <h3 class="category-title">Tin học - Công nghệ</h3>
                        <p class="category-count">42 sách</p>
                    </a>
                </div>
                
                <div class="col-lg-3 col-md-4 col-sm-6">
                    <a href="${pageContext.request.contextPath}/shop?category=6" class="category-card">
                        <div class="category-icon">
                            <i class="fas fa-briefcase"></i>
                        </div>
                        <h3 class="category-title">Kinh tế - Quản trị</h3>
                        <p class="category-count">92 sách</p>
                    </a>
                </div>
                
                <div class="col-lg-3 col-md-4 col-sm-6">
                    <a href="${pageContext.request.contextPath}/shop?category=7" class="category-card">
                        <div class="category-icon">
                            <i class="fas fa-graduation-cap"></i>
                        </div>
                        <h3 class="category-title">Giáo dục</h3>
                        <p class="category-count">74 sách</p>
                    </a>
                </div>
                
                <div class="col-lg-3 col-md-4 col-sm-6">
                    <a href="${pageContext.request.contextPath}/shop" class="category-card">
                        <div class="category-icon">
                            <i class="fas fa-ellipsis-h"></i>
                        </div>
                        <h3 class="category-title">Xem tất cả</h3>
                        <p class="category-count">1000+ sách</p>
                    </a>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Newsletter Section -->
    <section class="newsletter-section">
        <div class="container">
            <h2 class="newsletter-title">Đăng ký nhận thông tin</h2>
            <p class="newsletter-text">Đăng ký nhận email để cập nhật những sách mới nhất và khuyến mãi đặc biệt từ chúng tôi.</p>
            <form class="newsletter-form">
                <input type="email" class="newsletter-input" placeholder="Địa chỉ email của bạn">
                <button type="submit" class="newsletter-button">Đăng ký</button>
            </form>
        </div>
    </section>
    
    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/user/includes/footer.jsp" />
    
    
    <!-- Login Modal -->
    <div class="modal fade login-modal" id="loginModal" tabindex="-1" aria-labelledby="loginModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="loginModalLabel">Đăng nhập</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Error message display -->
                    <c:if test="${not empty sessionScope.errorMessage}">
                        <div class="error-message">
                            ${sessionScope.errorMessage}
                        </div>
                        <c:remove var="errorMessage" scope="session" />
                    </c:if>
                    
                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <!-- Role toggle (for UI only, server determines actual role) -->
                        <div class="role-toggle">
                            <input type="radio" id="userRole" name="roleUI" value="user" checked>
                            <label for="userRole">Người dùng</label>
                            <input type="radio" id="adminRole" name="roleUI" value="admin">
                            <label for="adminRole">Quản trị viên</label>
                        </div>  

                        <!-- Username input -->
                        <div class="mb-3">
                            <label for="username" class="form-label">Tên đăng nhập</label>
                            <input type="text" class="form-control" id="username" name="username" 
                                value="${cookie.username != null ? cookie.username.value : ''}" required>
                        </div>

                        <!-- Password input -->
                        <div class="mb-3">
                            <label for="password" class="form-label">Mật khẩu</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>

                        <!-- 2 column grid layout -->
                        <div class="row mb-3">
                            <div class="col-6">
                                <!-- Checkbox -->
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
                                    <label class="form-check-label" for="rememberMe">Ghi nhớ đăng nhập</label>
                                </div>
                            </div>

                            <div class="col-6 forgot-password">
                                <!-- Simple link -->
                                <a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu?</a>
                            </div>
                        </div>

                        <!-- Submit button -->
                        <button type="submit" class="btn btn-login mb-3">Đăng nhập</button>
                        
                        <div class="divider">hoặc</div>
                        
                        <!-- Social login -->
                        <div class="social-login">
                            <a href="#!" class="social-btn facebook">
                                <i class="fab fa-facebook-f"></i>
                            </a>
                            <a href="#!" class="social-btn google">
                                <i class="fab fa-google"></i>
                            </a>
                            <a href="#!" class="social-btn twitter">
                                <i class="fab fa-twitter"></i>
                            </a>
                            <a href="#!" class="social-btn github">
                                <i class="fab fa-github"></i>
                            </a>
                        </div>
                        
                        <!-- Register link -->
                        <div class="login-footer">
                            Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JS -->
    <script>
        // Automatically populate username field if cookie exists
        document.addEventListener("DOMContentLoaded", function() {
            // Set the role UI based on the username value
            const username = document.getElementById('username').value;
            if (username === "admin") {
                document.getElementById('adminRole').checked = true;
            }
            
            // Add event listener to role toggle to update username placeholder
            document.getElementById('userRole').addEventListener('change', function() {
                if (this.checked) {
                    document.getElementById('username').placeholder = "user";
                }
            });
            
            document.getElementById('adminRole').addEventListener('change', function() {
                if (this.checked) {
                    document.getElementById('username').placeholder = "admin";
                }
            });
            
            // Check if we need to show login modal (e.g., after failed login attempt)
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.has('showLogin') || urlParams.has('loginError')) {
                const loginModal = new bootstrap.Modal(document.getElementById('loginModal'));
                loginModal.show();
            }
        });
    </script>
</body>
</html> 