   <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
   <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
   <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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
                     <h2><i class="fas fa-file-alt"></i> Xem Trước Báo Cáo</h2>
                     <hr>
                  </div>
               </div>

               <!-- Report Preview Card -->
               <div class="row">
                  <div class="col-md-12">
                     <div class="card shadow">
                           <div class="card-header bg-primary text-white">
                              <div class="d-flex justify-content-between align-items-center">
                                 <h5 class="mb-0">
                                       <c:choose>
                                          <c:when test="${reportType == 'sales'}">Báo Cáo Doanh Thu</c:when>
                                          <c:when test="${reportType == 'customers'}">Báo Cáo Khách Hàng</c:when>
                                          <c:when test="${reportType == 'inventory'}">Báo Cáo Tồn Kho</c:when>
                                          <c:otherwise>Báo Cáo</c:otherwise>
                                       </c:choose>
                                 </h5>
                                 <div>
                                       <a href="${pageContext.request.contextPath}/admin/reports/download" class="btn btn-light">
                                          <i class="fas fa-download"></i> Tải Xuống
                                       </a>
                                       <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-light ml-2">
                                          <i class="fas fa-arrow-left"></i> Quay Lại
                                       </a>
                                 </div>
                              </div>
                           </div>
                           <div class="card-body">
                              <!-- Report Information -->
                              <div class="row mb-4">
                                 <div class="col-md-6">
                                       <p><strong>Loại báo cáo:</strong> 
                                          <c:choose>
                                             <c:when test="${reportType == 'sales'}">Doanh Thu</c:when>
                                             <c:when test="${reportType == 'customers'}">Khách Hàng</c:when>
                                             <c:when test="${reportType == 'inventory'}">Tồn Kho</c:when>
                                             <c:otherwise>Không xác định</c:otherwise>
                                          </c:choose>
                                       </p>
                                       <p><strong>Định dạng:</strong> 
                                          <c:choose>
                                             <c:when test="${fileFormat == 'pdf'}">PDF</c:when>
                                             <c:when test="${fileFormat == 'excel'}">Excel</c:when>
                                             <c:otherwise>Không xác định</c:otherwise>
                                          </c:choose>
                                       </p>
                                 </div>
                                 <div class="col-md-6">
                                       <p><strong>Thời gian báo cáo:</strong> 
                                          <c:if test="${not empty startDate}">Từ ${startDate}</c:if>
                                          <c:if test="${not empty endDate}">đến ${endDate}</c:if>
                                          <c:if test="${empty startDate and empty endDate}">Tất cả thời gian</c:if>
                                       </p>
                                       <p><strong>Ngày tạo:</strong> <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy" /></p>
                                 </div>
                              </div>

                              <!-- Report Content Preview based on type -->
                              <c:choose>
                                 <c:when test="${reportType == 'sales'}">
                                       <!-- Sales Report Preview -->
                                       <div class="table-responsive">
                                          <table class="table table-bordered table-hover">
                                             <thead class="table-primary">
                                                   <tr>
                                                      <th>Tháng</th>
                                                      <th class="text-end">Doanh Thu</th>
                                                   </tr>
                                             </thead>
                                             <tbody>
                                                   <c:forEach var="entry" items="${revenueMap}">
                                                      <tr>
                                                         <td>${entry.key}</td>
                                                         <td class="text-end">${entry.value} đ</td>
                                                      </tr>
                                                   </c:forEach>
                                                   <c:if test="${empty revenueMap}">
                                                      <tr>
                                                         <td colspan="2" class="text-center">Không có dữ liệu doanh thu</td>
                                                      </tr>
                                                   </c:if>
                                             </tbody>
                                             <tfoot class="table-primary">
                                                   <tr>
                                                      <th>TỔNG DOANH THU</th>
                                                      <th class="text-end">${totalRevenue} đ</th>
                                                   </tr>
                                             </tfoot>
                                          </table>
                                       </div>
                                 </c:when>
                                 
                                 <c:when test="${reportType == 'customers'}">
                                       <!-- Customer Report Preview -->
                                       <div class="table-responsive">
                                          <table class="table table-bordered table-hover">
                                             <thead class="table-primary">
                                                   <tr>
                                                      <th>ID</th>
                                                      <th>Tên Khách Hàng</th>
                                                      <th>Email</th>
                                                      <th>Số Điện Thoại</th>
                                                   </tr>
                                             </thead>
                                             <tbody>
                                                   <c:forEach var="customer" items="${customers}">
                                                      <tr>
                                                         <td>${customer.customerId}</td>
                                                         <td>${customer.fullName}</td>
                                                         <td>${customer.email}</td>
                                                         <td>${customer.phone}</td>
                                                      </tr>
                                                   </c:forEach>
                                                   <c:if test="${empty customers}">
                                                      <tr>
                                                         <td colspan="4" class="text-center">Không có dữ liệu khách hàng</td>
                                                      </tr>
                                                   </c:if>
                                             </tbody>
                                          </table>
                                       </div>
                                 </c:when>
                                 
                                 <c:when test="${reportType == 'inventory'}">
                                       <!-- Inventory Report Preview -->
                                       <div class="table-responsive">
                                          <table class="table table-bordered table-hover">
                                             <thead class="table-primary">
                                                   <tr>
                                                      <th>Mã Sách</th>
                                                      <th>Tên Sách</th>
                                                      <th>Tác Giả</th>
                                                      <th class="text-end">Số Lượng</th>
                                                      <th class="text-end">Giá Bán</th>
                                                   </tr>
                                             </thead>
                                             <tbody>
                                                   <c:forEach var="book" items="${books}">
                                                      <tr>
                                                         <td>${book.bookId}</td>
                                                         <td>${book.title}</td>
                                                         <td>${book.author}</td>
                                                         <td class="text-end">${book.quantity}</td>
                                                         <td class="text-end">${book.price} đ</td>
                                                      </tr>
                                                   </c:forEach>
                                                   <c:if test="${empty books}">
                                                      <tr>
                                                         <td colspan="5" class="text-center">Không có dữ liệu sách</td>
                                                      </tr>
                                                   </c:if>
                                             </tbody>
                                          </table>
                                       </div>
                                 </c:when>
                                 
                                 <c:otherwise>
                                       <div class="alert alert-info">
                                          Không có dữ liệu xem trước cho loại báo cáo này.
                                       </div>
                                 </c:otherwise>
                              </c:choose>
                              
                           </div>
                     </div>
                  </div>
               </div>
         </div>
      </div>
   </div>

   <!-- Include footer -->
   <jsp:include page="/WEB-INF/views/admin/includes/footer.jsp" />