<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - Hệ thống Quản lý Bán Sách</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #f0f2f5;
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .register-container {
            max-width: 600px;
            width: 100%;
            padding: 2rem;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .register-header {
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .register-header h1 {
            font-size: 1.8rem;
            color: #333;
            margin-bottom: 0.5rem;
        }

        .register-header p {
            color: #666;
            font-size: 0.9rem;
        }

        .form-outline {
            margin-bottom: 1.5rem;
            position: relative;
        }

        .form-label {
            color: #333;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
            display: block;
        }

        .form-control {
            background-color: #f8f9fa;
            border: 1px solid #ddd;
            color: #333;
            padding: 0.75rem;
            font-size: 0.9rem;
            border-radius: 4px;
        }

        .form-control:focus {
            border-color: #4267B2;
            box-shadow: 0 0 0 0.2rem rgba(66, 103, 178, 0.25);
        }

        .btn-primary {
            background-color: #4267B2;
            border: none;
            padding: 0.75rem;
            font-size: 0.9rem;
            border-radius: 4px;
            text-transform: uppercase;
            width: 100%;
            font-weight: 500;
        }

        .btn-primary:hover {
            background-color: #365899;
        }

        .text-center p {
            color: #333;
            font-size: 0.9rem;
            margin: 0.5rem 0;
        }

        .text-center p a {
            color: #4267B2;
            text-decoration: none;
        }

        .text-center p a:hover {
            text-decoration: underline;
        }

        .alert {
            margin-bottom: 1rem;
            padding: 0.75rem 1rem;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h1>Đăng ký tài khoản</h1>
        </div>

        <!-- Error message display -->
        <% if(request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger" role="alert">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="row">
                <!-- Thông tin tài khoản -->
                <div class="col-md-6">
                    <h5 class="mb-3">Thông tin tài khoản</h5>
                    
                    <!-- Username input -->
                    <div class="form-outline">
                        <label class="form-label" for="username">Tên đăng nhập *</label>
                        <input type="text" id="username" class="form-control" name="username" 
                               value="${requestScope.username != null ? requestScope.username : ''}" required />
                    </div>

                    <!-- Email input -->
                    <div class="form-outline">
                        <label class="form-label" for="email">Email *</label>
                        <input type="email" id="email" class="form-control" name="email" 
                               value="${requestScope.email != null ? requestScope.email : ''}" required />
                    </div>

                    <!-- Password input -->
                    <div class="form-outline">
                        <label class="form-label" for="password">Mật khẩu *</label>
                        <input type="password" id="password" class="form-control" name="password" required />
                    </div>

                    <!-- Confirm password input -->
                    <div class="form-outline">
                        <label class="form-label" for="confirmPassword">Xác nhận mật khẩu *</label>
                        <input type="password" id="confirmPassword" class="form-control" name="confirmPassword" required />
                    </div>
                </div>

                <!-- Thông tin cá nhân -->
                <div class="col-md-6">
                    <h5 class="mb-3">Thông tin cá nhân</h5>
                    
                    <!-- Name input -->
                    <div class="form-outline">
                        <label class="form-label" for="name">Họ và tên *</label>
                        <input type="text" id="name" class="form-control" name="name" 
                               value="${requestScope.name != null ? requestScope.name : ''}" required />
                    </div>

                    <!-- Phone input -->
                    <div class="form-outline">
                        <label class="form-label" for="phone">Số điện thoại *</label>
                        <input type="tel" id="phone" class="form-control" name="phone" 
                               value="${requestScope.phone != null ? requestScope.phone : ''}" required />
                    </div>

                    <!-- Address input -->
                    <div class="form-outline">
                        <label class="form-label" for="address">Địa chỉ</label>
                        <textarea id="address" class="form-control" name="address" rows="3">${requestScope.address != null ? requestScope.address : ''}</textarea>
                    </div>
                </div>
            </div>

            <!-- Submit button -->
            <button type="submit" class="btn btn-primary btn-block mt-4">Đăng ký</button>

            <!-- Login link -->
            <div class="text-center mt-3">
                <p>Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a></p>
            </div>
        </form>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không khớp!');
            }
        });
    </script>
</body>
</html> 