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
                  <h2><i class="fas fa-shopping-cart"></i> Quản lý đơn hàng</h2>
                  <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addOrderModal">
                     <i class="fas fa-plus"></i> Thêm đơn hàng mới
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
                                    <label for="orderKeyword" class="form-label">Tìm kiếm</label>
                                    <input type="text" class="form-control" id="orderKeyword" placeholder="Mã đơn hàng hoặc tên khách hàng...">
                              </div>
                              <div class="col-md-3">
                                    <label for="orderStatus" class="form-label">Trạng thái</label>
                                    <select class="form-select" id="orderStatus">
                                       <option value="">Tất cả</option>
                                       <option value="pending">Đang xử lý</option>
                                       <option value="completed">Hoàn thành</option>
                                       <option value="cancelled">Đã hủy</option>
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
            
            <!-- Orders Table -->
            <div class="row">
               <div class="col-md-12">
                  <div class="card shadow">
                        <div class="card-body">
                           <div class="table-responsive">
                              <table class="table table-bordered table-hover">
                                    <thead class="table-light">
                                       <tr>
                                          <th width="5%">ID</th>
                                          <th width="20%">Khách hàng</th>
                                          <th width="15%">Ngày đặt</th>
                                          <th width="15%">Tổng tiền</th>
                                          <th width="15%">Trạng thái</th>
                                          <th width="15%">Thao tác</th>
                                       </tr>
                                    </thead>
                                    <tbody>
                                       <c:forEach var="order" items="${orders}">
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
                                                   <button class="btn btn-sm btn-info" data-bs-toggle="modal" data-bs-target="#viewOrderModal"><i class="fas fa-eye"></i></button>
                                                   <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editOrderModal"><i class="fas fa-edit"></i></button>
                                                   <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteOrderModal"><i class="fas fa-trash"></i></button>
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

<!-- Modal Thêm Đơn Hàng Mới -->
<div class="modal fade" id="addOrderModal" tabindex="-1" aria-labelledby="addOrderModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-lg">
       <div class="modal-content">
           <div class="modal-header">
               <h5 class="modal-title" id="addOrderModalLabel">Thêm đơn hàng mới</h5>
               <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
           </div>
           <div class="modal-body">
               <form action="${pageContext.request.contextPath}/admin/orders/create" method="post">
                   <div class="mb-3">
                       <label for="customerId" class="form-label">Khách hàng</label>
                       <select class="form-select" id="customerId" name="customerId" required>
                           <option value="">-- Chọn khách hàng --</option>
                           <c:forEach var="customer" items="${customers}">
                               <option value="${customer.customerId}">${customer.name}</option>
                           </c:forEach>
                       </select>
                   </div>
                   <div class="mb-3">
                       <label for="orderDate" class="form-label">Ngày đặt</label>
                       <input type="date" class="form-control" id="orderDate" name="orderDate" required>
                   </div>
                   <div class="mb-3">
                       <label for="orderStatus" class="form-label">Trạng thái</label>
                       <select class="form-select" id="orderStatus" name="status" required>
                           <option value="pending">Đang xử lý</option>
                           <option value="completed">Hoàn thành</option>
                           <option value="cancelled">Đã hủy</option>
                       </select>
                   </div>
                   <div class="mb-3">
                       <label for="orderItems" class="form-label">Sản phẩm</label>
                       <div id="orderItems">
                           <div class="row mb-2">
                               <div class="col-md-6">
                                   <select class="form-select" name="productIds[]" required>
                                       <option value="">-- Chọn sản phẩm --</option>
                                       <c:forEach var="product" items="${products}">
                                           <option value="${product.productId}">${product.name}</option>
                                       </c:forEach>
                                   </select>
                               </div>
                               <div class="col-md-3">
                                   <input type="number" class="form-control" name="quantities[]" placeholder="Số lượng" min="1" required>
                               </div>
                               <div class="col-md-3">
                                   <button type="button" class="btn btn-danger w-100 remove-item">Xóa</button>
                               </div>
                           </div>
                       </div>
                       <button type="button" class="btn btn-secondary" id="addItem">Thêm sản phẩm</button>
                   </div>
                   <div class="modal-footer">
                       <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                       <button type="submit" class="btn btn-primary">Thêm đơn hàng</button>
                   </div>
               </form>
           </div>
       </div>
   </div>
</div>

