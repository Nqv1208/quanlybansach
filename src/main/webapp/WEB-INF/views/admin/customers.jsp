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
               <div class="col-md-12 d-flex justify-content-between align-items-center">
                  <h2><i class="fas fa-users"></i> Quản lý khách hàng</h2>
                  <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
                     <i class="fas fa-plus"></i> Thêm khách hàng mới
                  </button>
               </div>
               <hr class="mt-2">
            </div>
            
            <!-- Search Area -->
            <div class="row mb-4">
               <div class="col-md-12">
                  <div class="card shadow">
                        <div class="card-body">
                           <form id="searchForm" class="row g-3">
                              <div class="col-md-4">
                                    <label for="keyword" class="form-label">Tìm kiếm</label>
                                    <input type="text" class="form-control" id="keyword" placeholder="Tên khách hàng...">
                              </div>
                              <div class="col-md-3">
                                    <label for="city" class="form-label">Thành phố</label>
                                    <select class="form-select" id="city">
                                       <option value="">Tất cả</option>
                                       <option value="Hà Nội">Hà Nội</option>
                                       <option value="TP.HCM">TP.HCM</option>
                                       <option value="Đà Nẵng">Đà Nẵng</option>
                                       <option value="Cần Thơ">Cần Thơ</option>
                                    </select>
                              </div>
                              <div class="col-md-3 d-flex align-items-end">
                                    <button type="submit" class="btn btn-primary w-100">
                                       <i class="fas fa-search"></i> Tìm kiếm
                                    </button>
                              </div>
                           </form>
                        </div>
                  </div>
               </div>
            </div>
            
            <!-- Customers Table -->
            <div class="row">
               <div class="col-md-12">
                  <div class="card shadow">
                        <div class="card-body">
                           <div class="table-responsive">
                              <table class="table table-bordered table-hover">
                                    <thead class="table-light">
                                       <tr>
                                          <th width="10%">ID</th>
                                          <th width="20%">Tên khách hàng</th>
                                          <th width="20%">Email</th>
                                          <th width="15%">Số điện thoại</th>
                                          <th width="20%">Thành phố</th>
                                          <th width="15%">Thao tác</th>
                                       </tr>
                                    </thead>
                                    <tbody>
                                       <c:forEach var="customer" items="${customers}">
                                          <tr>
                                                <td>${customer.customerId}</td>
                                                <td>${customer.name}</td>
                                                <td>${customer.email}</td>
                                                <td>${customer.phone}</td>
                                                <td>${customer.address}</td>
                                                <td>
                                                   <button class="btn btn-sm btn-info" data-bs-toggle="modal" data-bs-target="#viewCustomerModal"><i class="fas fa-eye"></i></button>
                                                   <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editCustomerModal"><i class="fas fa-edit"></i></button>
                                                   <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteCustomerModal"><i class="fas fa-trash"></i></button>
                                                </td>
                                          </tr>
                                       </c:forEach>
                                    </tbody>
                              </table>
                           </div>
                           
                           <!-- Pagination -->
                           <nav aria-label="Page navigation" class="mt-4">
                              <ul class="pagination justify-content-center">
                                    <li class="page-item disabled">
                                       <a class="page-link" href="#" aria-label="Previous">
                                          <span aria-hidden="true">&laquo;</span>
                                       </a>
                                    </li>
                                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                                    <li class="page-item">
                                       <a class="page-link" href="#" aria-label="Next">
                                          <span aria-hidden="true">&raquo;</span>
                                       </a>
                                    </li>
                              </ul>
                           </nav>
                        </div>
                  </div>
               </div>
            </div>
      </div>
   </div>
</div>

<!-- Add Customer Modal -->
<div class="modal fade" id="addCustomerModal" tabindex="-1" aria-labelledby="addCustomerModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-lg">
      <div class="modal-content">
            <div class="modal-header">
               <h5 class="modal-title" id="addCustomerModalLabel">Thêm khách hàng mới</h5>
               <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
               <form id="addCustomerForm">
                  <div class="row">
                        <div class="col-md-6">
                           <div class="mb-3">
                              <label for="customerName" class="form-label">Tên khách hàng</label>
                              <input type="text" class="form-control" id="customerName" name="customerName" required>
                           </div>
                           <div class="mb-3">
                              <label for="customerEmail" class="form-label">Email</label>
                              <input type="email" class="form-control" id="customerEmail" name="customerEmail" required>
                           </div>
                           <div class="mb-3">
                              <label for="customerPhone" class="form-label">Số điện thoại</label>
                              <input type="text" class="form-control" id="customerPhone" name="customerPhone" required>
                           </div>
                        </div>
                        <div class="col-md-6">
                           <div class="mb-3">
                              <label for="customerCity" class="form-label">Thành phố</label>
                              <select class="form-select" id="customerCity" name="customerCity">
                                    <option value="">Chọn thành phố</option>
                                    <option value="Hà Nội">Hà Nội</option>
                                    <option value="TP.HCM">TP.HCM</option>
                                    <option value="Đà Nẵng">Đà Nẵng</option>
                                    <option value="Cần Thơ">Cần Thơ</option>
                                    <option value="Khác">Khác</option>
                              </select>
                           </div>
                           <div class="mb-3">
                              <label for="customerStatus" class="form-label">Trạng thái</label>
                              <select class="form-select" id="customerStatus" name="customerStatus">
                                    <option value="active">Hoạt động</option>
                                    <option value="inactive">Ngừng hoạt động</option>
                              </select>
                           </div>
                        </div>
                  </div>
               </form>
            </div>
            <div class="modal-footer">
               <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
               <button type="button" class="btn btn-primary">Lưu</button>
            </div>
      </div>
   </div>
