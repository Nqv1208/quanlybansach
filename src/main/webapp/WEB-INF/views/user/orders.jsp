<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử đơn hàng - Nhà Sách Online</title>
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
            <h1 class="text-center">Lịch sử đơn hàng</h1>
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
                    <form action="${pageContext.request.contextPath}/user/orders" method="get">
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
                    <form action="${pageContext.request.contextPath}/user/orders" method="get" id="statusForm">
                        <div class="form-check mb-2">
                            <input class="form-check-input status-check" type="radio" name="status" value="all" id="statusAll" ${empty param.status || param.status == 'all' ? 'checked' : ''}>
                            <label class="form-check-label" for="statusAll">Tất cả</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input status-check" type="radio" name="status" value="pending" id="statusPending" ${param.status == 'pending' ? 'checked' : ''}>
                            <label class="form-check-label" for="statusPending">Chờ xác nhận</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input status-check" type="radio" name="status" value="processing" id="statusProcessing" ${param.status == 'processing' ? 'checked' : ''}>
                            <label class="form-check-label" for="statusProcessing">Đang xử lý</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input status-check" type="radio" name="status" value="shipped" id="statusShipped" ${param.status == 'shipped' ? 'checked' : ''}>
                            <label class="form-check-label" for="statusShipped">Đang giao hàng</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input status-check" type="radio" name="status" value="delivered" id="statusDelivered" ${param.status == 'delivered' ? 'checked' : ''}>
                            <label class="form-check-label" for="statusDelivered">Đã giao hàng</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input status-check" type="radio" name="status" value="cancelled" id="statusCancelled" ${param.status == 'cancelled' ? 'checked' : ''}>
                            <label class="form-check-label" for="statusCancelled">Đã hủy</label>
                        </div>
                    </form>
                </div>

                <!-- Date Filter -->
                <div class="filter-card">
                    <h5 class="filter-title">Khoảng thời gian</h5>
                    <form action="${pageContext.request.contextPath}/user/orders" method="get" id="dateForm">
                        <div class="mb-3">
                            <label for="startDate" class="form-label">Từ ngày</label>
                            <input type="date" class="form-control" id="startDate" name="startDate" value="${param.startDate}">
                        </div>
                        <div class="mb-3">
                            <label for="endDate" class="form-label">Đến ngày</label>
                            <input type="date" class="form-control" id="endDate" name="endDate" value="${param.endDate}">
                        </div>
                        <button type="submit" class="btn btn-primary btn-sm w-100">Áp dụng</button>
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
                            <a href="${pageContext.request.contextPath}/user/shop" class="btn btn-primary mt-3">Mua sắm ngay</a>
                        </div>
                    </c:if>
                    
                    <c:forEach var="order" items="${orders}">
                        <div class="order-card">
                            <div class="order-header">
                                <div>
                                    <div class="order-number">Đơn hàng #${order.code}</div>
                                    <div class="order-date">Ngày đặt: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" /></div>
                                </div>
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
                            </div>
                            
                            <div class="order-content">
                                <c:forEach var="item" items="${order.orderItems}" varStatus="loop">
                                    <c:if test="${loop.index < 3}">
                                        <div class="order-item">
                                            <img src="${item.book.imageUrl}" alt="${item.book.title}" class="item-image">
                                            <div class="item-details">
                                                <h6 class="item-title">${item.book.title}</h6>
                                                <p class="item-quantity">SL: ${item.quantity}</p>
                                            </div>
                                            <div class="item-price">
                                                <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="" /> ₫
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                                
                                <c:if test="${order.orderItems.size() > 3}">
                                    <div class="text-center mt-2">
                                        <small class="text-muted">và ${order.orderItems.size() - 3} sản phẩm khác</small>
                                    </div>
                                </c:if>
                                
                                <c:if test="${order.status == 'shipped'}">
                                    <div class="tracking-info">
                                        <div class="tracking-icon">
                                            <i class="fas fa-truck"></i>
                                        </div>
                                        <div class="tracking-details">
                                            <div class="tracking-status">Đang giao hàng</div>
                                            <div class="tracking-code">Mã vận đơn: ${order.trackingCode}</div>
                                        </div>
                                        <div class="tracking-date">
                                            <div>Dự kiến giao hàng:</div>
                                            <div><fmt:formatDate value="${order.estimatedDeliveryDate}" pattern="dd/MM/yyyy" /></div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                            
                            <div class="order-footer">
                                <div class="order-total">
                                    <span class="order-total-label">Tổng tiền:</span>
                                    <span class="order-total-value"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="" /> ₫</span>
                                </div>
                                <div class="order-actions">
                                    <a href="${pageContext.request.contextPath}/user/orders/detail?id=${order.id}" class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-eye me-1"></i> Chi tiết
                                    </a>
                                    <c:if test="${order.status == 'pending'}">
                                        <form action="${pageContext.request.contextPath}/user/orders/cancel" method="post" class="d-inline">
                                            <input type="hidden" name="orderId" value="${order.id}">
                                            <button type="submit" class="btn btn-outline-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này?')">
                                                <i class="fas fa-times me-1"></i> Hủy đơn
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${order.status == 'delivered'}">
                                        <a href="${pageContext.request.contextPath}/user/orders/review?id=${order.id}" class="btn btn-outline-secondary btn-sm">
                                            <i class="fas fa-star me-1"></i> Đánh giá
                                        </a>
                                        <a href="${pageContext.request.contextPath}/user/orders/reorder?id=${order.id}" class="btn btn-outline-success btn-sm">
                                            <i class="fas fa-redo me-1"></i> Đặt lại
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <!-- Pagination -->
                    <c:if test="${not empty orders}">
                        <nav aria-label="Page navigation">
                            <ul class="pagination">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="${pageContext.request.contextPath}/user/orders?page=${currentPage - 1}" aria-label="Previous">
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
                                            <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/user/orders?page=${i}">${i}</a></li>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                
                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="${pageContext.request.contextPath}/user/orders?page=${currentPage + 1}" aria-label="Next">
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
    
    <!-- Custom JS -->
    <script>
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