<!-- <script>
   // Thêm sản phẩm mới vào danh sách
   document.getElementById('addItem').addEventListener('click', function () {
       const orderItems = document.getElementById('orderItems');
       const newItem = document.createElement('div');
       newItem.classList.add('row', 'mb-2');
       newItem.innerHTML = `
           <div class="col-md-6">
               <select class="form-select" name="productIds[]" required>
                   <option value="">-- Chọn sản phẩm --</option>
                   <c:forEach var="product" items="${products}">
                       <option value="${product.productId}">${product.name}</option>
                   </c:forEach>
               </select>
           </div>
           <div class="col-md-3">
               <input type="number" class="form-control" name="quantities[]" placeholder="Số lượng" min="1" required>
           </div>
           <div class="col-md-3">
               <button type="button" class="btn btn-danger w-100 remove-item">Xóa</button>
           </div>
       `;
       orderItems.appendChild(newItem);
   });

   // Xóa sản phẩm khỏi danh sách
   document.addEventListener('click', function (e) {
       if (e.target.classList.contains('remove-item')) {
           e.target.closest('.row').remove();
       }
   });
</script> -->

<!-- Modal Xem Chi Tiết Đơn Hàng -->
<div class="modal fade" id="viewOrderModal" tabindex="-1" aria-labelledby="viewOrderModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-lg">
      <div class="modal-content">
            <div class="modal-header">
               <h5 class="modal-title" id="viewOrderModalLabel">Chi tiết đơn hàng</h5>
               <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
               <p><strong>Mã đơn hàng:</strong> ${order.orderId}</p>
               <p><strong>Khách hàng:</strong> ${order.customerName}</p>
               <p><strong>Ngày đặt:</strong> ${order.orderDate}</p>
               <p><strong>Tổng tiền:</strong> ${order.totalAmount} ₫</p>
               <p><strong>Trạng thái:</strong> 
                  <span class="badge ${order.status == 'completed' ? 'bg-success' : order.status == 'pending' ? 'bg-warning' : 'bg-danger'}">
                        ${order.status == 'completed' ? 'Hoàn thành' : order.status == 'pending' ? 'Đang xử lý' : 'Đã hủy'}
                  </span>
               </p>
               <h5>Danh sách sản phẩm</h5>
               <ul>
                  <c:forEach var="item" items="${order.items}">
                        <li>${item.productName} - ${item.quantity} x ${item.price} ₫</li>
                  </c:forEach>
               </ul>
            </div>
            <div class="modal-footer">
               <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
      </div>
   </div>
</div>

<!-- Modal Sửa Đơn Hàng -->
<div class="modal fade" id="editOrderModal" tabindex="-1" aria-labelledby="editOrderModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-lg">
      <div class="modal-content">
            <div class="modal-header">
               <h5 class="modal-title" id="editOrderModalLabel">Chỉnh sửa đơn hàng</h5>
               <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
               <form action="${pageContext.request.contextPath}/admin/orders/update" method="post">
                  <input type="hidden" name="orderId" value="${order.orderId}">
                  <div class="mb-3">
                        <label for="orderStatus" class="form-label">Trạng thái</label>
                        <select class="form-select" id="orderStatus" name="status">
                           <option value="pending" ${order.status == 'pending' ? 'selected' : ''}>Đang xử lý</option>
                           <option value="completed" ${order.status == 'completed' ? 'selected' : ''}>Hoàn thành</option>
                           <option value="cancelled" ${order.status == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                        </select>
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

<!-- Modal Xóa Đơn Hàng -->
<div class="modal fade" id="deleteOrderModal" tabindex="-1" aria-labelledby="deleteOrderModalLabel" aria-hidden="true">
   <div class="modal-dialog">
      <div class="modal-content">
            <div class="modal-header">
               <h5 class="modal-title" id="deleteOrderModalLabel">Xác nhận xóa</h5>
               <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
               <p>Bạn có chắc chắn muốn xóa đơn hàng <strong>${order.orderId}</strong> không? Hành động này không thể hoàn tác.</p>
            </div>
            <div class="modal-footer">
               <form action="${pageContext.request.contextPath}/admin/orders/delete" method="post">
                  <input type="hidden" name="orderId" value="${order.orderId}">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                  <button type="submit" class="btn btn-danger">Xóa</button>
               </form>
            </div>
      </div>
   </div>
</div>

<!-- Include footer -->
<jsp:include page="/WEB-INF/views/admin/includes/footer.jsp" />