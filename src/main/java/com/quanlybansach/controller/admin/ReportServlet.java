package com.quanlybansach.controller.admin;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

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
import com.itextpdf.text.pdf.PdfDocument;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.quanlybansach.model.Book;
import com.quanlybansach.model.Customer;
import com.quanlybansach.service.BookService;
import com.quanlybansach.service.CustomerService;
import com.quanlybansach.service.OrderService;
import com.quanlybansach.service.ReportService;
import com.quanlybansach.util.PdfUtil;


@WebServlet(urlPatterns = {"/admin/reports/*"})
public class ReportServlet extends HttpServlet {
   private static final long serialVersionUID = 1L;
   private ReportService reportService;
   private BookService bookService;
   private CustomerService customerService;
   private OrderService orderService;

   @Override
   public void init() throws ServletException {
      // Khởi tạo các đối tượng Service
      reportService = new ReportService();
      bookService = new BookService();
      customerService = new CustomerService();
      orderService = new OrderService();
   }

   @Override
   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      
      String pathInfo = request.getPathInfo();
      if (pathInfo == null) {
         pathInfo = "/reports";
      }

      System.out.println(pathInfo);

      switch (pathInfo) {
         case "/reports":
            showReport(request, response);
            break;
         case "/export":
            showExport(request, response);
            break;
         case "/download":
            downloadReport(request, response);
            break;
         case "/preview":
            previewReport(request, response);
            break;
         default:
            showReportDashboard(request, response);
            break;
      }
   }

   private void showExport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      // Lấy thông tin từ form
      String reportType = request.getParameter("reportType");
      String fileFormat = request.getParameter("fileFormat");
      String startDateStr = request.getParameter("startDate");
      String endDateStr = request.getParameter("endDate");

      // Lưu thông tin vào session để sử dụng ở các trang khác
      HttpSession session = request.getSession();
      session.setAttribute("reportType", reportType);
      session.setAttribute("fileFormat", fileFormat);
      session.setAttribute("startDate", startDateStr);
      session.setAttribute("endDate", endDateStr);

      // Chuyển hướng đến trang xem trước
      response.sendRedirect(request.getContextPath() + "/admin/reports/preview");
   }

   private void previewReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      // Lấy thông tin từ session
      HttpSession session = request.getSession();
      String reportType = (String) session.getAttribute("reportType");
      String fileFormat = (String) session.getAttribute("fileFormat");
      String startDateStr = (String) session.getAttribute("startDate");
      String endDateStr = (String) session.getAttribute("endDate");

      // Thiết lập các thuộc tính để hiển thị ở trang xem trước
      request.setAttribute("reportType", reportType);
      request.setAttribute("fileFormat", fileFormat);
      request.setAttribute("startDate", startDateStr);
      request.setAttribute("endDate", endDateStr);

      // Chuẩn bị dữ liệu cho báo cáo
      if ("sales".equals(reportType)) {
         prepareSalesReportData(request, response, startDateStr, endDateStr);
      } else if ("customers".equals(reportType)) {
         prepareCustomerReportData(request, response);
      } else if ("inventory".equals(reportType)) {
         prepareInventoryReportData(request, response);
      }

      // Hiển thị trang xem trước báo cáo
      request.getRequestDispatcher("/WEB-INF/views/admin/preview.jsp").forward(request, response);
   }

   private void downloadReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      // Lấy thông tin từ session
      HttpSession session = request.getSession();
      String reportType = (String) session.getAttribute("reportType");
      String fileFormat = (String) session.getAttribute("fileFormat");
      String startDateStr = (String) session.getAttribute("startDate");
      String endDateStr = (String) session.getAttribute("endDate");

      // Xuất báo cáo dựa trên loại báo cáo và định dạng file
      if ("sales".equals(reportType)) {
         if ("pdf".equals(fileFormat)) {
            exportSalesPdfReport(request, response, startDateStr, endDateStr, true);
         } else if ("excel".equals(fileFormat)) {
            exportSalesExcelReport(request, response, startDateStr, endDateStr);
         }
      } else if ("customers".equals(reportType)) {
         if ("pdf".equals(fileFormat)) {
            exportCustomerPdfReport(request, response, true);
         } else if ("excel".equals(fileFormat)) {
            exportCustomerExcelReport(request, response);
         }
      } else if ("inventory".equals(reportType)) {
         if ("pdf".equals(fileFormat)) {
            exportInventoryPdfReport(request, response, true);
         } else if ("excel".equals(fileFormat)) {
            exportInventoryExcelReport(request, response);
         }
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
      int totalBooks = reportService.getTotalBooks();
      int totalCustomers = reportService.getTotalCustomers();
      BigDecimal monthlyRevenue = reportService.getMonthlyRevenue();
      
      request.setAttribute("totalBooks", totalBooks);
      request.setAttribute("totalCustomers", totalCustomers);
      request.setAttribute("totalRevenue", monthlyRevenue);
      
      request.getRequestDispatcher("/WEB-INF/views/admin/reports/dashboard.jsp").forward(request, response);
   }
   
   private void prepareSalesReportData(HttpServletRequest request, HttpServletResponse response, String startDateStr, String endDateStr) {
      // Chuẩn bị dữ liệu cho báo cáo doanh thu
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
      
      // Lấy dữ liệu doanh thu
      Map<String, BigDecimal> revenueMap = reportService.getRevenueByMonth(startDate, endDate);
      
      // Tính tổng doanh thu
      BigDecimal totalRevenue = reportService.calculateTotalRevenue(revenueMap);
      
      // Đặt dữ liệu vào request để hiển thị ở trang xem trước
      request.setAttribute("revenueMap", revenueMap);
      request.setAttribute("totalRevenue", totalRevenue);
   }

   private void prepareCustomerReportData(HttpServletRequest request, HttpServletResponse response) {
      // Chuẩn bị dữ liệu cho báo cáo khách hàng
      List<Customer> customers = reportService.getCustomerReport();
      request.setAttribute("customers", customers);
   }

   private void prepareInventoryReportData(HttpServletRequest request, HttpServletResponse response) {
      // Chuẩn bị dữ liệu cho báo cáo tồn kho
      List<Book> books = reportService.getInventoryReport();
      request.setAttribute("books", books);
   }

   private void exportSalesPdfReport(HttpServletRequest request, HttpServletResponse response, String startDateStr, String endDateStr, boolean isDownload) throws ServletException, IOException {
      // Lấy tham số ngày bắt đầu và kết thúc
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
      
      Map<String, BigDecimal> revenueMap = reportService.getRevenueByMonth(startDate, endDate);
      
      // Thiết lập header cho PDF
      PdfUtil.configureResponse(response, isDownload, "bao-cao-doanh-thu.pdf");

      try {
         // Tạo document PDF
         Document document = new Document();
         PdfWriter.getInstance(document, response.getOutputStream());
         document.open();
         
         // Lấy fonts
         Font[] fonts = PdfUtil.getPdfFonts(request);
         Font titleFont = fonts[0];
         Font normalFont = fonts[1];
         Font headerFont = fonts[2];
         
         // Thêm phần header cho document
         PdfUtil.addDocumentHeader(document, "BÁO CÁO DOANH THU", titleFont, normalFont);
         
         // Thêm thông tin thời gian báo cáo
         String reportPeriod = "Tất cả thời gian";
         if (startDate != null && endDate != null) {
            reportPeriod = "Từ " + dateFormat.format(startDate) + " đến " + dateFormat.format(endDate);
         } else if (startDate != null) {
            reportPeriod = "Từ " + dateFormat.format(startDate) + " đến nay";
         } else if (endDate != null) {
            reportPeriod = "Đến " + dateFormat.format(endDate);
         }
         
         Paragraph periodInfo = new Paragraph("Thời gian: " + reportPeriod, normalFont);
         periodInfo.setAlignment(Element.ALIGN_CENTER);
         document.add(periodInfo);
         
         document.add(new Paragraph(" ")); // Thêm khoảng trống
         
         // Thêm bảng doanh thu
         PdfPTable table = new PdfPTable(2); // 2 cột: tháng và doanh thu
         table.setWidthPercentage(100);
         table.setWidths(new float[] {1.5f, 2f});
         
         // Thêm tiêu đề bảng
         table.addCell(PdfUtil.createHeaderCell("Tháng", headerFont));
         table.addCell(PdfUtil.createHeaderCell("Doanh thu", headerFont));
         
         // Thêm dữ liệu doanh thu vào bảng
         NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
         BigDecimal totalRevenue = reportService.calculateTotalRevenue(revenueMap);
         
         for (Map.Entry<String, BigDecimal> entry : revenueMap.entrySet()) {
            table.addCell(PdfUtil.createCell(entry.getKey(), normalFont));
            table.addCell(PdfUtil.createRightAlignedCell(currencyFormat.format(entry.getValue()), normalFont));
         }
         
         // Thêm dòng tổng doanh thu
         PdfPCell totalLabelCell = new PdfPCell(new Phrase("TỔNG DOANH THU", headerFont));
         totalLabelCell.setBackgroundColor(new BaseColor(41, 128, 185));
         totalLabelCell.setPadding(5);
         table.addCell(totalLabelCell);
         
         PdfPCell totalValueCell = new PdfPCell(new Phrase(currencyFormat.format(totalRevenue), headerFont));
         totalValueCell.setBackgroundColor(new BaseColor(41, 128, 185));
         totalValueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
         totalValueCell.setPadding(5);
         table.addCell(totalValueCell);
         
         document.add(table);
         
         // Thêm phần footer
         PdfUtil.addDocumentFooter(document, normalFont);
         
         document.close();
      } catch (Exception e) {
         throw new ServletException(e);
      }
   }
   
   private void exportSalesExcelReport(HttpServletRequest request, HttpServletResponse response, String startDateStr, String endDateStr) {
      // Implement Excel export for sales report here
      // Thông báo tạm thời - sẽ triển khai sau
      try {
         response.setContentType("text/html");
         response.getWriter().write("<h1>Xuất báo cáo doanh thu dạng Excel đang được phát triển</h1>");
      } catch (IOException e) {
         e.printStackTrace();
      }
   }

   private void exportCustomerPdfReport(HttpServletRequest request, HttpServletResponse response, boolean isDownload) throws ServletException, IOException {
      List<Customer> customers = reportService.getCustomerReport();
      
      // Thiết lập header cho PDF
      PdfUtil.configureResponse(response, isDownload, "bao-cao-khach-hang.pdf");
      
      try {
         // Create PDF document
         Document document = new Document();
         PdfWriter.getInstance(document, response.getOutputStream());
         document.open();
         
         // Lấy fonts
         Font[] fonts = PdfUtil.getPdfFonts(request);
         Font titleFont = fonts[0];
         Font normalFont = fonts[1];
         Font headerFont = fonts[2];
         
         // Thêm phần header cho document
         PdfUtil.addDocumentHeader(document, "BÁO CÁO KHÁCH HÀNG", titleFont, normalFont);
         
         // Add customer table
         PdfPTable table = new PdfPTable(4); // 4 columns
         table.setWidthPercentage(100);
         table.setWidths(new float[] {0.7f, 2f, 2f, 2f});
         
         // Add table header
         table.addCell(PdfUtil.createHeaderCell("ID", headerFont));
         table.addCell(PdfUtil.createHeaderCell("Tên khách hàng", headerFont));
         table.addCell(PdfUtil.createHeaderCell("Email", headerFont));
         table.addCell(PdfUtil.createHeaderCell("Số điện thoại", headerFont));
         
         // Add customer data to table
         for (Customer customer : customers) {
            table.addCell(PdfUtil.createCell(String.valueOf(customer.getCustomerId()), normalFont));
            table.addCell(PdfUtil.createCell(customer.getName(), normalFont));
            table.addCell(PdfUtil.createCell(customer.getEmail(), normalFont));
            table.addCell(PdfUtil.createCell(customer.getPhone(), normalFont));
         }
         
         document.add(table);
         
         // Add footer
         PdfUtil.addDocumentFooter(document, normalFont);
         
         document.close();
      } catch (DocumentException e) {
         throw new ServletException(e);
      }
   }

   private void exportCustomerExcelReport(HttpServletRequest request, HttpServletResponse response) {
      // Implement Excel export for customer report
      try {
         response.setContentType("text/html");
         response.getWriter().write("<h1>Xuất báo cáo khách hàng dạng Excel đang được phát triển</h1>");
      } catch (IOException e) {
         e.printStackTrace();
      }
   }

   private void exportInventoryPdfReport(HttpServletRequest request, HttpServletResponse response, boolean isDownload) throws ServletException, IOException {
      // Xuất báo cáo danh sách sách ra PDF
      List<Book> books = reportService.getInventoryReport();
      
      // Thiết lập header cho PDF
      PdfUtil.configureResponse(response, isDownload, "bao-cao-ton-kho.pdf");
      
      try {
         // Tạo document PDF
         Document document = new Document();
         PdfWriter.getInstance(document, response.getOutputStream());
         document.open();
         
         // Lấy fonts
         Font[] fonts = PdfUtil.getPdfFonts(request);
         Font titleFont = fonts[0];
         Font normalFont = fonts[1];
         Font headerFont = fonts[2];
         
         // Thêm phần header cho document
         PdfUtil.addDocumentHeader(document, "BÁO CÁO TỒN KHO", titleFont, normalFont);
         
         // Thêm bảng sách
         PdfPTable table = new PdfPTable(5); // 5 cột
         table.setWidthPercentage(100);
         table.setWidths(new float[] {0.7f, 3f, 2f, 1f, 1.5f});
         
         // Thêm tiêu đề bảng
         table.addCell(PdfUtil.createHeaderCell("Mã sách", headerFont));
         table.addCell(PdfUtil.createHeaderCell("Tên sách", headerFont));
         table.addCell(PdfUtil.createHeaderCell("Tác giả", headerFont));
         table.addCell(PdfUtil.createHeaderCell("Số lượng", headerFont));
         table.addCell(PdfUtil.createHeaderCell("Giá bán", headerFont));
         
         // Thêm dữ liệu sách vào bảng
         NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
         
         for (Book book : books) {
            table.addCell(PdfUtil.createCell(String.valueOf(book.getBookId()), normalFont));
            table.addCell(PdfUtil.createCell(book.getTitle(), normalFont));
            
            // Kiểm tra nếu có phương thức getAuthor, nếu không có thì dùng mặc định "Không có thông tin"
            String author = "Không có thông tin";
            try {
               java.lang.reflect.Method method = book.getClass().getMethod("getAuthor");
               author = (String) method.invoke(book);
            } catch (Exception e) {
               // Không làm gì, giữ giá trị mặc định
            }
            table.addCell(PdfUtil.createCell(author, normalFont));
            
            // Số lượng
            int quantity = 0;
            try {
               java.lang.reflect.Method method = book.getClass().getMethod("getQuantity");
               quantity = (Integer) method.invoke(book);
            } catch (Exception e) {
               // Không làm gì, giữ giá trị mặc định
            }
            table.addCell(PdfUtil.createRightAlignedCell(String.valueOf(quantity), normalFont));
            
            // Giá
            double price = 0.0;
            try {
               java.lang.reflect.Method method = book.getClass().getMethod("getPrice");
               price = (Double) method.invoke(book);
            } catch (Exception e) {
               // Không làm gì, giữ giá trị mặc định
            }
            table.addCell(PdfUtil.createRightAlignedCell(currencyFormat.format(price), normalFont));
         }
         
         document.add(table);
         
         // Thêm footer
         PdfUtil.addDocumentFooter(document, normalFont);
         
         document.close();
      } catch (DocumentException e) {
         throw new ServletException(e);
      } catch (Exception e) {
         throw new ServletException(e);
      }
   }

   private void exportInventoryExcelReport(HttpServletRequest request, HttpServletResponse response) {
      // Implement Excel export for inventory report
      try {
         response.setContentType("text/html");
         response.getWriter().write("<h1>Xuất báo cáo tồn kho dạng Excel đang được phát triển</h1>");
      } catch (IOException e) {
         e.printStackTrace();
      }
   }
   
   @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      doGet(request, response);
   }
}