</div>

<!-- Modal Xem Chi Tiết Khách Hàng -->
<div class="modal fade" id="viewCustomerModal" tabindex="-1" aria-labelledby="viewCustomerModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-lg">
      <div class="modal-content">
         <div class="modal-header">
               <h5 class="modal-title" id="viewCustomerModalLabel">Thông tin khách hàng</h5>
               <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
         </div>
         <div class="modal-body">
               <p><strong>Tên khách hàng:</strong> ${customer.name}</p>
               <p><strong>Email:</strong> ${customer.email}</p>
               <p><strong>Số điện thoại:</strong> ${customer.phone}</p>
               <p><strong>Thành phố:</strong> ${customer.city}</p>
               <p><strong>Trạng thái:</strong> 
                  <span class="badge ${customer.status == 'active' ? 'bg-success' : 'bg-danger'}">
                     ${customer.status == 'active' ? 'Hoạt động' : 'Ngừng hoạt động'}
                  </span>
               </p>
         </div>
         <div class="modal-footer">
               <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
         </div>
      </div>
   </div>
</div>

<!-- Modal Sửa Khách Hàng -->
<div class="modal fade" id="editCustomerModal" tabindex="-1" aria-labelledby="editCustomerModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-lg">
      <div class="modal-content">
         <div class="modal-header">
               <h5 class="modal-title" id="editCustomerModalLabel">Chỉnh sửa thông tin khách hàng</h5>
               <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
         </div>
         <div class="modal-body">
               <form action="${pageContext.request.contextPath}/customers/update" method="post">
                  <input type="hidden" name="customerId" value="${customer.customerId}">
                  <div class="row">
                     <div class="col-md-6">
                           <div class="mb-3">
                              <label for="editCustomerName" class="form-label">Tên khách hàng</label>
                              <input type="text" class="form-control" id="editCustomerName" name="name" value="${customer.name}" required>
                           </div>
                           <div class="mb-3">
                              <label for="editCustomerEmail" class="form-label">Email</label>
                              <input type="email" class="form-control" id="editCustomerEmail" name="email" value="${customer.email}" required>
                           </div>
                           <div class="mb-3">
                              <label for="editCustomerPhone" class="form-label">Số điện thoại</label>
                              <input type="text" class="form-control" id="editCustomerPhone" name="phone" value="${customer.phone}" required>
                           </div>
                     </div>
                     <div class="col-md-6">
                           <div class="mb-3">
                              <label for="editCustomerCity" class="form-label">Thành phố</label>
                              <select class="form-select" id="editCustomerCity" name="city">
                                 <option value="Hà Nội" ${customer.city == 'Hà Nội' ? 'selected' : ''}>Hà Nội</option>
                                 <option value="TP.HCM" ${customer.city == 'TP.HCM' ? 'selected' : ''}>TP.HCM</option>
                                 <option value="Đà Nẵng" ${customer.city == 'Đà Nẵng' ? 'selected' : ''}>Đà Nẵng</option>
                                 <option value="Cần Thơ" ${customer.city == 'Cần Thơ' ? 'selected' : ''}>Cần Thơ</option>
                                 <option value="Khác" ${customer.city == 'Khác' ? 'selected' : ''}>Khác</option>
                              </select>
                           </div>
                           <div class="mb-3">
                              <label for="editCustomerStatus" class="form-label">Trạng thái</label>
                              <select class="form-select" id="editCustomerStatus" name="status">
                                 <option value="active" ${customer.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                 <option value="inactive" ${customer.status == 'inactive' ? 'selected' : ''}>Ngừng hoạt động</option>
                              </select>
                           </div>
                     </div>
                  </div>
                  <div class="modal-footer">
                     <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                     <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                  </div>
               </form>
         </div>
      </div>
   </div>
</div>

<!-- Modal Xóa Khách Hàng -->
<div class="modal fade" id="deleteCustomerModal" tabindex="-1" aria-labelledby="deleteCustomerModalLabel" aria-hidden="true">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-header">
               <h5 class="modal-title" id="deleteCustomerModalLabel">Xác nhận xóa</h5>
               <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
         </div>
         <div class="modal-body">
               <p>Bạn có chắc chắn muốn xóa khách hàng <strong>${customer.name}</strong> không? Hành động này không thể hoàn tác.</p>
         </div>
         <div class="modal-footer">
               <form action="${pageContext.request.contextPath}/customers/delete" method="post">
                  <input type="hidden" name="customerId" value="${customer.customerId}">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                  <button type="submit" class="btn btn-danger">Xóa</button>
               </form>
         </div>
      </div>
   </div>
</div>

<!-- Include footer -->
<jsp:include page="/WEB-INF/views/admin/includes/footer.jsp" />