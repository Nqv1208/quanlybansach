<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Login Modal -->
<div class="modal fade login-modal" id="loginModal" tabindex="-1" aria-labelledby="loginModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="loginModalLabel">Đăng nhập</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- Error message display -->
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="error-message">
                        ${sessionScope.errorMessage}
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>
                
                <form action="${pageContext.request.contextPath}/login" method="post">
                    <!-- Role toggle (for UI only, server determines actual role) -->
                    <div class="role-toggle">
                        <input type="radio" id="userRole" name="roleUI" value="user" checked>
                        <label for="userRole">Người dùng</label>
                        <input type="radio" id="adminRole" name="roleUI" value="admin">
                        <label for="adminRole">Quản trị viên</label>
                    </div>  

                    <!-- Username input -->
                    <div class="mb-3">
                        <label for="username" class="form-label">Tên đăng nhập</label>
                        <input type="text" class="form-control" id="username" name="username" 
                            value="${cookie.username != null ? cookie.username.value : ''}" required>
                    </div>

                    <!-- Password input -->
                    <div class="mb-3">
                        <label for="password" class="form-label">Mật khẩu</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>

                    <!-- 2 column grid layout -->
                    <div class="row mb-3">
                        <div class="col-6">
                            <!-- Checkbox -->
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
                                <label class="form-check-label" for="rememberMe">Ghi nhớ đăng nhập</label>
                            </div>
                        </div>

                        <div class="col-6 forgot-password">
                            <!-- Simple link -->
                            <a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu?</a>
                        </div>
                    </div>

                    <!-- Submit button -->
                    <button type="submit" class="btn btn-login mb-3">Đăng nhập</button>
                    
                    <div class="divider">hoặc</div>
                    
                    <!-- Social login -->
                    <div class="social-login">
                        <a href="#!" class="social-btn facebook">
                            <i class="fab fa-facebook-f"></i>
                        </a>
                        <a href="#!" class="social-btn google">
                            <i class="fab fa-google"></i>
                        </a>
                        <a href="#!" class="social-btn twitter">
                            <i class="fab fa-twitter"></i>
                        </a>
                        <a href="#!" class="social-btn github">
                            <i class="fab fa-github"></i>
                        </a>
                    </div>
                    
                    <!-- Register link -->
                    <div class="login-footer">
                        Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Login Modal Script -->
<script>
    // Automatically populate username field if cookie exists
    document.addEventListener("DOMContentLoaded", function() {
        // Set the role UI based on the username value
        const username = document.getElementById('username').value;
        if (username === "admin") {
            document.getElementById('adminRole').checked = true;
        }
        
        // Add event listener to role toggle to update username placeholder
        document.getElementById('userRole').addEventListener('change', function() {
            if (this.checked) {
                document.getElementById('username').placeholder = "user";
            }
        });
        
        document.getElementById('adminRole').addEventListener('change', function() {
            if (this.checked) {
                document.getElementById('username').placeholder = "admin";
            }
        });
        
        // Check if we need to show login modal (e.g., after failed login attempt)
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('showLogin') || urlParams.has('loginError')) {
            const loginModal = new bootstrap.Modal(document.getElementById('loginModal'));
            loginModal.show();
        }
    });
</script> 