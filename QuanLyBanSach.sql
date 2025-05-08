-- Tạo database
/*
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'BOOKSTORE_MANAGEMENT')
BEGIN
    CREATE DATABASE BOOKSTORE_MANAGEMENT;
END
*/
USE master
DROP DATABASE IF EXISTS BOOKSTORE_MANAGEMENT
GO
CREATE DATABASE BOOKSTORE_MANAGEMENT;
GO	
USE BOOKSTORE_MANAGEMENT;
GO

-- Bảng tác giả
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AUTHORS')
BEGIN
    CREATE TABLE AUTHORS (
        author_id INT IDENTITY(1,1) PRIMARY KEY,
        image_url VARCHAR(255),
        name NVARCHAR(50) NOT NULL,
        bio NVARCHAR(MAX),
        birth_year INT,
        country NVARCHAR(100)
    );
END
GO

-- Bảng danh mục sách
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'CATEGORIES')
BEGIN
    CREATE TABLE CATEGORIES (
        category_id INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(100) NOT NULL,
        description NVARCHAR(MAX)
    );
END
GO

-- Bảng nhà xuất bản
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PUBLISHERS')
BEGIN
    CREATE TABLE PUBLISHERS (
        publisher_id INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(255) NOT NULL,
        address NVARCHAR(255),
        phone NVARCHAR(20),
        email NVARCHAR(100)
    );
END
GO

-- Bảng sách
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BOOKS')
BEGIN
    CREATE TABLE BOOKS (
        book_id INT IDENTITY(1,1) PRIMARY KEY,
        title NVARCHAR(255) NOT NULL,
        author_id INT,
        category_id INT,
        publisher_id INT,
        ISBN NVARCHAR(20) UNIQUE,
        price DECIMAL(10, 2) NOT NULL,
        stock_quantity INT NOT NULL DEFAULT 0,
        publication_date DATE,
        description NVARCHAR(MAX),
        image_url NVARCHAR(255),
        CONSTRAINT FK_BOOKS_AUTHORS FOREIGN KEY (author_id) REFERENCES AUTHORS(author_id) ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT FK_BOOKS_CATEGORIES FOREIGN KEY (category_id) REFERENCES CATEGORIES(category_id) ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT FK_BOOKS_PUBLISHERS FOREIGN KEY (publisher_id) REFERENCES PUBLISHERS(publisher_id) ON DELETE CASCADE ON UPDATE CASCADE
    );
END
GO

-- Bảng khách hàng
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'CUSTOMERS')
BEGIN
    CREATE TABLE CUSTOMERS (
        customer_id INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(255) NOT NULL,
        email NVARCHAR(100) UNIQUE,
        phone NVARCHAR(20),
        address NVARCHAR(255),
        registration_date DATE DEFAULT GETDATE()
    );
END
GO

-- Bảng đơn hàng
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ORDERS')
BEGIN
    CREATE TABLE ORDERS (
        order_id INT IDENTITY(1,1) PRIMARY KEY,
        customer_id INT,
        order_date DATETIME DEFAULT GETDATE(),
        total_amount DECIMAL(10, 2) NOT NULL,
        status NVARCHAR(50) DEFAULT N'Chờ xử lý',
        shipping_address NVARCHAR(255),
        payment_method NVARCHAR(50),
        CONSTRAINT FK_ORDERS_CUSTOMERS FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id) ON DELETE CASCADE ON UPDATE CASCADE
    );
END
GO

-- Bảng chi tiết đơn hàng
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ORDER_DETAILS')
BEGIN
    CREATE TABLE ORDER_DETAILS (
        order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
        order_id INT,
        book_id INT,
        quantity INT NOT NULL,
        unit_price DECIMAL(10, 2) NOT NULL,
        discount DECIMAL(5, 2) DEFAULT 0,
        CONSTRAINT FK_ORDER_DETAILS_ORDERS FOREIGN KEY (order_id) REFERENCES ORDERS(order_id) ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT FK_ORDER_DETAILS_BOOKS FOREIGN KEY (book_id) REFERENCES BOOKS(book_id) ON DELETE CASCADE ON UPDATE CASCADE
    );
END
GO

-- Bảng đánh giá sách
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'REVIEWS')
BEGIN
    CREATE TABLE REVIEWS (
        review_id INT IDENTITY(1,1) PRIMARY KEY,
        book_id INT,
        customer_id INT,
        rating INT CHECK (rating BETWEEN 1 AND 5),
        comment NVARCHAR(MAX),
        review_date DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_REVIEWS_BOOKS FOREIGN KEY (book_id) REFERENCES BOOKS(book_id) ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT FK_REVIEWS_CUSTOMERS FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id) ON DELETE CASCADE ON UPDATE CASCADE
    );
END
GO

-- Bảng hóa đơn (INVOICES)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'INVOICES')
BEGIN
    CREATE TABLE INVOICES (
        invoice_id VARCHAR(20) PRIMARY KEY,
        customer_name NVARCHAR(255) NOT NULL,
        customer_phone NVARCHAR(20),
        created_date DATETIME DEFAULT GETDATE(),
        status NVARCHAR(50) DEFAULT N'Đã thanh toán'
    );
END
GO

-- Bảng chi tiết hóa đơn (INVOICE_ITEMS)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'INVOICE_ITEMS')
BEGIN
    CREATE TABLE INVOICE_ITEMS (
        id INT IDENTITY(1,1) PRIMARY KEY,
        invoice_id VARCHAR(20) NOT NULL,
        book_id INT NOT NULL,
        book_title NVARCHAR(255) NOT NULL,
        book_author NVARCHAR(100),
        quantity INT NOT NULL,
        price DECIMAL(10,2) NOT NULL,
        CONSTRAINT FK_INVOICE_ITEMS_INVOICES FOREIGN KEY (invoice_id) REFERENCES INVOICES(invoice_id) ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT FK_INVOICE_ITEMS_BOOKS FOREIGN KEY (book_id) REFERENCES BOOKS(book_id) ON DELETE CASCADE ON UPDATE CASCADE
    );
END
GO

-- Bảng giỏ hàng
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'CARTS')
BEGIN
    CREATE TABLE CARTS (
        cart_id INT IDENTITY(1,1) PRIMARY KEY,
        customer_id INT,
        created_date DATETIME DEFAULT GETDATE(),
        last_modified DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_CARTS_CUSTOMERS FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id) ON DELETE CASCADE
    );
END
GO

-- Bảng chi tiết giỏ hàng
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'CART_ITEMS')
BEGIN
    CREATE TABLE CART_ITEMS (
        cart_item_id INT IDENTITY(1,1) PRIMARY KEY,
        cart_id INT NOT NULL,
        book_id INT NOT NULL,
        quantity INT NOT NULL DEFAULT 1,
        added_date DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_CART_ITEMS_CARTS FOREIGN KEY (cart_id) REFERENCES CARTS(cart_id) ON DELETE CASCADE,
        CONSTRAINT FK_CART_ITEMS_BOOKS FOREIGN KEY (book_id) REFERENCES BOOKS(book_id) ON DELETE CASCADE,
        CONSTRAINT UQ_CART_ITEM UNIQUE (cart_id, book_id),
        CONSTRAINT CHK_CART_ITEM_QUANTITY CHECK (quantity > 0)
    );
END
GO

