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
    <!-- Swiper CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.css" />
    <!-- AOS Animation -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
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
            <div class="row align-items-center">
                <div class="col-md-6" data-aos="fade-right" data-aos-duration="1000">
                    <h1 class="hero-title">Khám phá thế giới qua từng trang sách</h1>
                    <p class="hero-subtitle">Tìm kiếm tri thức, cảm xúc và niềm vui qua hàng ngàn đầu sách chất lượng</p>
                    <div class="hero-search">
                        <form action="${pageContext.request.contextPath}/shop" method="get">
                            <input type="text" name="keyword" class="hero-search-input" placeholder="Tìm kiếm tên sách, tác giả...">
                            <button type="submit" class="hero-search-button"><i class="fas fa-search"></i> Tìm</button>
                        </form>
                    </div>
                </div>
                <div class="col-md-6 d-none d-md-block text-center" data-aos="fade-left" data-aos-duration="1000">
                    <div class="d-flex justify-content-center flex-wrap" style="font-size: 3rem; color: rgba(255,255,255,0.9);">
                        <div class="m-3"><i class="fas fa-book-open"></i></div>
                        <div class="m-3"><i class="fas fa-graduation-cap"></i></div>
                        <div class="m-3"><i class="fas fa-lightbulb"></i></div>
                        <div class="m-3"><i class="fas fa-brain"></i></div>
                        <div class="m-3"><i class="fas fa-journal-whills"></i></div>
                        <div class="m-3"><i class="fas fa-bookmark"></i></div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- New Arrivals Section -->
    <section class="section">
        <div class="container">
            <div class="section-header d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="section-title" data-aos="fade-right">Sách mới</h2>
                    <p class="section-subtitle" data-aos="fade-right" data-aos-delay="100">Những đầu sách vừa được cập nhật trong tuần qua</p>
                </div>
                <div class="d-none d-md-block">
                    <a href="${pageContext.request.contextPath}/shop" class="btn btn-outline-primary rounded-pill">
                        <i class="fas fa-book me-2"></i> Xem tất cả
                    </a>
                </div>
            </div>
            
            <div class="swiper newArrivalsSwiper">
                <div class="swiper-wrapper">
                    <c:forEach var="book" items="${newArrivals}" varStatus="status">
                        <div class="swiper-slide" data-aos="fade-up" data-aos-delay="${status.index * 100}">
                            <div class="card h-100">
                                <div class="card-img-container">
                                    <img src="${not empty book.imageUrl ? book.imageUrl : 'https://placehold.co/280x400/e9ecef/495057?text=No+Image'}" 
                                         class="card-img-top" alt="${book.title}">
                                </div>
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title">${book.title}</h5>
                                    <p class="card-author"><i class="fas fa-user-edit me-1"></i> ${not empty book.authorName ? book.authorName : 'Unknown Author'}</p>
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
                                        <span class="ms-1 text-muted small">(${book.reviewCount})</span>
                                    </div>
                                    <p class="card-price mt-auto">
                                        <fmt:formatNumber value="${book.price}" type="currency" currencySymbol="" maxFractionDigits="0" /> ₫
                                    </p>
                                    <div class="card-actions">
                                        <button type="button" class="btn btn-primary btn-cart" data-book-id="${book.bookId}" data-quantity="1">
                                            <i class="fas fa-shopping-cart me-1"></i> Thêm vào giỏ
                                        </button>
                                        <a href="#" class="btn-wishlist"><i class="far fa-heart"></i></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <!-- Fallback if no books are available -->
                    <c:if test="${empty newArrivals}">
                        <!-- Sample Book 1 -->
                        <div class="swiper-slide" data-aos="fade-up">
                            <div class="card h-100">
                                <div class="card-img-container">
                                    <span class="discount-badge">-15%</span>
                                    <img src="https://salt.tikicdn.com/cache/280x280/ts/product/5e/18/24/2a6154ba08df6ce6161c13f4303fa19e.jpg" class="card-img-top" alt="Nhà Giả Kim">
                                </div>
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title">Nhà Giả Kim</h5>
                                    <p class="card-author"><i class="fas fa-user-edit me-1"></i> Paulo Coelho</p>
                                    <div class="card-rating">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star-half-alt"></i>
                                        <span class="ms-1 text-muted small">(124)</span>
                                    </div>
                                    <p class="card-price mt-auto">
                                        79.000 ₫
                                        <span class="text-decoration-line-through text-muted ms-2" style="font-size: 0.9rem;">
                                            90.000 ₫
                                        </span>
                                    </p>
                                    <div class="card-actions">
                                        <button type="button" class="btn btn-primary btn-cart" data-book-id="1" data-quantity="1">
                                            <i class="fas fa-shopping-cart me-1"></i> Thêm vào giỏ
                                        </button>
                                        <a href="#" class="btn-wishlist"><i class="far fa-heart"></i></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Sample Book 2 -->
                        <div class="swiper-slide" data-aos="fade-up" data-aos-delay="100">
                            <div class="card h-100">
                                <div class="card-img-container">
                                    <span class="discount-badge">-20%</span>
                                    <img src="https://salt.tikicdn.com/cache/280x280/ts/product/f6/06/6e/c7b78ca6c15e406e7c568fb52075c901.jpg" class="card-img-top" alt="Đắc Nhân Tâm">
                                </div>
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title">Đắc Nhân Tâm</h5>
                                    <p class="card-author"><i class="fas fa-user-edit me-1"></i> Dale Carnegie</p>
                                    <div class="card-rating">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <span class="ms-1 text-muted small">(235)</span>
                                    </div>
                                    <p class="card-price mt-auto">
                                        68.000 ₫
                                        <span class="text-decoration-line-through text-muted ms-2" style="font-size: 0.9rem;">
                                            85.000 ₫
                                        </span>
                                    </p>
                                    <div class="card-actions">
                                        <button type="button" class="btn btn-primary btn-cart" data-book-id="2" data-quantity="1">
                                            <i class="fas fa-shopping-cart me-1"></i> Thêm vào giỏ
                                        </button>
                                        <a href="#" class="btn-wishlist"><i class="far fa-heart"></i></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Sample Book 3 -->
                        <div class="swiper-slide" data-aos="fade-up" data-aos-delay="200">
                            <div class="card h-100">
                                <div class="card-img-container">
                                    <img src="https://salt.tikicdn.com/cache/280x280/ts/product/57/54/d2/24db8adc9fb33d1a33a858528c5f9141.jpg" class="card-img-top" alt="Tôi Tài Giỏi, Bạn Cũng Thế">
                                </div>
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title">Tôi Tài Giỏi, Bạn Cũng Thế</h5>
                                    <p class="card-author"><i class="fas fa-user-edit me-1"></i> Adam Khoo</p>
                                    <div class="card-rating">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="far fa-star"></i>
                                        <span class="ms-1 text-muted small">(98)</span>
                                    </div>
                                    <p class="card-price mt-auto">
                                        110.000 ₫
                                    </p>
                                    <div class="card-actions">
                                        <button type="button" class="btn btn-primary btn-cart" data-book-id="3" data-quantity="1">
                                            <i class="fas fa-shopping-cart me-1"></i> Thêm vào giỏ
                                        </button>
                                        <a href="#" class="btn-wishlist"><i class="far fa-heart"></i></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Sample Book 4 -->
                        <div class="swiper-slide" data-aos="fade-up" data-aos-delay="300">
                            <div class="card h-100">
                                <div class="card-img-container">
                                    <span class="discount-badge">-25%</span>
                                    <img src="https://salt.tikicdn.com/cache/280x280/ts/product/c1/2b/23/c7823c6de5fddc630cca4d2469f0bbe4.jpg" class="card-img-top" alt="Sapiens: Lược Sử Loài Người">
                                </div>
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title">Sapiens: Lược Sử Loài Người</h5>
                                    <p class="card-author"><i class="fas fa-user-edit me-1"></i> Yuval Noah Harari</p>
                                    <div class="card-rating">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star-half-alt"></i>
                                        <span class="ms-1 text-muted small">(156)</span>
                                    </div>
                                    <p class="card-price mt-auto">
                                        149.000 ₫
                                        <span class="text-decoration-line-through text-muted ms-2" style="font-size: 0.9rem;">
                                            199.000 ₫
                                        </span>
                                    </p>
                                    <div class="card-actions">
                                        <button type="button" class="btn btn-primary btn-cart" data-book-id="4" data-quantity="1">
                                            <i class="fas fa-shopping-cart me-1"></i> Thêm vào giỏ
                                        </button>
                                        <a href="#" class="btn-wishlist"><i class="far fa-heart"></i></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
                <div class="swiper-pagination"></div>
                <div class="swiper-button-next"></div>
                <div class="swiper-button-prev"></div>
            </div>
            
            <div class="text-center d-md-none mt-4">
                <a href="${pageContext.request.contextPath}/shop" class="btn btn-outline-primary rounded-pill">
                    <i class="fas fa-book me-2"></i> Xem tất cả sách mới
                </a>
            </div>
        </div>
    </section>
    
    <!-- Categories Section -->
    <section class="section categories-section">
        <div class="container">
            <div class="section-header text-center">
                <h2 class="section-title mx-auto" data-aos="fade-up">Danh mục sách</h2>
                <p class="section-subtitle" data-aos="fade-up" data-aos-delay="100">Khám phá sách theo sở thích và nhu cầu của bạn</p>
            </div>
            
            <div class="row g-4">
                <div class="col-lg-3 col-md-4 col-sm-6" data-aos="zoom-in" data-aos-delay="100">
                    <a href="${pageContext.request.contextPath}/shop?category=1" class="category-card">
                        <div class="category-icon">
                            <i class="fas fa-book"></i>
                        </div>
                        <h3 class="category-title">Văn học Việt Nam</h3>
                        <p class="category-count">125 sách</p>
                    </a>
                </div>
                
                <div class="col-lg-3 col-md-4 col-sm-6" data-aos="zoom-in" data-aos-delay="200">
                    <a href="${pageContext.request.contextPath}/shop?category=2" class="category-card">
                        <div class="category-icon">
                            <i class="fas fa-globe-americas"></i>
                        </div>
                        <h3 class="category-title">Văn học nước ngoài</h3>
                        <p class="category-count">243 sách</p>
                    </a>
                </div>
                
                <div class="col-lg-3 col-md-4 col-sm-6" data-aos="zoom-in" data-aos-delay="300">
                    <a href="${pageContext.request.contextPath}/shop?category=3" class="category-card">
                        <div class="category-icon">
                            <i class="fas fa-child"></i>
                        </div>
                        <h3 class="category-title">Sách thiếu nhi</h3>
                        <p class="category-count">87 sách</p>
                    </a>
                </div>
                
                <div class="col-lg-3 col-md-4 col-sm-6" data-aos="zoom-in" data-aos-delay="400">
                    <a href="${pageContext.request.contextPath}/shop?category=4" class="category-card">
                        <div class="category-icon">
                            <i class="fas fa-brain"></i>
                        </div>
                        <h3 class="category-title">Kỹ năng sống</h3>
                        <p class="category-count">65 sách</p>
                    </a>
                </div>
                
                <div class="col-lg-3 col-md-4 col-sm-6" data-aos="zoom-in" data-aos-delay="500">
                    <a href="${pageContext.request.contextPath}/shop?category=5" class="category-card">
                        <div class="category-icon">
                            <i class="fas fa-laptop-code"></i>
                        </div>
                        <h3 class="category-title">Tin học - Công nghệ</h3>
                        <p class="category-count">42 sách</p>
                    </a>
                </div>
                
                <div class="col-lg-3 col-md-4 col-sm-6" data-aos="zoom-in" data-aos-delay="600">
                    <a href="${pageContext.request.contextPath}/shop?category=6" class="category-card">
                        <div class="category-icon">
                            <i class="fas fa-briefcase"></i>
                        </div>
                        <h3 class="category-title">Kinh tế - Quản trị</h3>
                        <p class="category-count">92 sách</p>
                    </a>
                </div>
                
                <div class="col-lg-3 col-md-4 col-sm-6" data-aos="zoom-in" data-aos-delay="700">
                    <a href="${pageContext.request.contextPath}/shop?category=7" class="category-card">
                        <div class="category-icon">
                            <i class="fas fa-graduation-cap"></i>
                        </div>
                        <h3 class="category-title">Giáo dục</h3>
                        <p class="category-count">74 sách</p>
                    </a>
                </div>
                
                <div class="col-lg-3 col-md-4 col-sm-6" data-aos="zoom-in" data-aos-delay="800">
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
    
    <!-- Feature section -->
    <section class="section">
        <div class="container">
            <div class="row g-4 align-items-center">
                <div class="col-lg-6" data-aos="fade-right">
                    <div class="p-4 bg-light rounded text-center">
                        <div class="d-flex justify-content-center flex-wrap my-4" style="font-size: 2.5rem; color: var(--primary-color);">
                            <div class="m-3"><i class="fas fa-book"></i></div>
                            <div class="m-3"><i class="fas fa-star"></i></div>
                            <div class="m-3"><i class="fas fa-thumbs-up"></i></div>
                            <div class="m-3"><i class="fas fa-heart"></i></div>
                        </div>
                        <h3 class="text-primary">Sách hay mỗi ngày</h3>
                        <p class="text-muted">Chúng tôi cập nhật liên tục những đầu sách chất lượng từ các nhà xuất bản uy tín</p>
                    </div>
                </div>
                <div class="col-lg-6" data-aos="fade-left">
                    <h2 class="mb-4">Tại sao chọn Nhà Sách Online?</h2>
                    <div class="d-flex mb-4">
                        <div class="me-3">
                            <div class="feature-icon">
                                <i class="fas fa-shipping-fast"></i>
                            </div>
                        </div>
                        <div>
                            <h4>Giao hàng nhanh chóng</h4>
                            <p class="text-muted">Giao hàng miễn phí toàn quốc cho đơn hàng từ 300.000đ</p>
                        </div>
                    </div>
                    <div class="d-flex mb-4">
                        <div class="me-3">
                            <div class="feature-icon">
                                <i class="fas fa-book-open"></i>
                            </div>
                        </div>
                        <div>
                            <h4>Sách chính hãng</h4>
                            <p class="text-muted">Cam kết 100% sách chính hãng từ các nhà xuất bản uy tín</p>
                        </div>
                    </div>
                    <div class="d-flex">
                        <div class="me-3">
                            <div class="feature-icon">
                                <i class="fas fa-undo-alt"></i>
                            </div>
                        </div>
                        <div>
                            <h4>Đổi trả dễ dàng</h4>
                            <p class="text-muted">Đổi trả sản phẩm trong vòng 7 ngày nếu có lỗi từ nhà sản xuất</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Newsletter Section -->
    <section class="newsletter-section" data-aos="fade-up">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 text-lg-start text-center mb-4 mb-lg-0">
                    <h2 class="newsletter-title">Đăng ký nhận thông tin</h2>
                    <p class="newsletter-text">Đăng ký nhận email để cập nhật những sách mới nhất và khuyến mãi đặc biệt từ chúng tôi.</p>
                </div>
                <div class="col-lg-6">
                    <form class="newsletter-form">
                        <div class="input-group">
                            <input type="email" class="form-control" placeholder="Địa chỉ email của bạn">
                            <button type="submit" class="btn">
                                <i class="fas fa-paper-plane me-2"></i> Đăng ký
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/user/includes/footer.jsp" />
    
    <!-- Login Modal -->
    <jsp:include page="/WEB-INF/views/user/includes/login-modal.jsp" />
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Swiper JS -->
    <script src="https://cdn.jsdelivr.net/npm/swiper@8/swiper-bundle.min.js"></script>
    <!-- AOS Animation -->
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    
    <script>
        // Initialize AOS animation library
        AOS.init({
            once: true,
            duration: 800
        });
        
        // Initialize Swiper slider
        const newArrivalsSwiper = new Swiper('.newArrivalsSwiper', {
            slidesPerView: 1,
            spaceBetween: 20,
            pagination: {
                el: '.swiper-pagination',
                clickable: true,
            },
            navigation: {
                nextEl: '.swiper-button-next',
                prevEl: '.swiper-button-prev',
            },
            breakpoints: {
                640: {
                    slidesPerView: 2,
                },
                768: {
                    slidesPerView: 3,
                },
                1024: {
                    slidesPerView: 4,
                },
            },
            autoplay: {
                delay: 3000,
                disableOnInteraction: false,
            },
        });
        
        // Add to cart functionality
        document.querySelectorAll('.btn-cart').forEach(button => {
            button.addEventListener('click', function() {
                const bookId = this.getAttribute('data-book-id');
                const quantity = this.getAttribute('data-quantity');
                
                // You can replace this with your actual cart functionality
                fetch('${pageContext.request.contextPath}/cart/add', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        bookId: bookId,
                        quantity: quantity
                    })
                })
                .then(response => response.json())
                .then(data => {
                    // Show success message
                    alert('Sản phẩm đã được thêm vào giỏ hàng!');
                })
                .catch((error) => {
                    console.error('Error:', error);
                });
            });
        });
    </script>
</body>
</html> 