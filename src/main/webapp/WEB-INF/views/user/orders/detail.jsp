<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng - Nhà Sách Online</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Main CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <!-- Page-specific CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/user/order-detail.css">
</head>
<body>
    <!-- Header -->
    <jsp:include page="/WEB-INF/views/user/includes/header.jsp" />

    <!-- Page Title -->
    <section class="page-title">
        <div class="container">
            <h1 class="text-center">Chi tiết đơn hàng</h1>
            <p class="text-center mb-0">Thông tin chi tiết đơn hàng #${order.code}</p>
        </div>
    </section>

    <!-- Order Detail Section -->
    <section class="container mb-5">
        <div class="order-detail-container">
            <!-- Order Header -->
            <div class="order-header">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h3 class="order-id">Đơn hàng #${order.code}</h3>
                        <p class="order-date">Đặt ngày: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" /></p>
                    </div>
                    <div class="col-md-6 text-md-end">
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
                        <c:if test="${order.status == 'pending'}">
                            <form action="${pageContext.request.contextPath}/orders/cancel" method="post" class="d-inline mt-2">
                                <input type="hidden" name="orderId" value="${order.id}">
                                <button type="submit" class="btn btn-outline-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này?')">
                                    <i class="fas fa-times me-1"></i> Hủy đơn hàng
                                </button>
                            </form>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Order Progress -->
            <c:if test="${order.status != 'cancelled'}">
                <div class="order-progress">
                    <div class="progress-track">
                        <div class="progress-step ${order.status == 'pending' || order.status == 'processing' || order.status == 'shipped' || order.status == 'delivered' ? 'active' : ''}">
                            <span class="progress-icon">
                                <i class="fas fa-check-circle"></i>
                            </span>
                            <div class="progress-text">Đã đặt hàng</div>
                            <div class="progress-date"><fmt:formatDate value="${order.orderDate}" pattern="dd/MM" /></div>
                        </div>
                        <div class="progress-step ${order.status == 'processing' || order.status == 'shipped' || order.status == 'delivered' ? 'active' : ''}">
                            <span class="progress-icon">
                                <i class="fas fa-box"></i>
                            </span>
                            <div class="progress-text">Đang xử lý</div>
                            <c:if test="${not empty order.processingDate}">
                                <div class="progress-date"><fmt:formatDate value="${order.processingDate}" pattern="dd/MM" /></div>
                            </c:if>
                        </div>
                        <div class="progress-step ${order.status == 'shipped' || order.status == 'delivered' ? 'active' : ''}">
                            <span class="progress-icon">
                                <i class="fas fa-truck"></i>
                            </span>
                            <div class="progress-text">Đang giao hàng</div>
                            <c:if test="${not empty order.shippedDate}">
                                <div class="progress-date"><fmt:formatDate value="${order.shippedDate}" pattern="dd/MM" /></div>
                            </c:if>
                        </div>
                        <div class="progress-step ${order.status == 'delivered' ? 'active' : ''}">
                            <span class="progress-icon">
                                <i class="fas fa-home"></i>
                            </span>
                            <div class="progress-text">Đã giao hàng</div>
                            <c:if test="${not empty order.deliveredDate}">
                                <div class="progress-date"><fmt:formatDate value="${order.deliveredDate}" pattern="dd/MM" /></div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Order Information -->
            <div class="order-info">
                <div class="row">
                    <div class="col-md-6">
                        <div class="info-card">
                            <h5 class="info-title">Thông tin giao hàng</h5>
                            <p><strong>Người nhận:</strong> ${order.recipientName}</p>
                            <p><strong>Số điện thoại:</strong> ${order.recipientPhone}</p>
                            <p><strong>Địa chỉ:</strong> ${order.shippingAddress}</p>
                            <p><strong>Email:</strong> ${order.recipientEmail}</p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-card">
                            <h5 class="info-title">Thông tin thanh toán</h5>
                            <p><strong>Phương thức thanh toán:</strong> ${order.paymentMethod}</p>
                            <p><strong>Trạng thái thanh toán:</strong> ${order.paymentStatus}</p>
                            <c:if test="${not empty order.paymentDate}">
                                <p><strong>Ngày thanh toán:</strong> <fmt:formatDate value="${order.paymentDate}" pattern="dd/MM/yyyy" /></p>
                            </c:if>
                            <c:if test="${order.status == 'shipped'}">
                                <p><strong>Mã vận đơn:</strong> ${order.trackingCode}</p>
                                <p><strong>Đơn vị vận chuyển:</strong> ${order.shippingProvider}</p>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Order Items -->
            <div class="order-items">
                <h5 class="items-title">Sản phẩm đã đặt</h5>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Giá</th>
                                <th>Số lượng</th>
                                <th class="text-end">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${order.orderItems}">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${item.book.imageUrl}" alt="${item.book.title}" class="item-image">
                                            <div class="item-info">
                                                <h6 class="item-title">${item.book.title}</h6>
                                                <p class="item-author">${item.book.authorName}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="" /> ₫</td>
                                    <td>${item.quantity}</td>
                                    <td class="text-end"><fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencySymbol="" /> ₫</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Order Summary -->
            <div class="order-summary">
                <div class="summary-row">
                    <span>Tạm tính:</span>
                    <span><fmt:formatNumber value="${order.subtotal}" type="currency" currencySymbol="" /> ₫</span>
                </div>
                <div class="summary-row">
                    <span>Phí vận chuyển:</span>
                    <span><fmt:formatNumber value="${order.shippingFee}" type="currency" currencySymbol="" /> ₫</span>
                </div>
                <c:if test="${order.discount > 0}">
                    <div class="summary-row">
                        <span>Giảm giá:</span>
                        <span>-<fmt:formatNumber value="${order.discount}" type="currency" currencySymbol="" /> ₫</span>
                    </div>
                </c:if>
                <div class="summary-row total">
                    <span>Tổng cộng:</span>
                    <span><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="" /> ₫</span>
                </div>
            </div>

            <!-- Actions -->
            <div class="order-actions">
                <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-primary">
                    <i class="fas fa-arrow-left me-2"></i> Quay lại danh sách đơn hàng
                </a>
                
                <div>
                    <c:if test="${order.status == 'delivered'}">
                        <a href="${pageContext.request.contextPath}/orders/review?id=${order.id}" class="btn btn-outline-secondary">
                            <i class="fas fa-star me-2"></i> Đánh giá sản phẩm
                        </a>
                    </c:if>
                    
                    <c:if test="${order.status == 'delivered' || order.status == 'cancelled'}">
                        <a href="${pageContext.request.contextPath}/orders/reorder?id=${order.id}" class="btn btn-primary">
                            <i class="fas fa-redo me-2"></i> Đặt lại đơn hàng
                        </a>
                    </c:if>
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