-- Bảng vai trò người dùng
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ROLES')
BEGIN
    CREATE TABLE ROLES (
        role_id INT IDENTITY(1,1) PRIMARY KEY,
        role_name NVARCHAR(50) NOT NULL UNIQUE,
        description NVARCHAR(255)
    );
END
GO

-- Bảng tài khoản
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ACCOUNTS')
BEGIN
    CREATE TABLE ACCOUNTS (
        account_id INT IDENTITY(1,1) PRIMARY KEY,
        username NVARCHAR(50) NOT NULL UNIQUE,
        password_hash NVARCHAR(255) NOT NULL,
        email NVARCHAR(100) NOT NULL UNIQUE,
        role_id INT NOT NULL,
        customer_id INT NULL,
        is_active BIT DEFAULT 1,
        created_date DATETIME DEFAULT GETDATE(),
        last_login DATETIME NULL,
        CONSTRAINT FK_ACCOUNTS_ROLES FOREIGN KEY (role_id) REFERENCES ROLES(role_id),
        CONSTRAINT FK_ACCOUNTS_CUSTOMERS FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id) ON DELETE SET NULL,
        CONSTRAINT CHK_ACCOUNTS_EMAIL CHECK (email LIKE '%_@_%.__%')
    );
END
GO

-- Chèn dữ liệu mẫu cho AUTHORS
IF NOT EXISTS (SELECT * FROM AUTHORS)
BEGIN
    INSERT INTO AUTHORS (image_url, name, bio, birth_year, country)
    VALUES 
        ('https://www.nxbtre.com.vn/Images/Writer/nxbtre_thumb_30552016_085555.jpg', N'Nguyễn Nhật Ánh', N'Tác giả nổi tiếng với nhiều tác phẩm văn học thiếu nhi và truyện dài', 1955, N'Việt Nam'),
        ('https://static.tuoitre.vn/tto/i/s626/2014/07/07/tN7e4d46.jpg', N'Tô Hoài', N'Nhà văn nổi tiếng với tác phẩm Dế Mèn Phiêu Lưu Ký', 1920, N'Việt Nam'),
        ('https://lovebookslovelife.vn/wp-content/uploads/2019/11/jjk-01-1200x1200.png', N'J.K. Rowling', N'Tác giả của series Harry Potter', 1965, N'Anh'),
        ('https://upload.wikimedia.org/wikipedia/vi/a/ad/Picturecarnegie.jpg', N'Dale Carnegie', N'Tác giả của nhiều sách về kỹ năng sống và thành công', 1888, N'Mỹ'),
        ('https://upload.wikimedia.org/wikipedia/vi/thumb/9/92/NgoTatTo.jpg/175px-NgoTatTo.jpg', N'Ngô Tất Tố', N'Nhà văn, nhà báo nổi tiếng với tác phẩm Tắt Đèn', 1894, N'Việt Nam');
END
GO

-- Chèn dữ liệu mẫu cho CATEGORIES
IF NOT EXISTS (SELECT * FROM CATEGORIES)
BEGIN
    INSERT INTO CATEGORIES (name, description)
    VALUES 
        (N'Văn học Việt Nam', N'Các tác phẩm văn học của tác giả Việt Nam'),
        (N'Văn học nước ngoài', N'Các tác phẩm văn học của tác giả nước ngoài'),
        (N'Sách thiếu nhi', N'Sách dành cho trẻ em và thiếu niên'),
        (N'Kỹ năng sống', N'Sách hướng dẫn kỹ năng sống và phát triển bản thân'),
        (N'Kinh tế', N'Sách về kinh tế, kinh doanh, tài chính');
END
GO

-- Chèn dữ liệu mẫu cho PUBLISHERS
IF NOT EXISTS (SELECT * FROM PUBLISHERS)
BEGIN
    INSERT INTO PUBLISHERS (name, address, phone, email)
    VALUES 
        (N'NXB Trẻ', N'161B Lý Chính Thắng, Phường 7, Quận 3, TP.HCM', N'028 3931 6289', N'hopthubandoc@nxbtre.com.vn'),
        (N'NXB Kim Đồng', N'55 Quang Trung, Hai Bà Trưng, Hà Nội', N'024 3943 4730', N'info@nxbkimdong.com.vn'),
        (N'NXB Tổng hợp TP.HCM', N'62 Nguyễn Thị Minh Khai, Quận 1, TP.HCM', N'028 3822 5340', N'tonghop@nxbhcm.com.vn'),
        (N'NXB Giáo Dục', N'81 Trần Hưng Đạo, Hoàn Kiếm, Hà Nội', N'024 3822 0801', N'contact@nxbgd.vn'),
        (N'First News', N'11H Nguyễn Thị Minh Khai, Quận 1, TP.HCM', N'028 3822 7979', N'firstnews@firstnews.com.vn');
END
GO

