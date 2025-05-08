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
                    <h2><i class="fas fa-user-edit"></i> Quản lý tác giả</h2>
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addAuthorModal">
                        <i class="fas fa-plus"></i> Thêm tác giả mới
                    </button>
                </div>
                <hr class="mt-2">
            </div>
            
            <!-- Search Area -->
            <div class="row mb-4">
                <div class="col-md-12">
                    <div class="card shadow">
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/admin/authors/search" id="searchForm" class="row g-3" method="post">
                                <div class="col-md-4">
                                    <label for="keyword" class="form-label">Tìm kiếm</label>
                                    <input type="text" class="form-control" name="keyword" placeholder="Tên tác giả..." value="${param.keyword}">
                                </div>
                                <div class="col-md-3">
                                    <label for="country" class="form-label">Quốc gia</label>
                                    <select class="form-select" id="country" name="country">
                                        <option value="">-- Tất cả --</option>
                                        <c:forEach var="country" items="${countries}">
                                            <option value="${country}" ${param.country == country ? 'selected' : ''}>${country}</option>
                                        </c:forEach>
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
            
            <!-- Authors Table -->
            <div class="row">
                <div class="col-md-12">
                    <div class="card shadow">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th width="5%">ID</th>
                                            <th width="15%">Ảnh</th>
                                            <th width="20%">Tên tác giả</th>
                                            <th width="15%">Quốc gia</th>
                                            <th width="25%">Tiểu sử</th>
                                            <th width="10%">Số tác phẩm</th>
                                            <th width="10%">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach  var="author" items="${authors}">
                                            <tr>
                                                <td>${author.authorId}</td>
                                                <td><img src="${author.image}" alt="${author.name}" class="img-fluid rounded" style="max-height: 100px;"></td>
                                                <td>${author.name}</td>
                                                <td>${author.country}</td>
                                                <td>${author.bio}</td>
                                                <td>${author.bookCount}</td>
                                                <td>
                                                    <button class="btn btn-sm btn-info" data-bs-toggle="modal" data-bs-target="#viewAuthorModal"><i class="fas fa-eye"></i></button>
                                                    <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editAuthorModal"><i class="fas fa-edit"></i></button>
                                                    <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteAuthorModal"><i class="fas fa-trash"></i></button>
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

<!-- Add Author Modal -->
<div class="modal fade" id="addAuthorModal" tabindex="-1" aria-labelledby="addAuthorModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addAuthorModalLabel">Thêm tác giả mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="addAuthorForm">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="authorName" class="form-label">Tên tác giả</label>
                                <input type="text" class="form-control" id="authorName" name="authorName" required>
                            </div>
                            <div class="mb-3">
                                <label for="authorCountry" class="form-label">Quốc gia</label>
                                <select class="form-select" id="authorCountry" name="authorCountry" required>
                                    <option value="">Chọn quốc gia</option>
                                    <option value="Vietnam">Việt Nam</option>
                                    <option value="USA">Mỹ</option>
                                    <option value="UK">Anh</option>
                                    <option value="France">Pháp</option>
                                    <option value="Japan">Nhật Bản</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="authorDOB" class="form-label">Ngày sinh</label>
                                <input type="date" class="form-control" id="authorDOB" name="authorDOB">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="authorImage" class="form-label">Ảnh tác giả</label>
                                <input type="file" class="form-control" id="authorImage" name="authorImage">
                            </div>
                            <div class="mb-3">
                                <label for="authorBio" class="form-label">Tiểu sử</label>
                                <textarea class="form-control" id="authorBio" name="authorBio" rows="6"></textarea>
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

