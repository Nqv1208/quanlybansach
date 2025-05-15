package com.quanlybansach.util;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;

/**
 * Utility class for PDF operations with Vietnamese fonts
 */
public class PdfUtil {
    
    /**
     * Get fonts for PDF document that support Vietnamese
     * Using fonts from WEB-INF/fonts directory
     */
    public static Font[] getPdfFonts(HttpServletRequest request) {
        Font titleFont = null, normalFont = null, headerFont = null;
        
        try {
            // Tìm font trong thư mục WEB-INF/fonts
            ServletContext context = request.getServletContext();
            String fontPath = context.getRealPath("/WEB-INF/fonts/Roboto-VariableFont_wdth,wght.ttf");
            
            // Kiểm tra nếu file tồn tại
            File fontFile = new File(fontPath);
            if (!fontFile.exists()) {
                // Thử tìm font Montserrat nếu không có Roboto
                fontPath = context.getRealPath("/WEB-INF/fonts/Montserrat-VariableFont_wght.ttf");
                fontFile = new File(fontPath);
                if (!fontFile.exists()) {
                    throw new Exception("Không tìm thấy font trong thư mục WEB-INF/fonts");
                }
            }
            
            System.out.println("Đang sử dụng font từ: " + fontPath);
            BaseFont baseFont = BaseFont.createFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            titleFont = new Font(baseFont, 18, Font.BOLD);
            normalFont = new Font(baseFont, 12, Font.NORMAL);
            headerFont = new Font(baseFont, 12, Font.BOLD, BaseColor.WHITE);
        } catch (Exception e) {
            System.out.println("Lỗi font: " + e.getMessage());
            
            try {
                // Sử dụng font Times Roman nếu không tìm thấy font tùy chỉnh
                BaseFont baseFont = BaseFont.createFont(BaseFont.TIMES_ROMAN, "Cp1258", BaseFont.EMBEDDED);
                titleFont = new Font(baseFont, 18, Font.BOLD);
                normalFont = new Font(baseFont, 12, Font.NORMAL);
                headerFont = new Font(baseFont, 12, Font.BOLD, BaseColor.WHITE);
            } catch (Exception ex) {
                // Nếu không tìm thấy font tùy chỉnh, sử dụng font Helvetica
                System.out.println("Fallback to basic font: " + ex.getMessage());
                titleFont = FontFactory.getFont(FontFactory.HELVETICA, 18, Font.BOLD);
                normalFont = FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL);
                headerFont = FontFactory.getFont(FontFactory.HELVETICA, 12, Font.BOLD, BaseColor.WHITE);
            }
        }
        
        return new Font[]{titleFont, normalFont, headerFont};
    }
    
    /**
     * Cấu hình phản hồi HTTP cho PDF
     */
    public static void configureResponse(HttpServletResponse response, boolean isDownload, String filename) {
        response.setContentType("application/pdf");
        if (isDownload) {
            response.setHeader("Content-Disposition", "attachment; filename=" + filename);
        } else {
            response.setHeader("Content-Disposition", "inline; filename=" + filename);
        }
    }
    
    /**
     * Thêm tiêu đề cho tài liệu PDF
     */
    public static void addDocumentHeader(Document document, String title, Font titleFont, Font normalFont) throws DocumentException {
        // Add title
        Paragraph titlePara = new Paragraph(title, titleFont);
        titlePara.setAlignment(Element.ALIGN_CENTER);
        document.add(titlePara);
        
        // Thêm ngày report
        Paragraph date = new Paragraph("Ngày xuất báo cáo: " + new SimpleDateFormat("dd/MM/yyyy").format(new Date()), normalFont);
        date.setAlignment(Element.ALIGN_RIGHT);
        document.add(date);
        
        document.add(new Paragraph(" ")); // Thêm khoảng trắng
    }
    
    /**
     * Thêm footer cho tài liệu PDF
     */
    public static void addDocumentFooter(Document document, Font normalFont) throws DocumentException {
        document.add(new Paragraph(" ")); // Add space
        Paragraph footer = new Paragraph("© Hệ Thống Quản Lý Bán Sách", normalFont);
        footer.setAlignment(Element.ALIGN_CENTER);
        document.add(footer);
    }
    
    /**
     * Tạo header cho bảng
     */
    public static PdfPCell createHeaderCell(String text, Font headerFont) {
        PdfPCell cell = new PdfPCell(new Phrase(text, headerFont));
        cell.setBackgroundColor(new BaseColor(41, 128, 185));
        cell.setPadding(5);
        return cell;
    }
    
    /**
     * Tạo cell cho bảng
     */
    public static PdfPCell createCell(String text, Font normalFont) {
        return new PdfPCell(new Phrase(text, normalFont));
    }
    
    /**
     * Tạo cell cho bảng với căn phải
     */
    public static PdfPCell createRightAlignedCell(String text, Font normalFont) {
        PdfPCell cell = new PdfPCell(new Phrase(text, normalFont));
        cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        return cell;
    }
} 