<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                        <form action="${pageContext.request.contextPath}/shop" method="get">
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
                        <c:forEach var="category" items="${categories}">
                            <div class="form-check">
                                <input class="form-check-input category-filter" type="checkbox" value="${category.categoryId}" id="category${category.categoryId}"
                                    ${param.category == category.categoryId ? 'checked' : ''}>
                                <label class="form-check-label" for="category${category.categoryId}">
                                    ${category.name} (${category.bookCount})
                                </label>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                
                <!-- Price Range Filter -->
                <div class="filter-card">
                    <h4 class="filter-title">Khoảng giá</h4>
                    <div class="filter-section">
                        <input type="range" class="form-range" min="0" max="1000000" step="10000" id="priceRange">
                        <div class="price-values">
                            <span id="minPrice">0₫</span>
                            <span id="maxPrice">1.000.000₫</span>
                        </div>
                        <button class="btn btn-primary btn-sm w-100 mt-2">Áp dụng</button>
                    </div>
                </div>
                
                <!-- Author Filter -->
                <div class="filter-card">
                    <h4 class="filter-title">Tác giả</h4>
                    <div class="filter-section">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="" id="author1">
                            <label class="form-check-label" for="author1">
                                Nguyễn Nhật Ánh
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="" id="author2">
                            <label class="form-check-label" for="author2">
                                Tô Hoài
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="" id="author3">
                            <label class="form-check-label" for="author3">
                                J.K. Rowling
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="" id="author4">
                            <label class="form-check-label" for="author4">
                                Dale Carnegie
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="" id="author5">
                            <label class="form-check-label" for="author5">
                                Paulo Coelho
                            </label>
                        </div>
                    </div>
                </div>
                
                <!-- Rating Filter -->
                <div class="filter-card">
                    <h4 class="filter-title">Đánh giá</h4>
                    <div class="filter-section">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="rating" id="rating5">
                            <label class="form-check-label" for="rating5">
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="rating" id="rating4">
                            <label class="form-check-label" for="rating4">
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="far fa-star text-warning"></i>
                                & trở lên
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="rating" id="rating3">
                            <label class="form-check-label" for="rating3">
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="far fa-star text-warning"></i>
                                <i class="far fa-star text-warning"></i>
                                & trở lên
                            </label>
                        </div>
                    </div>
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
                                Hiển thị ${(currentPage-1)*booksPerPage + 1} - ${Math.min(currentPage*booksPerPage, totalBooks)} của ${totalBooks} sách
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
                <div class="row">
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
                                        <c:if test="${book.stockQuantity > 0}">
                                            <a href="${pageContext.request.contextPath}/cart/add?bookId=${book.bookId}&quantity=1" class="btn btn-primary"><i class="fas fa-cart-plus"></i></a>
                                        </c:if>
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
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script>
        // Handle category filter checkboxes
        document.querySelectorAll('.category-filter').forEach(checkbox => {
            checkbox.addEventListener('change', function() {
                // Uncheck other category filters
                document.querySelectorAll('.category-filter').forEach(cb => {
                    if (cb !== this) cb.checked = false;
                });
                
                // Redirect to the same page with the selected category
                if (this.checked) {
                    window.location.href = '${pageContext.request.contextPath}/shop?category=' + this.value;
                } else {
                    window.location.href = '${pageContext.request.contextPath}/shop';
                }
            });
        });
        
        // Handle sort select dropdown
        document.querySelector('.sort-select').addEventListener('change', function() {
            const currentUrl = new URL(window.location.href);
            currentUrl.searchParams.set('sort', this.value);
            window.location.href = currentUrl.toString();
        });
        
        // Handle price range
        const priceRange = document.getElementById('priceRange');
        const minPrice = document.getElementById('minPrice');
        const maxPrice = document.getElementById('maxPrice');
        
        if (priceRange) {
            priceRange.addEventListener('input', function() {
                const value = this.value;
                minPrice.textContent = '0₫';
                maxPrice.textContent = new Intl.NumberFormat('vi-VN').format(value) + '₫';
            });
        }
    </script>
</body>
</html> 