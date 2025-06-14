﻿# Quản Lý Bán Sách Online

## Mô tả dự án

**Quản Lý Bán Sách Online** là ứng dụng web quản lý và bán sách trực tuyến được phát triển bằng Java Servlet/JSP. Dự án cung cấp nền tảng cho cả khách hàng mua sắm sách và quản trị viên quản lý cửa hàng.

## Tính năng chính

### Dành cho khách hàng
- Xem và tìm kiếm sách theo danh mục, tác giả, giá...
- Xem chi tiết thông tin sách
- Thêm sách vào giỏ hàng
- Đặt hàng và thanh toán
- Theo dõi trạng thái đơn hàng
- Đánh giá sản phẩm
- Quản lý thông tin tài khoản cá nhân

### Dành cho quản trị viên
- Quản lý danh mục sách (thêm, sửa, xóa, tìm kiếm)
- Quản lý thông tin tác giả, nhà xuất bản
- Quản lý thông tin khách hàng
- Quản lý đơn hàng và xử lý đơn hàng
- Thống kê doanh thu, số lượng sách bán ra
- Xuất báo cáo PDF

## Công nghệ sử dụng

- **Backend:**
  - Java Servlet/JSP
  - JDBC (Kết nối cơ sở dữ liệu)
  - SQL Server

- **Frontend:**
  - HTML, CSS, JavaScript
  - Bootstrap 5
  - Font Awesome

- **Thư viện và công cụ:**
  - Maven (Quản lý dự án)
  - JSTL (JSP Standard Tag Library)
  - iText (Xuất báo cáo PDF)
  - Gson (Xử lý JSON)

## Cấu trúc dự án

```
quanlybansach/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/quanlybansach/
│   │   │       ├── controller/     # Servlet Controllers
│   │   │       ├── dao/            # Data Access Objects
│   │   │       ├── model/          # Model Classes
│   │   │       ├── util/           # Utility Classes
│   │   │       └── service/        # Business Logic Services
│   │   ├── resources/              # Configuration Files
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── views/          # JSP Views
│   │       ├── css/                # Stylesheets
│   │       ├── js/                 # JavaScript Files
│   │       └── assets/             # Images and other static resources
│   └── test/                       # Unit Tests
└── pom.xml                         # Maven Configuration
```

## Hướng dẫn cài đặt

1. Clone repository về máy:
   ```
   git clone https://github.com/Nqv1208/quanlybansach.git
   ```
2. Mở project bằng IDE (Eclipse, IntelliJ, VS Code...)
3. Cấu hình SQL Server và cập nhật thông tin kết nối trong file cấu hình
4. Chạy script SQL để tạo cơ sở dữ liệu
5. Build project bằng Maven:
   ```
   mvn clean install
   ```
6. Deploy ứng dụng lên máy chủ Tomcat hoặc chạy trực tiếp từ IDE

---
