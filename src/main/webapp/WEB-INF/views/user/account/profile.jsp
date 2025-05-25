<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin tài khoản - Nhà Sách Online</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Main CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <!-- Page-specific CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/user/profile.css">
</head>
<body>
    <!-- Header -->
    <jsp:include page="/WEB-INF/views/user/includes/header.jsp" />

    <!-- Page Title -->
    <section class="page-title">
        <div class="container">
            <h1 class="text-center">Tài khoản của tôi</h1>
            <p class="text-center mb-0">Quản lý thông tin và hoạt động tài khoản</p>
        </div>
    </section>

    <!-- Profile Section -->
    <section class="container mb-5">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-lg-3">
                <div class="profile-sidebar">
                    <div class="user-info text-center mb-4">
                        <div class="avatar-container mb-3">
                            <c:choose>
                                <c:when test="${not empty sessionScope.account.avatarUrl}">
                                    <img src="${pageContext.request.contextPath}/${sessionScope.account.avatarUrl}" alt="${sessionScope.account.username}" class="avatar-image">
                                </c:when>
                                <c:otherwise>
                                    <div class="avatar-placeholder">
                                        <span>${fn:substring(sessionScope.account.username, 0, 1)}</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <h4 class="user-name">${sessionScope.account.username}</h4>
                        <p class="user-email">${sessionScope.account.email}</p>
                    </div>
                    
                    <nav class="profile-nav">
                        <ul class="nav flex-column">
                            <li class="nav-item">
                                <a class="nav-link active" href="${pageContext.request.contextPath}/account/profile">
                                    <i class="fas fa-user me-2"></i> Thông tin tài khoản
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/orders">
                                    <i class="fas fa-box me-2"></i> Đơn hàng của tôi
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/account/wishlist">
                                    <i class="fas fa-heart me-2"></i> Sản phẩm yêu thích
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/account/reviews">
                                    <i class="fas fa-star me-2"></i> Đánh giá của tôi
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/account/change-password">
                                    <i class="fas fa-lock me-2"></i> Đổi mật khẩu
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout">
                                    <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-lg-9">
                <div class="profile-content">
                    <div class="profile-header">
                        <h3>Thông tin tài khoản</h3>
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                            <i class="fas fa-edit me-2"></i> Chỉnh sửa thông tin
                        </button>
                    </div>
                    
                    <!-- Profile Information -->
                    <div class="profile-info">
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Họ và tên</div>
                                    <div class="info-value">${sessionScope.customer.name}</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Email</div>
                                    <div class="info-value">${sessionScope.customer.email}</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Số điện thoại</div>
                                    <div class="info-value">${sessionScope.customer.phone}</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Địa chỉ</div>
                                    <div class="info-value">${sessionScope.customer.address}</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="info-item">
                                    <div class="info-label">Ngày đăng ký</div>
                                    <div class="info-value">
                                        <c:if test="${not empty sessionScope.account.createdDate}">
                                            <fmt:formatDate value="${sessionScope.account.createdDate}" pattern="dd/MM/yyyy" />
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Account Stats -->
                    <div class="account-stats">
                        <h4 class="stats-title">Thống kê tài khoản</h4>
                        <div class="row">
                            <div class="col-md-3 col-6">
                                <div class="stat-card">
                                    <div class="stat-icon">
                                        <i class="fas fa-shopping-bag"></i>
                                    </div>
                                    <div class="stat-count">${orderCount}</div>
                                    <div class="stat-label">Đơn hàng</div>
                                </div>
                            </div>
                            <!-- <div class="col-md-3 col-6">
                                <div class="stat-card">
                                    <div class="stat-icon">
                                        <i class="fas fa-heart"></i>
                                    </div>
                                    <div class="stat-count">${wishlistCount}</div>
                                    <div class="stat-label">Yêu thích</div>
                                </div>
                            </div> -->
                            <div class="col-md-3 col-6">
                                <div class="stat-card">
                                    <div class="stat-icon">
                                        <i class="fas fa-star"></i>
                                    </div>
                                    <div class="stat-count">${reviewCount}</div>
                                    <div class="stat-label">Đánh giá</div>
                                </div>
                            </div>
                            <!-- <div class="col-md-3 col-6">
                                <div class="stat-card">
                                    <div class="stat-icon">
                                        <i class="fas fa-map-marker-alt"></i>
                                    </div>
                                    <div class="stat-count">${addressCount}</div>
                                    <div class="stat-label">Địa chỉ</div>
                                </div>
                            </div> -->
                        </div>
                    </div>
                    
                    <!-- Recent Orders -->
                    <div class="recent-orders mt-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h4 class="section-title">Đơn hàng gần đây</h4>
                            <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-primary btn-sm">
                                Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
                            </a>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Mã đơn hàng</th>
                                        <th>Ngày đặt</th>
                                        <th>Tổng tiền</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${recentOrders}" varStatus="loop">
                                        <c:if test="${loop.index < 5}">
                                            <tr>
                                                <td>${order.orderId}</td>
                                                <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy" /></td>
                                                <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="" /> ₫</td>
                                                <td>
                                                    <span class="status-badge ${order.status}">
                                                        <c:choose>
                                                            <c:when test="${order.status == 'pending'}">Chờ xác nhận</c:when>
                                                            <c:when test="${order.status == 'processing'}">Đang xử lý</c:when>
                                                            <c:when test="${order.status == 'shipped'}">Đang giao hàng</c:when>
                                                            <c:when test="${order.status == 'delivered'}">Đã giao hàng</c:when>
                                                            <c:when test="${order.status == 'cancelled'}">Đã hủy</c:when>
                                                            <c:otherwise>${order.status}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/orders/detail?id=${order.orderId}" class="btn btn-sm btn-outline-primary">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                    
                                    <c:if test="${empty recentOrders}">
                                        <tr>
                                            <td colspan="5" class="text-center">Bạn chưa có đơn hàng nào</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Edit Profile Modal -->
    <div class="modal fade" id="editProfileModal" tabindex="-1" aria-labelledby="editProfileModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editProfileModalLabel">Chỉnh sửa thông tin cá nhân</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editProfileForm" action="${pageContext.request.contextPath}/account/update-profile" method="post" enctype="multipart/form-data">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="fullName" class="form-label">Họ và tên</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" value="${sessionScope.customer.name}" required>
                            </div>
                            <div class="col-md-6">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" value="${sessionScope.customer.email}" required>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="phone" class="form-label">Số điện thoại</label>
                                <input type="tel" class="form-control" id="phone" name="phone" value="${sessionScope.customer.phone}">
                            </div>
                            <div class="col-md-6">
                                <label for="address" class="form-label">Địa chỉ</label>
                                <input type="text" class="form-control" id="address" name="address" value="${sessionScope.customer.address}">
                            </div>
                        </div>
                        
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/user/includes/footer.jsp" />

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JS -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Form validation
            const editProfileForm = document.getElementById('editProfileForm');
            if (editProfileForm) {
                editProfileForm.addEventListener('submit', function(e) {
                    let isValid = true;
                    
                    // Validate email
                    const email = document.getElementById('email').value.trim();
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    if (!emailRegex.test(email)) {
                        alert('Vui lòng nhập email hợp lệ');
                        isValid = false;
                    }
                    
                    // Validate phone
                    const phone = document.getElementById('phone').value.trim();
                    if (phone && !/^\d{10,11}$/.test(phone)) {
                        alert('Số điện thoại không hợp lệ');
                        isValid = false;
                    }
                    
                    if (!isValid) {
                        e.preventDefault();
                    }
                });
            }
        });
    </script>
</body>
</html> 