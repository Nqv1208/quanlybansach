<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt hàng thành công - Nhà Sách Online</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Main CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <!-- Page-specific CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/user/checkout.css">
</head>
<body>
    <!-- Header -->
    <jsp:include page="/WEB-INF/views/user/includes/header.jsp" />

    <!-- Page Title -->
    <section class="page-title">
        <div class="container">
            <h1 class="text-center">Đặt hàng thành công</h1>
            <p class="text-center mb-0">Cảm ơn bạn đã mua sắm tại Nhà Sách Online</p>
        </div>
    </section>

    <!-- Checkout Steps -->
    <div class="container mb-4">
        <div class="checkout-steps">
            <div class="step completed">
                <div class="step-icon">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <p class="step-title">Giỏ hàng</p>
            </div>
            <div class="step completed">
                <div class="step-icon">
                    <i class="fas fa-address-card"></i>
                </div>
                <p class="step-title">Thông tin</p>
            </div>
            <div class="step completed">
                <div class="step-icon">
                    <i class="fas fa-credit-card"></i>
                </div>
                <p class="step-title">Thanh toán</p>
            </div>
            <div class="step completed">
                <div class="step-icon">
                    <i class="fas fa-check"></i>
                </div>
                <p class="step-title">Hoàn tất</p>
            </div>
        </div>
    </div>

    <!-- Confirmation Section -->
    <section class="container mb-5">
        <div class="confirmation-container">
            <div class="confirmation-header">
                <i class="fas fa-check-circle confirmation-icon"></i>
                <h2 class="confirmation-title">Đặt hàng thành công!</h2>
                <p class="confirmation-message">Cảm ơn bạn đã đặt hàng. Đơn hàng của bạn đã được xử lý và sẽ được giao trong thời gian sớm nhất.</p>
            </div>
            
            <div class="row">
                <div class="col-md-6">
                    <div class="order-details">
                        <h3 class="order-info-title">Thông tin đơn hàng</h3>
                        <ul class="order-info-list">
                            <li class="order-info-item">
                                <span class="order-info-label">Mã đơn hàng:</span>
                                <span class="order-info-value">#${order.code}</span>
                            </li>
                            <li class="order-info-item">
                                <span class="order-info-label">Ngày đặt hàng:</span>
                                <span class="order-info-value"><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" /></span>
                            </li>
                            <li class="order-info-item">
                                <span class="order-info-label">Tổng tiền:</span>
                                <span class="order-info-value"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="" /> ₫</span>
                            </li>
                            <li class="order-info-item">
                                <span class="order-info-label">Phương thức thanh toán:</span>
                                <span class="order-info-value">
                                    <c:choose>
                                        <c:when test="${order.paymentMethod == 'cod'}">Thanh toán khi nhận hàng</c:when>
                                        <c:when test="${order.paymentMethod == 'bank-transfer'}">Chuyển khoản ngân hàng</c:when>
                                        <c:when test="${order.paymentMethod == 'momo'}">Ví MoMo</c:when>
                                        <c:when test="${order.paymentMethod == 'credit-card'}">Thẻ tín dụng/ghi nợ</c:when>
                                        <c:otherwise>${order.paymentMethod}</c:otherwise>
                                    </c:choose>
                                </span>
                            </li>
                            <li class="order-info-item">
                                <span class="order-info-label">Trạng thái đơn hàng:</span>
                                <span class="order-info-value badge bg-primary">Đã xác nhận</span>
                            </li>
                            <li class="order-info-item">
                                <span class="order-info-label">Mã vận đơn:</span>
                                <span class="order-info-value tracking-code">${order.trackingCode}</span>
                            </li>
                        </ul>
                    </div>
                </div>
                
                <div class="col-md-6">
                    <div class="order-details">
                        <h3 class="order-info-title">Thông tin giao hàng</h3>
                        <ul class="order-info-list">
                            <li class="order-info-item">
                                <span class="order-info-label">Họ tên:</span>
                                <span class="order-info-value">${order.shippingAddress.fullName}</span>
                            </li>
                            <li class="order-info-item">
                                <span class="order-info-label">Điện thoại:</span>
                                <span class="order-info-value">${order.shippingAddress.phone}</span>
                            </li>
                            <li class="order-info-item">
                                <span class="order-info-label">Email:</span>
                                <span class="order-info-value">${order.shippingAddress.email}</span>
                            </li>
                            <li class="order-info-item">
                                <span class="order-info-label">Địa chỉ:</span>
                                <span class="order-info-value">${order.shippingAddress.address}, ${order.shippingAddress.ward}, ${order.shippingAddress.district}, ${order.shippingAddress.provinceText}</span>
                            </li>
                            <li class="order-info-item">
                                <span class="order-info-label">Phương thức vận chuyển:</span>
                                <span class="order-info-value">
                                    <c:choose>
                                        <c:when test="${order.shippingMethod == 'standard'}">Giao hàng tiêu chuẩn (2-3 ngày)</c:when>
                                        <c:when test="${order.shippingMethod == 'fast'}">Giao hàng nhanh (1-2 ngày)</c:when>
                                        <c:when test="${order.shippingMethod == 'express'}">Giao hàng hỏa tốc (trong ngày)</c:when>
                                        <c:otherwise>${order.shippingMethod}</c:otherwise>
                                    </c:choose>
                                </span>
                            </li>
                            <li class="order-info-item">
                                <span class="order-info-label">Ngày giao hàng dự kiến:</span>
                                <span class="order-info-value"><fmt:formatDate value="${order.estimatedDeliveryDate}" pattern="dd/MM/yyyy" /></span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            
            <div class="order-items">
                <h3 class="order-info-title">Chi tiết đơn hàng</h3>
                
                <c:forEach var="item" items="${order.orderItems}">
                    <div class="order-item">
                        <img src="${item.book.imageUrl}" alt="${item.book.title}" class="item-image">
                        <div class="item-details">
                            <h5 class="item-title">${item.book.title}</h5>
                            <p class="item-author">${item.book.author}</p>
                            <div class="d-flex justify-content-between">
                                <p class="item-price"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="" /> ₫</p>
                                <p class="item-quantity">x${item.quantity}</p>
                            </div>
                        </div>
                        <div class="item-subtotal">
                            <fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencySymbol="" /> ₫
                        </div>
                    </div>
                </c:forEach>
                
                <table class="summary-table">
                    <tr>
                        <td>Tạm tính:</td>
                        <td class="price-column"><fmt:formatNumber value="${order.subtotal}" type="currency" currencySymbol="" /> ₫</td>
                    </tr>
                    <tr>
                        <td>Phí vận chuyển:</td>
                        <td class="price-column"><fmt:formatNumber value="${order.shippingFee}" type="currency" currencySymbol="" /> ₫</td>
                    </tr>
                    <tr>
                        <td>Giảm giá:</td>
                        <td class="price-column">-<fmt:formatNumber value="${order.discount}" type="currency" currencySymbol="" /> ₫</td>
                    </tr>
                    <tr class="total-row">
                        <td>Tổng cộng:</td>
                        <td class="price-column"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="" /> ₫</td>
                    </tr>
                </table>
            </div>
            
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/user/orders" class="btn btn-primary">
                    <i class="fas fa-list me-2"></i> Xem đơn hàng của tôi
                </a>
                <a href="${pageContext.request.contextPath}/user/shop" class="btn btn-outline-primary">
                    <i class="fas fa-shopping-cart me-2"></i> Tiếp tục mua sắm
                </a>
                <a href="#" class="btn btn-outline-secondary" onclick="window.print()">
                    <i class="fas fa-print me-2"></i> In đơn hàng
                </a>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/user/includes/footer.jsp" />

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JS -->
    <script>
        // Add any custom scripts here
    </script>
</body>
</html> 