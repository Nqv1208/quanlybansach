package com.quanlybansach.model;

public class CartSummary {
    private double subtotal;
    private double shippingFee;
    private double discount;
    private double total;
    private int itemCount;

    public CartSummary() {
        this.subtotal = 0;
        this.shippingFee = 30000; // Default shipping fee
        this.discount = 0;
        this.total = 0;
        this.itemCount = 0;
    }

    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }

    public double getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(double shippingFee) {
        this.shippingFee = shippingFee;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }

    public double getTotal() {
        return subtotal + shippingFee - discount;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public int getItemCount() {
        return itemCount;
    }

    public void setItemCount(int itemCount) {
        this.itemCount = itemCount;
    }

    public void calculateTotal() {
        this.total = subtotal + shippingFee - discount;
    }
} 