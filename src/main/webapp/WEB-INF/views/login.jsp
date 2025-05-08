<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Hệ thống Quản lý Bán Sách</title>
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

        .login-container {
            max-width: 450px;
            width: 100%;
            padding: 2rem;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .login-header {
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .login-header h1 {
            font-size: 1.8rem;
            color: #333;
            margin-bottom: 0.5rem;
        }

        .login-header p {
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

        .form-check {
            margin-bottom: 1rem;
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

        .social-login {
            margin-top: 1rem;
            display: flex;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-floating {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #f8f9fa;
            color: #333;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .btn-floating:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .btn-floating.facebook {
            background-color: #4267B2;
            color: white;
        }

        .btn-floating.google {
            background-color: #DB4437;
            color: white;
        }

        .btn-floating.twitter {
            background-color: #1DA1F2;
            color: white;
        }

        .btn-floating.github {
            background-color: #333;
            color: white;
        }

        .alert {
            margin-bottom: 1rem;
            padding: 0.75rem 1rem;
            border-radius: 4px;
        }

        .role-toggle {
            display: flex;
            margin-bottom: 1rem;
            background-color: #f8f9fa;
            border-radius: 4px;
            overflow: hidden;
        }

        .role-toggle label {
            flex: 1;
            text-align: center;
            padding: 0.5rem 0;
            cursor: pointer;
            transition: all 0.2s ease;
            color: #333;
        }

        .role-toggle input[type="radio"] {
            display: none;
        }

        .role-toggle input[type="radio"]:checked + label {
            background-color: #4267B2;
            color: white;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h1>Đăng nhập</h1>
            <p>Hệ thống Quản lý Bán Sách</p>
        </div>

        <!-- Error message display -->
        <% if(request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger" role="alert">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <!-- Role toggle (for UI only, server determines actual role) -->
            <div class="role-toggle">
                <input type="radio" id="userRole" name="roleUI" value="user" checked>
                <label for="userRole">Người dùng</label>
                <input type="radio" id="adminRole" name="roleUI" value="admin">
                <label for="adminRole">Quản trị viên</label>
            </div>

            <!-- Username input -->
            <div class="form-outline">
                <label class="form-label" for="username">Tên đăng nhập</label>
                <input type="text" id="username" class="form-control" name="username" 
                       value="${cookie.username != null ? cookie.username.value : ''}" required />
            </div>

            <!-- Password input -->
            <div class="form-outline">
                <label class="form-label" for="password">Mật khẩu</label>
                <input type="password" id="password" class="form-control" name="password" required />
            </div>

            <!-- 2 column grid layout -->
            <div class="row mb-4">
                <div class="col d-flex">
                    <!-- Checkbox -->
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe" />
                        <label class="form-check-label" for="rememberMe">Ghi nhớ đăng nhập</label>
                    </div>
                </div>

                <div class="col text-end">
                    <!-- Simple link -->
                    <a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu?</a>
                </div>
            </div>

            <!-- Submit button -->
            <button type="submit" class="btn btn-primary btn-block mb-4">Đăng nhập</button>

            <!-- Register buttons -->
            <div class="text-center">
                <p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký</a></p>
                <p>Hoặc đăng nhập với:</p>
                <div class="social-login">
                    <a href="#!" class="btn-floating facebook mx-1">
                        <i class="fab fa-facebook-f"></i>
                    </a>
                    <a href="#!" class="btn-floating google mx-1">
                        <i class="fab fa-google"></i>
                    </a>
                    <a href="#!" class="btn-floating twitter mx-1">
                        <i class="fab fa-twitter"></i>
                    </a>
                    <a href="#!" class="btn-floating github mx-1">
                        <i class="fab fa-github"></i>
                    </a>
                </div>
            </div>
        </form>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
        });
    </script>
</body>
</html>