package com.quanlybansach.dao;

import com.quanlybansach.model.Address;
import com.quanlybansach.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Address operations
 */
public class AddressDAO {
    
    /**
     * Get addresses for a customer
     * 
     * @param customerId Customer ID
     * @return List of addresses
     * @throws SQLException if database error occurs
     */
    public List<Address> getAddressesByCustomer(int customerId) throws SQLException {
        List<Address> addresses = new ArrayList<>();
        String sql = "SELECT * FROM addresses WHERE customer_id = ? ORDER BY is_default DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Address address = mapResultSetToAddress(rs);
                    addresses.add(address);
                }
            }
        }
        
        return addresses;
    }
    
    /**
     * Get default address for a customer
     * 
     * @param customerId Customer ID
     * @return Default address or null if no default address exists
     * @throws SQLException if database error occurs
     */
    public Address getDefaultAddress(int customerId) throws SQLException {
        String sql = "SELECT * FROM addresses WHERE customer_id = ? AND is_default = 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAddress(rs);
                }
            }
        }
        
        return null;
    }
    
    /**
     * Get address by ID
     * 
     * @param addressId Address ID
     * @return Address or null if not found
     * @throws SQLException if database error occurs
     */
    public Address getAddressById(int addressId) throws SQLException {
        String sql = "SELECT * FROM addresses WHERE address_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, addressId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAddress(rs);
                }
            }
        }
        
        return null;
    }
    
    /**
     * Add a new address
     * 
     * @param address Address to add
     * @return Generated address ID
     * @throws SQLException if database error occurs
     */
    public int addAddress(Address address) throws SQLException {
        String sql = "INSERT INTO addresses (customer_id, recipient_name, phone, address_line1, address_line2, city, " +
                     "state, postal_code, country, is_default, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, address.getCustomerId());
            stmt.setString(2, address.getRecipientName());
            stmt.setString(3, address.getPhone());
            stmt.setString(4, address.getAddressLine1());
            stmt.setString(5, address.getAddressLine2());
            stmt.setString(6, address.getCity());
            stmt.setString(7, address.getState());
            stmt.setString(8, address.getPostalCode());
            stmt.setString(9, address.getCountry());
            stmt.setBoolean(10, address.isDefault());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating address failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int addressId = generatedKeys.getInt(1);
                    
                    // If this is the default address, update other addresses
                    if (address.isDefault()) {
                        updateOtherAddressesDefaultStatus(address.getCustomerId(), addressId);
                    }
                    
                    return addressId;
                } else {
                    throw new SQLException("Creating address failed, no ID obtained.");
                }
            }
        }
    }
    
    /**
     * Update an existing address
     * 
     * @param address Address to update
     * @throws SQLException if database error occurs
     */
    public void updateAddress(Address address) throws SQLException {
        String sql = "UPDATE addresses SET recipient_name = ?, phone = ?, address_line1 = ?, " +
                     "address_line2 = ?, city = ?, state = ?, postal_code = ?, country = ?, " +
                     "is_default = ?, updated_at = NOW() " +
                     "WHERE address_id = ? AND customer_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, address.getRecipientName());
            stmt.setString(2, address.getPhone());
            stmt.setString(3, address.getAddressLine1());
            stmt.setString(4, address.getAddressLine2());
            stmt.setString(5, address.getCity());
            stmt.setString(6, address.getState());
            stmt.setString(7, address.getPostalCode());
            stmt.setString(8, address.getCountry());
            stmt.setBoolean(9, address.isDefault());
            stmt.setInt(10, address.getAddressId());
            stmt.setInt(11, address.getCustomerId());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0 && address.isDefault()) {
                // If this is the default address, update other addresses
                updateOtherAddressesDefaultStatus(address.getCustomerId(), address.getAddressId());
            }
        }
    }
    
    /**
     * Delete an address
     * 
     * @param addressId Address ID
     * @param customerId Customer ID (for security check)
     * @throws SQLException if database error occurs
     */
    public void deleteAddress(int addressId, int customerId) throws SQLException {
        String sql = "DELETE FROM addresses WHERE address_id = ? AND customer_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, addressId);
            stmt.setInt(2, customerId);
            
            stmt.executeUpdate();
        }
    }
    
    /**
     * Get count of addresses for a customer
     * 
     * @param customerId Customer ID
     * @return Count of addresses
     * @throws SQLException if database error occurs
     */
    public int getAddressCountByCustomer(int customerId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM addresses WHERE customer_id = ?";
        
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
    
    /**
     * Set an address as default and update other addresses
     * 
     * @param addressId Address ID to set as default
     * @param customerId Customer ID
     * @throws SQLException if database error occurs
     */
    public void setDefaultAddress(int addressId, int customerId) throws SQLException {
        // First, set all addresses for this customer as non-default
        String sql1 = "UPDATE addresses SET is_default = 0, updated_at = NOW() WHERE customer_id = ?";
        
        // Then, set the specified address as default
        String sql2 = "UPDATE addresses SET is_default = 1, updated_at = NOW() WHERE address_id = ? AND customer_id = ?";
        
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            try (PreparedStatement stmt1 = conn.prepareStatement(sql1)) {
                stmt1.setInt(1, customerId);
                stmt1.executeUpdate();
            }
            
            try (PreparedStatement stmt2 = conn.prepareStatement(sql2)) {
                stmt2.setInt(1, addressId);
                stmt2.setInt(2, customerId);
                stmt2.executeUpdate();
            }
            
            conn.commit();
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    throw new SQLException("Error during transaction rollback", ex);
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    throw new SQLException("Error resetting auto-commit", e);
                }
            }
        }
    }
    
    /**
     * Update default status of other addresses when a new default is set
     * 
     * @param customerId Customer ID
     * @param excludeAddressId Address ID to exclude (the new default)
     * @throws SQLException if database error occurs
     */
    private void updateOtherAddressesDefaultStatus(int customerId, int excludeAddressId) throws SQLException {
        String sql = "UPDATE addresses SET is_default = 0, updated_at = NOW() " +
                     "WHERE customer_id = ? AND address_id != ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);
            stmt.setInt(2, excludeAddressId);
            
            stmt.executeUpdate();
        }
    }
    
    /**
     * Map ResultSet to Address object
     * 
     * @param rs ResultSet
     * @return Address object
     * @throws SQLException if database error occurs
     */
    private Address mapResultSetToAddress(ResultSet rs) throws SQLException {
        Address address = new Address();
        address.setAddressId(rs.getInt("address_id"));
        address.setCustomerId(rs.getInt("customer_id"));
        address.setRecipientName(rs.getString("recipient_name"));
        address.setPhone(rs.getString("phone"));
        address.setAddressLine1(rs.getString("address_line1"));
        address.setAddressLine2(rs.getString("address_line2"));
        address.setCity(rs.getString("city"));
        address.setState(rs.getString("state"));
        address.setPostalCode(rs.getString("postal_code"));
        address.setCountry(rs.getString("country"));
        address.setDefault(rs.getBoolean("is_default"));
        address.setCreatedAt(rs.getTimestamp("created_at"));
        address.setUpdatedAt(rs.getTimestamp("updated_at"));
        return address;
    }
} 