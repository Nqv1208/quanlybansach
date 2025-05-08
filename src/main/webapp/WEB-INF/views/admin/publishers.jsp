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
                    <h2><i class="fas fa-building"></i> Quản lý nhà xuất bản</h2>
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addPublisherModal">
                        <i class="fas fa-plus"></i> Thêm nhà xuất bản mới
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
                                    <input type="text" class="form-control" id="keyword" placeholder="Tên nhà xuất bản...">
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
            
            <!-- Publishers Table -->
            <div class="row">
                <div class="col-md-12">
                    <div class="card shadow">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th width="5%">ID</th>
                                            <th width="15%">Logo</th>
                                            <th width="20%">Tên nhà xuất bản</th>
                                            <th width="15%">Thành phố</th>
                                            <th width="15%">Liên hệ</th>
                                            <th width="10%">Số sách</th>
                                            <th width="10%">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>1</td>
                                            <td><img src="assets/img/publishers/nxb-kim-dong.png" alt="NXB Kim Đồng" class="img-fluid rounded" style="max-height: 60px;"></td>
                                            <td>Nhà xuất bản Kim Đồng</td>
                                            <td>Hà Nội</td>
                                            <td>
                                                <strong>ĐT:</strong> 024.39428653<br>
                                                <strong>Email:</strong> info@nxbkimdong.com.vn
                                            </td>
                                            <td>128</td>
                                            <td>
                                                <button class="btn btn-sm btn-info" data-bs-toggle="modal" data-bs-target="#viewPublisherModal"><i class="fas fa-eye"></i></button>
                                                <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editPublisherModal"><i class="fas fa-edit"></i></button>
                                                <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deletePublisherModal"><i class="fas fa-trash"></i></button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>2</td>
                                            <td><img src="assets/img/publishers/nxb-tre.png" alt="NXB Trẻ" class="img-fluid rounded" style="max-height: 60px;"></td>
                                            <td>Nhà xuất bản Trẻ</td>
                                            <td>TP.HCM</td>
                                            <td>
                                                <strong>ĐT:</strong> 028.39316289<br>
                                                <strong>Email:</strong> hopthubandoc@nxbtre.com.vn
                                            </td>
                                            <td>95</td>
                                            <td>
                                                <button class="btn btn-sm btn-info" data-bs-toggle="modal" data-bs-target="#viewPublisherModal"><i class="fas fa-eye"></i></button>
                                                <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editPublisherModal"><i class="fas fa-edit"></i></button>
                                                <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deletePublisherModal"><i class="fas fa-trash"></i></button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>3</td>
                                            <td><img src="assets/img/publishers/nxb-giao-duc.png" alt="NXB Giáo Dục" class="img-fluid rounded" style="max-height: 60px;"></td>
                                            <td>Nhà xuất bản Giáo Dục</td>
                                            <td>Hà Nội</td>
                                            <td>
                                                <strong>ĐT:</strong> 024.38221917<br>
                                                <strong>Email:</strong> contact@nxbgd.vn
                                            </td>
                                            <td>76</td>
                                            <td>
                                                <button class="btn btn-sm btn-info" data-bs-toggle="modal" data-bs-target="#viewPublisherModal"><i class="fas fa-eye"></i></button>
                                                <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editPublisherModal"><i class="fas fa-edit"></i></button>
                                                <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deletePublisherModal"><i class="fas fa-trash"></i></button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>4</td>
                                            <td><img src="assets/img/publishers/nxb-hoi-nha-van.png" alt="NXB Hội Nhà Văn" class="img-fluid rounded" style="max-height: 60px;"></td>
                                            <td>Nhà xuất bản Hội Nhà Văn</td>
                                            <td>Hà Nội</td>
                                            <td>
                                                <strong>ĐT:</strong> 024.38222135<br>
                                                <strong>Email:</strong> nxbhoinhavan@gmail.com
                                            </td>
                                            <td>58</td>
                                            <td>
                                                <button class="btn btn-sm btn-info" data-bs-toggle="modal" data-bs-target="#viewPublisherModal"><i class="fas fa-eye"></i></button>
                                                <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editPublisherModal"><i class="fas fa-edit"></i></button>
                                                <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deletePublisherModal"><i class="fas fa-trash"></i></button>
                                            </td>
                                        </tr>
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

