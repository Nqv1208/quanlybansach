package com.quanlybansach.service;

import com.quanlybansach.dao.AuthorDAO;
import com.quanlybansach.model.Author;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Lớp service xử lý logic nghiệp vụ liên quan đến tác giả
 */
public class AuthorService {
    private AuthorDAO authorDAO;
    
    public AuthorService() {
        this.authorDAO = new AuthorDAO();
    }
    
    /**
     * Lấy danh sách tất cả tác giả
     */
    public List<Author> getAllAuthors() {
        return authorDAO.getAllAuthors();
    }
    
    /**
     * Lấy thông tin chi tiết một tác giả
     */
    public Author getAuthorById(int authorId) {
        return authorDAO.getAuthorById(authorId);
    }
    
    /**
     * Thêm tác giả mới
     */
    public boolean addAuthor(Author author) {
        // Kiểm tra dữ liệu đầu vào
        if (author == null || author.getName() == null || author.getName().trim().isEmpty()) {
            return false;
        }
        
        return authorDAO.addAuthor(author);
    }
    
    /**
     * Cập nhật thông tin tác giả
     */
    public boolean updateAuthor(Author author) {
        // Kiểm tra dữ liệu đầu vào
        if (author == null || author.getAuthorId() <= 0 || 
            author.getName() == null || author.getName().trim().isEmpty()) {
            return false;
        }
        
        return authorDAO.updateAuthor(author);
    }
    
    /**
     * Xóa tác giả
     */
    public boolean deleteAuthor(int authorId) {
        if (authorId <= 0) {
            return false;
        }
        
        return authorDAO.deleteAuthor(authorId);
    }
    
    /**
     * Tìm kiếm tác giả theo từ khóa và quốc tịch
     */
    public List<Author> searchAuthors(String keyword, String nationality) {
        return authorDAO.getAuthorsByParameters(keyword, nationality);
    }
    
    /**
     * Lấy danh sách tất cả các quốc gia của tác giả
     */
    public List<String> getAllCountries() {
        return authorDAO.getAllCountries();
    }
} 