-- Chèn dữ liệu mẫu cho BOOKS
IF NOT EXISTS (SELECT * FROM BOOKS)
BEGIN
    INSERT INTO BOOKS (title, author_id, category_id, publisher_id, ISBN, price, stock_quantity, publication_date, description, image_url)
    VALUES 
        (N'Tôi thấy hoa vàng trên cỏ xanh', 1, 1, 1, N'8935235226746', 88000, 6, '2018-01-01', N'Truyện kể về cuộc sống của những đứa trẻ ở vùng nông thôn nghèo', N'https://salt.tikicdn.com/ts/product/5e/18/24/2a6154ba08df6ce6161c13f4303fa19e.jpg'),
        (N'Dế Mèn Phiêu Lưu Ký', 2, 3, 2, N'8934974170617', 75000, 120, '2019-06-15', N'Tác phẩm kể về những cuộc phiêu lưu của chú Dế Mèn', N'https://salt.tikicdn.com/ts/product/eb/62/6b/0e56b45bddc01b57277484865818ab9b.jpg'),
        (N'Harry Potter và Hòn đá Phù thủy', 3, 2, 5, N'8935235203150', 195000, 85, '2020-03-10', N'Tập đầu tiên trong series Harry Potter', N'https://encrypted-tbn1.gstatic.com/shopping?q=tbn:ANd9GcShmnC05uJSeCT1MA3N2CIf6Taa9D1Y_qpCXO6W06kIFsjsOOZDUG_IxKRD2Q8M7fyNDfZCJnnqhhI6UYTveeD6LoulnTtiuDjv5Nw9IxJ6ScOoMN49uESkplciik8NVqOYu0Pl16wfI09A&usqp=CAc'),
        (N'Đắc Nhân Tâm', 4, 4, 5, N'8935086854395', 86000, 10, '2021-01-20', N'Cuốn sách nổi tiếng về nghệ thuật đối nhân xử thế', N'https://nhanvietmedia.edu.vn/publics/files/sach-dac-nhan-tam.jpg'),
        (N'Tắt Đèn', 5, 1, 3, N'8934974158066', 69000, 100, '2019-05-05', N'Tác phẩm phản ánh cuộc sống khổ cực của người nông dân Việt Nam', N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSs0Zx7Dgs6a74lq623kmqHTS4nO30QSqbEEZ4jkzvXGaUWIxS0');
END
GO

-- Chèn dữ liệu mẫu cho CUSTOMERS
IF NOT EXISTS (SELECT * FROM CUSTOMERS)
BEGIN
    INSERT INTO CUSTOMERS (name, email, phone, address, registration_date)
    VALUES 
        (N'Nguyễn Văn An', N'an.nguyen@email.com', N'0901234567', N'123 Lê Lợi, Quận 1, TP.HCM', '2025-01-15'),
        (N'Trần Thị Bình', N'binh.tran@email.com', N'0912345678', N'456 Nguyễn Huệ, Quận 1, TP.HCM', '2025-02-20'),
        (N'Lê Văn Cường', N'cuong.le@email.com', N'0923456789', N'789 Trần Hưng Đạo, Quận 5, TP.HCM', '2025-03-10'),
        (N'Phạm Thị Dung', N'dung.pham@email.com', N'0934567890', N'101 Hai Bà Trưng, Quận 3, TP.HCM', '2025-04-05'),
        (N'Hoàng Văn Em', N'em.hoang@email.com', N'0945678901', N'202 Võ Văn Tần, Quận 3, TP.HCM', '2025-04-12');
END
GO

-- Chèn dữ liệu mẫu cho ORDERS
IF NOT EXISTS (SELECT * FROM ORDERS)
BEGIN
    INSERT INTO ORDERS (customer_id, order_date, total_amount, status, shipping_address, payment_method)
    VALUES 
        (1, '2025-04-01', 263000, N'Đã giao hàng', N'123 Lê Lợi, Quận 1, TP.HCM', N'Thẻ tín dụng'),
        (2, '2025-04-05', 195000, N'Đã giao hàng', N'456 Nguyễn Huệ, Quận 1, TP.HCM', N'Tiền mặt khi nhận hàng'),
        (3, '2025-04-10', 144000, N'Đang giao hàng', N'789 Trần Hưng Đạo, Quận 5, TP.HCM', N'Chuyển khoản'),
        (4, '2025-04-15', 86000, N'Chờ xử lý', N'101 Hai Bà Trưng, Quận 3, TP.HCM', N'Ví điện tử'),
        (5, '2025-04-20', 337000, N'Đã xác nhận', N'202 Võ Văn Tần, Quận 3, TP.HCM', N'Tiền mặt khi nhận hàng'),
        (5, '2025-04-28', 337000, N'Đã giao hàng', N'202 Võ Văn Tần, Quận 3, TP.HCM', N'Tiền mặt khi nhận hàng');
END
GO

-- Chèn dữ liệu mẫu cho ORDER_DETAILS
IF NOT EXISTS (SELECT * FROM ORDER_DETAILS)
BEGIN
    INSERT INTO ORDER_DETAILS (order_id, book_id, quantity, unit_price, discount)
    VALUES 
        (1, 1, 2, 88000, 0),
        (1, 3, 1, 195000, 10),
        (2, 3, 1, 195000, 0),
        (3, 2, 1, 75000, 0),
        (3, 5, 1, 69000, 0),
        (4, 4, 1, 86000, 0),
        (5, 1, 1, 88000, 0),
        (5, 3, 1, 195000, 0),
        (5, 4, 1, 86000, 10),
        (6, 4, 1, 86000, 10);
END
GO

-- Chèn dữ liệu mẫu cho REVIEWS
IF NOT EXISTS (SELECT * FROM REVIEWS)
BEGIN
    INSERT INTO REVIEWS (book_id, customer_id, rating, comment, review_date)
    VALUES 
        (1, 1, 5, N'Sách rất hay, cảm động và chân thực', '2025-04-02'),
        (3, 2, 5, N'Tuyệt vời, không thể ngừng đọc', '2025-03-06'),
        (2, 3, 4, N'Sách hay, phù hợp cho trẻ em', '2025-04-11'),
        (4, 4, 5, N'Cuốn sách thay đổi cuộc đời tôi', '2025-04-16'),
        (5, 5, 4, N'Tác phẩm có giá trị lịch sử và nhân văn sâu sắc', '2025-04-21');
END
GO

-- Dữ liệu mẫu cho bảng INVOICES
IF NOT EXISTS (SELECT * FROM INVOICES)
BEGIN
    INSERT INTO INVOICES (invoice_id, customer_name, customer_phone, created_date, status)
    VALUES 
        ('INV-2025-0001', N'Nguyễn Văn An', '0901234567', '2025-04-01 10:15:00', N'Đã thanh toán'),
        ('INV-2025-0002', N'Trần Thị Bình', '0912345678', '2025-04-05 14:30:00', N'Đã thanh toán'),
        ('INV-2025-0003', N'Lê Văn Cường', '0923456789', '2025-04-10 16:45:00', N'Đã thanh toán'),
        ('INV-2025-0004', N'Phạm Thị Dung', '0934567890', '2025-04-15 09:20:00', N'Đã thanh toán'),
        ('INV-2025-0005', N'Hoàng Văn Em', '0945678901', '2025-04-20 11:10:00', N'Đã thanh toán');
END
GO

-- Dữ liệu mẫu cho bảng INVOICE_ITEMS
IF NOT EXISTS (SELECT * FROM INVOICE_ITEMS)
BEGIN
    INSERT INTO INVOICE_ITEMS (invoice_id, book_id, book_title, book_author, quantity, price)
    VALUES 
        ('INV-2025-0001', 1, N'Tôi thấy hoa vàng trên cỏ xanh', N'Nguyễn Nhật Ánh', 2, 88000),
        ('INV-2025-0001', 3, N'Harry Potter và Hòn đá Phù thủy', N'J.K. Rowling', 1, 195000),
        ('INV-2025-0002', 3, N'Harry Potter và Hòn đá Phù thủy', N'J.K. Rowling', 1, 195000),
        ('INV-2025-0003', 2, N'Dế Mèn Phiêu Lưu Ký', N'Tô Hoài', 1, 75000),
        ('INV-2025-0003', 5, N'Tắt Đèn', N'Ngô Tất Tố', 1, 69000),
        ('INV-2025-0004', 4, N'Đắc Nhân Tâm', N'Dale Carnegie', 1, 86000),
        ('INV-2025-0005', 1, N'Tôi thấy hoa vàng trên cỏ xanh', N'Nguyễn Nhật Ánh', 1, 88000);
END
GO

-- Dữ liệu mẫu cho bảng ROLES
IF NOT EXISTS (SELECT * FROM ROLES)
BEGIN
    INSERT INTO ROLES (role_name, description)
    VALUES 
        (N'Admin', N'Quản trị viên hệ thống với toàn quyền truy cập'),
        (N'Staff', N'Nhân viên với quyền quản lý sách, đơn hàng và khách hàng'),
        (N'User', N'Người dùng đã đăng ký có thể mua sách và quản lý tài khoản cá nhân'),
        (N'Guest', N'Khách vãng lai chỉ có quyền xem sách');
END
GO

-- Dữ liệu mẫu cho bảng ACCOUNTS (Mật khẩu mẫu là 'password123')
IF NOT EXISTS (SELECT * FROM ACCOUNTS)
BEGIN
    INSERT INTO ACCOUNTS (username, password_hash, email, role_id, customer_id, is_active, created_date, last_login)
    VALUES 
        ('admin', 'e8dc057d92fefc56b5387de13a747a5fb38d8318df4b66c197b773340302aca0', 'admin@bookstore.com', 1, NULL, 1, '2025-01-01', '2025-04-15'),
        ('staff1', 'e8dc057d92fefc56b5387de13a747a5fb38d8318df4b66c197b773340302aca0', 'staff@bookstore.com', 2, NULL, 1, '2025-01-10', '2025-04-10'),
        ('user1', 'e8dc057d92fefc56b5387de13a747a5fb38d8318df4b66c197b773340302aca0', 'an.nguyen@email.com', 3, 1, 1, '2025-01-15', '2025-04-01'),
        ('user2', 'e8dc057d92fefc56b5387de13a747a5fb38d8318df4b66c197b773340302aca0', 'binh.tran@email.com', 3, 2, 1, '2025-02-20', '2025-04-05'),
        ('user3', 'e8dc057d92fefc56b5387de13a747a5fb38d8318df4b66c197b773340302aca0', 'cuong.le@email.com', 3, 3, 1, '2025-03-10', NULL),
        ('admin2', '96cae35ce8a9b0244178bf28e4966c2ce1b8385723a96a6b838858cdd6ca0a1e', 'admin2@gmail.com', 1, NULL, 1, '2025-03-10', '2025-04-15');
END
GO

------------------------------------------------
-- Thêm ràng buộc cho bảng AUTHORS
ALTER TABLE AUTHORS
ADD CONSTRAINT CHK_author_birth_year CHECK (birth_year > 0 AND birth_year <= YEAR(GETDATE()));
GO	

------------------------------------------------
-- Thêm ràng buộc cho bảng CATEGORIES
ALTER TABLE CATEGORIES
ADD CONSTRAINT UQ_category_name UNIQUE (name);
GO	

------------------------------------------------
-- Thêm ràng buộc cho bảng PUBLISHERS
ALTER TABLE PUBLISHERS
ADD CONSTRAINT UQ_publisher_name UNIQUE (name),
    CONSTRAINT CHK_publisher_email CHECK (email LIKE '%_@_%.__%');
GO	

------------------------------------------------
-- Thêm ràng buộc cho bảng BOOKS
ALTER TABLE BOOKS
ADD CONSTRAINT CHK_book_price CHECK (price >= 0),
    CONSTRAINT CHK_book_stock CHECK (stock_quantity >= 0),
    CONSTRAINT CHK_book_publication_date CHECK (publication_date <= GETDATE());
GO	

------------------------------------------------
-- Thêm chỉ mục cho bảng BOOKS
CREATE INDEX IX_book_title ON BOOKS(title);
CREATE INDEX IX_book_author_id ON BOOKS(author_id);
CREATE INDEX IX_book_category_id ON BOOKS(category_id);
CREATE INDEX IX_book_publisher_id ON BOOKS(publisher_id);
CREATE INDEX IX_book_price ON BOOKS(price);
GO	

------------------------------------------------
-- Thêm ràng buộc cho bảng CUSTOMERS
ALTER TABLE CUSTOMERS
ADD CONSTRAINT CHK_customer_email CHECK (email LIKE '%_@_%.__%'),
    CONSTRAINT CHK_customer_phone CHECK (LEN(phone) >= 10),
    CONSTRAINT CHK_customer_registration_date CHECK (registration_date <= GETDATE());
GO	

------------------------------------------------
-- Thêm chỉ mục cho bảng CUSTOMERS
CREATE INDEX IX_customers_name ON CUSTOMERS(name);
CREATE INDEX IX_customers_email ON CUSTOMERS(email);
GO	

------------------------------------------------
-- Thêm ràng buộc cho bảng ORDERS
ALTER TABLE ORDERS
ADD CONSTRAINT CHK_order_total CHECK (total_amount >= 0),
    CONSTRAINT CHK_order_date CHECK (order_date <= GETDATE()),
    CONSTRAINT CHK_order_status CHECK (status IN (N'Chờ xử lý', N'Đã xác nhận', N'Đang giao hàng', N'Đã giao hàng', N'Đã hủy'));
GO	

------------------------------------------------
-- Thêm chỉ mục cho bảng ORDERS
CREATE INDEX IX_orders_customer_id ON ORDERS(customer_id);
CREATE INDEX IX_orders_order_date ON ORDERS(order_date);
CREATE INDEX IX_orders_status ON ORDERS(status);
GO	

------------------------------------------------
-- Thêm ràng buộc cho bảng ORDER_DETAILS
ALTER TABLE ORDER_DETAILS
ADD CONSTRAINT CHK_order_detail_quantity CHECK (quantity > 0),
    CONSTRAINT CHK_order_detail_price CHECK (unit_price >= 0),
    CONSTRAINT CHK_order_detail_discount CHECK (discount >= 0 AND discount <= 100),
    CONSTRAINT UQ_order_detail_book UNIQUE (order_id, book_id);
GO	

------------------------------------------------
-- Thêm chỉ mục cho bảng ORDER_DETAILS
CREATE INDEX IX_order_details_order_id ON ORDER_DETAILS(order_id);
CREATE INDEX IX_order_details_book_id ON ORDER_DETAILS(book_id);

GO	
------------------------------------------------
-- Thêm ràng buộc cho bảng REVIEWS
ALTER TABLE REVIEWS
ADD CONSTRAINT CHK_review_rating CHECK (rating BETWEEN 1 AND 5),
    CONSTRAINT CHK_review_date CHECK (review_date <= GETDATE()),
    CONSTRAINT UQ_review_customer_book UNIQUE (customer_id, book_id);
GO	
------------------------------------------------
-- Thêm chỉ mục cho bảng REVIEWS
CREATE INDEX IX_reviews_book_id ON REVIEWS(book_id);
CREATE INDEX IX_reviews_customer_id ON REVIEWS(customer_id);
CREATE INDEX IX_reviews_rating ON REVIEWS(rating);
GO	
-- Chỉ mục cho bảng INVOICES
CREATE INDEX IX_invoices_created_date ON INVOICES(created_date);
GO
------------------------------------------------
-- Chỉ mục cho bảng INVOICE_ITEMS
CREATE INDEX IX_invoice_items_invoice_id ON INVOICE_ITEMS(invoice_id);
CREATE INDEX IX_invoice_items_book_id ON INVOICE_ITEMS(book_id);
GO
------------------------------------------------
-- Ràng buộc cho bảng INVOICES
ALTER TABLE INVOICES
ADD CONSTRAINT CHK_invoice_created_date CHECK (created_date <= GETDATE()),
    CONSTRAINT CHK_invoice_status CHECK (status IN (N'Đã thanh toán', N'Đã hủy', N'Chờ xử lý'));
GO
------------------------------------------------
-- Ràng buộc cho bảng INVOICE_ITEMS
ALTER TABLE INVOICE_ITEMS
ADD CONSTRAINT CHK_invoice_item_quantity CHECK (quantity > 0),
    CONSTRAINT CHK_invoice_item_price CHECK (price >= 0);
GO

------------------------------------------------
-- Ràng buộc và chỉ mục cho bảng ROLES
CREATE INDEX IX_roles_name ON ROLES(role_name);
GO

------------------------------------------------
-- Ràng buộc và chỉ mục cho bảng ACCOUNTS
ALTER TABLE ACCOUNTS
ADD CONSTRAINT CHK_accounts_username CHECK (LEN(username) >= 4),
    CONSTRAINT CHK_accounts_password CHECK (LEN(password_hash) >= 8);

CREATE INDEX IX_accounts_username ON ACCOUNTS(username);
CREATE INDEX IX_accounts_email ON ACCOUNTS(email);
CREATE INDEX IX_accounts_role_id ON ACCOUNTS(role_id);
CREATE INDEX IX_accounts_customer_id ON ACCOUNTS(customer_id);
GO

------------------------------------------------
/*
-- Tạo bảng giảm giá (PROMOTIONS)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PROMOTIONS')
BEGIN
    CREATE TABLE PROMOTIONS (
        promotion_id INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(255) NOT NULL,
        description NVARCHAR(MAX),
        discount_percentage DECIMAL(5, 2) NOT NULL,
        start_date DATE NOT NULL,
        end_date DATE NOT NULL,
        active BIT DEFAULT 1,
        CONSTRAINT CHK_promotion_dates CHECK (start_date <= end_date),
        CONSTRAINT CHK_promotion_discount CHECK (discount_percentage > 0 AND discount_percentage <= 100)
    );
END
GO

-- Tạo bảng sách-khuyến mãi (BOOK_PROMOTIONS) - quan hệ nhiều-nhiều
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BOOK_PROMOTIONS')
BEGIN
    CREATE TABLE BOOK_PROMOTIONS (
        book_id INT NOT NULL,
        promotion_id INT NOT NULL,
        PRIMARY KEY (book_id, promotion_id),
        FOREIGN KEY (book_id) REFERENCES BOOKS(book_id),
        FOREIGN KEY (promotion_id) REFERENCES PROMOTIONS(promotion_id)
    );
END
GO

-- Tạo bảng kho sách (INVENTORY)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'INVENTORY')
BEGIN
    CREATE TABLE INVENTORY (
        inventory_id INT IDENTITY(1,1) PRIMARY KEY,
        book_id INT NOT NULL,
        quantity_change INT NOT NULL,
        transaction_type NVARCHAR(50) NOT NULL, -- 'Nhập kho', 'Xuất kho', 'Điều chỉnh'
        transaction_date DATETIME DEFAULT GETDATE(),
        notes NVARCHAR(MAX),
        FOREIGN KEY (book_id) REFERENCES BOOKS(book_id),
        CONSTRAINT CHK_inventory_type CHECK (transaction_type IN (N'Nhập kho', N'Xuất kho', N'Điều chỉnh'))
    );
END
GO

--=====================================================
---------------------- TRIGGER ------------------------
--=====================================================
-- Tạo trigger cập nhật số lượng sách khi thêm INVENTORY
CREATE OR ALTER TRIGGER trg_update_book_quantity
ON INVENTORY
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE b
    SET b.stock_quantity = b.stock_quantity + i.quantity_change
    FROM BOOKS b
    INNER JOIN inserted i ON b.book_id = i.book_id;
END
GO
*/

-- Tạo trigger cập nhật số lượng sách khi xử lý đơn hàng
CREATE OR ALTER TRIGGER trg_update_stock_on_order
ON ORDERS
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @old_status NVARCHAR(50)
    DECLARE @new_status NVARCHAR(50)
    
    SELECT @old_status = d.status, @new_status = i.status
    FROM deleted d INNER JOIN inserted i ON d.order_id = i.order_id
    
    -- Nếu đơn hàng chuyển trạng thái từ "Chờ xử lý" hoặc "Đã xác nhận" sang "Đang giao hàng"
    IF (@old_status IN (N'Chờ xử lý', N'Đã xác nhận') AND @new_status = N'Đang giao hàng')
    BEGIN
        -- Tự động giảm số lượng tồn kho
        INSERT INTO INVENTORY (book_id, quantity_change, transaction_type, notes)
        SELECT od.book_id, -od.quantity, N'Xuất kho', N'Tự động xuất kho cho đơn hàng #' + CAST(od.order_id AS NVARCHAR)
        FROM ORDER_DETAILS od
        INNER JOIN inserted i ON od.order_id = i.order_id;
    END
    
    -- Nếu đơn hàng chuyển từ "Đang giao hàng" sang "Đã hủy"
    IF (@old_status = N'Đang giao hàng' AND @new_status = N'Đã hủy')
    BEGIN
        -- Tự động hoàn lại số lượng tồn kho
        INSERT INTO INVENTORY (book_id, quantity_change, transaction_type, notes)
        SELECT od.book_id, od.quantity, N'Nhập kho', N'Tự động nhập lại kho cho đơn hàng #' + CAST(od.order_id AS NVARCHAR) + N' bị hủy'
        FROM ORDER_DETAILS od
        INNER JOIN inserted i ON od.order_id = i.order_id;
    END
END;
GO

-- Trigger để cập nhật thời gian chỉnh sửa giỏ hàng khi thêm/sửa/xóa sản phẩm
CREATE OR ALTER TRIGGER trg_update_cart_modified_time
ON CART_ITEMS
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Cập nhật thời gian chỉnh sửa cho giỏ hàng có sản phẩm được thêm/sửa
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        UPDATE c
        SET c.last_modified = GETDATE()
        FROM CARTS c
        INNER JOIN inserted i ON c.cart_id = i.cart_id;
    END
    
    -- Cập nhật thời gian chỉnh sửa cho giỏ hàng có sản phẩm bị xóa
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        UPDATE c
        SET c.last_modified = GETDATE()
        FROM CARTS c
        INNER JOIN deleted d ON c.cart_id = d.cart_id;
    END
END
GO

/*
-- Thêm dữ liệu mẫu cho PROMOTIONS
IF NOT EXISTS (SELECT * FROM PROMOTIONS)
BEGIN
    INSERT INTO PROMOTIONS (name, description, discount_percentage, start_date, end_date, active)
    VALUES 
        (N'Khuyến mãi Mùa hè', N'Giảm giá cho tất cả sách thiếu nhi', 15.00, '2025-06-01', '2025-08-31', 1),
        (N'Tựu trường', N'Giảm giá sách giáo khoa và tham khảo', 10.00, '2025-08-15', '2025-09-15', 1),
        (N'Black Friday', N'Giảm giá tất cả sách', 25.00, '2025-11-24', '2025-11-26', 0);
END
GO

-- Thêm dữ liệu mẫu cho BOOK_PROMOTIONS
IF NOT EXISTS (SELECT * FROM BOOK_PROMOTIONS)
BEGIN
    INSERT INTO BOOK_PROMOTIONS (book_id, promotion_id)
    VALUES 
        (1, 1), -- Tôi thấy hoa vàng trên cỏ xanh - Khuyến mãi Mùa hè
        (2, 1), -- Dế Mèn Phiêu Lưu Ký - Khuyến mãi Mùa hè
        (3, 1), -- Harry Potter - Khuyến mãi Mùa hè
        (1, 3), -- Tôi thấy hoa vàng trên cỏ xanh - Black Friday
        (2, 3), -- Dế Mèn Phiêu Lưu Ký - Black Friday
        (3, 3), -- Harry Potter - Black Friday
        (4, 3), -- Đắc Nhân Tâm - Black Friday
        (5, 3); -- Tắt Đèn - Black Friday
END
GO

-- Thêm dữ liệu mẫu cho INVENTORY
IF NOT EXISTS (SELECT * FROM INVENTORY)
BEGIN
    INSERT INTO INVENTORY (book_id, quantity_change, transaction_type, transaction_date, notes)
    VALUES 
        (1, 150, N'Nhập kho', '2025-01-05', N'Nhập kho lần đầu'),
        (2, 120, N'Nhập kho', '2025-01-05', N'Nhập kho lần đầu'),
        (3, 85, N'Nhập kho', '2025-01-05', N'Nhập kho lần đầu'),
        (4, 200, N'Nhập kho', '2025-01-05', N'Nhập kho lần đầu'),
        (5, 100, N'Nhập kho', '2025-01-05', N'Nhập kho lần đầu'),
        (1, 50, N'Nhập kho', '2025-03-10', N'Bổ sung kho'),
        (3, 30, N'Nhập kho', '2025-03-10', N'Bổ sung kho'),
        (1, -2, N'Xuất kho', '2025-06-01', N'Đơn hàng #1'),
        (3, -1, N'Xuất kho', '2025-06-05', N'Đơn hàng #2'),
        (2, -1, N'Xuất kho', '2025-06-10', N'Đơn hàng #3'),
        (5, -1, N'Xuất kho', '2025-06-10', N'Đơn hàng #3');
END
GO

GO

-- Tạo View để xem thông tin sách đầy đủ
CREATE OR ALTER VIEW vw_book_details
AS
    SELECT 
        b.book_id,
        b.title,
        a.name AS author_name,
        c.name AS category_name,
        p.name AS publisher_name,
        b.ISBN,
        b.price,
        b.stock_quantity,
        b.publication_date,
        b.description,
        b.image_url,
        COALESCE(AVG(CAST(r.rating AS FLOAT)), 0) AS avg_rating,
        COUNT(r.review_id) AS review_count
    FROM BOOKS b
    LEFT JOIN AUTHORS a ON b.author_id = a.author_id
    LEFT JOIN CATEGORIES c ON b.category_id = c.category_id
    LEFT JOIN PUBLISHERS p ON b.publisher_id = p.publisher_id
    LEFT JOIN REVIEWS r ON b.book_id = r.book_id
    GROUP BY 
        b.book_id, b.title, a.name, c.name, p.name, 
        b.ISBN, b.price, b.stock_quantity, b.publication_date, 
        b.description, b.image_url
GO
*/

--===================================================--
---------------------- FUNTION ------------------------
--===================================================--
-- Tạo Function để tính giá sau khuyến mãi
CREATE OR ALTER FUNCTION fn_get_discounted_price(
    @book_id INT,
    @date DATE = NULL
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @price DECIMAL(10, 2)
    DECLARE @max_discount DECIMAL(5, 2)
    
    IF @date IS NULL
        SET @date = GETDATE()
    
    -- Lấy giá gốc của sách
    SELECT @price = price FROM BOOKS WHERE book_id = @book_id
    
    -- Tìm khuyến mãi cao nhất áp dụng cho sách vào ngày chỉ định
    SELECT @max_discount = COALESCE(MAX(p.discount_percentage), 0)
    FROM PROMOTIONS p
    JOIN BOOK_PROMOTIONS bp ON p.promotion_id = bp.promotion_id
    WHERE bp.book_id = @book_id
    AND p.active = 1
    AND @date BETWEEN p.start_date AND p.end_date
    
    -- Tính giá sau khuyến mãi
    RETURN @price * (1 - @max_discount / 100)
END
GO

------------------------------------------------------
-- Tạo Function để tìm kiếm sách
CREATE OR ALTER FUNCTION fn_search_BOOKS(
    @search_term NVARCHAR(255)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        b.book_id,
        b.title,
        a.name AS author,
        c.name AS category,
        p.name AS publisher,
        b.price,
        b.stock_quantity,
        dbo.fn_get_discounted_price(b.book_id, GETDATE()) AS discounted_price
    FROM BOOKS b
    JOIN AUTHORS a ON b.author_id = a.author_id
    JOIN CATEGORIES c ON b.category_id = c.category_id
    JOIN PUBLISHERS p ON b.publisher_id = p.publisher_id
    WHERE 
        b.title LIKE '%' + @search_term + '%'
        OR a.name LIKE '%' + @search_term + '%'
        OR c.name LIKE '%' + @search_term + '%'
        OR b.description LIKE '%' + @search_term + '%'
        OR b.ISBN LIKE '%' + @search_term + '%'
)
GO

------------------------------------------------------
-- Tổng số sách hiện có trong kho
DROP FUNCTION IF EXISTS fn_Total_Books
GO	
CREATE FUNCTION fn_Total_Books()
RETURNS INT
AS
BEGIN
    DECLARE @total_book INT
    SELECT @total_book = COUNT(*)
    FROM dbo.BOOKS

    RETURN @total_book
END
GO

DECLARE @total INT
SET @total = dbo.fn_Total_Books()
PRINT(@total)

------------------------------------------------------
-- Tổng số đơn hàng hôm nay
DROP FUNCTION IF EXISTS fn_Total_Today_Orders
GO
CREATE FUNCTION fn_Total_Today_Orders()
RETURNS INT
AS
BEGIN
    DECLARE @count_orders INT
    SELECT @count_orders = COUNT(*)
    FROM dbo.ORDERS
    WHERE CAST(ORDER_DATE AS DATE) = CAST(GETDATE() AS DATE)

    RETURN @count_orders
END
GO

------------------------------------------------------
-- Tổng số khách hàng
DROP FUNCTION IF EXISTS fn_Total_Customers
GO
CREATE FUNCTION fn_Total_Customers()
RETURNS INT
AS
BEGIN
    DECLARE @count_customers INT
    SELECT @count_customers = COUNT(*)
    FROM dbo.CUSTOMERS

    RETURN @count_customers
END
GO

------------------------------------------------------
-- Tổng số doanh thu tháng
DROP FUNCTION IF EXISTS fn_Monthly_Revenue
GO
CREATE FUNCTION fn_Monthly_Revenue()
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @revenue DECIMAL(18, 2)
    SELECT @revenue = SUM(TOTAL_AMOUNT)
    FROM dbo.ORDERS
    WHERE MONTH(ORDER_DATE) = MONTH(GETDATE())
      AND YEAR(ORDER_DATE) = YEAR(GETDATE())

    RETURN ISNULL(@revenue, 0)
END;
GO

------------------------------------------------------
-- Tạo Function để tính tổng giá trị đơn hàng
CREATE OR ALTER FUNCTION fn_get_invoice_total(@invoice_id VARCHAR(20))
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2)
    
    SELECT @total = SUM(quantity * price)
    FROM INVOICE_ITEMS
    WHERE invoice_id = @invoice_id
    
    RETURN ISNULL(@total, 0)
END
GO




--================================================--
-------------------- PROCEDURE----------------------
--================================================--
-- Recent Orders
DROP PROCEDURE IF EXISTS pr_Recent_Orders
GO	
CREATE PROCEDURE pr_Recent_Orders
AS
BEGIN
	SELECT TOP 5 o.order_id, o.order_date, o.total_amount, o.status, c.name
	FROM dbo.ORDERS o
	JOIN dbo.CUSTOMERS c ON c.customer_id = o.customer_id
	ORDER BY o.order_date DESC
END;
GO

EXEC dbo.pr_Recent_Orders
GO	

-- Stored Procedure để lấy ra hàng bán chạy
DROP PROCEDURE IF EXISTS pr_Best_Selling_Books
GO	
CREATE OR ALTER PROCEDURE pr_Best_Selling_Books
AS
BEGIN
    DECLARE @top_count INT = 5
	DECLARE @start_date DATE
	DECLARE @end_date DATE
    IF @start_date IS NULL
        SET @start_date = DATEADD(MONTH, -1, GETDATE())
    
    IF @end_date IS NULL
        SET @end_date = GETDATE()
    
    SELECT TOP (@top_count)
        b.book_id,
        b.title,
        a.name AS author,
        c.name AS category,
		b.price,
        SUM(od.quantity) AS total_sold,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM BOOKS b
    JOIN ORDER_DETAILS od ON b.book_id = od.book_id
    JOIN ORDERS o ON od.order_id = o.order_id
    JOIN AUTHORS a ON b.author_id = a.author_id
    JOIN CATEGORIES c ON b.category_id = c.category_id
    WHERE o.order_date BETWEEN @start_date AND @end_date
		AND o.status != N'Đã hủy'
    GROUP BY b.book_id, b.title, a.name, c.name, b.price
    ORDER BY total_sold DESC;
END;
GO

EXEC dbo.pr_Best_Selling_Books
GO	

----------------------------------------------------------
-- Stored Procedure để lấy ra hàng sắp hết
DROP PROCEDURE IF EXISTS pr_Low_Stock_Books
GO	
CREATE OR ALTER PROCEDURE pr_Low_Stock_Books
AS
BEGIN
    DECLARE @threshold INT = 10
    SELECT 
        b.book_id,
        b.title,
        b.stock_quantity,
        a.name AS author,
        c.name AS category
    FROM BOOKS b
    LEFT JOIN AUTHORS a ON b.author_id = a.author_id
    LEFT JOIN CATEGORIES c ON b.category_id = c.category_id
    WHERE b.stock_quantity < @threshold
    ORDER BY b.stock_quantity ASC;
END;
GO

EXEC dbo.pr_Low_Stock_Books
GO	
-----------------------------------------------------
-- Tìm kiếm thông tin sách từ form
DROP PROCEDURE IF EXISTS pr_Search_Books
GO	
CREATE PROCEDURE pr_search_books
    @keyword NVARCHAR(255) = NULL,
    @categoryId INT = NULL,
    @authorId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        b.book_id,
		b.image_url,
        b.title,
        b.stock_quantity,
		b.price,
        c.name AS category_name,
        a.name AS author_name
    FROM 
        BOOKS b
    LEFT JOIN 
        CATEGORIES c ON b.category_id = c.category_id
    LEFT JOIN 
        AUTHORS a ON b.author_id = a.author_id
    WHERE 
        (@keyword IS NULL OR b.title LIKE '%' + @keyword + '%')
        AND (@categoryId = 0 OR b.category_id = @categoryId)
        AND (@authorId = 0 OR b.author_id = @authorId);
END;
GO	

EXEC dbo.pr_search_books @keyword = N'',  -- nvarchar(255)
                         @categoryId = 0, -- int
                         @authorId = 0    -- int

-----------------------------------------------------
-- Tìm kiếm thông tin tác giả từ form
DROP PROCEDURE IF EXISTS pr_Search_Authors
GO	
CREATE PROCEDURE pr_Search_Authors
    @author_name NVARCHAR(50) = NULL,
    @country NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        a.author_id,
        a.image_url,
        a.name,
        a.country,
        a.bio,
        COUNT(b.book_id) AS bookcount
    FROM 
		AUTHORS a
    LEFT JOIN 
		BOOKS b ON a.author_id = b.author_id
    WHERE 
        (@author_name IS NULL OR a.name LIKE '%' + @author_name + '%')
        AND (@country = N'tất cả' OR a.country = @country)
    GROUP BY 
        a.author_id,
        a.image_url,
        a.name,
        a.country,
        a.bio
    ORDER BY a.author_id;
END;
GO

EXEC dbo.pr_Search_Authors @author_name = N'', -- nvarchar(50)
                           @country = N'Việt Nam'      -- nvarchar(100)

SELECT * FROM dbo.AUTHORS

-----------------------------------------------------
-- Lấy các quốc gia trong tác giả 
DROP PROCEDURE IF EXISTS pr_GetCountriesFromAuthors
GO
CREATE PROCEDURE pr_GetCountriesFromAuthors
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT country
    FROM AUTHORS
    WHERE country IS NOT NULL
    ORDER BY country;
END;
GO

EXEC pr_GetCountriesFromAuthors;
GO

-----------------------------------------------------
-- Tạo Stored Procedure để tạo hóa đơn mới
CREATE OR ALTER PROCEDURE pr_create_invoice
    @customer_name NVARCHAR(255),
    @customer_phone NVARCHAR(20),
    @invoice_id VARCHAR(20) OUTPUT
AS
BEGIN
    DECLARE @current_year INT = YEAR(GETDATE())
    DECLARE @last_invoice_num INT
    
    -- Tạo invoice_id mới
    SELECT @last_invoice_num = ISNULL(MAX(CAST(SUBSTRING(invoice_id, 10, 4) AS INT)), 0)
    FROM INVOICES
    WHERE invoice_id LIKE 'INV-' + CAST(@current_year AS VARCHAR) + '-%'
    
    SET @invoice_id = 'INV-' + CAST(@current_year AS VARCHAR) + '-' + RIGHT('0000' + CAST(@last_invoice_num + 1 AS VARCHAR), 4)
    
    -- Tạo hóa đơn mới
    INSERT INTO INVOICES (invoice_id, customer_name, customer_phone, created_date, status)
    VALUES (@invoice_id, @customer_name, @customer_phone, GETDATE(), N'Đã thanh toán')
    
    RETURN
END;
GO

-----------------------------------------------------
-- Tạo Stored Procedure để thêm sản phẩm vào hóa đơn
CREATE OR ALTER PROCEDURE pr_add_invoice_item
    @invoice_id VARCHAR(20),
    @book_id INT,
    @quantity INT
AS
BEGIN
    DECLARE @book_title NVARCHAR(255)
    DECLARE @book_author NVARCHAR(100)
    DECLARE @price DECIMAL(10,2)
    
    -- Lấy thông tin sách
    SELECT 
        @book_title = b.title,
        @book_author = a.name,
        @price = b.price
    FROM BOOKS b
    JOIN AUTHORS a ON b.author_id = a.author_id
    WHERE b.book_id = @book_id
    
    -- Thêm chi tiết hóa đơn
    IF @book_title IS NOT NULL
    BEGIN
        INSERT INTO INVOICE_ITEMS (invoice_id, book_id, book_title, book_author, quantity, price)
        VALUES (@invoice_id, @book_id, @book_title, @book_author, @quantity, @price)
        
        -- Cập nhật số lượng sách
        UPDATE BOOKS
        SET stock_quantity = stock_quantity - @quantity
        WHERE book_id = @book_id AND stock_quantity >= @quantity
    END
    
    RETURN
END;
GO

-----------------------------------------------------
-- Stored Procedure để đăng nhập
CREATE OR ALTER PROCEDURE pr_login
    @username NVARCHAR(50),
    @password_hash NVARCHAR(255),
    @login_success BIT OUTPUT,
    @role_name NVARCHAR(50) OUTPUT,
    @customer_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @account_id INT
    DECLARE @role_id INT
    
    -- Kiểm tra đăng nhập
    SELECT 
        @account_id = a.account_id,
        @role_id = a.role_id,
        @customer_id = a.customer_id
    FROM 
        ACCOUNTS a
    WHERE 
        a.username = @username 
        AND a.password_hash = @password_hash
        AND a.is_active = 1
    
    -- Xác định thành công và lấy tên vai trò
    IF @account_id IS NOT NULL
    BEGIN
        SET @login_success = 1
        
        SELECT @role_name = r.role_name
        FROM ROLES r
        WHERE r.role_id = @role_id
        
        -- Cập nhật thời gian đăng nhập cuối
        UPDATE ACCOUNTS
        SET last_login = GETDATE()
        WHERE account_id = @account_id
    END
    ELSE
    BEGIN
        SET @login_success = 0
        SET @role_name = NULL
        SET @customer_id = NULL
    END
    
    RETURN
END;
GO

-- Stored Procedure để đăng ký tài khoản mới
CREATE OR ALTER PROCEDURE pr_register_account
    @username NVARCHAR(50),
    @password_hash NVARCHAR(255),
    @email NVARCHAR(100),
    @customer_name NVARCHAR(255),
    @phone NVARCHAR(20),
    @address NVARCHAR(255),
    @success BIT OUTPUT,
    @customer_id INT OUTPUT,
    @account_id INT OUTPUT,
    @error_message NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
            
            -- Kiểm tra username đã tồn tại chưa
            IF EXISTS (SELECT 1 FROM ACCOUNTS WHERE username = @username)
            BEGIN
                SET @success = 0
                SET @error_message = N'Tên đăng nhập đã tồn tại'
                SET @customer_id = NULL
                SET @account_id = NULL
                ROLLBACK
                RETURN
            END
            
            -- Kiểm tra email đã tồn tại chưa
            IF EXISTS (SELECT 1 FROM ACCOUNTS WHERE email = @email)
            BEGIN
                SET @success = 0
                SET @error_message = N'Email đã được sử dụng'
                SET @customer_id = NULL
                SET @account_id = NULL
                ROLLBACK
                RETURN
            END
            
            -- Thêm thông tin khách hàng
            INSERT INTO CUSTOMERS (name, email, phone, address, registration_date)
            VALUES (@customer_name, @email, @phone, @address, GETDATE())
            
            SET @customer_id = SCOPE_IDENTITY()
            
            -- Thêm tài khoản với vai trò User (role_id = 3)
            INSERT INTO ACCOUNTS (username, password_hash, email, role_id, customer_id, is_active, created_date)
            VALUES (@username, @password_hash, @email, 3, @customer_id, 1, GETDATE())
            
            SET @account_id = SCOPE_IDENTITY()
            SET @success = 1
            SET @error_message = NULL
            
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK
        SET @success = 0
        SET @customer_id = NULL
        SET @account_id = NULL
        SET @error_message = ERROR_MESSAGE()
    END CATCH
    
    RETURN
END;
GO

-- Stored Procedure để thay đổi quyền người dùng
CREATE OR ALTER PROCEDURE pr_change_user_role
    @account_id INT,
    @new_role_id INT,
    @success BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Kiểm tra tài khoản tồn tại
        IF NOT EXISTS (SELECT 1 FROM ACCOUNTS WHERE account_id = @account_id)
        BEGIN
            SET @success = 0
            RETURN
        END
        
        -- Kiểm tra vai trò tồn tại
        IF NOT EXISTS (SELECT 1 FROM ROLES WHERE role_id = @new_role_id)
        BEGIN
            SET @success = 0
            RETURN
        END
        
        -- Cập nhật vai trò
        UPDATE ACCOUNTS
        SET role_id = @new_role_id
        WHERE account_id = @account_id
        
        SET @success = 1
    END TRY
    BEGIN CATCH
        SET @success = 0
    END CATCH
    
    RETURN
END;
GO

--================================================--
-------------------- VIEW----------------------
--================================================--
-- Tạo View để xem thông tin hóa đơn chi tiết
CREATE OR ALTER VIEW vw_invoice_details
AS
    SELECT 
        i.invoice_id,
        i.customer_name,
        i.customer_phone,
        i.created_date,
        i.status,
        dbo.fn_get_invoice_total(i.invoice_id) AS total_amount,
        COUNT(ii.id) AS item_count,
        SUM(ii.quantity) AS total_items
    FROM INVOICES i
    LEFT JOIN INVOICE_ITEMS ii ON i.invoice_id = ii.invoice_id
    GROUP BY 
        i.invoice_id, 
        i.customer_name, 
        i.customer_phone, 
        i.created_date, 
        i.status
GO

-- View hiển thị thông tin tài khoản và vai trò
CREATE OR ALTER VIEW vw_account_details
AS
    SELECT 
        a.account_id,
        a.username,
        a.email,
        r.role_name,
        r.role_id,
        a.is_active,
        a.created_date,
        a.last_login,
        a.customer_id,
        c.name AS customer_name,
        c.phone AS customer_phone,
        c.address AS customer_address
    FROM 
        ACCOUNTS a
    JOIN 
        ROLES r ON a.role_id = r.role_id
    LEFT JOIN 
        CUSTOMERS c ON a.customer_id = c.customer_id
GO

--================================================--
-------------------- TEST ----------------------
--================================================--
SELECT b.*, a.name as author_name, c.name as category_name, p.name as publisher_name,
    COALESCE(AVG(CAST(r.rating AS FLOAT)), 0) AS avg_rating,
    COUNT(r.review_id) AS review_count
FROM BOOKS b
LEFT JOIN AUTHORS a ON b.author_id = a.author_id
LEFT JOIN CATEGORIES c ON b.category_id = c.category_id
LEFT JOIN PUBLISHERS p ON b.publisher_id = p.publisher_id
LEFT JOIN REVIEWS r ON b.book_id = r.book_id
GROUP BY b.book_id, b.title, b.author_id, b.category_id, b.publisher_id,
	b.ISBN, b.price, b.stock_quantity, b.publication_date, b.description,
	b.image_url, a.name, c.name, p.name
ORDER BY b.book_id

------------------------------------
-- Danh sách tác giả
SELECT 
	a.author_id,
	a.image_url,
	a.name,
	a.bio,
	a.birth_year,
	a.country,
	COUNT(b.author_id) AS bookcount
FROM 
	dbo.AUTHORS a
LEFT JOIN 
	dbo.BOOKS b ON b.author_id = a.author_id
GROUP BY 
	a.author_id,
	a.image_url,
	a.name,
	a.bio,
	a.birth_year,
	a.country
ORDER BY 
	a.author_id


-------------------------------------
-- Danh sách danh mục sách
SELECT 
    c.category_id, 
    c.name, 
    COUNT(b.category_id) AS book_count
FROM 
    CATEGORIES c
JOIN 
    BOOKS b ON b.category_id = c.category_id
GROUP BY 
    c.category_id, 
    c.name
ORDER BY 
    c.category_id ASC;
GO

-------------------------------------
-- Danh sách nhà xuất bản
SELECT
	p.publisher_id,
	p.name,
	p.address,
	p.phone,
	COUNT(b.publisher_id) AS bookcount
FROM
	dbo.PUBLISHERS p
LEFT JOIN
	dbo.BOOKS b ON b.publisher_id = p.publisher_id
GROUP BY
	p.publisher_id,
	p.name,
	p.address,
	p.phone
ORDER BY
	p.publisher_id
GO	

-------------------------------------
SELECT * FROM dbo.CUSTOMERS
-------------------------------------
SELECT * FROM dbo.ORDERS
-------------------------------------
SELECT b.*, a.name AS authorName, c.name AS categoryName
FROM dbo.BOOKS AS b
JOIN dbo.AUTHORS AS a ON a.author_id = b.author_id
JOIN dbo.CATEGORIES AS c ON c.category_id = b.category_id
-------------------------------------
SELECT * FROM dbo.CATEGORIES
-------------------------------------
SELECT * FROM dbo.PUBLISHERS
-------------------------------------
SELECT * FROM dbo.AUTHORS
-------------------------------------
SELECT * FROM dbo.ACCOUNTS
-------------------------------------
SELECT * FROM dbo.ROLES
-------------------------------------