<!-- Add Publisher Modal -->
<div class="modal fade" id="addPublisherModal" tabindex="-1" aria-labelledby="addPublisherModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addPublisherModalLabel">Thêm nhà xuất bản mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="addPublisherForm">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="publisherName" class="form-label">Tên nhà xuất bản</label>
                                <input type="text" class="form-control" id="publisherName" name="publisherName" required>
                            </div>
                            <div class="mb-3">
                                <label for="publisherCity" class="form-label">Thành phố</label>
                                <select class="form-select" id="publisherCity" name="publisherCity">
                                    <option value="">Chọn thành phố</option>
                                    <option value="Hà Nội">Hà Nội</option>
                                    <option value="TP.HCM">TP.HCM</option>
                                    <option value="Đà Nẵng">Đà Nẵng</option>
                                    <option value="Cần Thơ">Cần Thơ</option>
                                    <option value="Khác">Khác</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="publisherAddress" class="form-label">Địa chỉ</label>
                                <textarea class="form-control" id="publisherAddress" name="publisherAddress" rows="3"></textarea>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="publisherPhone" class="form-label">Số điện thoại</label>
                                <input type="text" class="form-control" id="publisherPhone" name="publisherPhone">
                            </div>
                            <div class="mb-3">
                                <label for="publisherEmail" class="form-label">Email</label>
                                <input type="email" class="form-control" id="publisherEmail" name="publisherEmail">
                            </div>
                            <div class="mb-3">
                                <label for="publisherLogo" class="form-label">Logo</label>
                                <input type="file" class="form-control" id="publisherLogo" name="publisherLogo">
                            </div>
                            <div class="mb-3">
                                <label for="publisherWebsite" class="form-label">Website</label>
                                <input type="url" class="form-control" id="publisherWebsite" name="publisherWebsite">
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

<!-- View Publisher Modal -->
<div class="modal fade" id="viewPublisherModal" tabindex="-1" aria-labelledby="viewPublisherModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="viewPublisherModalLabel">Thông tin nhà xuất bản</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-4 text-center">
                        <img src="assets/img/publishers/nxb-kim-dong.png" alt="NXB Kim Đồng" class="img-fluid rounded mb-3" style="max-height: 150px;">
                        <h4>Nhà xuất bản Kim Đồng</h4>
                    </div>
                    <div class="col-md-8">
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Thành phố:</strong> Hà Nội</p>
                                <p><strong>Điện thoại:</strong> 024.39428653</p>
                                <p><strong>Email:</strong> info@nxbkimdong.com.vn</p>
                                <p><strong>Website:</strong> <a href="https://www.nxbkimdong.com.vn" target="_blank">www.nxbkimdong.com.vn</a></p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Số lượng sách:</strong> 128</p>
                                <p><strong>Ngày hợp tác:</strong> 15/05/2020</p>
                                <p><strong>Trạng thái:</strong> <span class="badge bg-success">Đang hoạt động</span></p>
                            </div>
                        </div>
                        <hr>
                        <p><strong>Địa chỉ:</strong></p>
                        <p>55 Quang Trung, Hai Bà Trưng, Hà Nội</p>
                        <hr>
                        <p><strong>Giới thiệu:</strong></p>
                        <p>Nhà xuất bản Kim Đồng là một trong những nhà xuất bản hàng đầu Việt Nam trong lĩnh vực sách thiếu nhi, truyện tranh và văn học thanh thiếu niên. Được thành lập từ năm 1957, NXB Kim Đồng đã trở thành người bạn thân thiết của nhiều thế hệ độc giả Việt Nam.</p>
                    </div>
                </div>
                <div class="row mt-4">
                    <div class="col-12">
                        <h5>Các sách nổi bật</h5>
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <div class="card h-100">
                                    <img src="assets/img/books/doraemon.jpg" class="card-img-top" alt="Doraemon">
                                    <div class="card-body">
                                        <h6 class="card-title">Doraemon</h6>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="card h-100">
                                    <img src="assets/img/books/than-dong-dat-viet.jpg" class="card-img-top" alt="Thần Đồng Đất Việt">
                                    <div class="card-body">
                                        <h6 class="card-title">Thần Đồng Đất Việt</h6>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="card h-100">
                                    <img src="assets/img/books/co-be-lo-lem.jpg" class="card-img-top" alt="Cô Bé Lọ Lem">
                                    <div class="card-body">
                                        <h6 class="card-title">Cô Bé Lọ Lem</h6>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="card h-100">
                                    <img src="assets/img/books/truyen-co-grimm.jpg" class="card-img-top" alt="Truyện Cổ Grimm">
                                    <div class="card-body">
                                        <h6 class="card-title">Truyện Cổ Grimm</h6>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<!-- Edit Publisher Modal -->
