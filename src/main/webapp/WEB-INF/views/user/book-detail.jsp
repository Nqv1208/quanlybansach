<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${book.title} - Nhà Sách Online</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/pages/user/book-detail.css" rel="stylesheet">
</head>
<body>
    <!-- Header -->
    <jsp:include page="/WEB-INF/views/user/includes/header.jsp" />

    <!-- Breadcrumb -->
    <section class="breadcrumb-section">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/shop">Cửa hàng</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/shop?category=${book.categoryId}">${book.categoryName}</a></li>
                    <li class="breadcrumb-item active" aria-current="page">${book.title}</li>
                </ol>
            </nav>
        </div>
    </section>

    <!-- Book Detail Section -->
    <section class="container my-5">
        <div class="book-detail-card">
            <div class="row g-0">
                <div class="col-md-4 flex flex-column">
                    <div class="book-image-container">
                        <img src="${book.imageUrl}" alt="${book.title}" class="book-image">
                    </div>
                    <div class="book-actions flex flex-row">
                        <div class="social-sharing flex items-center">
                            <span class="me-2">Chia sẻ:</span>
                            <a href="#" class="btn btn-sm btn-outline-primary me-2"><i class="fab fa-facebook-f"></i></a>
                            <a href="#" class="btn btn-sm btn-outline-info me-2"><i class="fab fa-twitter"></i></a>
                            <a href="#" class="btn btn-sm btn-outline-danger me-2"><i class="fab fa-pinterest"></i></a>
                        </div>
                        <div class="wishlist flex items-center">
                            <a href="${pageContext.request.contextPath}/account/wishlist/add?bookId=${book.bookId}" class="wishlist-btn btn btn-sm ms-2">
                                <i class="far fa-heart"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-md-8">
                    <div class="book-info">
                        <h1 class="book-title">${book.title}</h1>
                        <p class="book-author">Tác giả: <a href="${pageContext.request.contextPath}/shop?author=${book.authorId}" class="fw-semibold">${book.authorName}</a></p>
                        <h2 class="book-price"><fmt:formatNumber value="${book.price}" type="currency" currencySymbol="" /> ₫</h2>
                        
                        <div class="stock-info">
                            <c:choose>
                                <c:when test="${book.stockQuantity > 10}">
                                    <div class="stock-status in-stock"><i class="fas fa-check-circle me-2"></i> Còn hàng</div>
                                </c:when>
                                <c:when test="${book.stockQuantity > 0 && book.stockQuantity <= 10}">
                                    <div class="book-badge badge-warning"><i class="fas fa-exclamation-circle me-1"></i> Chỉ còn ${book.stockQuantity} sản phẩm</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="stock-status out-of-stock"><i class="fas fa-times-circle me-2"></i> Hết hàng</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <div class="book-details mb-4">
                            <div class="book-detail-item">
                                <div class="book-detail-label">Danh mục:</div>
                                <div class="book-detail-value"><a href="${pageContext.request.contextPath}/shop?category=${book.categoryId}">${book.categoryName}</a></div>
                            </div>
                            <div class="book-detail-item">
                                <div class="book-detail-label">Năm xuất bản:</div>
                                <div class="book-detail-value"><fmt:formatDate value="${book.publicationDate}" pattern="yyyy"/></div>
                            </div>
                            <div class="book-detail-item">
                                <div class="book-detail-label">Nhà xuất bản:</div>
                                <div class="book-detail-value"><a href="${pageContext.request.contextPath}/shop?publisher=${book.publisherId}">${book.publisherName}</a></div>
                            </div>
                            <div class="book-detail-item">
                                <div class="book-detail-label">ISBN:</div>
                                <div class="book-detail-value">${book.isbn}</div>
                            </div>
                        </div>
                        
                        <c:if test="${book.stockQuantity > 0}">
                            <div class="quantity-control">
                                <button type="button" class="quantity-btn decrease-btn">-</button>
                                <input type="number" id="quantity" min="1" max="${book.stockQuantity}" value="1" class="quantity-input">
                                <button type="button" class="quantity-btn increase-btn">+</button>
                            </div>
                            
                            <div class="action-buttons">
                                <form id="addToCartForm" action="${pageContext.request.contextPath}/cart/add" method="post" class="d-inline-block me-2">
                                    <input type="hidden" name="bookId" value="${book.bookId}">
                                    <input type="hidden" name="quantity" id="cartQuantity" value="1">
                                    <button type="submit" class="btn btn-outline-primary btn-add-to-cart">
                                        <i class="fas fa-cart-plus me-2"></i> Thêm vào giỏ hàng
                                    </button>
                                </form>
                                
                                <form id="buyNowForm" action="${pageContext.request.contextPath}/checkout?bookId=${book.bookId}" method="get" class="d-inline-block">
                                    <input type="hidden" name="bookId" value="${book.bookId}">
                                    <input type="hidden" name="quantity" id="buyQuantity" value="1">
                                    <input type="hidden" name="redirect" value="checkout">
                                    <button type="submit" class="btn btn-buy-now">
                                        <i class="fas fa-bolt me-2"></i> Mua ngay
                                    </button>
                                </form>
                            </div>
                        </c:if>
                        
                        <c:if test="${book.stockQuantity == 0}">
                            <div class="action-buttons">
                                <button type="button" class="btn btn-secondary btn-add-to-cart" disabled>
                                    <i class="fas fa-cart-plus me-2"></i> Hết hàng
                                </button>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Book Tabs Section -->
        <ul class="nav nav-tabs" id="bookTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="description-tab" data-bs-toggle="tab" data-bs-target="#description" type="button" role="tab" aria-controls="description" aria-selected="true">Mô tả sách</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="details-tab" data-bs-toggle="tab" data-bs-target="#details" type="button" role="tab" aria-controls="details" aria-selected="false">Thông tin chi tiết</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="reviews-tab" data-bs-toggle="tab" data-bs-target="#reviews" type="button" role="tab" aria-controls="reviews" aria-selected="false">Đánh giá (${book.reviewCount})</button>
            </li>
        </ul>
        <div class="tab-content" id="bookTabContent">
            <div class="tab-pane fade show active description-content" id="description" role="tabpanel" aria-labelledby="description-tab">
                <p>${book.description}</p>
            </div>
            <div class="tab-pane fade" id="details" role="tabpanel" aria-labelledby="details-tab">
                <table class="specifications-table">
                    <tbody>
                        <tr>
                            <th>Tác giả</th>
                            <td>${book.authorName}</td>
                        </tr>
                        <tr>
                            <th>Nhà xuất bản</th>
                            <td>${book.publisherName}</td>
                        </tr>
                        <tr>
                            <th>Năm xuất bản</th>
                            <td><fmt:formatDate value="${book.publicationDate}" pattern="yyyy"/></td>
                        </tr>
                        <tr>
                            <th>ISBN</th>
                            <td>${book.isbn}</td>
                        </tr>
                        <tr>
                            <th>Danh mục</th>
                            <td>${book.categoryName}</td>
                        </tr>
                        <tr>
                            <th>Đánh giá</th>
                            <td>${book.avgRating} sao (${book.reviewCount} đánh giá)</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="tab-pane fade" id="reviews" role="tabpanel" aria-labelledby="reviews-tab">
                <p class="text-center py-4">Chưa có đánh giá nào cho sản phẩm này.</p>
                <div class="review-form">
                    <h4 class="mb-3">Viết đánh giá của bạn</h4>
                    <form>
                        <div class="mb-3">
                            <label for="reviewRating" class="form-label">Đánh giá của bạn</label>
                            <div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="rating" id="rating5" value="5">
                                    <label class="form-check-label" for="rating5">5 <i class="fas fa-star text-warning"></i></label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="rating" id="rating4" value="4">
                                    <label class="form-check-label" for="rating4">4 <i class="fas fa-star text-warning"></i></label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="rating" id="rating3" value="3">
                                    <label class="form-check-label" for="rating3">3 <i class="fas fa-star text-warning"></i></label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="rating" id="rating2" value="2">
                                    <label class="form-check-label" for="rating2">2 <i class="fas fa-star text-warning"></i></label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="rating" id="rating1" value="1">
                                    <label class="form-check-label" for="rating1">1 <i class="fas fa-star text-warning"></i></label>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="reviewText" class="form-label">Nội dung đánh giá</label>
                            <textarea class="form-control" id="reviewText" rows="5" placeholder="Nhập nội dung đánh giá của bạn"></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <!-- Related Books Section -->
    <section class="container mb-5">
        <h2 class="related-title">Sách liên quan</h2>
        <div class="row">
            <c:forEach var="relatedBook" items="${relatedBooks}" varStatus="loop">
                <c:if test="${loop.index < 4}">
                    <div class="col-lg-3 col-md-6">
                        <div class="card">
                            <div class="card-img-container">
                                <img src="${relatedBook.imageUrl}" class="card-img-top" alt="${relatedBook.title}">
                            </div>
                            <div class="card-body">
                                <h5 class="card-title">${relatedBook.title}</h5>
                                <p class="card-author">${relatedBook.authorName}</p>
                                <p class="card-price"><fmt:formatNumber value="${relatedBook.price}" type="currency" currencySymbol="" /> ₫</p>
                                <a href="${pageContext.request.contextPath}/book-detail?id=${relatedBook.bookId}" class="btn btn-primary w-100">Xem chi tiết</a>
                            </div>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
        </div>
    </section>

    <!-- Toast thông báo -->
    <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 5">
        <div id="cartToast" class="toast align-items-center text-white bg-primary border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    Sản phẩm đã được thêm vào giỏ hàng
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/user/includes/footer.jsp" />

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/js/user/book-detail.js"></script>
</body>
</html>