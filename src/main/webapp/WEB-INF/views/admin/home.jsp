<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Include header -->
<jsp:include page="/WEB-INF/views/admin/includes/header.jsp" />

<!-- Include sidebar -->
<jsp:include page="/WEB-INF/views/admin/includes/sidebar.jsp" />

<!-- Main Content -->
<div class="main-content">
    <div class="content-wrapper">
        <div class="container-fluid">
            <div class="row mb-4">
                <div class="col-md-12">
                    <h2><i class="fas fa-tachometer-alt"></i> Tổng quan</h2>
                    <hr>
                </div>
            </div>
            
            <!-- Dashboard Cards -->
            <div class="row mb-4">
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card card-dashboard border-left-primary shadow h-100 py-2 bg-primary text-white">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-uppercase mb-1">Tổng số sách</div>
                                    <div class="h5 mb-0 font-weight-bold">${totalBooks}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-book icon-big"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card card-dashboard border-left-success shadow h-100 py-2 bg-success text-white">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-uppercase mb-1">Đơn hàng hôm nay</div>
                                    <div class="h5 mb-0 font-weight-bold">${totalOrders}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-shopping-cart icon-big"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card card-dashboard border-left-info shadow h-100 py-2 bg-info text-white">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-uppercase mb-1">Khách hàng</div>
                                    <div class="h5 mb-0 font-weight-bold">${totalCustomers}</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-users icon-big"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card card-dashboard border-left-warning shadow h-100 py-2 bg-warning text-white">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-uppercase mb-1">Doanh thu tháng</div>
                                    <div class="h5 mb-0 font-weight-bold">${totalRevenue} ₫</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-money-bill-wave icon-big"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Orders -->
            <div class="row mb-4">
                <div class="col-md-12">
                    <div class="card shadow">
                        <div class="card-header bg-primary text-white">
                            <h6 class="m-0 font-weight-bold"><i class="fas fa-shopping-cart"></i> Đơn hàng gần đây</h6>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Mã đơn</th>
                                            <th>Khách hàng</th>
                                            <th>Ngày đặt</th>
                                            <th>Tổng tiền</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="order" items="${recentOrders}">
                                            <tr>
                                                <td>${order.orderId}</td>
                                                <td>${order.customerName}</td>
                                                <td>${order.orderDate}</td>
                                                <td>${order.totalAmount} ₫</td>
                                                <td>
                                                    <span class="badge 
                                                        <c:choose>
                                                            <c:when test="${order.status == 'Đã giao hàng'}">bg-success</c:when>
                                                            <c:when test="${order.status == 'Đang giao hàng'}">bg-warning</c:when>
                                                            <c:when test="${order.status == 'Đã xác nhận'}">bg-primary</c:when>
                                                            <c:when test="${order.status == 'Đã hủy'}">bg-danger</c:when>
                                                            <c:otherwise>bg-secondary</c:otherwise>
                                                        </c:choose>">
                                                        ${order.status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href="#" class="btn btn-sm btn-info"><i class="fas fa-eye"></i></a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Low Stock Alert and Best Selling Books -->
            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="card shadow">
                        <div class="card-header bg-danger text-white">
                            <h6 class="m-0 font-weight-bold"><i class="fas fa-exclamation-triangle"></i> Sắp hết hàng</h6>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th width="20%">Mã sách</th>
                                            <th width="40%">Tên sách</th>
                                            <th width="10%">Số lượng</th>
                                            <th width="30%">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach  var="book" items="${lowStockBooks}">
                                            <tr>
                                                <td>${book.bookId}</td>
                                                <td>${book.title}</td>
                                                <td>${book.stockQuantity}</td>
                                                <td>
                                                    <a href="#" class="btn btn-sm btn-primary"><i class="fas fa-plus-circle"></i> Nhập thêm</a>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                        <!-- <tr>
                                            <td>B002</td>
                                            <td>Tôi thấy hoa vàng trên cỏ xanh</td>
                                            <td>5</td>
                                            <td>
                                                <a href="#" class="btn btn-sm btn-primary"><i class="fas fa-plus-circle"></i> Nhập thêm</a>
                                            </td>
                                        </tr> -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Best Selling Books -->
                <div class="col-md-6 mb-4">
                    <div class="card shadow">
                        <div class="card-header bg-success text-white">
                            <h6 class="m-0 font-weight-bold"><i class="fas fa-chart-line"></i> Sách bán chạy</h6>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th width="20%">Mã sách</th>
                                            <th width="40%">Tên sách</th>
                                            <th width="10%">Đã bán</th>
                                            <th width="30%">Doanh thu</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="book" items="${bestSellBooks}">
                                            <tr>
                                                <td>${book.bookId}</td>
                                                <td>${book.title}</td>
                                                <td>${book.totalSold}</td>
                                                <td>${book.price * book.totalSold}đ</td>
                                            </tr>
                                        </c:forEach>

                                        <!-- <tr>
                                            <td>B005</td>
                                            <td>Harry Potter và Hòn đá Phù thủy</td>
                                            <td>42</td>
                                            <td>8.190.000 ₫</td>
                                        </tr> -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Include footer -->
<jsp:include page="/WEB-INF/views/admin/includes/footer.jsp" />
