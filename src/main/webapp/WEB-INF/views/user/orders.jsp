<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử mua hàng - Nhà Sách Online</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- AOS Animation -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
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
            <h1 class="text-center">Lịch sử mua hàng</h1>
            <p class="text-center mb-0">Xem và quản lý các đơn hàng của bạn</p>
        </div>
    </section>

    <!-- Orders Section -->
    <section class="container mb-5">
        <div class="row">
            <!-- Sidebar Filters -->
            <div class="col-lg-3">
                <!-- Search Filter -->
                <div class="filter-card">
                    <h5 class="filter-title">Tìm kiếm</h5>
                    <form action="${pageContext.request.contextPath}/orders" method="get">
                        <div class="input-group">
                            <input type="text" class="form-control" name="keyword" placeholder="Mã đơn hàng..." value="${param.keyword}">
                            <button class="btn btn-primary" type="submit">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Status Filter -->
                <div class="filter-card">
                    <h5 class="filter-title">Trạng thái</h5>
                    <form action="${pageContext.request.contextPath}/orders" method="get" id="statusForm">
                        <div class="form-check mb-2">
                            <input class="form-check-input status-check" type="radio" name="status" value="all" id="statusAll" ${empty param.status || param.status == 'all' ? 'checked' : ''}>
                            <label class="form-check-label" for="statusAll">Tất cả</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input status-check" type="radio" name="status" value="Chờ xử lý" id="statusPending" ${param.status == 'Chờ xử lý' ? 'checked' : ''}>
                            <label class="form-check-label" for="statusPending">Chờ xử lý</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input status-check" type="radio" name="status" value="Đã xác nhận" id="statusProcessing" ${param.status == 'Đã xác nhận' ? 'checked' : ''}>
                            <label class="form-check-label" for="statusProcessing">Đã xác nhận</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input status-check" type="radio" name="status" value="Đang giao hàng" id="statusShipped" ${param.status == 'Đang giao hàng' ? 'checked' : ''}>
                            <label class="form-check-label" for="statusShipped">Đang giao hàng</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input status-check" type="radio" name="status" value="Đã giao hàng" id="statusDelivered" ${param.status == 'Đã giao hàng' ? 'checked' : ''}>
                            <label class="form-check-label" for="statusDelivered">Đã giao hàng</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input status-check" type="radio" name="status" value="Đã hủy" id="statusCancelled" ${param.status == 'Đã hủy' ? 'checked' : ''}>
                            <label class="form-check-label" for="statusCancelled">Đã hủy</label>
                        </div>
                    </form>
                </div>

                <!-- Date Filter -->
                <div class="filter-card">
                    <h5 class="filter-title">Khoảng thời gian</h5>
                    <form action="${pageContext.request.contextPath}/orders" method="get" id="dateForm">
                        <div class="mb-3">
                            <label for="startDate" class="form-label">Từ ngày</label>
                            <input type="date" class="form-control" id="startDate" name="startDate" value="${param.startDate}">
                        </div>
                        <div class="mb-3">
                            <label for="endDate" class="form-label">Đến ngày</label>
                            <input type="date" class="form-control" id="endDate" name="endDate" value="${param.endDate}">
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Áp dụng</button>
                    </form>
                </div>
            </div>

            <!-- Orders List -->
            <div class="col-lg-9">
                <div class="orders-container">
                    <h3 class="orders-title">Đơn hàng của tôi</h3>
                    
                    <c:if test="${empty orders}">
                        <div class="empty-orders">
                            <i class="fas fa-box-open empty-orders-icon"></i>
                            <h4>Không có đơn hàng nào</h4>
                            <p>Bạn chưa có đơn hàng nào hoặc không tìm thấy đơn hàng phù hợp.</p>
                            <a href="${pageContext.request.contextPath}/shop" class="btn btn-primary mt-3">Mua sắm ngay</a>
                        </div>
                    </c:if>
                    
                    <c:forEach var="order" items="${orders}" varStatus="status">
                        <div class="order-card">
                            <div class="order-header">
                                <div>
                                    <div class="order-number">Đơn hàng #${order.orderId}</div>
                                    <div class="order-date">Ngày đặt: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" /></div>
                                </div>
                                <div class="order-status ${order.status}">
                                    <c:choose>
                                        <c:when test="${order.status == 'Chờ xác nhận'}">Chờ xác nhận</c:when>
                                        <c:when test="${order.status == 'Đang xử lý'}">Đang xử lý</c:when>
                                        <c:when test="${order.status == 'Đang giao hàng'}">Đang giao hàng</c:when>
                                        <c:when test="${order.status == 'Đã giao hàng'}">Đã giao hàng</c:when>
                                        <c:when test="${order.status == 'Đã hủy'}">Đã hủy</c:when>
                                        <c:otherwise>${order.status}</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <div class="order-content">
                                <c:if test="${not empty order.orderDetails}">
                                    <c:forEach var="item" items="${order.orderDetails}" varStatus="loop">
                                        <c:if test="${loop.index < 3}">
                                            <div class="order-item">
                                                <c:if test="${not empty item.imageUrl}">
                                                    <img src="${item.imageUrl}" alt="${item.bookTitle}" class="item-image">
                                                </c:if>
                                                <c:if test="${empty item.imageUrl}">
                                                    <div class="item-image-placeholder">
                                                        <i class="fas fa-book"></i>
                                                    </div>
                                                </c:if>
                                                <div class="item-details">
                                                    <h6 class="item-title">
                                                        <c:if test="${not empty item.bookTitle}">
                                                            ${item.bookTitle}
                                                        </c:if>
                                                        <c:if test="${empty item.bookTitle}">
                                                            Sách #${item.bookId}
                                                        </c:if>
                                                    </h6>
                                                    <p class="item-quantity">SL: ${item.quantity}</p>
                                                </div>
                                                <div class="item-price">
                                                    <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="" /> ₫
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                    
                                    <c:if test="${order.orderDetails.size() > 3}">
                                        <div class="text-center mt-2">
                                            <small class="text-muted">và ${order.orderDetails.size() - 3} sản phẩm khác</small>
                                        </div>
                                    </c:if>
                                </c:if>
                                
                                <c:if test="${empty order.orderDetails}">
                                    <div class="text-center my-3">
                                        <p class="text-muted">Không có thông tin chi tiết đơn hàng</p>
                                    </div>
                                </c:if>
                                
                                <c:if test="${order.status == 'shipped'}">
                                    <div class="tracking-info">
                                        <div class="tracking-icon">
                                            <i class="fas fa-truck"></i>
                                        </div>
                                        <div class="tracking-details">
                                            <div class="tracking-status">Đang giao hàng</div>
                                            <div class="tracking-code">Mã vận đơn: ${not empty order.trackingCode ? order.trackingCode : 'Đang cập nhật'}</div>
                                        </div>
                                        <div class="tracking-date">
                                            <div>Dự kiến giao hàng:</div>
                                            <div>
                                                <c:if test="${not empty order.estimatedDeliveryDate}">
                                                    <fmt:formatDate value="${order.estimatedDeliveryDate}" pattern="dd/MM/yyyy" />
                                                </c:if>
                                                <c:if test="${empty order.estimatedDeliveryDate}">
                                                    Đang cập nhật
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                            
                            <div class="order-footer">
                                <div class="order-total">
                                    <span class="order-total-label">Tổng tiền:</span>
                                    <span class="order-total-value">
                                        <c:if test="${not empty order.totalAmount}">
                                            <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="" /> ₫
                                        </c:if>
                                        <c:if test="${empty order.totalAmount}">
                                            0 ₫
                                        </c:if>
                                    </span>
                                </div>
                                <div class="order-actions">
                                    <a href="${pageContext.request.contextPath}/orders/detail?id=${order.orderId}" class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-eye me-1"></i> Chi tiết
                                    </a>
                                    <c:if test="${order.status == 'pending'}">
                                        <form action="${pageContext.request.contextPath}/orders/cancel" method="post" class="d-inline">
                                            <input type="hidden" name="orderId" value="${order.orderId}">
                                            <button type="submit" class="btn btn-outline-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này?')">
                                                <i class="fas fa-times me-1"></i> Hủy đơn
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${order.status == 'delivered'}">
                                        <a href="${pageContext.request.contextPath}/orders/review?id=${order.orderId}" class="btn btn-outline-secondary btn-sm">
                                            <i class="fas fa-star me-1"></i> Đánh giá
                                        </a>
                                        <a href="${pageContext.request.contextPath}/orders/reorder?id=${order.orderId}" class="btn btn-outline-success btn-sm">
                                            <i class="fas fa-redo me-1"></i> Đặt lại
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <!-- Pagination -->
                    <c:if test="${not empty orders && totalPages > 1}">
                        <nav aria-label="Page navigation">
                            <ul class="pagination">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="${pageContext.request.contextPath}/orders?page=${currentPage - 1}" aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>
                                </c:if>
                                
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <c:choose>
                                        <c:when test="${currentPage == i}">
                                            <li class="page-item active"><span class="page-link">${i}</span></li>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/orders?page=${i}">${i}</a></li>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                
                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="${pageContext.request.contextPath}/orders?page=${currentPage + 1}" aria-label="Next">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/user/includes/footer.jsp" />

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- AOS Animation -->
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    
    <!-- Custom JS -->
    <script>
        // Initialize AOS animation library
        AOS.init({
            once: true,
            duration: 800
        });
        
        // Status filter auto-submit
        const statusChecks = document.querySelectorAll('.status-check');
        statusChecks.forEach(check => {
            check.addEventListener('change', function() {
                document.getElementById('statusForm').submit();
            });
        });
    </script>
</body>
</html> 