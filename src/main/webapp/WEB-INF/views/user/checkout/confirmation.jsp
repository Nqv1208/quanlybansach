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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/user/confirmation.css">
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

    <div class="container mb-5">
        <div class="checkout-steps d-flex justify-content-between py-4">
            <div class="step d-flex flex-column align-items-center">
                <div class="step-icon rounded-circle d-flex justify-content-center align-items-center bg-primary text-white">
                    <i class="fas fa-shopping-cart fs-5"></i>
                </div>
                <p class="step-title mt-3 mb-0 text-success fw-medium">Giỏ hàng</p>
            </div>
            <div class="progress-line flex-grow-1 mx-3 my-auto" style="height: 4px; background-color: #ddd;">
                <div class="progress-fill bg-primary" style="width: 100%; height: 100%;"></div>
            </div>
            <div class="step d-flex flex-column align-items-center">
                <div class="step-icon rounded-circle d-flex justify-content-center align-items-center bg-primary text-white">
                    <i class="fas fa-address-card fs-5"></i>
                </div>
                <p class="step-title mt-3 mb-0 text-primary fw-medium">Thông tin</p>
            </div>
            <div class="progress-line flex-grow-1 mx-3 my-auto" style="height: 4px; background-color: #ddd;">
                <div class="progress-fill bg-primary" style="width: 100%; height: 100%;"></div>
            </div>
            <div class="step d-flex flex-column align-items-center">
                <div class="step-icon rounded-circle d-flex justify-content-center align-items-center bg-primary text-white">
                    <i class="fas fa-credit-card fs-5"></i>
                </div>
                <p class="step-title mt-3 mb-0 text-secondary fw-medium">Thanh toán</p>
            </div>
            <div class="progress-line flex-grow-1 mx-3 my-auto" style="height: 4px; background-color: #ddd;">
                <div class="progress-fill bg-primary" style="width: 100%; height: 100%;"></div>
            </div>
            <div class="step d-flex flex-column align-items-center">
                <div class="step-icon rounded-circle d-flex justify-content-center align-items-center" style="background-color: #e9ecef;">
                    <i class="fas fa-check fs-5"></i>
                </div>
                <p class="step-title mt-3 mb-0 text-secondary fw-medium">Hoàn tất</p>
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
            
            <div class="row g-4">
                <div class="col-lg-6">
                    <div class="order-details h-100">
                        <h3 class="order-info-title">
                            <i class="fas fa-file-invoice me-2"></i>Thông tin đơn hàng
                        </h3>
                        <ul class="order-info-list">
                            <li class="order-info-item">
                                <span class="order-info-label">Mã đơn hàng:</span>
                                <span class="order-info-value fw-bold">#${order.orderId}</span>
                            </li>
                            <li class="order-info-item">
                                <span class="order-info-label">Ngày đặt hàng:</span>
                                <span class="order-info-value"><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" /></span>
                            </li>
                            <li class="order-info-item">
                                <span class="order-info-label">Tổng tiền:</span>
                                <span class="order-info-value text-primary fw-bold"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="" /> ₫</span>
                            </li>
                            <li class="order-info-item">
                                <span class="order-info-label">Phương thức thanh toán:</span>
                                <span class="order-info-value">
                                    <c:choose>
                                        <c:when test="${order.paymentMethod == 'cod'}">
                                            <i class="fas fa-money-bill-wave me-1 text-success"></i> Thanh toán khi nhận hàng
                                        </c:when>
                                        <c:when test="${order.paymentMethod == 'bank-transfer'}">
                                            <i class="fas fa-university me-1 text-primary"></i> Chuyển khoản ngân hàng
                                        </c:when>
                                        <c:when test="${order.paymentMethod == 'momo'}">
                                            <i class="fas fa-wallet me-1 text-danger"></i> Ví MoMo
                                        </c:when>
                                        <c:when test="${order.paymentMethod == 'credit-card'}">
                                            <i class="fas fa-credit-card me-1 text-info"></i> Thẻ tín dụng/ghi nợ
                                        </c:when>
                                        <c:otherwise>${order.paymentMethod}</c:otherwise>
                                    </c:choose>
                                </span>
                            </li>
                            <li class="order-info-item">
                                <span class="order-info-label">Trạng thái đơn hàng:</span>
                                <span class="order-info-value badge bg-success">Đã xác nhận</span>
                            </li>
                        </ul>
                    </div>
                </div>
                
                <div class="col-lg-6">
                    <div class="order-details h-100">
                        <h3 class="order-info-title">
                            <i class="fas fa-shipping-fast me-2"></i>Thông tin giao hàng
                        </h3>
                        <ul class="order-info-list">
                            <li class="order-info-item">
                                <span class="order-info-label">Họ tên:</span>
                                <span class="order-info-value fw-bold">${shippingAddress.fullName}</span>
                            </li>
                            <li class="order-info-item">
                                <span class="order-info-label">Điện thoại:</span>
                                <span class="order-info-value">
                                    <i class="fas fa-phone-alt me-1 text-primary"></i> ${shippingAddress.phone}
                                </span>
                            </li>
                            <li class="order-info-item">
                                <span class="order-info-label">Email:</span>
                                <span class="order-info-value">
                                    <i class="fas fa-envelope me-1 text-primary"></i> ${shippingAddress.email}
                                </span>
                            </li>
                            <li class="order-info-item">
                                <span class="order-info-label">Địa chỉ:</span>
                                <span class="order-info-value">
                                    <i class="fas fa-map-marker-alt me-1 text-danger"></i> ${shippingAddress.address}, ${shippingAddress.ward}, ${shippingAddress.district}, ${shippingAddress.provinceText}
                                </span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            
            <div class="order-items mt-4">
                <h3 class="order-info-title">
                    <i class="fas fa-shopping-basket me-2"></i>Chi tiết đơn hàng
                </h3>
                
                <c:forEach var="item" items="${order.orderDetails}" varStatus="status">
                    <div class="order-item ${status.last ? '' : 'border-bottom'}">
                        <div class="item-details">
                            <img src="${item.imageUrl}" alt="${item.bookTitle}" class="item-image">
                            <div>
                                <h5 class="item-title">${item.bookTitle}</h5>
                                <div class="d-flex align-items-center">
                                    <span class="item-quantity">Số lượng: ${item.quantity}</span>
                                </div>
                            </div>
                        </div>
                        <div class="item-subtotal">
                            <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="" /> ₫
                        </div>
                    </div>
                </c:forEach>
                
                <table class="summary-table">
                    <tr>
                        <td>Tạm tính:</td>
                        <td class="price-column"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="" /> ₫</td>
                    </tr>
                    <tr>
                        <td>Phí vận chuyển:</td>
                        <td class="price-column"><fmt:formatNumber value="0" type="currency" currencySymbol="" /> ₫</td>
                    </tr>
                    <tr>
                        <td>Giảm giá:</td>
                        <td class="price-column">-<fmt:formatNumber value="0" type="currency" currencySymbol="" /> ₫</td>
                    </tr>
                    <tr class="total-row">
                        <td>Tổng cộng:</td>
                        <td class="price-column"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="" /> ₫</td>
                    </tr>
                </table>
            </div>
            
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/orders" class="btn btn-primary">
                    <i class="fas fa-list me-2"></i> Xem đơn hàng của tôi
                </a>
                <a href="${pageContext.request.contextPath}/shop" class="btn btn-outline-primary">
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
        // Animation for the confirmation section
        document.addEventListener('DOMContentLoaded', function() {
            const container = document.querySelector('.confirmation-container');
            setTimeout(() => {
                container.style.opacity = '0';
                container.style.transform = 'translateY(20px)';
                setTimeout(() => {
                    container.style.transition = 'all 0.5s ease';
                    container.style.opacity = '1';
                    container.style.transform = 'translateY(0)';
                }, 100);
            }, 200);
        });
    </script>
</body>
</html> 