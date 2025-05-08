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
                    <h2><i class="fas fa-book"></i> Quản lý sách</h2>
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addBookModal">
                        <i class="fas fa-plus"></i> Thêm sách mới
                    </button>
                </div>
                <hr class="mt-2">
            </div>
            
            <!-- Search Bar -->
            <div class="row mb-4">
                <div class="col-md-12">
                    <div class="card shadow">
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/admin/books/search" method="post" class="row g-3">
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <input type="text" class="form-control" placeholder="Tìm kiếm sách..." name="keyword" value="${param.keyword}">
                                        <button class="btn btn-primary" type="submit">
                                            <i class="fas fa-search"></i> Tìm
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <select class="form-select" name="category">
                                        <option value="">-- Danh mục --</option>
                                        <c:forEach var="category" items="${categories}">
                                            <option value="${category.categoryId}" ${param.category == category.categoryId ? 'selected' : ''}>${category.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <select class="form-select" name="author">
                                        <option value="">-- Tác giả --</option>
                                        <c:forEach var="author" items="${authors}">
                                            <option value="${author.authorId}" ${param.author == author.authorId ? 'selected' : ''}>${author.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Books Table -->
            <div class="row">
                <div class="col-md-12">
                    <div class="card shadow">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th>ID</th>
                                            <th>Hình ảnh</th>
                                            <th>Tên sách</th>
                                            <th>Tác giả</th>
                                            <th>Danh mục</th>
                                            <th>Giá</th>
                                            <th>Số lượng</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="book" items="${books}">
                                            <tr>
                                                <td>${book.bookId}</td>
                                                <td>
                                                    <img src="${book.imageUrl}" alt="${book.title}" class="img-thumbnail" style="width: 60px; height: 80px; object-fit: cover;">
                                                </td>
                                                <td>${book.title}</td>
                                                <td>${book.authorName}</td>
                                                <td>${book.categoryName}</td>
                                                <td>${book.price} ₫</td>
                                                <td>${book.stockQuantity}</td>
                                                <td>
                                                    <button class="btn btn-sm btn-info" data-bs-toggle="modal" data-bs-target="#viewBookModal-${book.bookId}">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editBookModal-${book.bookId}">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteBookModal-${book.bookId}">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
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
                                        <a class="page-link" href="#" tabindex="-1" aria-disabled="true">Trước</a>
                                    </li>
                                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                                    <li class="page-item">
                                        <a class="page-link" href="#">Sau</a>
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

<!-- Modal Thêm Sách Mới -->
<div class="modal fade" id="addBookModal" tabindex="-1" aria-labelledby="addBookModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addBookModalLabel">Thêm Sách Mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/books/create" method="post">
                <div class="modal-body">
                    <div class="row">
                        <!-- Left Column -->
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="title" class="form-label">Tên sách</label>
                                <input type="text" class="form-control" id="title" name="title" placeholder="Nhập tên sách" required>
                            </div>
                            <div class="mb-3">
                                <label for="authorId" class="form-label">Tác giả</label>
                                <select class="form-select" id="authorId" name="authorId" required>
                                    <option value="">-- Chọn tác giả --</option>
                                    <c:forEach var="author" items="${authors}">
                                        <option value="${author.authorId}">${author.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="categoryId" class="form-label">Danh mục</label>
                                <select class="form-select" id="categoryId" name="categoryId" required>
                                    <option value="">-- Chọn danh mục --</option>
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category.categoryId}">${category.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="publisherId" class="form-label">Nhà xuất bản</label>
                                <select class="form-select" id="publisherId" name="publisherId" required>
                                    <option value="">-- Chọn nhà xuất bản --</option>
                                    <c:forEach var="publisher" items="${publishers}">
                                        <option value="${publisher.publisherId}">${publisher.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="isbn" class="form-label">ISBN</label>
                                <input type="text" class="form-control" id="isbn" name="isbn" placeholder="Nhập ISBN" required>
                            </div>
                        </div>
                        <!-- Right Column -->
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="price" class="form-label">Giá</label>
                                <input type="number" class="form-control" id="price" name="price" placeholder="Nhập giá sách" required>
                            </div>
                            <div class="mb-3">
                                <label for="stockQuantity" class="form-label">Số lượng</label>
                                <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" placeholder="Nhập số lượng" required>
                            </div>
                            <div class="mb-3">
                                <label for="publicationDate" class="form-label">Ngày xuất bản</label>
                                <input type="date" class="form-control" id="publicationDate" name="publicationDate" required>
                            </div>
                            <div class="mb-3">
                                <label for="description" class="form-label">Mô tả</label>
                                <textarea class="form-control" id="description" name="description" rows="3" placeholder="Nhập mô tả sách"></textarea>
                            </div>
                            <div class="mb-3">
                                <label for="imageUrl" class="form-label">URL Hình ảnh</label>
                                <input type="text" class="form-control" id="imageUrl" name="imageUrl" placeholder="Nhập URL hình ảnh">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Thêm sách</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Tạo phần thao tác cho sách -->
<c:forEach var="book" items="${books}">
    <!-- Modal Xem Chi Tiết -->
    <div class="modal fade" id="viewBookModal-${book.bookId}" tabindex="-1" aria-labelledby="viewBookModalLabel-${book.bookId}" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="viewBookModalLabel-${book.bookId}">Chi Tiết Sách</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-4 text-center">
                            <img src="${book.imageUrl}" alt="${book.title}" class="img-fluid mb-3" style="max-height: 300px;">
                        </div>
                        <div class="col-md-8">
                            <h4>${book.title}</h4>
                            <p><strong>Tác giả:</strong> ${book.authorName}</p>
                            <p><strong>Danh mục:</strong> ${book.categoryName}</p>
                            <p><strong>Giá:</strong> ${book.price} ₫</p>
                            <p><strong>Số lượng trong kho:</strong> ${book.stockQuantity}</p>
                            <p><strong>Mô tả:</strong></p>
                            <p class="text-justify">${book.description}</p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Sửa -->
    <div class="modal fade" id="editBookModal-${book.bookId}" tabindex="-1" aria-labelledby="editBookModalLabel-${book.bookId}" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/admin/books/update" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editBookModalLabel-${book.bookId}">Sửa Thông Tin Sách</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="bookId" value="${book.bookId}">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="edit-book-title-${book.bookId}" class="form-label">Tên sách</label>
                                    <input type="text" class="form-control" id="edit-book-title-${book.bookId}" name="title" value="${book.title}" required>
                                </div>
                                <div class="mb-3">
                                    <label for="edit-book-author-${book.bookId}" class="form-label">Tác giả</label>
                                    <select class="form-select" id="edit-book-author-${book.bookId}" name="authorId" required>
                                        <c:forEach var="author" items="${authors}">
                                            <option value="${author.authorId}" ${author.authorId == book.authorId ? 'selected' : ''}>${author.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label for="edit-book-category-${book.bookId}" class="form-label">Danh mục</label>
                                    <select class="form-select" id="edit-book-category-${book.bookId}" name="categoryId" required>
                                        <c:forEach var="category" items="${categories}">
                                            <option value="${category.categoryId}" ${category.categoryId == book.categoryId ? 'selected' : ''}>${category.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="edit-book-price-${book.bookId}" class="form-label">Giá</label>
                                    <input type="number" class="form-control" id="edit-book-price-${book.bookId}" name="price" value="${book.price}" required>
                                </div>
                                <div class="mb-3">
                                    <label for="edit-book-stock-${book.bookId}" class="form-label">Số lượng</label>
                                    <input type="number" class="form-control" id="edit-book-stock-${book.bookId}" name="stockQuantity" value="${book.stockQuantity}" required>
                                </div>
                                <div class="mb-3">
                                    <label for="edit-book-desc-${book.bookId}" class="form-label">Mô tả</label>
                                    <textarea class="form-control" id="edit-book-desc-${book.bookId}" name="description" rows="3">${book.description}</textarea>
                                </div>
                                <div class="mb-3">
                                    <label for="edit-book-image-${book.bookId}" class="form-label">URL Hình ảnh</label>
                                    <input type="text" class="form-control" id="edit-book-image-${book.bookId}" name="imageUrl" value="${book.imageUrl}">
                                </div>
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

    <!-- Modal Xóa -->
    <div class="modal fade" id="deleteBookModal-${book.bookId}" tabindex="-1" aria-labelledby="deleteBookModalLabel-${book.bookId}" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteBookModalLabel-${book.bookId}">Xóa Sách</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa sách <strong>${book.title}</strong> không?</p>
                </div>
                <div class="modal-footer">
                    <form action="${pageContext.request.contextPath}/admin/books/delete" method="post">
                        <input type="hidden" name="bookId" value="${book.bookId}">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-danger">Xóa</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</c:forEach>
<!-- Include footer -->
<jsp:include page="/WEB-INF/views/admin/includes/footer.jsp" />