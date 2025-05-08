<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán - Nhà Sách Online</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Main CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <!-- Page-specific CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/user/checkout.css">
</head>
<body>
    <!-- Header -->
    <jsp:include page="/WEB-INF/views/user/includes/header.jsp" />

    <!-- Page Title -->
    <section class="page-title">
        <div class="container">
            <h1 class="text-center">Thanh toán</h1>
            <p class="text-center mb-0">Hoàn tất đơn hàng của bạn</p>
        </div>
    </section>

    <!-- Checkout Steps -->
    <div class="container mb-4">
        <div class="checkout-steps">
            <div class="step completed">
                <div class="step-icon">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <p class="step-title">Giỏ hàng</p>
            </div>
            <div class="step active">
                <div class="step-icon">
                    <i class="fas fa-address-card"></i>
                </div>
                <p class="step-title">Thông tin</p>
            </div>
            <div class="step">
                <div class="step-icon">
                    <i class="fas fa-credit-card"></i>
                </div>
                <p class="step-title">Thanh toán</p>
            </div>
            <div class="step">
                <div class="step-icon">
                    <i class="fas fa-check"></i>
                </div>
                <p class="step-title">Hoàn tất</p>
            </div>
        </div>
    </div>

    <!-- Checkout Section -->
    <section class="container mb-5">
        <div class="row">
            <div class="col-lg-8">
                <form action="${pageContext.request.contextPath}/user/checkout/place-order" method="post" id="checkoutForm">
                    <!-- Shipping Information -->
                    <div class="checkout-container mb-4">
                        <h3 class="checkout-section-title">Thông tin giao hàng</h3>
                        
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="fullName" class="form-label">Họ và tên</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" value="${sessionScope.user.fullName}" required>
                            </div>
                            <div class="col-md-6">
                                <label for="phone" class="form-label">Số điện thoại</label>
                                <input type="tel" class="form-control" id="phone" name="phone" value="${sessionScope.user.phone}" required>
                            </div>
                            <div class="col-12">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" value="${sessionScope.user.email}" required>
                            </div>
                            <div class="col-12">
                                <label for="address" class="form-label">Địa chỉ</label>
                                <input type="text" class="form-control" id="address" name="address" value="${sessionScope.user.address}" required>
                            </div>
                            <div class="col-md-4">
                                <label for="province" class="form-label">Tỉnh/Thành phố</label>
                                <select class="form-select" id="province" name="province" required>
                                    <option value="">Chọn Tỉnh/Thành phố</option>
                                    <option value="HN" ${sessionScope.user.province == 'HN' ? 'selected' : ''}>Hà Nội</option>
                                    <option value="HCM" ${sessionScope.user.province == 'HCM' ? 'selected' : ''}>TP. Hồ Chí Minh</option>
                                    <option value="DN" ${sessionScope.user.province == 'DN' ? 'selected' : ''}>Đà Nẵng</option>
                                    <option value="HP" ${sessionScope.user.province == 'HP' ? 'selected' : ''}>Hải Phòng</option>
                                    <option value="CT" ${sessionScope.user.province == 'CT' ? 'selected' : ''}>Cần Thơ</option>
                                    <!-- Thêm các tỉnh khác -->
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="district" class="form-label">Quận/Huyện</label>
                                <input type="text" class="form-control" id="district" name="district" value="${sessionScope.user.district}" required>
                            </div>
                            <div class="col-md-4">
                                <label for="ward" class="form-label">Phường/Xã</label>
                                <input type="text" class="form-control" id="ward" name="ward" value="${sessionScope.user.ward}" required>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Shipping Method -->
                    <div class="checkout-container mb-4">
                        <h3 class="checkout-section-title">Phương thức vận chuyển</h3>
                        <div class="mb-3">
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="radio" name="shippingMethod" id="shippingStandard" value="standard" checked>
                                <label class="form-check-label" for="shippingStandard">
                                    <span class="fw-bold">Giao hàng tiêu chuẩn</span> - 30.000₫ (2-3 ngày)
                                </label>
                            </div>
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="radio" name="shippingMethod" id="shippingFast" value="fast">
                                <label class="form-check-label" for="shippingFast">
                                    <span class="fw-bold">Giao hàng nhanh</span> - 50.000₫ (1-2 ngày)
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="shippingMethod" id="shippingExpress" value="express">
                                <label class="form-check-label" for="shippingExpress">
                                    <span class="fw-bold">Giao hàng hỏa tốc</span> - 80.000₫ (trong ngày)
                                </label>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Payment Method -->
                    <div class="checkout-container">
                        <h3 class="checkout-section-title">Phương thức thanh toán</h3>
                        
                        <div class="payment-method active" data-payment="cod">
                            <div class="d-flex align-items-center">
                                <input type="radio" class="payment-method-radio" name="paymentMethod" id="paymentCod" value="cod" checked>
                                <div>
                                    <h5 class="payment-method-title">Thanh toán khi nhận hàng (COD)</h5>
                                    <p class="payment-method-description">Quý khách sẽ thanh toán bằng tiền mặt khi nhận được hàng.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="payment-method" data-payment="bank-transfer">
                            <div class="d-flex align-items-center">
                                <input type="radio" class="payment-method-radio" name="paymentMethod" id="paymentBank" value="bank-transfer">
                                <div>
                                    <h5 class="payment-method-title">Chuyển khoản ngân hàng</h5>
                                    <p class="payment-method-description">Quý khách vui lòng chuyển khoản theo thông tin bên dưới.</p>
                                </div>
                            </div>
                            <div class="bank-details mt-2 ps-4" style="display: none;">
                                <div class="alert alert-info">
                                    <p class="mb-1"><strong>Tên ngân hàng:</strong> Vietcombank</p>
                                    <p class="mb-1"><strong>Số tài khoản:</strong> 1234567890</p>
                                    <p class="mb-1"><strong>Chủ tài khoản:</strong> CÔNG TY TNHH NHÀ SÁCH ONLINE</p>
                                    <p class="mb-0"><strong>Nội dung:</strong> Thanh toan don hang #${orderCode}</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="payment-method" data-payment="momo">
                            <div class="d-flex align-items-center">
                                <input type="radio" class="payment-method-radio" name="paymentMethod" id="paymentMomo" value="momo">
                                <div>
                                    <h5 class="payment-method-title">Ví điện tử MoMo</h5>
                                    <p class="payment-method-description">Thanh toán an toàn qua ví điện tử MoMo.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="payment-method" data-payment="credit-card">
                            <div class="d-flex align-items-center">
                                <input type="radio" class="payment-method-radio" name="paymentMethod" id="paymentCard" value="credit-card">
                                <div>
                                    <h5 class="payment-method-title">Thẻ tín dụng / Ghi nợ</h5>
                                    <p class="payment-method-description">Thanh toán an toàn qua cổng OnePay.</p>
                                </div>
                            </div>
                            <div class="card-payment-form mt-3 ps-4" style="display: none;">
                                <div class="row g-3">
                                    <div class="col-12">
                                        <label for="cardNumber" class="form-label">Số thẻ</label>
                                        <input type="text" class="form-control" id="cardNumber" placeholder="1234 5678 9012 3456">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="cardExpiry" class="form-label">Ngày hết hạn</label>
                                        <input type="text" class="form-control" id="cardExpiry" placeholder="MM/YY">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="cardCvc" class="form-label">Mã bảo mật (CVC)</label>
                                        <input type="text" class="form-control" id="cardCvc" placeholder="123">
                                    </div>
                                    <div class="col-12">
                                        <label for="cardName" class="form-label">Tên chủ thẻ</label>
                                        <input type="text" class="form-control" id="cardName" placeholder="NGUYEN VAN A">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            
            <div class="col-lg-4">
                <div class="summary-container">
                    <h3 class="summary-title">Tóm tắt đơn hàng</h3>
                    
                    <div class="order-items mb-4">
                        <c:forEach var="item" items="${cart}">
                            <div class="order-item">
                                <img src="${item.book.imageUrl}" alt="${item.book.title}" class="item-image">
                                <div class="item-details">
                                    <h6 class="item-title">${item.book.title}</h6>
                                    <p class="item-quantity">SL: ${item.quantity}</p>
                                </div>
                                <div class="item-price">
                                    <fmt:formatNumber value="${item.book.price * item.quantity}" type="currency" currencySymbol="" /> ₫
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <div class="summary-item">
                        <span>Tạm tính:</span>
                        <span><fmt:formatNumber value="${cartSummary.subtotal}" type="currency" currencySymbol="" /> ₫</span>
                    </div>
                    
                    <div class="summary-item">
                        <span>Phí vận chuyển:</span>
                        <span id="shippingFee"><fmt:formatNumber value="${cartSummary.shippingFee}" type="currency" currencySymbol="" /> ₫</span>
                    </div>
                    
                    <div class="summary-item">
                        <span>Giảm giá:</span>
                        <span>-<fmt:formatNumber value="${cartSummary.discount}" type="currency" currencySymbol="" /> ₫</span>
                    </div>
                    
                    <div class="summary-item total">
                        <span>Tổng cộng:</span>
                        <span id="totalAmount"><fmt:formatNumber value="${cartSummary.total}" type="currency" currencySymbol="" /> ₫</span>
                    </div>
                    
                    <div class="coupon-section mt-3">
                        <c:if test="${not empty couponApplied}">
                            <div class="alert alert-success p-2 mb-3">
                                <small><i class="fas fa-tag me-2"></i>Đã áp dụng mã <strong>${couponApplied.code}</strong></small>
                            </div>
                        </c:if>
                    </div>
                    
                    <button type="submit" form="checkoutForm" class="btn btn-primary place-order-btn">
                        Đặt hàng
                    </button>
                    
                    <div class="text-center mt-3">
                        <small>Bằng cách đặt hàng, bạn đồng ý với <a href="#">Điều khoản</a> của chúng tôi</small>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/user/includes/footer.jsp" />

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JS -->
    <script>
        // Payment method selection
        const paymentMethods = document.querySelectorAll('.payment-method');
        const paymentRadios = document.querySelectorAll('.payment-method-radio');
        
        paymentMethods.forEach(method => {
            method.addEventListener('click', function() {
                // Clear active class from all methods
                paymentMethods.forEach(m => m.classList.remove('active'));
                
                // Add active class to clicked method
                this.classList.add('active');
                
                // Check the radio button
                const radio = this.querySelector('input[type="radio"]');
                radio.checked = true;
                
                // Hide all expandable content
                document.querySelector('.bank-details').style.display = 'none';
                document.querySelector('.card-payment-form').style.display = 'none';
                
                // Show the appropriate expandable content
                const paymentType = this.getAttribute('data-payment');
                if (paymentType === 'bank-transfer') {
                    document.querySelector('.bank-details').style.display = 'block';
                } else if (paymentType === 'credit-card') {
                    document.querySelector('.card-payment-form').style.display = 'block';
                }
            });
        });
        
        // Shipping method change
        const shippingRadios = document.querySelectorAll('input[name="shippingMethod"]');
        const shippingFeeDisplay = document.getElementById('shippingFee');
        const totalAmountDisplay = document.getElementById('totalAmount');
        const subtotal = Number('${cartSummary.subtotal}');
        const discount = Number('${cartSummary.discount}');
        
        shippingRadios.forEach(radio => {
            radio.addEventListener('change', function() {
                let shippingFee = 30000; // Default standard shipping
                
                if (this.value === 'fast') {
                    shippingFee = 50000;
                } else if (this.value === 'express') {
                    shippingFee = 80000;
                }
                
                const total = subtotal + shippingFee - discount;
                
                // Update display
                shippingFeeDisplay.textContent = new Intl.NumberFormat('vi-VN').format(shippingFee) + ' ₫';
                totalAmountDisplay.textContent = new Intl.NumberFormat('vi-VN').format(total) + ' ₫';
            });
        });
    </script>
</body>
</html> 