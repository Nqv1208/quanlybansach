<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - Nhà Sách Online</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/main.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/pages/user/cart.css" rel="stylesheet">
</head>
<body>
    <!-- Header -->
    <jsp:include page="/WEB-INF/views/user/includes/header.jsp" />

    <!-- Page Title -->
    <section class="page-title">
        <div class="container">
            <h1 class="text-center">Giỏ hàng</h1>
            <p class="text-center mb-0">Xem lại các sản phẩm bạn đã chọn</p>
        </div>
    </section>

    <!-- Cart Section -->
    <section class="container mb-5">
        <div class="row">
            <div class="col-lg-8">
                <div class="cart-container">
                    <div class="cart-header">
                        <h2 class="mb-0">Chi tiết giỏ hàng</h2>
                    </div>
                    
                    <c:if test="${empty cart || cart.size() == 0}">
                        <div class="empty-cart">
                            <i class="fas fa-shopping-cart empty-cart-icon"></i>
                            <h3>Giỏ hàng trống</h3>
                            <p>Bạn chưa có sản phẩm nào trong giỏ hàng.</p>
                            <a href="${pageContext.request.contextPath}/shop" class="btn btn-primary mt-3">Tiếp tục mua sắm</a>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty cart && cart.size() > 0}">
                        <div class="cart-items">
                            <c:forEach var="item" items="${cart}">
                                <div class="cart-item">
                                    <div class="item-select">
                                        <input type="checkbox" class="item-checkbox" data-id="${item.book.bookId}" data-price="${item.book.price}" data-quantity="${item.quantity}" checked>
                                    </div>
                                    <img src="${item.book.imageUrl}" alt="${item.book.title}" class="item-image">
                                    <div class="item-details">
                                        <h5 class="item-title">${item.book.title}</h5>
                                        <p class="item-author">${item.book.authorName}</p>
                                        <p class="item-price"><fmt:formatNumber value="${item.book.price}" type="currency" currencySymbol="" /> ₫</p>
                                    </div>
                                    <div class="d-flex align-items-center">
                                        <input type="hidden" name="bookId" value="${item.book.bookId}">
                                        <div class="quantity-control">
                                            <button type="button" class="quantity-btn decrease-btn" data-id="${item.book.bookId}">-</button>
                                            <input type="number" name="quantity" min="1" max="${item.book.stockQuantity}" value="${item.quantity}" class="quantity-input" data-id="${item.book.bookId}">
                                            <button type="button" class="quantity-btn increase-btn" data-id="${item.book.bookId}">+</button>
                                        </div>
                                        <div class="item-subtotal">
                                            <fmt:formatNumber value="${item.book.price * item.quantity}" type="currency" currencySymbol="" /> ₫
                                        </div>
                                        <button type="button" class="remove-btn" data-id="${item.book.bookId}">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <div class="d-flex justify-content-between align-items-center mt-4">
                            <a href="${pageContext.request.contextPath}/shop" class="btn btn-outline-primary">
                                <i class="fas fa-arrow-left me-2"></i> Tiếp tục mua sắm
                            </a>
                            <button type="button" id="clear-cart-btn" class="btn btn-outline-danger">
                                <i class="fas fa-trash me-2"></i> Xóa giỏ hàng
                            </button>
                        </div>
                    </c:if>
                </div>
            </div>
            
            <div class="col-lg-4">
                <div class="cart-summary">
                    <h3 class="summary-title">Tóm tắt đơn hàng</h3>
                    
                    <div class="summary-item">
                        <span>Tổng số sản phẩm:</span>
                        <span class="summary-value">${empty cartSummary ? 0 : cartSummary.itemCount}</span>
                    </div>
                    
                    <div class="summary-item">
                        <span>Tạm tính:</span>
                        <span class="summary-value"><fmt:formatNumber value="${empty cartSummary ? 0 : cartSummary.subtotal}" type="currency" currencySymbol="" /> ₫</span>
                    </div>
                    
                    <div class="summary-item">
                        <span>Phí vận chuyển:</span>
                        <span class="summary-value"><fmt:formatNumber value="${empty cartSummary ? 0 : cartSummary.shippingFee}" type="currency" currencySymbol="" /> ₫</span>
                    </div>
                    
                    <div class="summary-item">
                        <span>Giảm giá:</span>
                        <span class="summary-value">-<fmt:formatNumber value="${empty cartSummary ? 0 : cartSummary.discount}" type="currency" currencySymbol="" /> ₫</span>
                    </div>
                    
                    <div class="summary-item total">
                        <span>Tổng cộng:</span>
                        <span class="summary-value"><fmt:formatNumber value="${empty cartSummary ? 0 : cartSummary.total}" type="currency" currencySymbol="" /> ₫</span>
                    </div>
                    
                    <div class="coupon-section mt-3">
                        <label for="couponCode" class="form-label">Mã giảm giá</label>
                        <div class="coupon-form">
                            <input type="text" class="form-control coupon-input" id="couponCode" name="couponCode" placeholder="Nhập mã giảm giá">
                            <button type="button" id="apply-coupon-btn" class="btn btn-outline-primary">Áp dụng</button>
                        </div>
                    </div>
                    
                    <c:choose>
                        <c:when test="${empty cart || cart.size() == 0}">
                            <button class="btn btn-primary checkout-btn" disabled>
                                Thanh toán
                            </button>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/checkout" id="checkout-btn" class="btn btn-primary checkout-btn">
                                Tiến hành thanh toán
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/user/includes/footer.jsp" />
    
    <!-- Login Modal -->
    <jsp:include page="/WEB-INF/views/user/includes/login-modal.jsp" />

    <!-- Toast Notification -->
    <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
        <div id="cartToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header">
                <strong class="me-auto">Thông báo</strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body">
                Giỏ hàng đã được cập nhật
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JS -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const decreaseBtns = document.querySelectorAll('.decrease-btn');
            const increaseBtns = document.querySelectorAll('.increase-btn');
            const quantityInputs = document.querySelectorAll('.quantity-input');
            const itemCheckboxes = document.querySelectorAll('.item-checkbox');
            const removeBtns = document.querySelectorAll('.remove-btn');
            const clearCartBtn = document.getElementById('clear-cart-btn');
            const applyCouponBtn = document.getElementById('apply-coupon-btn');
            const cartToast = document.getElementById('cartToast');
            const toast = new bootstrap.Toast(cartToast);
            
            // Cập nhật hiển thị giá tiền của từng sản phẩm
            function updateItemSubtotal(id, quantity) {
                const checkbox = document.querySelector(`.item-checkbox[data-id="${id}"]`);
                if (!checkbox) return;
                
                const price = parseFloat(checkbox.getAttribute('data-price'));
                const subtotal = price * quantity;
                
                // Tìm phần tử hiển thị tổng tiền của sản phẩm
                const itemRow = checkbox.closest('.cart-item');
                const subtotalElement = itemRow.querySelector('.item-subtotal');
                
                if (subtotalElement) {
                    subtotalElement.textContent = new Intl.NumberFormat('vi-VN').format(subtotal) + ' ₫';
                }
            }
            
            // Cập nhật tổng quan giỏ hàng dựa trên các mục được chọn
            function updateCartSummary() {
                let totalItems = 0;
                let subtotal = 0;
                let shippingFee = parseFloat('${empty cartSummary ? 0 : cartSummary.shippingFee}');
                let discount = parseFloat('${empty cartSummary ? 0 : cartSummary.discount}');
                
                itemCheckboxes.forEach(checkbox => {
                    if (checkbox.checked) {
                        const price = parseFloat(checkbox.getAttribute('data-price'));
                        const quantity = parseInt(checkbox.getAttribute('data-quantity'));
                        totalItems += quantity;
                        subtotal += price * quantity;
                    }
                });
                
                const total = subtotal + shippingFee - discount;
                
                // Cập nhật hiển thị tổng quan
                const summaryValues = document.querySelectorAll('.summary-value');
                if (summaryValues.length >= 5) {
                    // Tổng số sản phẩm
                    summaryValues[0].textContent = totalItems;
                    // Tạm tính
                    summaryValues[1].textContent = new Intl.NumberFormat('vi-VN').format(subtotal) + ' ₫';
                    // Tổng cộng
                    summaryValues[4].textContent = new Intl.NumberFormat('vi-VN').format(total) + ' ₫';
                }
                
                // Vô hiệu hóa nút thanh toán nếu không có sản phẩm nào được chọn
                const checkoutBtn = document.getElementById('checkout-btn');
                if (checkoutBtn) {
                    if (totalItems === 0) {
                        checkoutBtn.classList.add('disabled');
                    } else {
                        checkoutBtn.classList.remove('disabled');
                    }
                }
                
                // Cập nhật form ẩn với các mục đã chọn
                updateSelectedItemsForm();
            }
            
            // Tạo form ẩn để chuyển các mục đã chọn đến trang thanh toán
            function updateSelectedItemsForm() {
                let selectedItems = [];
                itemCheckboxes.forEach(checkbox => {
                    if (checkbox.checked) {
                        selectedItems.push(checkbox.getAttribute('data-id'));
                    }
                });
                
                // Lưu các mục đã chọn vào session storage
                sessionStorage.setItem('selectedItems', JSON.stringify(selectedItems));
                
                // Cập nhật link thanh toán với các mục đã chọn
                const checkoutBtn = document.getElementById('checkout-btn');
                if (checkoutBtn) {
                    const baseUrl = '${pageContext.request.contextPath}/checkout';
                    checkoutBtn.href = baseUrl + '?items=' + selectedItems.join(',');
                }
            }
            
            // Hàm xử lý cập nhật số lượng sản phẩm
            function updateQuantity(id, newValue) {
                const input = document.querySelector(`.quantity-input[data-id="${id}"]`);
                if (!input) return;
                
                const max = parseInt(input.getAttribute('max'), 10);
                let value = parseInt(newValue, 10);
                
                // Đảm bảo giá trị nằm trong khoảng hợp lệ
                if (value < 1) {
                    value = 1;
                } else if (value > max) {
                    value = max;
                }
                
                // Cập nhật giá trị hiển thị
                input.value = value;
                
                // Cập nhật thuộc tính data-quantity của checkbox
                const checkbox = document.querySelector(`.item-checkbox[data-id="${id}"]`);
                if (checkbox) {
                    checkbox.setAttribute('data-quantity', value);
                    updateItemSubtotal(id, value);
                    
                    if (checkbox.checked) {
                        updateCartSummary();
                    }
                }
                
                // Gửi yêu cầu AJAX để cập nhật giỏ hàng
                updateCartWithAjax(id, value);
            }
            
            // Hàm gửi yêu cầu AJAX để cập nhật giỏ hàng
            function updateCartWithAjax(bookId, quantity) {
                // Hiển thị hiệu ứng loading
                const loadingOverlay = document.createElement('div');
                loadingOverlay.className = 'loading-overlay';
                loadingOverlay.innerHTML = '<div class="spinner-border text-primary" role="status"><span class="visually-hidden">Đang tải...</span></div>';
                document.body.appendChild(loadingOverlay);
                
                // Tạo FormData
                const formData = new FormData();
                formData.append('bookId', bookId);
                formData.append('quantity', quantity);
                
                // Gửi yêu cầu AJAX
                fetch('${pageContext.request.contextPath}/cart/update', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Lỗi khi cập nhật giỏ hàng');
                    }
                    return response.json();
                })
                .then(data => {
                    // Xóa hiệu ứng loading
                    document.body.removeChild(loadingOverlay);
                    
                    // Hiển thị thông báo thành công
                    document.querySelector('.toast-body').textContent = 'Giỏ hàng đã được cập nhật';
                    toast.show();
                })
                .catch(error => {
                    console.error('Lỗi:', error);
                    // Xóa hiệu ứng loading
                    document.body.removeChild(loadingOverlay);
                    
                    // Hiển thị thông báo lỗi
                    document.querySelector('.toast-body').textContent = 'Có lỗi xảy ra khi cập nhật giỏ hàng';
                    toast.show();
                });
            }
            
            // Hàm xóa sản phẩm khỏi giỏ hàng
            function removeFromCart(bookId) {
                // Hiển thị hiệu ứng loading
                const loadingOverlay = document.createElement('div');
                loadingOverlay.className = 'loading-overlay';
                loadingOverlay.innerHTML = '<div class="spinner-border text-primary" role="status"><span class="visually-hidden">Đang tải...</span></div>';
                document.body.appendChild(loadingOverlay);
                
                // Tạo FormData
                const formData = new FormData();
                formData.append('bookId', bookId);
                
                // Gửi yêu cầu AJAX
                fetch('${pageContext.request.contextPath}/cart/remove', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Lỗi khi xóa sản phẩm');
                    }
                    return response.json();
                })
                .then(data => {
                    // Xóa hiệu ứng loading
                    document.body.removeChild(loadingOverlay);
                    
                    // Xóa sản phẩm khỏi giao diện
                    const itemElement = document.querySelector(`.item-checkbox[data-id="${bookId}"]`).closest('.cart-item');
                    if (itemElement) {
                        itemElement.remove();
                    }
                    
                    // Cập nhật tổng quan giỏ hàng
                    updateCartSummary();
                    
                    // Kiểm tra nếu giỏ hàng trống
                    const cartItems = document.querySelectorAll('.cart-item');
                    if (cartItems.length === 0) {
                        location.reload(); // Tải lại trang để hiển thị giỏ hàng trống
                    }
                    
                    // Hiển thị thông báo thành công
                    document.querySelector('.toast-body').textContent = 'Sản phẩm đã được xóa khỏi giỏ hàng';
                    toast.show();
                })
                .catch(error => {
                    console.error('Lỗi:', error);
                    // Xóa hiệu ứng loading
                    document.body.removeChild(loadingOverlay);
                    
                    // Hiển thị thông báo lỗi
                    document.querySelector('.toast-body').textContent = 'Có lỗi xảy ra khi xóa sản phẩm';
                    toast.show();
                });
            }
            
            // Hàm xóa toàn bộ giỏ hàng
            function clearCart() {
                // Hiển thị hiệu ứng loading
                const loadingOverlay = document.createElement('div');
                loadingOverlay.className = 'loading-overlay';
                loadingOverlay.innerHTML = '<div class="spinner-border text-primary" role="status"><span class="visually-hidden">Đang tải...</span></div>';
                document.body.appendChild(loadingOverlay);
                
                // Gửi yêu cầu AJAX
                fetch('${pageContext.request.contextPath}/cart/clear', {
                    method: 'POST'
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Lỗi khi xóa giỏ hàng');
                    }
                    return response.json();
                })
                .then(data => {
                    // Xóa hiệu ứng loading
                    document.body.removeChild(loadingOverlay);
                    
                    // Tải lại trang
                    location.reload();
                })
                .catch(error => {
                    console.error('Lỗi:', error);
                    // Xóa hiệu ứng loading
                    document.body.removeChild(loadingOverlay);
                    
                    // Hiển thị thông báo lỗi
                    document.querySelector('.toast-body').textContent = 'Có lỗi xảy ra khi xóa giỏ hàng';
                    toast.show();
                });
            }
            
            // Hàm áp dụng mã giảm giá
            function applyCoupon() {
                const couponCode = document.getElementById('couponCode').value.trim();
                if (!couponCode) {
                    document.querySelector('.toast-body').textContent = 'Vui lòng nhập mã giảm giá';
                    toast.show();
                    return;
                }
                
                // Hiển thị hiệu ứng loading
                const loadingOverlay = document.createElement('div');
                loadingOverlay.className = 'loading-overlay';
                loadingOverlay.innerHTML = '<div class="spinner-border text-primary" role="status"><span class="visually-hidden">Đang tải...</span></div>';
                document.body.appendChild(loadingOverlay);
                
                // Tạo FormData
                const formData = new FormData();
                formData.append('couponCode', couponCode);
                
                // Gửi yêu cầu AJAX
                fetch('${pageContext.request.contextPath}/cart/apply-coupon', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Lỗi khi áp dụng mã giảm giá');
                    }
                    return response.json();
                })
                .then(data => {
                    // Xóa hiệu ứng loading
                    document.body.removeChild(loadingOverlay);
                    
                    if (data.success) {
                        // Cập nhật giảm giá và tổng cộng
                        const summaryValues = document.querySelectorAll('.summary-value');
                        if (summaryValues.length >= 5) {
                            // Giảm giá
                            summaryValues[3].textContent = '-' + new Intl.NumberFormat('vi-VN').format(data.discount) + ' ₫';
                            // Tổng cộng
                            summaryValues[4].textContent = new Intl.NumberFormat('vi-VN').format(data.total) + ' ₫';
                        }
                        
                        // Hiển thị thông báo thành công
                        document.querySelector('.toast-body').textContent = 'Mã giảm giá đã được áp dụng';
                        toast.show();
                    } else {
                        // Hiển thị thông báo lỗi
                        document.querySelector('.toast-body').textContent = data.message || 'Mã giảm giá không hợp lệ';
                        toast.show();
                    }
                })
                .catch(error => {
                    console.error('Lỗi:', error);
                    // Xóa hiệu ứng loading
                    document.body.removeChild(loadingOverlay);
                    
                    // Hiển thị thông báo lỗi
                    document.querySelector('.toast-body').textContent = 'Có lỗi xảy ra khi áp dụng mã giảm giá';
                    toast.show();
                });
            }
            
            // Thêm event listeners cho các nút giảm
            decreaseBtns.forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.preventDefault(); // Ngăn chặn hành vi mặc định
                    const id = this.getAttribute('data-id');
                    const input = document.querySelector(`.quantity-input[data-id="${id}"]`);
                    let value = parseInt(input.value, 10);
                    if (value > 1) {
                        updateQuantity(id, value - 1);
                    }
                });
            });
            
            // Thêm event listeners cho các nút tăng
            increaseBtns.forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.preventDefault(); // Ngăn chặn hành vi mặc định
                    const id = this.getAttribute('data-id');
                    const input = document.querySelector(`.quantity-input[data-id="${id}"]`);
                    let value = parseInt(input.value, 10);
                    const max = parseInt(input.getAttribute('max'), 10);
                    if (value < max) {
                        updateQuantity(id, value + 1);
                    }
                });
            });
            
            // Thêm event listeners cho các trường nhập số lượng
            quantityInputs.forEach(input => {
                input.addEventListener('change', function() {
                    const id = this.getAttribute('data-id');
                    updateQuantity(id, this.value);
                });
                
                // Ngăn chặn nhập giá trị không hợp lệ
                input.addEventListener('input', function() {
                    this.value = this.value.replace(/[^0-9]/g, '');
                    if (this.value === '') {
                        this.value = '1';
                    }
                });
            });
            
            // Thêm event listeners cho các checkbox
            itemCheckboxes.forEach(checkbox => {
                checkbox.addEventListener('change', updateCartSummary);
            });
            
            // Thêm event listeners cho các nút xóa
            removeBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const id = this.getAttribute('data-id');
                    removeFromCart(id);
                });
            });
            
            // Thêm event listener cho nút xóa giỏ hàng
            if (clearCartBtn) {
                clearCartBtn.addEventListener('click', clearCart);
            }
            
            // Thêm event listener cho nút áp dụng mã giảm giá
            if (applyCouponBtn) {
                applyCouponBtn.addEventListener('click', applyCoupon);
            }
            
            // Khởi tạo tổng quan giỏ hàng
            updateCartSummary();
            
            // Cập nhật ban đầu hiển thị tổng tiền cho mỗi sản phẩm
            itemCheckboxes.forEach(checkbox => {
                const id = checkbox.getAttribute('data-id');
                const quantity = parseInt(checkbox.getAttribute('data-quantity'));
                updateItemSubtotal(id, quantity);
            });
        });
    </script>
</body>
</html> 