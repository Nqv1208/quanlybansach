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
    <div class="container mb-5">
        <div class="checkout-steps d-flex justify-content-between py-4">
            <div class="step completed d-flex flex-column align-items-center">
                <div class="step-icon rounded-circle d-flex justify-content-center align-items-center bg-success text-white">
                    <i class="fas fa-shopping-cart fs-5"></i>
                </div>
                <p class="step-title mt-3 mb-0 text-success fw-medium">Giỏ hàng</p>
            </div>
            <div class="progress-line flex-grow-1 mx-3 my-auto" style="height: 4px; background-color: #ddd;">
                <div class="progress-fill bg-success" style="width: 100%; height: 100%;"></div>
            </div>
            <div class="step active d-flex flex-column align-items-center">
                <div class="step-icon rounded-circle d-flex justify-content-center align-items-center bg-primary text-white">
                    <i class="fas fa-address-card fs-5"></i>
                </div>
                <p class="step-title mt-3 mb-0 text-primary fw-medium">Thông tin</p>
            </div>
            <div class="progress-line flex-grow-1 mx-3 my-auto" style="height: 4px; background-color: #ddd;">
                <div class="progress-fill" style="width: 0%; height: 100%;"></div>
            </div>
            <div class="step d-flex flex-column align-items-center">
                <div class="step-icon rounded-circle d-flex justify-content-center align-items-center" style="background-color: #e9ecef;">
                    <i class="fas fa-credit-card fs-5"></i>
                </div>
                <p class="step-title mt-3 mb-0 text-secondary fw-medium">Thanh toán</p>
            </div>
            <div class="progress-line flex-grow-1 mx-3 my-auto" style="height: 4px; background-color: #ddd;">
                <div class="progress-fill" style="width: 0%; height: 100%;"></div>
            </div>
            <div class="step d-flex flex-column align-items-center">
                <div class="step-icon rounded-circle d-flex justify-content-center align-items-center" style="background-color: #e9ecef;">
                    <i class="fas fa-check fs-5"></i>
                </div>
                <p class="step-title mt-3 mb-0 text-secondary fw-medium">Hoàn tất</p>
            </div>
        </div>
    </div>

    <!-- Checkout Section -->
    <section class="container mb-5">
        <div class="row g-4">
            <div class="col-lg-8">
                <form action="${pageContext.request.contextPath}/checkout/place-order" method="post" id="checkoutForm">
                    <!-- Shipping Information -->
                    <div class="checkout-container mb-4 bg-white p-4 rounded shadow">
                        <h3 class="checkout-section-title border-bottom pb-3 mb-4"><i class="fas fa-map-marker-alt me-2 text-primary"></i>Thông tin giao hàng</h3>
                        
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="fullName" class="form-label fw-medium">Họ và tên</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" value="${sessionScope.customer.name}" required>
                            </div>
                            <div class="col-md-6">
                                <label for="phone" class="form-label fw-medium">Số điện thoại</label>
                                <input type="tel" class="form-control" id="phone" name="phone" value="${sessionScope.customer.phone}" required>
                            </div>
                            <div class="col-12">
                                <label for="email" class="form-label fw-medium">Email</label>
                                <input type="email" class="form-control" id="email" name="email" value="${sessionScope.customer.email}" required>
                            </div>
                            <div class="col-12">
                                <label for="address" class="form-label fw-medium">Địa chỉ</label>
                                <input type="text" class="form-control" id="address" name="address" value="${sessionScope.customer.address}" required>
                            </div>
                            <div class="col-md-4">
                                <label for="province" class="form-label fw-medium">Tỉnh/Thành phố</label>
                                <select class="form-select" id="province" name="province" required>
                                    <option value="">Chọn Tỉnh/Thành phố</option>
                                    <option value="HN" ${sessionScope.customer.address == 'HN' ? 'selected' : ''}>Hà Nội</option>
                                    <option value="HCM" ${sessionScope.customer.address == 'HCM' ? 'selected' : ''}>TP. Hồ Chí Minh</option>
                                    <option value="DN" ${sessionScope.customer.address == 'DN' ? 'selected' : ''}>Đà Nẵng</option>
                                    <option value="HP" ${sessionScope.customer.address == 'HP' ? 'selected' : ''}>Hải Phòng</option>
                                    <option value="CT" ${sessionScope.customer.address == 'CT' ? 'selected' : ''}>Cần Thơ</option>
                                    <!-- Thêm các tỉnh khác -->
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="district" class="form-label fw-medium">Quận/Huyện</label>
                                <input type="text" class="form-control" id="district" name="district" value="${sessionScope.user.district}" required>
                            </div>
                            <div class="col-md-4">
                                <label for="ward" class="form-label fw-medium">Phường/Xã</label>
                                <input type="text" class="form-control" id="ward" name="ward" value="${sessionScope.user.ward}" required>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Shipping Method -->
                    <div class="checkout-container mb-4 bg-white p-4 rounded shadow">
                        <h3 class="checkout-section-title border-bottom pb-3 mb-4"><i class="fas fa-truck me-2 text-primary"></i>Phương thức vận chuyển</h3>
                        
                        <div class="shipping-options">
                            <div class="shipping-option border rounded p-3 mb-3 position-relative">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="shippingMethod" id="shippingStandard" value="standard" checked>
                                    <label class="form-check-label w-100" for="shippingStandard">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <span class="fw-bold">Giao hàng tiêu chuẩn</span>
                                                <div class="text-muted">1-2 ngày</div>
                                            </div>
                                            <div class="fw-medium">30.000₫</div>
                                        </div>
                                    </label>
                                </div>
                            </div>
                            
                            <div class="shipping-option border rounded p-3 mb-3 position-relative">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="shippingMethod" id="shippingFast" value="fast">
                                    <label class="form-check-label w-100" for="shippingFast">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <span class="fw-bold">Giao hàng nhanh</span>
                                                <div class="text-muted">1-2 ngày</div>
                                            </div>
                                            <div class="fw-medium">50.000₫</div>
                                        </div>
                                    </label>
                                </div>
                            </div>
                            
                            <div class="shipping-option border rounded p-3 position-relative">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="shippingMethod" id="shippingExpress" value="express">
                                    <label class="form-check-label w-100" for="shippingExpress">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <span class="fw-bold">Giao hàng hỏa tốc</span>
                                                <div class="text-muted">Trong ngày</div>
                                            </div>
                                            <div class="fw-medium">80.000₫</div>
                                        </div>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Payment Method -->
                    <div class="checkout-container bg-white p-4 rounded shadow">
                        <h3 class="checkout-section-title border-bottom pb-3 mb-4"><i class="fas fa-credit-card me-2 text-primary"></i>Phương thức thanh toán</h3>
                        
                        <div class="payment-method border rounded p-3 mb-3 active" data-payment="cod">
                            <div class="form-check">
                                <input type="radio" class="form-check-input" name="paymentMethod" id="paymentCod" value="cod" checked>
                                <label class="form-check-label w-100" for="paymentCod">
                                    <div class="fw-bold mb-1">Thanh toán khi nhận hàng (COD)</div>
                                    <div class="text-muted small">Quý khách sẽ thanh toán bằng tiền mặt khi nhận được hàng.</div>
                                </label>
                            </div>
                        </div>
                        
                        <div class="payment-method border rounded p-3 mb-3" data-payment="bank-transfer">
                            <div class="form-check">
                                <input type="radio" class="form-check-input" name="paymentMethod" id="paymentBank" value="bank-transfer">
                                <label class="form-check-label w-100" for="paymentBank">
                                    <div class="fw-bold mb-1">Chuyển khoản ngân hàng</div>
                                    <div class="text-muted small">Quý khách vui lòng chuyển khoản theo thông tin bên dưới.</div>
                                </label>
                            </div>
                            <div class="bank-details mt-3 ps-4" style="display: none;">
                                <div class="alert alert-info py-2">
                                    <p class="mb-1 small"><strong>Tên ngân hàng:</strong> Vietcombank</p>
                                    <p class="mb-1 small"><strong>Số tài khoản:</strong> 1234567890</p>
                                    <p class="mb-1 small"><strong>Chủ tài khoản:</strong> CÔNG TY TNHH NHÀ SÁCH ONLINE</p>
                                    <p class="mb-0 small"><strong>Nội dung:</strong> Thanh toan don hang #${orderCode}</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="payment-method border rounded p-3 mb-3" data-payment="momo">
                            <div class="form-check">
                                <input type="radio" class="form-check-input" name="paymentMethod" id="paymentMomo" value="momo">
                                <label class="form-check-label w-100" for="paymentMomo">
                                    <div class="d-flex align-items-center">
                                        <img src="${pageContext.request.contextPath}/images/momo-logo.png" alt="MoMo" class="me-2" style="width: 24px; height: 24px;">
                                        <div>
                                            <div class="fw-bold mb-1">Ví điện tử MoMo</div>
                                            <div class="text-muted small">Thanh toán an toàn qua ví điện tử MoMo.</div>
                                        </div>
                                    </div>
                                </label>
                            </div>
                        </div>
                        
                        <div class="payment-method border rounded p-3" data-payment="credit-card">
                            <div class="form-check">
                                <input type="radio" class="form-check-input" name="paymentMethod" id="paymentCard" value="credit-card">
                                <label class="form-check-label w-100" for="paymentCard">
                                    <div class="d-flex align-items-center">
                                        <div class="me-2">
                                            <i class="fab fa-cc-visa me-1 text-primary" style="font-size: 24px;"></i>
                                            <i class="fab fa-cc-mastercard me-1 text-danger" style="font-size: 24px;"></i>
                                        </div>
                                        <div>
                                            <div class="fw-bold mb-1">Thẻ tín dụng / Ghi nợ</div>
                                            <div class="text-muted small">Thanh toán an toàn qua cổng OnePay.</div>
                                        </div>
                                    </div>
                                </label>
                            </div>
                            <div class="card-payment-form mt-3 ps-4" style="display: none;">
                                <div class="row g-3">
                                    <div class="col-12">
                                        <label for="cardNumber" class="form-label small fw-medium">Số thẻ</label>
                                        <input type="text" class="form-control" id="cardNumber" placeholder="1234 5678 9012 3456">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="cardExpiry" class="form-label small fw-medium">Ngày hết hạn</label>
                                        <input type="text" class="form-control" id="cardExpiry" placeholder="MM/YY">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="cardCvc" class="form-label small fw-medium">Mã bảo mật (CVC)</label>
                                        <input type="text" class="form-control" id="cardCvc" placeholder="123">
                                    </div>
                                    <div class="col-12">
                                        <label for="cardName" class="form-label small fw-medium">Tên chủ thẻ</label>
                                        <input type="text" class="form-control" id="cardName" placeholder="NGUYEN VAN A">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            
            <div class="col-lg-4">
                <div class="summary-container bg-white p-4 rounded shadow sticky-top" style="top: 15px;">
                    <h3 class="summary-title border-bottom pb-3 mb-4"><i class="fas fa-shopping-basket me-2 text-primary"></i>Tóm tắt đơn hàng</h3>
                    
                    <div class="order-items mb-4" style="max-height: 300px; overflow-y: auto;">
                        <c:forEach var="item" items="${sessionScope.checkoutCart.items}">
                            <div class="order-item d-flex mb-3 pb-3 border-bottom">
                                <img src="${item.book.imageUrl}" alt="${item.book.title}" class="item-image me-3" style="width: 60px; height: 60px; object-fit: cover;">
                                <div class="item-details flex-grow-1">
                                    <h6 class="item-title mb-1 fs-6 text-truncate">${item.book.title}</h6>
                                    <p class="item-quantity mb-0 small text-muted">SL: ${item.quantity}</p>
                                </div>
                                <div class="item-price text-end ms-2">
                                    <fmt:formatNumber value="${item.book.price * item.quantity}" type="currency" currencySymbol="" />₫
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <div class="summary-item d-flex justify-content-between mb-2">
                        <span class="text-muted">Tạm tính:</span>
                        <span class="fw-medium" data-subtotal="${cartSummary.subtotal}"><fmt:formatNumber value="${cartSummary.subtotal}" type="currency" currencySymbol="" />₫</span>
                    </div>
                    
                    <div class="summary-item d-flex justify-content-between mb-2">
                        <span class="text-muted">Phí vận chuyển:</span>
                        <span id="shippingFee" class="fw-medium"><fmt:formatNumber value="30000" type="currency" currencySymbol="" />₫</span>
                    </div>
                    
                    <c:if test="${cartSummary.discount > 0}">
                        <div class="summary-item d-flex justify-content-between mb-2">
                            <span class="text-muted">Giảm giá:</span>
                            <span class="fw-medium text-success" data-discount="${cartSummary.discount}">-<fmt:formatNumber value="${cartSummary.discount}" type="currency" currencySymbol="" />₫</span>
                        </div>
                    </c:if>
                    <c:if test="${cartSummary.discount == 0}">
                        <span class="d-none" data-discount="0"></span>
                    </c:if>
                    
                    <div class="summary-item d-flex justify-content-between mt-3 pt-3 border-top">
                        <span class="fw-bold">Tổng cộng:</span>
                        <span id="totalAmount" class="fw-bold fs-5 text-primary"><fmt:formatNumber value="${cartSummary.total + 30000}" type="currency" currencySymbol="" />₫</span>
                    </div>
                    
                    <c:if test="${not empty couponApplied}">
                        <div class="coupon-applied mt-3 p-2 bg-success-subtle border border-success-subtle rounded">
                            <small class="d-flex align-items-center">
                                <i class="fas fa-tag me-2 text-success"></i>
                                <span>Đã áp dụng mã <strong>${couponApplied.code}</strong></span>
                            </small>
                        </div>
                    </c:if>
                    
                    <button type="submit" form="checkoutForm" class="btn btn-primary w-100 py-3 mt-4 fw-bold">
                        <i class="fas fa-shopping-bag me-2"></i>Đặt hàng ngay
                    </button>
                    
                    <div class="text-center mt-3">
                        <small class="text-muted">Bằng cách đặt hàng, bạn đồng ý với <a href="#" class="text-decoration-none">Điều khoản</a> của chúng tôi</small>
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
    <script src="${pageContext.request.contextPath}/js/user/checkout.js"></script>
</body>
</html> 