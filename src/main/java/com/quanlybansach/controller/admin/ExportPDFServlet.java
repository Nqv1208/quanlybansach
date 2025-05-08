package com.quanlybansach.controller.admin;

import java.io.IOException;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.quanlybansach.dao.BookDAO;
import com.quanlybansach.dao.InvoiceDAO;
import com.quanlybansach.model.Book;
import com.quanlybansach.model.Invoice;
import com.quanlybansach.model.InvoiceItem;
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
import com.itextpdf.text.pdf.PdfWriter;

// @WebServlet(urlPatterns = {"/admin/reports/export"})
public class ExportPDFServlet extends HttpServlet {
   private static final long serialVersionUID = 1L;
   
   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      String invoiceId = request.getParameter("invoiceId");
      
      // Thiết lập header để trình duyệt hiểu đây là file PDF cần tải xuống
      response.setContentType("application/pdf");
      response.setHeader("Content-Disposition", "attachment; filename=hoa-don-" + invoiceId + ".pdf");

      try {
         // Lấy dữ liệu hóa đơn từ Database
         InvoiceDAO invoiceDAO = new InvoiceDAO();
         Invoice invoice = invoiceDAO.getInvoiceById(invoiceId);
         
         if (invoice == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy hóa đơn");
            return;
         }
         
         // Tạo document PDF
         Document document = new Document();
         PdfWriter.getInstance(document, response.getOutputStream());
         document.open();
         
         // Thêm font chữ hỗ trợ tiếng Việt
         BaseFont baseFont = BaseFont.createFont("WEB-INF/fonts/arial.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
         Font titleFont = new Font(baseFont, 18, Font.BOLD);
         Font normalFont = new Font(baseFont, 12, Font.NORMAL);
         Font smallFont = new Font(baseFont, 10, Font.NORMAL);
         Font boldFont = new Font(baseFont, 12, Font.BOLD);
         Font headerFont = new Font(baseFont, 12, Font.BOLD, BaseColor.WHITE);
         
         // Thông tin cửa hàng
         Paragraph storeName = new Paragraph("NHÀ SÁCH TRỰC TUYẾN", titleFont);
         storeName.setAlignment(Element.ALIGN_CENTER);
         document.add(storeName);
         
         Paragraph storeAddress = new Paragraph("Địa chỉ: 123 Đường ABC, Quận XYZ, TP. Hồ Chí Minh", normalFont);
         storeAddress.setAlignment(Element.ALIGN_CENTER);
         document.add(storeAddress);
         
         Paragraph storeContact = new Paragraph("Điện thoại: 028.1234.5678 - Email: contact@nhasach.com", normalFont);
         storeContact.setAlignment(Element.ALIGN_CENTER);
         document.add(storeContact);
         
         document.add(new Paragraph(" ")); // Thêm khoảng trống
         
         // Tiêu đề hóa đơn
         Paragraph invoiceTitle = new Paragraph("HÓA ĐƠN BÁN HÀNG", titleFont);
         invoiceTitle.setAlignment(Element.ALIGN_CENTER);
         document.add(invoiceTitle);
         
         document.add(new Paragraph(" ")); // Thêm khoảng trống
         
         // Thông tin hóa đơn
         SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
         String dateStr = dateFormat.format(invoice.getCreatedDate());
         
         document.add(new Paragraph("Số hóa đơn: " + invoice.getInvoiceId(), normalFont));
         document.add(new Paragraph("Ngày: " + dateStr, normalFont));
         document.add(new Paragraph("Khách hàng: " + invoice.getCustomerName(), normalFont));
         document.add(new Paragraph("Điện thoại: " + invoice.getCustomerPhone(), normalFont));
         
         document.add(new Paragraph(" ")); // Thêm khoảng trống
         
         // Bảng chi tiết đơn hàng
         PdfPTable table = new PdfPTable(6); // 6 cột
         table.setWidthPercentage(100);
         table.setWidths(new float[] {0.5f, 3f, 2f, 1f, 1.5f, 1.5f});
         
         // Header của bảng
         PdfPCell headerCell = new PdfPCell();
         headerCell.setBackgroundColor(new BaseColor(41, 128, 185));
         headerCell.setPadding(5);
         
         headerCell.setPhrase(new Phrase("STT", headerFont));
         table.addCell(headerCell);
         
         headerCell.setPhrase(new Phrase("Tên sách", headerFont));
         table.addCell(headerCell);
         
         headerCell.setPhrase(new Phrase("Tác giả", headerFont));
         table.addCell(headerCell);
         
         headerCell.setPhrase(new Phrase("Số lượng", headerFont));
         table.addCell(headerCell);
         
         headerCell.setPhrase(new Phrase("Đơn giá", headerFont));
         table.addCell(headerCell);
         
         headerCell.setPhrase(new Phrase("Thành tiền", headerFont));
         table.addCell(headerCell);
         
         // Định dạng tiền tệ Việt Nam
         NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
         
         // Dữ liệu bảng
         double totalAmount = 0;
         List<InvoiceItem> items = invoice.getItems();
         for (int i = 0; i < items.size(); i++) {
            InvoiceItem item = items.get(i);
            
            table.addCell(new Phrase(String.valueOf(i + 1), normalFont));
            table.addCell(new Phrase(item.getBookTitle(), normalFont));
            table.addCell(new Phrase(item.getBookAuthor(), normalFont));
            table.addCell(new Phrase(String.valueOf(item.getQuantity()), normalFont));
            
            PdfPCell priceCell = new PdfPCell(new Phrase(currencyFormat.format(item.getPrice()), normalFont));
            priceCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            table.addCell(priceCell);
            
            double lineTotal = item.getQuantity() * item.getPrice();
            totalAmount += lineTotal;
            
            PdfPCell totalCell = new PdfPCell(new Phrase(currencyFormat.format(lineTotal), normalFont));
            totalCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            table.addCell(totalCell);
         }
         
         // Tổng cộng
         PdfPCell emptyCell = new PdfPCell(new Phrase(""));
         emptyCell.setBorder(0);
         
         table.addCell(emptyCell);
         table.addCell(emptyCell);
         table.addCell(emptyCell);
         table.addCell(emptyCell);
         
         PdfPCell totalLabelCell = new PdfPCell(new Phrase("Tổng cộng:", boldFont));
         totalLabelCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
         table.addCell(totalLabelCell);
         
         PdfPCell totalValueCell = new PdfPCell(new Phrase(currencyFormat.format(totalAmount), boldFont));
         totalValueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
         table.addCell(totalValueCell);
         
         document.add(table);
         
         document.add(new Paragraph(" ")); // Thêm khoảng trống
         document.add(new Paragraph(" "));
         
         // Chữ ký
         PdfPTable signatureTable = new PdfPTable(2);
         signatureTable.setWidthPercentage(100);
         
         PdfPCell buyerCell = new PdfPCell();
         buyerCell.setBorder(0);
         Paragraph buyerPara = new Paragraph("Người mua hàng\n(Ký, ghi rõ họ tên)", normalFont);
         buyerPara.setAlignment(Element.ALIGN_CENTER);
         buyerCell.addElement(buyerPara);
         signatureTable.addCell(buyerCell);
         
         PdfPCell sellerCell = new PdfPCell();
         sellerCell.setBorder(0);
         Paragraph sellerPara = new Paragraph("Người bán hàng\n(Ký, ghi rõ họ tên)", normalFont);
         sellerPara.setAlignment(Element.ALIGN_CENTER);
         sellerCell.addElement(sellerPara);
         signatureTable.addCell(sellerCell);
         
         document.add(signatureTable);
         
         document.add(new Paragraph(" ")); // Thêm khoảng trống
         document.add(new Paragraph(" "));
         document.add(new Paragraph(" "));
         
         // Lời cảm ơn
         Paragraph thankYou = new Paragraph("Cảm ơn quý khách đã mua sắm tại nhà sách chúng tôi!", normalFont);
         thankYou.setAlignment(Element.ALIGN_CENTER);
         document.add(thankYou);
         
         document.close();
            
      } catch (DocumentException e) {
         throw new ServletException(e);
      } catch (Exception e) {
         throw new ServletException(e);
      }
   }
   
   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      doPost(request, response);
   }
}