<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng #${order.code} - Nhà Sách Online</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Main CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <!-- Page-specific CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/user/orders.css">
</head>
<body>
    <!-- Header -->
    <jsp:include page="/WEB-INF/views/user/includes/header.jsp" />

    <!-- Page Title -->
    <section class="page-title">
        <div class="container">
            <h1 class="text-center">Chi tiết đơn hàng</h1>
            <p class="text-center mb-0">Mã đơn hàng: #${order.code}</p>
        </div>
    </section>

    <!-- Order Detail Section -->
    <section class="container mb-5">
        <div class="detail-container">
            <!-- Order Progress Bar for non-cancelled orders -->
            <c:if test="${order.status != 'cancelled'}">
                <div class="progress-container">
                    <div class="progress-track"></div>
                    <c:choose>
                        <c:when test="${order.status == 'pending'}">
                            <div class="progress-fill" style="width: 25%"></div>
                        </c:when>
                        <c:when test="${order.status == 'processing'}">
                            <div class="progress-fill" style="width: 50%"></div>
                        </c:when>
                        <c:when test="${order.status == 'shipped'}">
                            <div class="progress-fill" style="width: 75%"></div>
                        </c:when>
                        <c:when test="${order.status == 'delivered'}">
                            <div class="progress-fill" style="width: 100%"></div>
                        </c:when>
                        <c:otherwise>
                            <div class="progress-fill" style="width: 0%"></div>
                        </c:otherwise>
                    </c:choose>
                    <div class="progress-steps">
                        <div class="progress-step">
                            <div class="step-icon ${order.status == 'pending' || order.status == 'processing' || order.status == 'shipped' || order.status == 'delivered' ? 'active' : ''}">
                                <i class="fas fa-check"></i>
                            </div>
                            <p class="step-title">Đặt hàng</p>
                            <p class="step-date"><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy" /></p>
                        </div>
                        <div class="progress-step">
                            <div class="step-icon ${order.status == 'processing' || order.status == 'shipped' || order.status == 'delivered' ? 'active' : ''}">
                                <i class="fas fa-box"></i>
                            </div>
                            <p class="step-title">Xử lý</p>
                            <p class="step-date"><fmt:formatDate value="${order.processingDate}" pattern="dd/MM/yyyy" /></p>
                        </div>
                        <div class="progress-step">
                            <div class="step-icon ${order.status == 'shipped' || order.status == 'delivered' ? 'active' : ''}">
                                <i class="fas fa-truck"></i>
                            </div>
                            <p class="step-title">Vận chuyển</p>
                            <p class="step-date"><fmt:formatDate value="${order.shippedDate}" pattern="dd/MM/yyyy" /></p>
                        </div>
                        <div class="progress-step">
                            <div class="step-icon ${order.status == 'delivered' ? 'active' : ''}">
                                <i class="fas fa-home"></i>
                            </div>
                            <p class="step-title">Giao hàng</p>
                            <p class="step-date"><fmt:formatDate value="${order.deliveredDate}" pattern="dd/MM/yyyy" /></p>
                        </div>
                    </div>
                </div>
            </c:if>
            
            <!-- Order Info Cards -->
            <div class="row g-4 mb-4">
                <div class="col-md-6">
                    <div class="info-card">
                        <h4 class="info-title">Thông tin đơn hàng</h4>
                        <ul class="info-list">
                            <li class="info-item">
                                <span class="info-label">Mã đơn hàng:</span>
                                <span class="info-value">#${order.code}</span>
                            </li>
                            <li class="info-item">
                                <span class="info-label">Ngày đặt hàng:</span>
                                <span class="info-value"><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" /></span>
                            </li>
                            <li class="info-item">
                                <span class="info-label">Trạng thái:</span>
                                <span class="info-value">
                                    <div class="order-status ${order.status}">
                                        <c:choose>
                                            <c:when test="${order.status == 'pending'}">Chờ xác nhận</c:when>
                                            <c:when test="${order.status == 'processing'}">Đang xử lý</c:when>
                                            <c:when test="${order.status == 'shipped'}">Đang giao hàng</c:when>
                                            <c:when test="${order.status == 'delivered'}">Đã giao hàng</c:when>
                                            <c:when test="${order.status == 'cancelled'}">Đã hủy</c:when>
                                            <c:otherwise>${order.status}</c:otherwise>
                                        </c:choose>
                                    </div>
                                </span>
                            </li>
                            <li class="info-item">
                                <span class="info-label">Phương thức thanh toán:</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${order.paymentMethod == 'cod'}">Thanh toán khi nhận hàng</c:when>
                                        <c:when test="${order.paymentMethod == 'bank-transfer'}">Chuyển khoản ngân hàng</c:when>
                                        <c:when test="${order.paymentMethod == 'momo'}">Ví MoMo</c:when>
                                        <c:when test="${order.paymentMethod == 'credit-card'}">Thẻ tín dụng/ghi nợ</c:when>
                                        <c:otherwise>${order.paymentMethod}</c:otherwise>
                                    </c:choose>
                                </span>
                            </li>
                            <c:if test="${order.status == 'shipped' || order.status == 'delivered'}">
                                <li class="info-item">
                                    <span class="info-label">Mã vận đơn:</span>
                                    <span class="info-value tracking-code">${order.trackingCode}</span>
                                </li>
                            </c:if>
                        </ul>
                    </div>
                </div>
                
                <div class="col-md-6">
                    <div class="info-card">
                        <h4 class="info-title">Thông tin giao hàng</h4>
                        <ul class="info-list">
                            <li class="info-item">
                                <span class="info-label">Họ tên:</span>
                                <span class="info-value">${order.shippingAddress.fullName}</span>
                            </li>
                            <li class="info-item">
                                <span class="info-label">Điện thoại:</span>
                                <span class="info-value">${order.shippingAddress.phone}</span>
                            </li>
                            <li class="info-item">
                                <span class="info-label">Email:</span>
                                <span class="info-value">${order.shippingAddress.email}</span>
                            </li>
                            <li class="info-item">
                                <span class="info-label">Địa chỉ:</span>
                                <span class="info-value">${order.shippingAddress.address}, ${order.shippingAddress.ward}, ${order.shippingAddress.district}, ${order.shippingAddress.provinceText}</span>
                            </li>
                            <li class="info-item">
                                <span class="info-label">Phương thức vận chuyển:</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${order.shippingMethod == 'standard'}">Giao hàng tiêu chuẩn (2-3 ngày)</c:when>
                                        <c:when test="${order.shippingMethod == 'fast'}">Giao hàng nhanh (1-2 ngày)</c:when>
                                        <c:when test="${order.shippingMethod == 'express'}">Giao hàng hỏa tốc (trong ngày)</c:when>
                                        <c:otherwise>${order.shippingMethod}</c:otherwise>
                                    </c:choose>
                                </span>
                            </li>
                            <c:if test="${order.status == 'shipped'}">
                                <li class="info-item">
                                    <span class="info-label">Dự kiến giao:</span>
                                    <span class="info-value"><fmt:formatDate value="${order.estimatedDeliveryDate}" pattern="dd/MM/yyyy" /></span>
                                </li>
                            </c:if>
                        </ul>
                    </div>
                </div>
            </div>
            
            <!-- Order Timeline -->
            <div class="timeline">
                <h4 class="section-title">Lịch sử đơn hàng</h4>
                
                <div class="timeline-item">
                    <div class="timeline-icon active">
                        <i class="fas fa-check"></i>
                    </div>
                    <div class="timeline-content">
                        <h5 class="timeline-title">Đơn hàng đã được đặt</h5>
                        <p class="timeline-date"><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" /></p>
                        <p class="timeline-description">Đơn hàng của bạn đã được tạo và đang chờ xác nhận.</p>
                    </div>
                </div>
                
                <c:if test="${order.status == 'processing' || order.status == 'shipped' || order.status == 'delivered'}">
                    <div class="timeline-item">
                        <div class="timeline-icon active">
                            <i class="fas fa-box"></i>
                        </div>
                        <div class="timeline-content">
                            <h5 class="timeline-title">Đơn hàng đang được xử lý</h5>
                            <p class="timeline-date"><fmt:formatDate value="${order.processingDate}" pattern="dd/MM/yyyy HH:mm" /></p>
                            <p class="timeline-description">Đơn hàng của bạn đã được xác nhận và đang được chuẩn bị.</p>
                        </div>
                    </div>
                </c:if>
                
                <c:if test="${order.status == 'shipped' || order.status == 'delivered'}">
                    <div class="timeline-item">
                        <div class="timeline-icon active">
                            <i class="fas fa-truck"></i>
                        </div>
                        <div class="timeline-content">
                            <h5 class="timeline-title">Đơn hàng đang được vận chuyển</h5>
                            <p class="timeline-date"><fmt:formatDate value="${order.shippedDate}" pattern="dd/MM/yyyy HH:mm" /></p>
                            <p class="timeline-description">Đơn hàng của bạn đã được giao cho đơn vị vận chuyển. Mã vận đơn: ${order.trackingCode}</p>
                        </div>
                    </div>
                </c:if>
                
                <c:if test="${order.status == 'delivered'}">
                    <div class="timeline-item">
                        <div class="timeline-icon active">
                            <i class="fas fa-home"></i>
                        </div>
                        <div class="timeline-content">
                            <h5 class="timeline-title">Đơn hàng đã giao thành công</h5>
                            <p class="timeline-date"><fmt:formatDate value="${order.deliveredDate}" pattern="dd/MM/yyyy HH:mm" /></p>
                            <p class="timeline-description">Đơn hàng của bạn đã được giao thành công. Cảm ơn bạn đã mua sắm tại Nhà Sách Online!</p>
                        </div>
                    </div>
                </c:if>
                
                <c:if test="${order.status == 'cancelled'}">
                    <div class="timeline-item">
                        <div class="timeline-icon active">
                            <i class="fas fa-times"></i>
                        </div>
                        <div class="timeline-content">
                            <h5 class="timeline-title">Đơn hàng đã bị hủy</h5>
                            <p class="timeline-date"><fmt:formatDate value="${order.cancelledDate}" pattern="dd/MM/yyyy HH:mm" /></p>
                            <p class="timeline-description">Đơn hàng của bạn đã bị hủy. ${order.cancelReason}</p>
                        </div>
                    </div>
                </c:if>
            </div>
            
            <!-- Order Items -->
            <div class="order-items">
                <h4 class="section-title">Sản phẩm</h4>
                
                <c:forEach var="item" items="${order.orderItems}">
                    <div class="order-item">
                        <img src="${item.book.imageUrl}" alt="${item.book.title}" class="item-image">
                        <div class="item-details">
                            <h5 class="item-title">${item.book.title}</h5>
                            <p class="item-author">${item.book.author}</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <p class="item-price"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="" /> ₫</p>
                                <p class="item-quantity">Số lượng: ${item.quantity}</p>
                            </div>
                        </div>
                        <div class="item-subtotal">
                            <fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencySymbol="" /> ₫
                        </div>
                    </div>
                </c:forEach>
                
                <!-- Order Summary -->
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
                    <tr>
                        <td>Tổng cộng:</td>
                        <td class="price-column"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="" /> ₫</td>
                    </tr>
                </table>
            </div>
            
            <!-- Action Buttons -->
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/user/orders" class="btn btn-outline-primary">
                    <i class="fas fa-arrow-left me-2"></i> Trở lại danh sách đơn hàng
                </a>
                
                <div>
                    <c:if test="${order.status == 'pending'}">
                        <form action="${pageContext.request.contextPath}/user/orders/cancel" method="post" class="d-inline">
                            <input type="hidden" name="orderId" value="${order.id}">
                            <button type="submit" class="btn btn-outline-danger" onclick="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này?')">
                                <i class="fas fa-times me-2"></i> Hủy đơn hàng
                            </button>
                        </form>
                    </c:if>
                    
                    <c:if test="${order.status == 'delivered'}">
                        <a href="${pageContext.request.contextPath}/user/orders/review?id=${order.id}" class="btn btn-outline-secondary">
                            <i class="fas fa-star me-2"></i> Đánh giá sản phẩm
                        </a>
                    </c:if>
                    
                    <c:if test="${order.status == 'delivered' || order.status == 'cancelled'}">
                        <a href="${pageContext.request.contextPath}/user/orders/reorder?id=${order.id}" class="btn btn-primary">
                            <i class="fas fa-redo me-2"></i> Đặt lại
                        </a>
                    </c:if>
                    
                    <a href="#" class="btn btn-outline-secondary" onclick="window.print()">
                        <i class="fas fa-print me-2"></i> In đơn hàng
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/user/includes/footer.jsp" />

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 