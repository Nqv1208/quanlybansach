<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh giá sản phẩm - Nhà Sách Online</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Main CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <!-- Page-specific CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/user/review.css">
</head>
<body>
    <!-- Header -->
    <jsp:include page="/WEB-INF/views/user/includes/header.jsp" />

    <!-- Page Title -->
    <section class="page-title">
        <div class="container">
            <h1 class="text-center">Đánh giá sản phẩm</h1>
            <p class="text-center mb-0">Chia sẻ trải nghiệm của bạn về sản phẩm đã mua</p>
        </div>
    </section>

    <!-- Review Section -->
    <section class="container mb-5">
        <div class="review-container">
            <div class="order-summary mb-4">
                <h4>Đơn hàng #${order.code}</h4>
                <p class="order-date">Ngày đặt: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy" /></p>
                <p class="order-date">Ngày giao: <fmt:formatDate value="${order.deliveredDate}" pattern="dd/MM/yyyy" /></p>
            </div>
            
            <form action="${pageContext.request.contextPath}/user/orders/review/submit" method="post" id="reviewForm">
                <input type="hidden" name="orderId" value="${order.id}">
                
                <!-- Overall Rating -->
                <div class="overall-rating mb-4">
                    <h5>Đánh giá tổng thể về đơn hàng</h5>
                    <div class="rating-area">
                        <div class="rating-stars">
                            <input type="radio" id="overall-5" name="overallRating" value="5">
                            <label for="overall-5"></label>
                            <input type="radio" id="overall-4" name="overallRating" value="4">
                            <label for="overall-4"></label>
                            <input type="radio" id="overall-3" name="overallRating" value="3" checked>
                            <label for="overall-3"></label>
                            <input type="radio" id="overall-2" name="overallRating" value="2">
                            <label for="overall-2"></label>
                            <input type="radio" id="overall-1" name="overallRating" value="1">
                            <label for="overall-1"></label>
                        </div>
                        <div class="rating-text">Chọn số sao để đánh giá</div>
                    </div>
                    
                    <div class="form-group mt-3">
                        <label for="orderComment" class="form-label">Nhận xét về đơn hàng</label>
                        <textarea class="form-control" id="orderComment" name="orderComment" rows="3" placeholder="Chia sẻ trải nghiệm mua hàng của bạn..."></textarea>
                    </div>
                </div>
                
                <!-- Product Ratings -->
                <h5 class="mb-3">Đánh giá sản phẩm</h5>
                <c:forEach var="item" items="${order.orderItems}">
                    <div class="product-review-item">
                        <div class="d-flex align-items-center mb-3">
                            <img src="${item.book.imageUrl}" alt="${item.book.title}" class="product-image">
                            <div class="product-details">
                                <h6 class="product-title">${item.book.title}</h6>
                                <p class="product-author">${item.book.authorName}</p>
                            </div>
                        </div>
                        
                        <div class="rating-area mb-3">
                            <div class="rating-label">Đánh giá sản phẩm:</div>
                            <div class="rating-stars">
                                <input type="radio" id="product-${item.orderDetailId}-5" name="productRating-${item.orderDetailId}" value="5">
                                <label for="product-${item.orderDetailId}-5"></label>
                                <input type="radio" id="product-${item.orderDetailId}-4" name="productRating-${item.orderDetailId}" value="4">
                                <label for="product-${item.orderDetailId}-4"></label>
                                <input type="radio" id="product-${item.orderDetailId}-3" name="productRating-${item.orderDetailId}" value="3" checked>
                                <label for="product-${item.orderDetailId}-3"></label>
                                <input type="radio" id="product-${item.orderDetailId}-2" name="productRating-${item.orderDetailId}" value="2">
                                <label for="product-${item.orderDetailId}-2"></label>
                                <input type="radio" id="product-${item.orderDetailId}-1" name="productRating-${item.orderDetailId}" value="1">
                                <label for="product-${item.orderDetailId}-1"></label>
                            </div>
                        </div>
                        
                        <div class="form-group mb-3">
                            <label for="productComment-${item.orderDetailId}" class="form-label">Nhận xét về sản phẩm</label>
                            <textarea class="form-control" id="productComment-${item.orderDetailId}" name="productComment-${item.orderDetailId}" rows="3" placeholder="Chia sẻ ý kiến của bạn về sản phẩm này..."></textarea>
                        </div>
                        
                        <div class="form-group mb-4">
                            <label class="form-label">Tải lên hình ảnh sản phẩm (tùy chọn)</label>
                            <input type="file" class="form-control" name="productImages-${item.orderDetailId}" multiple accept="image/*">
                            <div class="form-text">Bạn có thể tải lên tối đa 3 hình ảnh (mỗi ảnh không quá 2MB)</div>
                        </div>
                    </div>
                </c:forEach>
                
                <!-- Shipping and Service Rating -->
                <div class="service-rating mt-4">
                    <h5 class="mb-3">Đánh giá dịch vụ</h5>
                    
                    <div class="rating-row">
                        <div class="rating-label">Đóng gói sản phẩm:</div>
                        <div class="rating-stars">
                            <input type="radio" id="packaging-5" name="packagingRating" value="5">
                            <label for="packaging-5"></label>
                            <input type="radio" id="packaging-4" name="packagingRating" value="4" checked>
                            <label for="packaging-4"></label>
                            <input type="radio" id="packaging-3" name="packagingRating" value="3">
                            <label for="packaging-3"></label>
                            <input type="radio" id="packaging-2" name="packagingRating" value="2">
                            <label for="packaging-2"></label>
                            <input type="radio" id="packaging-1" name="packagingRating" value="1">
                            <label for="packaging-1"></label>
                        </div>
                    </div>
                    
                    <div class="rating-row">
                        <div class="rating-label">Thời gian giao hàng:</div>
                        <div class="rating-stars">
                            <input type="radio" id="delivery-5" name="deliveryRating" value="5">
                            <label for="delivery-5"></label>
                            <input type="radio" id="delivery-4" name="deliveryRating" value="4" checked>
                            <label for="delivery-4"></label>
                            <input type="radio" id="delivery-3" name="deliveryRating" value="3">
                            <label for="delivery-3"></label>
                            <input type="radio" id="delivery-2" name="deliveryRating" value="2">
                            <label for="delivery-2"></label>
                            <input type="radio" id="delivery-1" name="deliveryRating" value="1">
                            <label for="delivery-1"></label>
                        </div>
                    </div>
                    
                    <div class="rating-row">
                        <div class="rating-label">Thái độ nhân viên giao hàng:</div>
                        <div class="rating-stars">
                            <input type="radio" id="courier-5" name="courierRating" value="5">
                            <label for="courier-5"></label>
                            <input type="radio" id="courier-4" name="courierRating" value="4" checked>
                            <label for="courier-4"></label>
                            <input type="radio" id="courier-3" name="courierRating" value="3">
                            <label for="courier-3"></label>
                            <input type="radio" id="courier-2" name="courierRating" value="2">
                            <label for="courier-2"></label>
                            <input type="radio" id="courier-1" name="courierRating" value="1">
                            <label for="courier-1"></label>
                        </div>
                    </div>
                </div>
                
                <!-- Form Actions -->
                <div class="form-actions mt-4 d-flex justify-content-between">
                    <a href="${pageContext.request.contextPath}/user/orders/detail?id=${order.id}" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-2"></i> Quay lại
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane me-2"></i> Gửi đánh giá
                    </button>
                </div>
            </form>
        </div>
    </section>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/user/includes/footer.jsp" />

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JS -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Display selected star rating text
            const ratingStars = document.querySelectorAll('.rating-stars input');
            
            ratingStars.forEach(star => {
                star.addEventListener('change', function() {
                    const ratingText = this.closest('.rating-area').querySelector('.rating-text');
                    if (ratingText) {
                        const value = parseInt(this.value);
                        let text = '';
                        
                        switch(value) {
                            case 1:
                                text = 'Rất không hài lòng';
                                break;
                            case 2:
                                text = 'Không hài lòng';
                                break;
                            case 3:
                                text = 'Bình thường';
                                break;
                            case 4:
                                text = 'Hài lòng';
                                break;
                            case 5:
                                text = 'Rất hài lòng';
                                break;
                        }
                        
                        ratingText.textContent = text;
                    }
                });
            });
            
            // Form validation
            const reviewForm = document.getElementById('reviewForm');
            
            reviewForm.addEventListener('submit', function(e) {
                let isValid = true;
                let comment = document.getElementById('orderComment').value.trim();
                
                if (comment.length < 5) {
                    alert('Vui lòng nhập nhận xét về đơn hàng (ít nhất 5 ký tự)');
                    isValid = false;
                }
                
                if (!isValid) {
                    e.preventDefault();
                }
            });
        });
    </script>
</body>
</html> 