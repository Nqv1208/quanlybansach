package com.quanlybansach.dao;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import com.quanlybansach.model.Order;
import com.quanlybansach.util.DBConnection;

public class OrderDAO {

   public List<Order> getAllOrders() {
      List<Order> orders = new ArrayList<>();

      try (Connection conn = DBConnection.getConnection()) {
         String sql = "SELECT o.*, c.name FROM orders o JOIN customers c ON o.customer_id = c.customer_id";
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery();

         while (rs.next()) {
            Order order = mapResultSetToOrder(rs);
            orders.add(order);
         }
      
      } catch (Exception e) {
         e.printStackTrace();
      }
      
      return orders;
   }
   
   public List<Order> getRecenOrders() {
      List<Order> orders = new ArrayList<>();

      try (Connection conn = DBConnection.getConnection()) {
         CallableStatement cstm = conn.prepareCall("{call pr_Recent_Orders()}");
         ResultSet rs = cstm.executeQuery();

         while (rs.next()) {
            Order order = new Order();
            order.setOrderId(rs.getInt("order_id"));
            order.setOrderDate(rs.getDate("order_date"));
            order.setTotalAmount(rs.getBigDecimal("total_amount"));
            order.setStatus(rs.getString("status"));
            order.setCustomerName(rs.getString("name"));
            orders.add(order);
         }
      
      } catch (Exception e) {
         e.printStackTrace();
      }
      
      return orders;
   }

   public int getTotalTodayOrders() {
      int totalOrders = 0;
      
      try (Connection conn = DBConnection.getConnection()) {
         CallableStatement cstm = conn.prepareCall("{? = call fn_Total_Today_Orders()}");
         cstm.registerOutParameter(1, Types.INTEGER);
         cstm.execute();

         totalOrders = cstm.getInt(1);

      } catch (SQLException e) {
         e.printStackTrace();
      }
      
      return totalOrders;
   }

   public BigDecimal getMonthlyRevenue() {
      BigDecimal monthlyRevenue = BigDecimal.ZERO;
      
      try (Connection conn = DBConnection.getConnection()) {
         CallableStatement cstm = conn.prepareCall("{? = call fn_Monthly_Revenue()}");
         cstm.registerOutParameter(1, Types.DECIMAL);
         cstm.execute();

         monthlyRevenue = cstm.getBigDecimal(1);

      } catch (SQLException e) {
         e.printStackTrace();
      }
      
      return monthlyRevenue;
   }

   private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
      Order order = new Order();
      order.setOrderId(rs.getInt("order_id"));
      order.setCustomerId(rs.getInt("customer_id"));
      order.setOrderDate(rs.getDate("order_date"));
      order.setTotalAmount(rs.getBigDecimal("total_amount"));
      order.setStatus(rs.getString("status"));
      order.setShippingAddress(rs.getString("shipping_address"));
      order.setPaymentMethod(rs.getString("payment_method"));
      
      // Join fields
      order.setCustomerName(rs.getString("name"));
      
      return order;
   }

   public Order getOrderById(int orderId) throws SQLException {
      Order order = null;
      try (Connection conn = DBConnection.getConnection()) {
         String sql = "SELECT * FROM orders WHERE order_id = ?";
         PreparedStatement ps = conn.prepareStatement(sql);
         ps.setInt(1, orderId);
         ResultSet rs = ps.executeQuery();

         if (rs.next()) {
            order = mapResultSetToOrder(rs);
         }
      }
      return order;
   }
   
   /**
    * Get recent orders by customer
   * 
   * @param customerId Customer ID
   * @param limit Maximum number of orders to return
   * @return List of recent orders
   * @throws SQLException if database error occurs
   */
   public List<Order> getRecentOrdersByCustomer(int customerId, int limit) throws SQLException {
      List<Order> orders = new ArrayList<>();
      String sql = "SELECT TOP(?) o.*, c.name FROM orders o " +
                  "JOIN customers c ON o.customer_id = c.customer_id " +
                  "WHERE o.customer_id = ? " +
                  "ORDER BY o.order_date DESC ";
      
      try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
         
         stmt.setInt(1, customerId);
         stmt.setInt(2, limit);
         
         try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                  Order order = mapResultSetToOrder(rs);
                  orders.add(order);
            }
         }
      }
      
      return orders;
   }
   
   /**
    * Get count of orders for a customer
   * 
   * @param customerId Customer ID
   * @return Count of orders
   * @throws SQLException if database error occurs
   */
   public int getOrderCountByCustomer(int customerId) throws SQLException {
      String sql = "SELECT COUNT(*) FROM orders WHERE customer_id = ?";
      
      try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
         
         stmt.setInt(1, customerId);
         
         try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                  return rs.getInt(1);
            }
         }
      }
      
      return 0;
   }

   public static void main(String[] args) throws SQLException {
      OrderDAO orderDAO = new OrderDAO();
      List<Order> orders = orderDAO.getRecentOrdersByCustomer(5, 5);
      for(Order order : orders) {
         System.out.println(order.toString());
      }

   }
}
