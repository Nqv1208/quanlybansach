<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo thống kê - Quản lý bán sách</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .card-dashboard {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
            border-left: 4px solid;
        }
        
        .card-dashboard:hover {
            transform: translateY(-5px);
        }
        
        .card-books {
            border-left-color: #4e73df;
        }
        
        .card-customers {
            border-left-color: #1cc88a;
        }
        
        .card-orders {
            border-left-color: #36b9cc;
        }
        
        .card-revenue {
            border-left-color: #f6c23e;
        }
        
        .icon-circle {
            height: 3rem;
            width: 3rem;
            border-radius: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .bg-primary-light {
            background-color: #eaecf4;
        }
        
        .bg-success-light {
            background-color: #e0f8f1;
        }
        
        .bg-info-light {
            background-color: #e3f6f9;
        }
        
        .bg-warning-light {
            background-color: #fdf2d0;
        }
        
        .text-primary {
            color: #4e73df !important;
        }
        
        .text-success {
            color: #1cc88a !important;
        }
        
        .text-info {
            color: #36b9cc !important;
        }
        
        .text-warning {
            color: #f6c23e !important;
        }
        
        .report-section {
            margin-bottom: 2rem;
        }
        
        .chart-container {
            position: relative;
            height: 300px;
            width: 100%;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/admin/header.jsp" />
    
    <div class="container-fluid py-4">
        <div class="d-sm-flex align-items-center justify-content-between mb-4">
            <h1 class="h3 mb-0 text-gray-800">Báo cáo thống kê</h1>
            <div>
                <a href="${pageContext.request.contextPath}/admin/reports/export-invoices" class="btn btn-primary">
                    <i class="fas fa-download fa-sm text-white-50 me-1"></i> Xuất báo cáo hóa đơn
                </a>
                <a href="${pageContext.request.contextPath}/admin/reports/export-books" class="btn btn-success">
                    <i class="fas fa-download fa-sm text-white-50 me-1"></i> Xuất báo cáo sách
                </a>
            </div>
        </div>

        <!-- Dashboard Cards -->
        <div class="row">
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card card-dashboard card-books h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Tổng số sách</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800">${totalBooks}</div>
                            </div>
                            <div class="col-auto">
                                <div class="icon-circle bg-primary-light">
                                    <i class="fas fa-book fa-2x text-primary"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card card-dashboard card-customers h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Khách hàng</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800">${totalCustomers}</div>
                            </div>
                            <div class="col-auto">
                                <div class="icon-circle bg-success-light">
                                    <i class="fas fa-users fa-2x text-success"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card card-dashboard card-orders h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Hóa đơn</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800">${totalInvoices}</div>
                            </div>
                            <div class="col-auto">
                                <div class="icon-circle bg-info-light">
                                    <i class="fas fa-file-invoice fa-2x text-info"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card card-dashboard card-revenue h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Doanh thu tháng</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800">
                                    <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                </div>
                            </div>
                            <div class="col-auto">
                                <div class="icon-circle bg-warning-light">
                                    <i class="fas fa-dollar-sign fa-2x text-warning"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Report Section -->
        <div class="row">
            <!-- Sales Chart -->
            <div class="col-xl-8 col-lg-7">
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                        <h6 class="m-0 font-weight-bold text-primary">Thống kê doanh thu</h6>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="salesChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Pie Chart -->
            <div class="col-xl-4 col-lg-5">
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                        <h6 class="m-0 font-weight-bold text-primary">Phân bố sản phẩm</h6>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="categoryChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Links to detailed reports -->
        <div class="row">
            <div class="col-lg-12">
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary">Báo cáo chi tiết</h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3 mb-4">
                                <a href="${pageContext.request.contextPath}/admin/reports/invoices" class="btn btn-block btn-outline-primary py-3">
                                    <i class="fas fa-file-invoice fa-2x mb-2"></i><br>
                                    Báo cáo hóa đơn
                                </a>
                            </div>
                            <div class="col-md-3 mb-4">
                                <a href="${pageContext.request.contextPath}/admin/reports/books" class="btn btn-block btn-outline-success py-3">
                                    <i class="fas fa-book fa-2x mb-2"></i><br>
                                    Báo cáo sách
                                </a>
                            </div>
                            <div class="col-md-3 mb-4">
                                <a href="${pageContext.request.contextPath}/admin/reports/customers" class="btn btn-block btn-outline-info py-3">
                                    <i class="fas fa-users fa-2x mb-2"></i><br>
                                    Báo cáo khách hàng
                                </a>
                            </div>
                            <div class="col-md-3 mb-4">
                                <a href="${pageContext.request.contextPath}/admin/reports/sales" class="btn btn-block btn-outline-warning py-3">
                                    <i class="fas fa-chart-line fa-2x mb-2"></i><br>
                                    Báo cáo doanh số
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/admin/footer.jsp" />

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Dữ liệu mẫu cho biểu đồ doanh thu
        const salesData = {
            labels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6'],
            datasets: [{
                label: 'Doanh thu (VNĐ)',
                data: [12500000, 19200000, 15800000, 16400000, 22800000, ${totalRevenue}],
                backgroundColor: 'rgba(78, 115, 223, 0.05)',
                borderColor: 'rgba(78, 115, 223, 1)',
                borderWidth: 2,
                pointBackgroundColor: 'rgba(78, 115, 223, 1)',
                pointBorderColor: '#fff',
                pointHoverRadius: 5,
                pointHoverBackgroundColor: 'rgba(78, 115, 223, 1)',
                pointHoverBorderColor: '#fff',
                pointHitRadius: 10,
                fill: true,
                tension: 0.4
            }]
        };

        // Dữ liệu mẫu cho biểu đồ phân bố
        const categoryData = {
            labels: ['Văn học', 'Kinh tế', 'Kỹ năng', 'Tiểu thuyết', 'Giáo trình'],
            datasets: [{
                data: [30, 22, 18, 17, 13],
                backgroundColor: [
                    '#4e73df',
                    '#1cc88a',
                    '#36b9cc',
                    '#f6c23e',
                    '#e74a3b'
                ],
                hoverBackgroundColor: [
                    '#2e59d9',
                    '#17a673',
                    '#2c9faf',
                    '#dda20a',
                    '#be2617'
                ],
                hoverBorderColor: "rgba(234, 236, 244, 1)",
            }]
        };

        // Tạo biểu đồ doanh thu
        const salesChart = new Chart(
            document.getElementById('salesChart'),
            {
                type: 'line',
                data: salesData,
                options: {
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return new Intl.NumberFormat('vi-VN', { 
                                        style: 'currency', 
                                        currency: 'VND',
                                        maximumFractionDigits: 0
                                    }).format(value);
                                }
                            }
                        }
                    }
                }
            }
        );

        // Tạo biểu đồ phân bố
        const categoryChart = new Chart(
            document.getElementById('categoryChart'),
            {
                type: 'doughnut',
                data: categoryData,
                options: {
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    },
                    cutout: '70%'
                }
            }
        );
    </script>
</body>
</html> 