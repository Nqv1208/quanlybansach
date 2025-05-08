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
                    <h2><i class="fas fa-list"></i> Quản lý danh mục</h2>
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                        <i class="fas fa-plus"></i> Thêm danh mục mới
                    </button>
                </div>
                <hr class="mt-2">
            </div>
            
            <!-- Categories Table -->
            <div class="row">
                <div class="col-md-12">
                    <div class="card shadow">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th width="10%">ID</th>
                                            <th width="50%">Tên danh mục</th>
                                            <th width="25%">Số lượng tác phẩm</th>
                                            <th width="15%">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="category" items="${categories}">
                                            <tr>
                                                <td>${category.categoryId}</td>
                                                <td>${category.name}</td>
                                                <td>${category.bookCount}</td>
                                                <td>
                                                    <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#editCategoryModal" data-id="${category.categoryId}"><i class="fas fa-edit"></i> Sửa</button>
                                                    <button class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#deleteCategoryModal" data-id="${category.categoryId}"><i class="fas fa-trash"></i> Xóa</button>
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
        </div>
    </div>
</div>

<!-- Add Category Modal -->
<div class="modal fade" id="addCategoryModal" tabindex="-1" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="addCategoryForm" action="${pageContext.request.contextPath}/admin/categories/create" method="post">
                <div class="modal-header">
                    <h5 class="modal-title" id="addCategoryModalLabel">Thêm danh mục mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="categoryName" class="form-label">Tên danh mục</label>
                        <input type="text" class="form-control" id="categoryName" name="categoryName" required>
                    </div>
                    <div class="mb-3">
                        <label for="categoryDescription" class="form-label">Mô tả</label>
                        <textarea class="form-control" id="categoryDescription" name="categoryDescription" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary">Lưu</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Category Modal -->
<div class="modal fade" id="editCategoryModal" tabindex="-1" aria-labelledby="editCategoryModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="editCategoryForm" action="${pageContext.request.contextPath}/admin/categories/update" method="post">
                <div class="modal-header">
                    <h5 class="modal-title" id="editCategoryModalLabel">Chỉnh sửa danh mục</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="editCategoryId" name="categoryId" value="">
                    <div class="mb-3">
                        <label for="editCategoryName" class="form-label">Tên danh mục</label>
                        <input type="text" class="form-control" id="editCategoryName" name="categoryName" value="Văn học Việt Nam" required>
                    </div>
                    <div class="mb-3">
                        <label for="editCategoryDescription" class="form-label">Mô tả</label>
                        <textarea class="form-control" id="editCategoryDescription" name="categoryDescription" rows="3">Sách thuộc thể loại văn học Việt Nam của các tác giả nổi tiếng.</textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary">Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Category Modal -->
<div class="modal fade" id="deleteCategoryModal" tabindex="-1" aria-labelledby="deleteCategoryModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteCategoryModalLabel">Xác nhận xóa</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa danh mục này không? Hành động này không thể hoàn tác.</p>
                <p class="text-danger"><strong>Lưu ý:</strong> Việc xóa danh mục có thể ảnh hưởng đến các sách thuộc danh mục này.</p>
            </div>
            <div class="modal-footer">
                <form action="${pageContext.request.contextPath}/admin/categories/delete" method="post">
                    <input type="hidden" name="categoryId" value="${category.categoryId}">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-danger">Xóa</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Include footer -->
<jsp:include page="/WEB-INF/views/admin/includes/footer.jsp" /> 