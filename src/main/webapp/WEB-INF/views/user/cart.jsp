<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - Nhà Sách Online</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/pages/user/cart.css" rel="stylesheet">
</head>
<body>
    <!-- Header -->
    <jsp:include page="/WEB-INF/views/user/includes/header.jsp" />

    <!-- Page Title -->
    <section class="page-title">
        <div class="container">
            <h1 class="text-center">Giỏ hàng</h1>
            <p class="text-center mb-0">Xem lại các sản phẩm bạn đã chọn</p>
        </div>
    </section>

    <!-- Cart Section -->
    <section class="container mb-5">
        <div class="row">
            <div class="col-lg-8">
                <div class="cart-container">
                    <div class="cart-header">
                        <h2 class="mb-0">Chi tiết giỏ hàng</h2>
                    </div>
                    
                    <c:if test="${empty cart}">
                        <div class="empty-cart">
                            <i class="fas fa-shopping-cart empty-cart-icon"></i>
                            <h3>Giỏ hàng trống</h3>
                            <p>Bạn chưa có sản phẩm nào trong giỏ hàng.</p>
                            <a href="${pageContext.request.contextPath}/shop" class="btn btn-primary mt-3">Tiếp tục mua sắm</a>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty cart}">
                        <div class="cart-items">
                            <c:forEach var="item" items="${cart}">
                                <div class="cart-item">
                                    <img src="${item.book.imageUrl}" alt="${item.book.title}" class="item-image">
                                    <div class="item-details">
                                        <h5 class="item-title">${item.book.title}</h5>
                                        <p class="item-author">${item.book.authorName}</p>
                                        <p class="item-price"><fmt:formatNumber value="${item.book.price}" type="currency" currencySymbol="" /> ₫</p>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/cart/update" method="post" class="d-flex align-items-center">
                                        <input type="hidden" name="bookId" value="${item.book.bookId}">
                                        <div class="quantity-control">
                                            <button type="button" class="quantity-btn decrease-btn" data-id="${item.book.bookId}">-</button>
                                            <input type="number" name="quantity" min="1" max="${item.book.stockQuantity}" value="${item.quantity}" class="quantity-input" data-id="${item.book.bookId}">
                                            <button type="button" class="quantity-btn increase-btn" data-id="${item.book.bookId}">+</button>
                                        </div>
                                        <div class="item-subtotal">
                                            <fmt:formatNumber value="${item.book.price * item.quantity}" type="currency" currencySymbol="" /> ₫
                                        </div>
                                        <button type="submit" class="btn btn-sm btn-outline-primary me-2">
                                            <i class="fas fa-sync-alt"></i>
                                        </button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/cart/remove" method="post">
                                        <input type="hidden" name="bookId" value="${item.book.bookId}">
                                        <button type="submit" class="remove-btn">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </form>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <div class="d-flex justify-content-between align-items-center mt-4">
                            <a href="${pageContext.request.contextPath}/shop" class="btn btn-outline-primary">
                                <i class="fas fa-arrow-left me-2"></i> Tiếp tục mua sắm
                            </a>
                            <form action="${pageContext.request.contextPath}/cart/clear" method="post">
                                <button type="submit" class="btn btn-outline-danger">
                                    <i class="fas fa-trash me-2"></i> Xóa giỏ hàng
                                </button>
                            </form>
                        </div>
                    </c:if>
                </div>
            </div>
            
            <div class="col-lg-4">
                <div class="cart-summary">
                    <h3 class="summary-title">Tóm tắt đơn hàng</h3>
                    
                    <div class="summary-item">
                        <span>Tổng số sản phẩm:</span>
                        <span class="summary-value">${empty cartSummary ? 0 : cartSummary.itemCount}</span>
                    </div>
                    
                    <div class="summary-item">
                        <span>Tạm tính:</span>
                        <span class="summary-value"><fmt:formatNumber value="${empty cartSummary ? 0 : cartSummary.subtotal}" type="currency" currencySymbol="" /> ₫</span>
                    </div>
                    
                    <div class="summary-item">
                        <span>Phí vận chuyển:</span>
                        <span class="summary-value"><fmt:formatNumber value="${empty cartSummary ? 0 : cartSummary.shippingFee}" type="currency" currencySymbol="" /> ₫</span>
                    </div>
                    
                    <div class="summary-item">
                        <span>Giảm giá:</span>
                        <span class="summary-value">-<fmt:formatNumber value="${empty cartSummary ? 0 : cartSummary.discount}" type="currency" currencySymbol="" /> ₫</span>
                    </div>
                    
                    <div class="summary-item total">
                        <span>Tổng cộng:</span>
                        <span class="summary-value"><fmt:formatNumber value="${empty cartSummary ? 0 : cartSummary.total}" type="currency" currencySymbol="" /> ₫</span>
                    </div>
                    
                    <div class="coupon-section mt-3">
                        <label for="couponCode" class="form-label">Mã giảm giá</label>
                        <form action="${pageContext.request.contextPath}/cart/apply-coupon" method="post" class="coupon-form">
                            <input type="text" class="form-control coupon-input" id="couponCode" name="couponCode" placeholder="Nhập mã giảm giá">
                            <button type="submit" class="btn btn-outline-primary">Áp dụng</button>
                        </form>
                    </div>
                    
                    <c:choose>
                        <c:when test="${empty cart || cart.size() == 0}">
                            <button class="btn btn-primary checkout-btn" disabled>
                                Thanh toán
                            </button>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary checkout-btn">
                                Tiến hành thanh toán
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/user/includes/footer.jsp" />
    
    <!-- Login Modal -->
    <jsp:include page="/WEB-INF/views/user/includes/login-modal.jsp" />

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JS -->
    <script>
        // Quantity control
        document.addEventListener('DOMContentLoaded', function() {
            const decreaseBtns = document.querySelectorAll('.decrease-btn');
            const increaseBtns = document.querySelectorAll('.increase-btn');
            const quantityInputs = document.querySelectorAll('.quantity-input');
            
            decreaseBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const id = this.getAttribute('data-id');
                    const input = document.querySelector(`.quantity-input[data-id="${id}"]`);
                    let value = parseInt(input.value, 10);
                    if (value > 1) {
                        value--;
                        input.value = value;
                        // Tự động submit form khi thay đổi số lượng
                        this.closest('form').submit();
                    }
                });
            });
            
            increaseBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const id = this.getAttribute('data-id');
                    const input = document.querySelector(`.quantity-input[data-id="${id}"]`);
                    let value = parseInt(input.value, 10);
                    const max = parseInt(input.getAttribute('max'), 10);
                    if (value < max) {
                        value++;
                        input.value = value;
                        // Tự động submit form khi thay đổi số lượng
                        this.closest('form').submit();
                    }
                });
            });
            
            quantityInputs.forEach(input => {
                input.addEventListener('change', function() {
                    let value = parseInt(this.value, 10);
                    const max = parseInt(this.getAttribute('max'), 10);
                    if (value < 1) {
                        this.value = 1;
                    } else if (value > max) {
                        this.value = max;
                    }
                    // Tự động submit form khi thay đổi số lượng
                    this.closest('form').submit();
                });
            });
        });
    </script>
</body>
</html> 