<div class="modal fade" id="editPublisherModal" tabindex="-1" aria-labelledby="editPublisherModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editPublisherModalLabel">Chỉnh sửa thông tin nhà xuất bản</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="editPublisherForm">
                    <input type="hidden" id="editPublisherId" name="publisherId" value="1">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="editPublisherName" class="form-label">Tên nhà xuất bản</label>
                                <input type="text" class="form-control" id="editPublisherName" name="publisherName" value="Nhà xuất bản Kim Đồng" required>
                            </div>
                            <div class="mb-3">
                                <label for="editPublisherCity" class="form-label">Thành phố</label>
                                <select class="form-select" id="editPublisherCity" name="publisherCity">
                                    <option value="Hà Nội" selected>Hà Nội</option>
                                    <option value="TP.HCM">TP.HCM</option>
                                    <option value="Đà Nẵng">Đà Nẵng</option>
                                    <option value="Cần Thơ">Cần Thơ</option>
                                    <option value="Khác">Khác</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="editPublisherAddress" class="form-label">Địa chỉ</label>
                                <textarea class="form-control" id="editPublisherAddress" name="publisherAddress" rows="3">55 Quang Trung, Hai Bà Trưng, Hà Nội</textarea>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="editPublisherPhone" class="form-label">Số điện thoại</label>
                                <input type="text" class="form-control" id="editPublisherPhone" name="publisherPhone" value="024.39428653">
                            </div>
                            <div class="mb-3">
                                <label for="editPublisherEmail" class="form-label">Email</label>
                                <input type="email" class="form-control" id="editPublisherEmail" name="publisherEmail" value="info@nxbkimdong.com.vn">
                            </div>
                            <div class="mb-3">
                                <label for="editPublisherLogo" class="form-label">Logo</label>
                                <input type="file" class="form-control" id="editPublisherLogo" name="publisherLogo">
                                <div class="form-text">Để trống nếu không muốn thay đổi logo.</div>
                                <div class="mt-2">
                                    <img src="assets/img/publishers/nxb-kim-dong.png" alt="Current logo" class="img-thumbnail" style="height: 80px;">
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="editPublisherWebsite" class="form-label">Website</label>
                                <input type="url" class="form-control" id="editPublisherWebsite" name="publisherWebsite" value="https://www.nxbkimdong.com.vn">
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

<!-- Delete Publisher Modal -->
<div class="modal fade" id="deletePublisherModal" tabindex="-1" aria-labelledby="deletePublisherModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deletePublisherModalLabel">Xác nhận xóa</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa nhà xuất bản này không? Hành động này không thể hoàn tác.</p>
                <p class="text-danger"><strong>Lưu ý:</strong> Việc xóa nhà xuất bản có thể ảnh hưởng đến các sách thuộc nhà xuất bản này.</p>
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle"></i> Hiện có 128 sách thuộc nhà xuất bản này.
                </div>
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