<!-- View Author Modal -->
<div class="modal fade" id="viewAuthorModal" tabindex="-1" aria-labelledby="viewAuthorModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="viewAuthorModalLabel">Thông tin tác giả</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-4 text-center">
                        <img src="assets/img/authors/nguyen-nhat-anh.jpg" alt="Nguyễn Nhật Ánh" class="img-fluid rounded mb-3" style="max-height: 200px;">
                    </div>
                    <div class="col-md-8">
                        <h4>Nguyễn Nhật Ánh</h4>
                        <p><strong>Quốc gia:</strong> Việt Nam</p>
                        <p><strong>Ngày sinh:</strong> 07/05/1955</p>
                        <p><strong>Số tác phẩm:</strong> 32</p>
                        <hr>
                        <p><strong>Tiểu sử:</strong></p>
                        <p>Nguyễn Nhật Ánh là nhà văn Việt Nam nổi tiếng với các tác phẩm văn học dành cho thanh thiếu niên. Ông được biết đến qua nhiều tác phẩm nổi tiếng như "Mắt biếc", "Tôi thấy hoa vàng trên cỏ xanh", "Cho tôi xin một vé đi tuổi thơ"...</p>
                    </div>
                </div>
                <div class="row mt-4">
                    <div class="col-12">
                        <h5>Các tác phẩm nổi bật</h5>
                        <ul class="list-group">
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                Mắt biếc
                                <span class="badge bg-primary rounded-pill">2000</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                Tôi thấy hoa vàng trên cỏ xanh
                                <span class="badge bg-primary rounded-pill">2010</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                Cho tôi xin một vé đi tuổi thơ
                                <span class="badge bg-primary rounded-pill">2008</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<!-- Edit Author Modal -->
<div class="modal fade" id="editAuthorModal" tabindex="-1" aria-labelledby="editAuthorModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editAuthorModalLabel">Chỉnh sửa thông tin tác giả</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="editAuthorForm">
                    <input type="hidden" id="editAuthorId" name="authorId" value="1">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="editAuthorName" class="form-label">Tên tác giả</label>
                                <input type="text" class="form-control" id="editAuthorName" name="authorName" value="Nguyễn Nhật Ánh" required>
                            </div>
                            <div class="mb-3">
                                <label for="editAuthorCountry" class="form-label">Quốc gia</label>
                                <select class="form-select" id="editAuthorCountry" name="authorCountry" required>
                                    <option value="Vietnam" selected>Việt Nam</option>
                                    <option value="USA">Mỹ</option>
                                    <option value="UK">Anh</option>
                                    <option value="France">Pháp</option>
                                    <option value="Japan">Nhật Bản</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="editAuthorDOB" class="form-label">Ngày sinh</label>
                                <input type="date" class="form-control" id="editAuthorDOB" name="authorDOB" value="1955-05-07">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="editAuthorImage" class="form-label">Ảnh tác giả</label>
                                <input type="file" class="form-control" id="editAuthorImage" name="authorImage">
                                <div class="form-text">Để trống nếu không muốn thay đổi ảnh.</div>
                                <div class="mt-2">
                                    <img src="assets/img/authors/nguyen-nhat-anh.jpg" alt="Current image" class="img-thumbnail" style="height: 100px;">
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="editAuthorBio" class="form-label">Tiểu sử</label>
                                <textarea class="form-control" id="editAuthorBio" name="authorBio" rows="6">Nguyễn Nhật Ánh là nhà văn Việt Nam nổi tiếng với các tác phẩm văn học dành cho thanh thiếu niên. Ông được biết đến qua nhiều tác phẩm nổi tiếng như "Mắt biếc", "Tôi thấy hoa vàng trên cỏ xanh", "Cho tôi xin một vé đi tuổi thơ"...</textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-primary">Lưu thay đổi</button>
            </div>
        </div>
    </div>
</div>

<!-- Delete Author Modal -->
<div class="modal fade" id="deleteAuthorModal" tabindex="-1" aria-labelledby="deleteAuthorModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteAuthorModalLabel">Xác nhận xóa</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa tác giả này không? Hành động này không thể hoàn tác.</p>
                <p class="text-danger"><strong>Lưu ý:</strong> Việc xóa tác giả có thể ảnh hưởng đến các sách thuộc tác giả này.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-danger">Xóa</button>
            </div>
        </div>
    </div>
</div>

<!-- Include footer -->
<jsp:include page="/WEB-INF/views/admin/includes/footer.jsp" /> 