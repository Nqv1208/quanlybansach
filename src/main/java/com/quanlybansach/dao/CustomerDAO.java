package com.quanlybansach.dao;

import java.sql.Array;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import com.quanlybansach.model.Customer;
import com.quanlybansach.util.DBConnection;

public class CustomerDAO {

   public List<Customer> getAllCustomers() {
      List<Customer> list = new ArrayList<>();

      try (Connection conn = DBConnection.getConnection()) {
         String sql = "SELECT * FROM customers";
         java.sql.PreparedStatement ps = conn.prepareStatement(sql);
         java.sql.ResultSet rs = ps.executeQuery();

         while (rs.next()) {
            Customer customer = new Customer();
            customer.setCustomerId(rs.getInt("customer_id"));
            customer.setName(rs.getString("name"));
            customer.setEmail(rs.getString("email"));
            customer.setPhone(rs.getString("phone"));
            customer.setAddress(rs.getString("address"));
            
            list.add(customer);
         }
         
      } catch (Exception e) {
         e.printStackTrace();
      }
      return list;
   }

   public Customer getCustomerById(int id) {
      // Implementation to get a customer by ID from the database
      Customer customer = null;
      try (Connection conn = DBConnection.getConnection()) {
         String sql = "SELECT * FROM customers WHERE customer_id = ?";
         PreparedStatement ps = conn.prepareStatement(sql);
         ps.setInt(1, id);
         ResultSet rs = ps.executeQuery();

         if (rs.next()) {
            customer = new Customer();
            customer.setCustomerId(rs.getInt("customer_id"));
            customer.setName(rs.getString("name"));
            customer.setEmail(rs.getString("email"));
            customer.setPhone(rs.getString("phone"));
            customer.setAddress(rs.getString("address"));
            customer.setRegistrationDate(rs.getDate("registration_date"));
         }
      } catch (Exception e) {
         e.printStackTrace();
      }
      return customer;
   }

   public int getTotalCustomers() {
      int total = 0;
      try (Connection conn = DBConnection.getConnection()) {
         CallableStatement cstm = conn.prepareCall("{? = call fn_Total_Customers()}");
         cstm.registerOutParameter(1, Types.INTEGER);
         cstm.execute();

         total = cstm.getInt(1);

      } catch (Exception e) {
         e.printStackTrace();
      }
      return total;
   }
   
   /**
    * Check if provided password is correct for the given username
    * 
    * @param username Username
    * @param password Password to check
    * @return true if password matches, false otherwise
    * @throws SQLException if database error occurs
    */
   public boolean checkPassword(String username, String password) throws SQLException {
      String sql = "SELECT COUNT(*) FROM customers WHERE username = ? AND password = ?";
      
      try (Connection conn = DBConnection.getConnection();
           PreparedStatement stmt = conn.prepareStatement(sql)) {
          
          stmt.setString(1, username);
          stmt.setString(2, password); // In a real app, you would hash the password
          
          try (ResultSet rs = stmt.executeQuery()) {
              if (rs.next()) {
                  return rs.getInt(1) > 0;
              }
          }
      }
      
      return false;
   }
   
   /**
    * Update customer password
    * 
    * @param username Username
    * @param newPassword New password
    * @throws SQLException if database error occurs
    */
   public void updatePassword(String username, String newPassword) throws SQLException {
      String sql = "UPDATE customers SET password = ? WHERE username = ?";
      
      try (Connection conn = DBConnection.getConnection();
           PreparedStatement stmt = conn.prepareStatement(sql)) {
          
          stmt.setString(1, newPassword); // In a real app, you would hash the password
          stmt.setString(2, username);
          
          stmt.executeUpdate();
      }
   }
   
   /**
    * Update customer information
    * 
    * @param customer Customer with updated information
    * @throws SQLException if database error occurs
    */
   public void updateCustomer(Customer customer) throws SQLException {
      String sql = "UPDATE customers SET name = ?, email = ?, phone = ?, address = ? WHERE customer_id = ?";
      
      try (Connection conn = DBConnection.getConnection();
           PreparedStatement stmt = conn.prepareStatement(sql)) {
          
          stmt.setString(1, customer.getName());
          stmt.setString(2, customer.getEmail());
          stmt.setString(3, customer.getPhone());
          stmt.setString(4, customer.getAddress());
          stmt.setInt(5, customer.getCustomerId());
          
          stmt.executeUpdate();
      }
   }

   public static void main(String[] args) {
      CustomerDAO customerDAO = new CustomerDAO();
      List<Customer> customers = customerDAO.getAllCustomers();
      for (Customer customer : customers) {
         System.out.println(customer);
      }
      
      int totalCustomers = customerDAO.getTotalCustomers();
      System.out.println("Total Customers: " + totalCustomers);
   }
   
}