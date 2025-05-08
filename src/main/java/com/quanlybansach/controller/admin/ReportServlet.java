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
import javax.servlet.http.HttpSession;

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
import com.quanlybansach.dao.BookDAO;
import com.quanlybansach.dao.CustomerDAO;
import com.quanlybansach.dao.InvoiceDAO;
import com.quanlybansach.dao.OrderDAO;
import com.quanlybansach.model.Book;
import com.quanlybansach.model.Customer;
import com.quanlybansach.model.Invoice;
import com.quanlybansach.model.InvoiceItem;


@WebServlet(urlPatterns = {"/admin/reports/*"})
public class ReportServlet extends HttpServlet {
   private static final long serialVersionUID = 1L;
   private InvoiceDAO invoiceDAO;
   private BookDAO bookDAO;
   private CustomerDAO customerDAO;
   private OrderDAO orderDAO;

   @Override
   public void init() throws ServletException {
      // Khởi tạo các đối tượng DAO
      invoiceDAO = new InvoiceDAO();
      bookDAO = new BookDAO();
      customerDAO = new CustomerDAO();
      orderDAO = new OrderDAO();
   }

   @Override
   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      // Kiểm tra quyền admin
      // HttpSession session = request.getSession();
      // String role = (String) session.getAttribute("role");
      
      // if (!"admin".equals(role)) {
      //    response.sendRedirect(request.getContextPath() + "/login");
      //    return;
      // }
      
      String pathInfo = request.getPathInfo();
      if (pathInfo == null) {
         pathInfo = "/reports";
      }

      System.out.println(pathInfo);

