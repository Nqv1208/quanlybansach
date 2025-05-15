<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>Xem trước báo cáo</title>
   <style>
      .container {
            width: 80%;
            margin: 0 auto;
            text-align: center;
      }
      iframe {
            width: 100%;
            height: 600px;
            border: 1px solid #ccc;
      }
   </style>
</head>
<body>
   <div class="container">
      <h2>Xem trước báo cáo</h2>
      <!-- Nhúng file PDF từ Servlet -->
      <iframe src="/admin/reports/export" title="Preview PDF"></iframe>
      <br>
      <button onclick="printPDF()">In Báo Cáo</button>
      <a href="/admin/reports/export" download="bao-cao-doanh-thu.pdf"><button>Tải Xuống</button></a>
   </div>

   <script>
      function printPDF() {
         const iframe = document.querySelector('iframe');
         iframe.contentWindow.print();
      }
   </script>
</body>
</html>