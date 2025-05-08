package com.quanlybansach.service;

import com.quanlybansach.dao.CustomerDAO;
import com.quanlybansach.model.Customer;

import java.sql.SQLException;
import java.util.List;

/**
 * Lớp service xử lý logic nghiệp vụ liên quan đến khách hàng
 */
public class CustomerService {
    private CustomerDAO customerDAO;
    
    public CustomerService() {
        this.customerDAO = new CustomerDAO();
    }
    
    /**
     * Lấy danh sách tất cả khách hàng
     */
    public List<Customer> getAllCustomers() throws SQLException {
        return customerDAO.getAllCustomers();
    }
    
    /**
     * Lấy thông tin chi tiết một khách hàng
     */
    public Customer getCustomerById(int customerId) throws SQLException {
        // Trong thực tế, bạn sẽ gọi hàm tương ứng từ CustomerDAO
        List<Customer> customers = customerDAO.getAllCustomers();
        
        for (Customer customer : customers) {
            if (customer.getCustomerId() == customerId) {
                return customer;
            }
        }
        
        return null;
    }
    
    /**
     * Tìm kiếm khách hàng theo từ khóa
     */
    public List<Customer> searchCustomers(String keyword) throws SQLException {
        // Trong thực tế, bạn sẽ gọi hàm tương ứng từ CustomerDAO
        return customerDAO.getAllCustomers();
    }
    
    /**
     * Xác thực khách hàng khi đăng nhập
     */
    public Customer authenticate(String email, String password) throws SQLException {
        // Trong thực tế, bạn sẽ gọi hàm tương ứng từ CustomerDAO
        List<Customer> customers = customerDAO.getAllCustomers();
        
        for (Customer customer : customers) {
            if (customer.getEmail() != null && customer.getEmail().equals(email)) {
                // Trong thực tế, bạn sẽ kiểm tra mật khẩu đã mã hóa
                // Ở đây chỉ là ví dụ đơn giản
                return customer;
            }
        }
        
        return null;
    }
    
    /**
     * Đăng ký khách hàng mới
     */
    public boolean registerCustomer(Customer customer) throws SQLException {
        // Trong thực tế, bạn sẽ gọi hàm tương ứng từ CustomerDAO
        // customerDAO.createCustomer(customer);
        return true;
    }
    
    /**
     * Cập nhật thông tin khách hàng
     */
    public boolean updateCustomer(Customer customer) throws SQLException {
        // Trong thực tế, bạn sẽ gọi hàm tương ứng từ CustomerDAO
        // customerDAO.updateCustomer(customer);
        return true;
    }
    
    /**
     * Kiểm tra email đã tồn tại chưa
     */
    public boolean isEmailExists(String email) throws SQLException {
        // Trong thực tế, bạn sẽ gọi hàm tương ứng từ CustomerDAO
        List<Customer> customers = customerDAO.getAllCustomers();
        
        for (Customer customer : customers) {
            if (customer.getEmail() != null && customer.getEmail().equals(email)) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * Lấy tổng số khách hàng
     */
    public int getTotalCustomers() throws SQLException {
        return customerDAO.getTotalCustomers();
    }
} 