      switch (pathInfo) {
         case "/reports":
            showReport(request, response);
            break;
         case "/dashboard":
            showReportDashboard(request, response);
            break;
         case "/invoices":
            showInvoiceReport(request, response);
            break;
         case "/books":
            showBookReport(request, response);
            break;
         case "/customers":
            showCustomerReport(request, response);
            break;
         case "/sales":
            showSalesReport(request, response);
            break;
         case "/export-invoices":
            exportInvoiceReport(request, response);
            break;
         case "/export-books":
            exportBookReport(request, response);
            break;
         case "/export":
            showExport(request, response);
            break;
         default:
            showReportDashboard(request, response);
            break;
      }
   }

   private void showReport(HttpServletRequest request, HttpServletResponse response) {
      // Chuyển hướng đến trang dashboard báo cáo
      try {
         request.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp").forward(request, response);
      } catch (ServletException | IOException e) {
         e.printStackTrace();
      }
   }

   private void showReportDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      // Tổng hợp dữ liệu cho trang dashboard báo cáo
      int totalInvoices = invoiceDAO.getAllInvoices().size();
      int totalBooks = bookDAO.getAllBooks().size();
      int totalCustomers = customerDAO.getTotalCustomers();
      // Sử dụng OrderDAO để lấy doanh thu nếu có
      java.math.BigDecimal monthlyRevenue = orderDAO.getMonthlyRevenue();
      
      request.setAttribute("totalInvoices", totalInvoices);
      request.setAttribute("totalBooks", totalBooks);
      request.setAttribute("totalCustomers", totalCustomers);
      request.setAttribute("totalRevenue", monthlyRevenue);
      
      request.getRequestDispatcher("/WEB-INF/views/admin/reports/dashboard.jsp").forward(request, response);
   }
   
   private void showInvoiceReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      // Lấy danh sách hóa đơn cho báo cáo
      List<Invoice> invoices = invoiceDAO.getAllInvoices();
      request.setAttribute("invoices", invoices);
      
      request.getRequestDispatcher("/WEB-INF/views/admin/reports/invoices.jsp").forward(request, response);
   }
   
   private void showBookReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      // Lấy danh sách sách cho báo cáo
      List<Book> books = bookDAO.getAllBooks();
      request.setAttribute("books", books);
      
      request.getRequestDispatcher("/WEB-INF/views/admin/reports/books.jsp").forward(request, response);
   }
   
   private void showCustomerReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      // Lấy danh sách khách hàng cho báo cáo
      List<Customer> customers = customerDAO.getAllCustomers();
      request.setAttribute("customers", customers);
      
      request.getRequestDispatcher("/WEB-INF/views/admin/reports/customers.jsp").forward(request, response);
   }
   
   private void showSalesReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      // Lấy tham số ngày bắt đầu và kết thúc nếu có
      String startDateStr = request.getParameter("startDate");
      String endDateStr = request.getParameter("endDate");
      
      SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
      Date startDate = null;
      Date endDate = null;
      
      try {
         if (startDateStr != null && !startDateStr.isEmpty()) {
            startDate = dateFormat.parse(startDateStr);
         }
         if (endDateStr != null && !endDateStr.isEmpty()) {
            endDate = dateFormat.parse(endDateStr);
         }
      } catch (Exception e) {
         e.printStackTrace();
      }
      
      // Lấy dữ liệu báo cáo doanh số (dùng tất cả hóa đơn vì chưa có phương thức theo khoảng thời gian)
      List<Invoice> salesData = invoiceDAO.getAllInvoices();
      java.math.BigDecimal totalRevenue = orderDAO.getMonthlyRevenue();
      
      request.setAttribute("salesData", salesData);
      request.setAttribute("totalRevenue", totalRevenue);
      request.setAttribute("startDate", startDateStr);
      request.setAttribute("endDate", endDateStr);
      
      request.getRequestDispatcher("/WEB-INF/views/admin/reports/sales.jsp").forward(request, response);
   }
   
   private void exportInvoiceReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      // Xuất báo cáo danh sách hóa đơn ra PDF
      List<Invoice> invoices = invoiceDAO.getAllInvoices();
      
      // Thiết lập header để trình duyệt hiểu đây là file PDF cần tải xuống
      response.setContentType("application/pdf");
      response.setHeader("Content-Disposition", "attachment; filename=bao-cao-hoa-don.pdf");
      
      try {
         // Tạo document PDF
         Document document = new Document();
         PdfWriter.getInstance(document, response.getOutputStream());
      document.open();
         
         // Thêm font chữ hỗ trợ tiếng Việt
         BaseFont baseFont = BaseFont.createFont("WEB-INF/fonts/arial.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
         Font titleFont = new Font(baseFont, 18, Font.BOLD);
         Font normalFont = new Font(baseFont, 12, Font.NORMAL);
         Font headerFont = new Font(baseFont, 12, Font.BOLD, BaseColor.WHITE);

      // Thêm tiêu đề
         Paragraph title = new Paragraph("BÁO CÁO DANH SÁCH HÓA ĐƠN", titleFont);
      title.setAlignment(Element.ALIGN_CENTER);
         document.add(title);
         
         // Thêm ngày xuất báo cáo
         Paragraph date = new Paragraph("Ngày xuất báo cáo: " + new SimpleDateFormat("dd/MM/yyyy").format(new Date()), normalFont);
         date.setAlignment(Element.ALIGN_RIGHT);
         document.add(date);
         
         document.add(new Paragraph(" ")); // Thêm khoảng trống

      // Thêm bảng hóa đơn
         PdfPTable table = new PdfPTable(4); // 4 cột
      table.setWidthPercentage(100);
         table.setWidths(new float[] {1f, 2f, 2f, 2f});
      
      // Thêm tiêu đề bảng
         PdfPCell headerCell = new PdfPCell();
         headerCell.setBackgroundColor(new BaseColor(41, 128, 185));
         headerCell.setPadding(5);
         
         headerCell.setPhrase(new Phrase("Mã hóa đơn", headerFont));
         table.addCell(headerCell);
         
         headerCell.setPhrase(new Phrase("Ngày lập", headerFont));
         table.addCell(headerCell);
         
         headerCell.setPhrase(new Phrase("Khách hàng", headerFont));
         table.addCell(headerCell);
         
         headerCell.setPhrase(new Phrase("Tổng tiền", headerFont));
         table.addCell(headerCell);

      // Thêm dữ liệu hóa đơn vào bảng
      NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
         SimpleDateFormat invoiceDateFormat = new SimpleDateFormat("dd/MM/yyyy");
         
         double totalAmount = 0;
         
      for (Invoice invoice : invoices) {
            table.addCell(new Phrase(invoice.getInvoiceId(), normalFont));
            table.addCell(new Phrase(invoiceDateFormat.format(invoice.getCreatedDate()), normalFont));
            table.addCell(new Phrase(invoice.getCustomerName(), normalFont));
            
            double invTotal = invoice.getTotalAmount();
            PdfPCell amountCell = new PdfPCell(new Phrase(currencyFormat.format(invTotal), normalFont));
            amountCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            table.addCell(amountCell);
            
            totalAmount += invTotal;
         }
         
         // Thêm tổng cộng
         PdfPCell emptyCell = new PdfPCell(new Phrase(""));
         emptyCell.setBorder(0);
         
         table.addCell(emptyCell);
         table.addCell(emptyCell);
         
         PdfPCell totalLabelCell = new PdfPCell(new Phrase("Tổng cộng:", normalFont));
         totalLabelCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
         table.addCell(totalLabelCell);
         
         PdfPCell totalValueCell = new PdfPCell(new Phrase(currencyFormat.format(totalAmount), normalFont));
         totalValueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
         table.addCell(totalValueCell);
         
         document.add(table);
         
         // Chân trang
         document.add(new Paragraph(" ")); // Thêm khoảng trống
         Paragraph footer = new Paragraph("© Hệ thống Quản lý Bán Sách - Báo cáo được tạo tự động", normalFont);
         footer.setAlignment(Element.ALIGN_CENTER);
         document.add(footer);
         
         document.close();
      } catch (DocumentException e) {
         throw new ServletException(e);
      } catch (Exception e) {
         throw new ServletException(e);
      }
   }
   
   private void exportBookReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      // Xuất báo cáo danh sách sách ra PDF
      List<Book> books = bookDAO.getAllBooks();
      
      // Thiết lập header để trình duyệt hiểu đây là file PDF cần tải xuống
      response.setContentType("application/pdf");
      response.setHeader("Content-Disposition", "attachment; filename=bao-cao-sach.pdf");
      
      try {
         // Tạo document PDF
         Document document = new Document();
         PdfWriter.getInstance(document, response.getOutputStream());
         document.open();
         
         // Thêm font chữ hỗ trợ tiếng Việt
         BaseFont baseFont = BaseFont.createFont("WEB-INF/fonts/arial.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
         Font titleFont = new Font(baseFont, 18, Font.BOLD);
         Font normalFont = new Font(baseFont, 12, Font.NORMAL);
         Font headerFont = new Font(baseFont, 12, Font.BOLD, BaseColor.WHITE);
         
         // Thêm tiêu đề
         Paragraph title = new Paragraph("BÁO CÁO DANH SÁCH SÁCH", titleFont);
         title.setAlignment(Element.ALIGN_CENTER);
         document.add(title);
         
         // Thêm ngày xuất báo cáo
         Paragraph date = new Paragraph("Ngày xuất báo cáo: " + new SimpleDateFormat("dd/MM/yyyy").format(new Date()), normalFont);
         date.setAlignment(Element.ALIGN_RIGHT);
         document.add(date);
         
         document.add(new Paragraph(" ")); // Thêm khoảng trống
         
         // Thêm bảng sách
         PdfPTable table = new PdfPTable(5); // 5 cột
         table.setWidthPercentage(100);
         table.setWidths(new float[] {0.7f, 3f, 2f, 1f, 1.5f});
         
         // Thêm tiêu đề bảng
         PdfPCell headerCell = new PdfPCell();
         headerCell.setBackgroundColor(new BaseColor(41, 128, 185));
         headerCell.setPadding(5);
         
         headerCell.setPhrase(new Phrase("Mã sách", headerFont));
         table.addCell(headerCell);
         
         headerCell.setPhrase(new Phrase("Tên sách", headerFont));
         table.addCell(headerCell);
         
         headerCell.setPhrase(new Phrase("Tác giả", headerFont));
         table.addCell(headerCell);
         
         headerCell.setPhrase(new Phrase("Số lượng", headerFont));
         table.addCell(headerCell);
         
         headerCell.setPhrase(new Phrase("Giá bán", headerFont));
         table.addCell(headerCell);
         
         // Thêm dữ liệu sách vào bảng
         NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
         
         for (Book book : books) {
            table.addCell(new Phrase(String.valueOf(book.getBookId()), normalFont));
            table.addCell(new Phrase(book.getTitle(), normalFont));
            
            // Kiểm tra nếu có phương thức getAuthor, nếu không có thì dùng mặc định "Không có thông tin"
            String author = "Không có thông tin";
            try {
               java.lang.reflect.Method method = book.getClass().getMethod("getAuthor");
               author = (String) method.invoke(book);
            } catch (Exception e) {
               // Không làm gì, giữ giá trị mặc định
            }
            table.addCell(new Phrase(author, normalFont));
            
            // Số lượng
            int quantity = 0;
            try {
               java.lang.reflect.Method method = book.getClass().getMethod("getQuantity");
               quantity = (Integer) method.invoke(book);
            } catch (Exception e) {
               // Không làm gì, giữ giá trị mặc định
            }
            PdfPCell quantityCell = new PdfPCell(new Phrase(String.valueOf(quantity), normalFont));
            quantityCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            table.addCell(quantityCell);
            
            // Giá
            double price = 0.0;
            try {
               java.lang.reflect.Method method = book.getClass().getMethod("getPrice");
               price = (Double) method.invoke(book);
            } catch (Exception e) {
               // Không làm gì, giữ giá trị mặc định
            }
            PdfPCell priceCell = new PdfPCell(new Phrase(currencyFormat.format(price), normalFont));
            priceCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            table.addCell(priceCell);
         }
         
         document.add(table);
         
         // Chân trang
         document.add(new Paragraph(" ")); // Thêm khoảng trống
         Paragraph footer = new Paragraph("© Hệ thống Quản lý Bán Sách - Báo cáo được tạo tự động", normalFont);
         footer.setAlignment(Element.ALIGN_CENTER);
         document.add(footer);
         
         document.close();
      } catch (DocumentException e) {
         throw new ServletException(e);
      } catch (Exception e) {
         throw new ServletException(e);
      }
   }

   protected void showExport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
   
   @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      doGet(request, response);
   }
}
