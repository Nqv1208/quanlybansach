package com.quanlybansach.model;

import java.util.Date;

public class Account {
    private int accountId;
    private String avatarUrl; // Optional, có thể dùng để lưu đường dẫn đến ảnh đại diện
    private String username;
    private String passwordHash;
    private String email;
    private int roleId;
    private Integer customerId; // Có thể null
    private boolean isActive;
    private Date createdDate;
    private Date lastLogin;
    
    // For display purpose (join queries)
    private String roleName;
    private String customerName;
    private String phoneNumber; // Optional, có thể dùng để lưu số điện thoại của khách hàng
    private String address; // Optional, có thể dùng để lưu địa chỉ của khách hàng

    
    public Account() {
    }
    
    public Account(int accountId, String username, String passwordHash, String email, 
                  int roleId, Integer customerId, boolean isActive, Date createdDate, Date lastLogin) {
        this.accountId = accountId;
        this.username = username;
        this.passwordHash = passwordHash;
        this.email = email;
        this.roleId = roleId;
        this.customerId = customerId;
        this.isActive = isActive;
        this.createdDate = createdDate;
        this.lastLogin = lastLogin;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }
    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Date getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(Date lastLogin) {
        this.lastLogin = lastLogin;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }
    
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    @Override
    public String toString() {
        return "Account{" +
                "accountId=" + accountId +
                ", avatarUrl='" + avatarUrl + '\'' +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", roleId=" + roleId +
                ", roleName='" + roleName + '\'' +
                ", customerId=" + customerId +
                ", customerName='" + customerName + '\'' +
                ", isActive=" + isActive +
                ", createdDate=" + createdDate +
                ", lastLogin=" + lastLogin +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", address='" + address + '\'' +
                '}';
    }
} 