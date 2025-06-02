<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhà Sách Online - Cửa hàng</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Main CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <!-- Page-specific CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/user/shop.css">
</head>
<body>
    <!-- Header -->
    <jsp:include page="/WEB-INF/views/user/includes/header.jsp" />
    
    <!-- Page Title -->
    <section class="page-title">
        <div class="container">
            <h1 class="m-0">Cửa hàng sách</h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home" class="text-white">Trang chủ</a></li>
                    <li class="breadcrumb-item active text-white" aria-current="page">Cửa hàng</li>
                    <c:if test="${not empty category}">
                        <li class="breadcrumb-item active text-white" aria-current="page">${category.name}</li>
                    </c:if>
                </ol>
            </nav>
        </div>
    </section>
    
    <!-- Main Content -->
    <div class="container py-4">
        <div class="row">
            <!-- Filter Sidebar -->
            <div class="col-lg-3 filter-sidebar">
                <!-- Search Form -->
                <div class="filter-card mb-4">
                    <h4 class="filter-title">Tìm kiếm</h4>
                    <div class="filter-section">
                        <form action="${pageContext.request.contextPath}/shop/search" method="get">
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="Tên sách, tác giả..." name="keyword" value="${param.keyword}">
                                <button class="btn btn-primary" type="submit">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Categories Filter -->
                <div class="filter-card">
                    <h4 class="filter-title">Danh mục</h4>
                    <div class="filter-section">
                        <form action="${pageContext.request.contextPath}/shop/search" method="get"></form>
                            <c:forEach var="category" items="${categories}">
                                <div class="form-check">
                                    <input class="form-check-input category-filter" type="checkbox" name="category" value="${category.categoryId}" id="category${category.categoryId}"
                                        ${param.category == category.categoryId ? 'checked' : ''}>
                                    <label class="form-check-label" for="category${category.categoryId}">
                                        ${category.name} (${category.bookCount})
                                    </label>
                                </div>
                            </c:forEach>
                        </form>
                    </div>
                </div>
                
                <!-- Price Range Filter -->
                <div class="filter-card">
                    <h4 class="filter-title">Khoảng Giá</h4>
                    <div class="filter-section">
                        <form action="${pageContext.request.contextPath}/shop/search" method="get">
                            <div class="price-range-inputs">
                                <div class="input-group mb-2">
                                    <input type="text" class="form-control" id="minPriceInput" placeholder="TỪ" value="${param.minPrice != null ? param.minPrice : ''}">
                                </div>
                                <div class="price-separator text-center mb-2">—</div>
                                <div class="input-group mb-2">
                                    <input type="text" class="form-control" id="maxPriceInput" placeholder="ĐẾN" value="${param.maxPrice != null ? param.maxPrice : ''}">
                                </div>
                            </div>
                            <button class="btn btn-primary w-100" id="applyPriceFilter">ÁP DỤNG</button>
                        </form>
                    </div>
                </div>
                
                <!-- Author Filter -->
                <div class="filter-card">
                    <h4 class="filter-title">Tác giả</h4>
                    <div class="filter-section">
                        <form action="${pageContext.request.contextPath}/shop/search" method="get">
                            <c:forEach var="author" items="${authors}">
                                <div class="form-check">
                                    <input class="form-check-input author-filter" type="checkbox" name="author" value="${author.authorId}" id="author${author.authorId}"
                                        ${param.author == author.authorId ? 'checked' : ''}>
                                    <label class="form-check-label" for="author${author.authorId}">
                                        ${author.name} (${author.bookCount})
                                    </label>
                                </div>
                            </c:forEach>
                        </form>
                    </div>
                </div>
                
                <!-- Rating Filter -->
                <div class="filter-card">
                    <h4 class="filter-title">Đánh giá</h4>
                    <div class="filter-section">
                        <form action="${pageContext.request.contextPath}/shop/search" method="get">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="rating" id="rating5" value="5" ${param.rating == '5' ? 'checked' : ''}>
                                <label class="form-check-label" for="rating5">
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="rating" id="rating4" value="4" ${param.rating == '4' ? 'checked' : ''}>
                                <label class="form-check-label" for="rating4">
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="far fa-star text-warning"></i>
                                    trở lên
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="rating" id="rating3" value="3" ${param.rating == '3' ? 'checked' : ''}>
                                <label class="form-check-label" for="rating3">
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="far fa-star text-warning"></i>
                                    <i class="far fa-star text-warning"></i>
                                    trở lên
                                </label>
                            </div>
                        </form>
                    </div>
                </div>
                <!-- Reset Filters Button -->
                <div class="filter-card mb-4">
                    <a href="${pageContext.request.contextPath}/shop" class="btn btn-outline-danger w-100">
                        <i class="fas fa-times-circle me-1"></i> Xóa tất cả bộ lọc
                    </a>
                </div>
                
            </div>
            
            <!-- Products Grid -->
            <div class="col-lg-9">
                <!-- Sorting Options -->
                <div class="sorting-container">
                    <div class="results-count">
                        <c:choose>
                            <c:when test="${empty books}">
                                Không tìm thấy sách nào
                            </c:when>
                            <c:otherwise>
                                Hiển thị ${startIndex} - ${endIndex} của ${totalBooks} sách
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="sorting-options">
                        <span class="sort-by-label">Sắp xếp theo:</span>
                        <select class="form-select form-select-sm sort-select">
                            <option value="newest" ${empty param.sort || param.sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                            <option value="price-asc" ${param.sort == 'price-asc' ? 'selected' : ''}>Giá tăng dần</option>
                            <option value="price-desc" ${param.sort == 'price-desc' ? 'selected' : ''}>Giá giảm dần</option>
                            <option value="rating" ${param.sort == 'rating' ? 'selected' : ''}>Đánh giá</option>
                            <option value="bestseller" ${param.sort == 'bestseller' ? 'selected' : ''}>Bán chạy</option>
                        </select>
                    </div>
                </div>
                
                <!-- Products Grid -->
                <div class="products-list row">
                    <c:forEach var="book" items="${books}">
                        <div class="col-lg-4 col-md-6 mb-4">
                            <div class="card h-100">
                                <!-- Category Badge -->
                                <span class="category-badge">${book.categoryName}</span>
                                
                                <!-- Stock Status -->
                                <c:choose>
                                    <c:when test="${book.stockQuantity > 10}">
                                        <span class="stock-status in-stock">Còn hàng</span>
                                    </c:when>
                                    <c:when test="${book.stockQuantity > 0 && book.stockQuantity <= 10}">
                                        <span class="stock-status low-stock">Sắp hết</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="stock-status out-of-stock">Hết hàng</span>
                                    </c:otherwise>
                                </c:choose>
                                
                                <div class="card-img-container">
                                    <img src="${book.imageUrl}" class="card-img-top" alt="${book.title}">
                                </div>
                                <div class="card-body">
                                    <h5 class="card-title">${book.title}</h5>
                                    <p class="card-author">${book.authorName}</p>
                                    <div class="d-flex align-items-center mb-2">
                                        <div class="me-2">
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${i <= book.avgRating}">
                                                        <i class="fas fa-star text-warning"></i>
                                                    </c:when>
                                                    <c:when test="${i <= book.avgRating + 0.5}">
                                                        <i class="fas fa-star-half-alt text-warning"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="far fa-star text-warning"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                        <small class="text-muted">(${book.reviewCount})</small>
                                    </div>
                                    <p class="card-price"><fmt:formatNumber value="${book.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></p>
                                    <div class="d-flex gap-2">
                                        <a href="${pageContext.request.contextPath}/book-detail?id=${book.bookId}" class="btn btn-outline-primary flex-grow-1">Chi tiết</a>
                                        <!-- <c:if test="${book.stockQuantity > 0}">
                                            <button type="button" class="btn btn-primary btn-add-to-cart" data-book-id="${book.bookId}" data-quantity="1">
                                                <i class="fas fa-cart-plus"></i>
                                            </button>
                                        </c:if> -->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/shop?page=${currentPage - 1}${not empty param.category ? '&category='.concat(param.category) : ''}${not empty param.keyword ? '&keyword='.concat(param.keyword) : ''}${not empty param.sort ? '&sort='.concat(param.sort) : ''}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/shop?page=${i}${not empty param.category ? '&category='.concat(param.category) : ''}${not empty param.keyword ? '&keyword='.concat(param.keyword) : ''}${not empty param.sort ? '&sort='.concat(param.sort) : ''}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/shop?page=${currentPage + 1}${not empty param.category ? '&category='.concat(param.category) : ''}${not empty param.keyword ? '&keyword='.concat(param.keyword) : ''}${not empty param.sort ? '&sort='.concat(param.sort) : ''}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>
    
    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/user/includes/footer.jsp" />
    
    <!-- Login Modal -->
    <jsp:include page="/WEB-INF/views/user/includes/login-modal.jsp" />
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script src="${pageContext.request.contextPath}/js/user/shop.js"></script>
</body>
</html> 