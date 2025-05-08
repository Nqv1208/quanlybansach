document.addEventListener('DOMContentLoaded', function() {
   // Sidebar toggle functionality
   const sidebar = document.getElementById('sidebar');
   const sidebarToggler = document.getElementById('sidebarToggler');
   const mainContent = document.querySelector('.main-content');
   
   // Toggle sidebar on mobile
   sidebarToggler.addEventListener('click', function() {
       sidebar.classList.toggle('show');
       
       // Toggle icon
       const icon = this.querySelector('i');
       if (sidebar.classList.contains('show')) {
           icon.classList.remove('fa-bars');
           icon.classList.add('fa-times');
       } else {
           icon.classList.remove('fa-times');
           icon.classList.add('fa-bars');
       }
   });
   
   // Collapse sidebar on desktop for more space (double-click on sidebar)
   sidebar.addEventListener('dblclick', function() {
       if (window.innerWidth >= 768) {
           sidebar.classList.toggle('sidebar-collapsed');
           if (sidebar.classList.contains('sidebar-collapsed')) {
               mainContent.style.marginLeft = '70px';
           } else {
               mainContent.style.marginLeft = '240px';
           }
       }
   });
});

document.addEventListener("DOMContentLoaded", function () {
   const searchForm = document.getElementById("searchForm");
   const keywordInput = document.getElementById("keyword");

   // Lắng nghe sự kiện "keydown" trên trường nhập liệu
   keywordInput.addEventListener("keydown", function (event) {
      if (event.key === "Enter") {
            event.preventDefault(); // Ngăn chặn hành vi mặc định của phím Enter
            searchForm.submit(); // Gửi form
      }
   });
});