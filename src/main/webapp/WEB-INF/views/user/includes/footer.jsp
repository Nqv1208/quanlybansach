<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer class="footer mt-5" id="footer">
    <div class="container">
        <div class="row">
            <div class="col-lg-3 col-md-6 mb-4 mb-md-0">
                <h5 class="footer-title">Nhà Sách Online</h5>
                <p class="mb-3">Đến với chúng tôi để trải nghiệm thế giới sách tuyệt vời với đa dạng thể loại và giá cả phải chăng.</p>
                <div class="social-links mb-3">
                    <a href="#" class="me-2"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="me-2"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="me-2"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-youtube"></i></a>
                </div>
            </div>

            <div class="col-lg-3 col-md-6 mb-4 mb-md-0">
                <h5 class="footer-title">Liên Kết Nhanh</h5>
                <ul class="footer-links list-unstyled">
                    <li><a href="${pageContext.request.contextPath}/home">Trang Chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/shop">Cửa Hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/cart">Giỏ Hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/orders">Đơn Hàng</a></li>
                </ul>
            </div>

            <!-- <div class="col-lg-3 col-md-6 mb-4 mb-md-0">
                <h5 class="footer-title">Danh Mục</h5>
                <ul class="footer-links list-unstyled">
                    <li><a href="${pageContext.request.contextPath}/shop?category=1">Văn Học Việt Nam</a></li>
                    <li><a href="${pageContext.request.contextPath}/shop?category=2">Văn Học Nước Ngoài</a></li>
                    <li><a href="${pageContext.request.contextPath}/shop?category=3">Sách Thiếu Nhi</a></li>
                    <li><a href="${pageContext.request.contextPath}/shop?category=4">Kỹ Năng Sống</a></li>
                </ul>
            </div> -->

            <div class="col-lg-3 col-md-6 mb-4 mb-md-0">
                <h5 class="footer-title">Liên Hệ</h5>
                <ul class="footer-links list-unstyled">
                    <li><i class="fas fa-map-marker-alt me-2"></i> 48 Cao Thắng, Hải Châu, Đà Nẵngs</li>
                    <li><i class="fas fa-phone-alt me-2"></i> (012) 1234 5678</li>
                    <li><i class="fas fa-envelope me-2"></i> contact@nhasachonline.com</li>
                    <li><i class="fas fa-clock me-2"></i> 08:00 - 22:00, Thứ 2 - Chủ Nhật</li>
                </ul>
            </div>
            <div class="col-lg-3 col-md-6 mb-4 mb-md-0">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3833.7795476776864!2d108.21102737396784!3d16.07692563923416!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31421847f125d0a9%3A0x936779884318eeca!2zNDggQ2FvIFRo4bqvbmcsIFRoYW5oIELDrG5oLCBI4bqjaSBDaMOidSwgxJDDoCBO4bq1bmcgNTUwMDAwLCBWaeG7h3QgTmFt!5e0!3m2!1svi!2s!4v1748100900440!5m2!1svi!2s" 
                    width="100%" height="100%" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade">
                </iframe>
            </div>
        </div>

        <hr>

        <div class="row">
            <div class="col-md-6 text-center text-md-start">
                <p class="mb-0">© 2023 Nhà Sách Online. Tất cả quyền được bảo lưu.</p>
            </div>
            <div class="col-md-6 text-center text-md-end">
                <p class="mb-0">
                    <a href="#" class="text-decoration-none me-3">Điều Khoản Sử Dụng</a>
                    <a href="#" class="text-decoration-none">Chính Sách Bảo Mật</a>
                </p>
            </div>
        </div>
    </div>
</footer>
