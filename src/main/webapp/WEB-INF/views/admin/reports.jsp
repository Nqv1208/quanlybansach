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
                    <h2><i class="fas fa-file-alt"></i> Báo cáo</h2>
                    <hr>
                </div>
            </div>

            <!-- Report Form -->
            <div class="row">
                <div class="col-md-12">
                    <div class="card shadow">
                        <div class="card-body">
                           <form action="${pageContext.request.contextPath}/admin/reports/export" method="post">
                              <div class="row g-3">
                                 <!-- Report Type -->
                                 <div class="col-md-6">
                                       <label for="reportType" class="form-label">Loại báo cáo</label>
                                       <select class="form-select" id="reportType" name="reportType" required>
                                          <option value="">-- Chọn loại báo cáo --</option>
                                          <option value="sales">Báo cáo doanh thu</option>
                                          <option value="inventory">Báo cáo tồn kho</option>
                                          <option value="customers">Báo cáo khách hàng</option>
                                       </select>
                                 </div>

                                 <!-- Date Range -->
                                 <div class="col-md-3">
                                    <label for="startDate" class="form-label">Từ ngày</label>
                                    <input type="date" class="form-control" id="startDate" name="startDate" required>
                                 </div>
                                 <div class="col-md-3">
                                    <label for="endDate" class="form-label">Đến ngày</label>
                                    <input type="date" class="form-control" id="endDate" name="endDate" required>
                                 </div>

                                 <!-- File Format -->
                                 <div class="col-md-6">
                                       <label for="fileFormat" class="form-label">Định dạng file</label>
                                       <select class="form-select" id="fileFormat" name="fileFormat" required>
                                       <option value="">-- Chọn định dạng --</option>
                                       <option value="pdf">PDF</option>
                                       <option value="excel">Excel</option>
                                       </select>
                                 </div>

                                 <!-- Submit Button -->
                                 <div class="col-md-12 d-flex justify-content-end">
                                       <button type="submit" class="btn btn-primary">
                                       <i class="fas fa-download"></i> Xuất báo cáo
                                       </button>
                                 </div>
                              </div>
                           </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Report History -->
            <div class="row mt-4">
                <div class="col-md-12">
                    <div class="card shadow">
                        <div class="card-body">
                            <h5 class="card-title">Lịch sử báo cáo</h5>
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th>#</th>
                                            <th>Loại báo cáo</th>
                                            <th>Ngày tạo</th>
                                            <th>Định dạng</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="report" items="${reportHistory}">
                                            <tr>
                                                <td>${report.id}</td>
                                                <td>${report.type}</td>
                                                <td>${report.createdDate}</td>
                                                <td>${report.format}</td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/admin/reports/download?id=${report.id}" class="btn btn-sm btn-success">
                                                        <i class="fas fa-download"></i> Tải xuống
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty reportHistory}">
                                            <tr>
                                                <td colspan="5" class="text-center">Không có báo cáo nào</td>
                                            </tr>
                                        </c:if>
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