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
</head>
<body>
    <!-- Header -->
    <jsp:include page="/WEB-INF/views/user/includes/header.jsp" />
    
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
                                    <button type="button" class="btn btn-primary btn-cart" data-book-id="${book.bookId}" data-quantity="1">
                                        <i class="fas fa-shopping-cart"></i> Thêm vào giỏ
                                    </button>
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
    <jsp:include page="/WEB-INF/views/user/includes/login-modal.jsp" />
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 