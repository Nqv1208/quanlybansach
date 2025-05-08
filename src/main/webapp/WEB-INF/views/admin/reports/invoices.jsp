<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo hóa đơn - Quản lý bán sách</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- DataTables -->
    <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <style>
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .card-header {
            background-color: #4e73df;
            color: white;
            border-radius: 10px 10px 0 0 !important;
        }
        
        .badge-status {
            padding: 0.5rem 0.75rem;
            font-size: 0.75rem;
            font-weight: 600;
            border-radius: 0.375rem;
        }
        
        .badge-completed {
            background-color: #1cc88a;
            color: white;
        }
        
        .badge-pending {
            background-color: #f6c23e;
            color: white;
        }
        
        .badge-canceled {
            background-color: #e74a3b;
            color: white;
        }
        
        .table thead th {
            font-weight: 600;
            background-color: #f8f9fc;
        }
        
        .btn-view {
            padding: 0.25rem 0.5rem;
            font-size: 0.75rem;
            background-color: #4e73df;
            border-color: #4e73df;
        }
        
        .btn-export {
            padding: 0.25rem 0.5rem;
            font-size: 0.75rem;
            background-color: #1cc88a;
            border-color: #1cc88a;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/admin/header.jsp" />
    
    <div class="container-fluid py-4">
        <div class="d-sm-flex align-items-center justify-content-between mb-4">
            <h1 class="h3 mb-0 text-gray-800">Báo cáo hóa đơn</h1>
            <a href="${pageContext.request.contextPath}/admin/reports/export-invoices" class="btn btn-sm btn-primary shadow-sm">
                <i class="fas fa-download fa-sm text-white-50 me-1"></i> Xuất báo cáo PDF
            </a>
        </div>

        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold">Danh sách hóa đơn</h6>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered" id="invoiceTable" width="100%" cellspacing="0">
                        <thead>
                            <tr>
                                <th>Mã hóa đơn</th>
                                <th>Ngày tạo</th>
                                <th>Khách hàng</th>
                                <th>Số điện thoại</th>
                                <th>Tổng tiền</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="invoice" items="${invoices}">
                                <tr>
                                    <td>${invoice.invoiceId}</td>
                                    <td><fmt:formatDate value="${invoice.createdDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                    <td>${invoice.customerName}</td>
                                    <td>${invoice.customerPhone}</td>
                                    <td class="text-end">
                                        <fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                    </td>
                                    <td class="text-center">
                                        <form action="${pageContext.request.contextPath}/reports/export" method="post" style="display: inline;">
                                            <input type="hidden" name="invoiceId" value="${invoice.invoiceId}">
                                            <button type="submit" class="btn btn-primary btn-sm btn-export">
                                                <i class="fas fa-file-pdf me-1"></i> Xuất PDF
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-xl-8 col-lg-7">
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold">Số lượng hóa đơn theo tháng</h6>
                    </div>
                    <div class="card-body">
                        <div style="height: 300px;">
                            <canvas id="invoiceChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-4 col-lg-5">
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold">Thống kê nhanh</h6>
                    </div>
                    <div class="card-body">
                        <div class="mb-4">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Tổng số hóa đơn</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${invoices.size()}</div>
                        </div>
                        <div class="mb-4">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Hóa đơn trong tháng</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <c:set var="currentMonthInvoices" value="0" />
                                <c:forEach var="invoice" items="${invoices}">
                                    <jsp:useBean id="now" class="java.util.Date" />
                                    <fmt:formatDate var="currentMonth" value="${now}" pattern="MM/yyyy" />
                                    <fmt:formatDate var="invoiceMonth" value="${invoice.createdDate}" pattern="MM/yyyy" />
                                    <c:if test="${currentMonth eq invoiceMonth}">
                                        <c:set var="currentMonthInvoices" value="${currentMonthInvoices + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${currentMonthInvoices}
                            </div>
                        </div>
                        <div class="mb-4">
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Tổng doanh thu</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <c:set var="totalRevenue" value="0" />
                                <c:forEach var="invoice" items="${invoices}">
                                    <c:set var="totalRevenue" value="${totalRevenue + invoice.totalAmount}" />
                                </c:forEach>
                                <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                            </div>
                        </div>
                        <div class="mb-4">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Giá trị trung bình</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <c:if test="${invoices.size() > 0}">
                                    <fmt:formatNumber value="${totalRevenue / invoices.size()}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                </c:if>
                                <c:if test="${invoices.size() == 0}">
                                    <fmt:formatNumber value="0" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                </c:if>
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
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- DataTables -->
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <script>
        $(document).ready(function() {
            $('#invoiceTable').DataTable({
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.11.5/i18n/vi.json'
                },
                order: [[1, 'desc']]
            });
        });
        
        // Dữ liệu mẫu cho biểu đồ số lượng hóa đơn theo tháng
        const invoiceData = {
            labels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6'],
            datasets: [{
                label: 'Số lượng hóa đơn',
                data: [42, 68, 50, 74, 85, ${currentMonthInvoices}],
                backgroundColor: [
                    'rgba(78, 115, 223, 0.8)',
                    'rgba(78, 115, 223, 0.8)',
                    'rgba(78, 115, 223, 0.8)',
                    'rgba(78, 115, 223, 0.8)',
                    'rgba(78, 115, 223, 0.8)',
                    'rgba(78, 115, 223, 0.8)'
                ],
                borderColor: [
                    'rgba(78, 115, 223, 1)',
                    'rgba(78, 115, 223, 1)',
                    'rgba(78, 115, 223, 1)',
                    'rgba(78, 115, 223, 1)',
                    'rgba(78, 115, 223, 1)',
                    'rgba(78, 115, 223, 1)'
                ],
                borderWidth: 1
            }]
        };

        // Tạo biểu đồ số lượng hóa đơn theo tháng
        const invoiceChart = new Chart(
            document.getElementById('invoiceChart'),
            {
                type: 'bar',
                data: invoiceData,
                options: {
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                precision: 0
                            }
                        }
                    }
                }
            }
        );
    </script>
</body>
</html> 