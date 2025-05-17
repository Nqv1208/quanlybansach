package com.quanlybansach.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=BOOKSTORE_MANAGEMENT;encrypt=false;trustServerCertificate=false";
    private static final String USER = "NQV";
    private static final String PASS = "120805"; // Change this to your actual password
    
    /**
     * Tạo và trả về một kết nối mới đến cơ sở dữ liệu
     * @return Kết nối đến cơ sở dữ liệu
     */
    public static Connection getConnection() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(DB_URL, USER, PASS);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Đóng kết nối đến cơ sở dữ liệu
     * @param connection Kết nối cần đóng
     */
    public static void closeConnection(Connection connection) {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
} 