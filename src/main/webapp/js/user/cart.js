// Quantity control
document.addEventListener('DOMContentLoaded', function() {
   const decreaseBtns = document.querySelectorAll('.decrease-btn');
   const increaseBtns = document.querySelectorAll('.increase-btn');
   const quantityInputs = document.querySelectorAll('.quantity-input');
   const itemCheckboxes = document.querySelectorAll('.item-checkbox');
   const removeBtns = document.querySelectorAll('.remove-btn');
   const clearCartBtn = document.getElementById('clear-cart-btn');
   const applyCouponBtn = document.getElementById('apply-coupon-btn');
   const cartToast = document.getElementById('cartToast');
   const toast = new bootstrap.Toast(cartToast);
   
   // Cập nhật hiển thị giá tiền của từng sản phẩm
   function updateItemSubtotal(id, quantity) {
      const checkbox = document.querySelector(`.item-checkbox[data-id="${id}"]`);
      if (!checkbox) return;
      
      const price = parseFloat(checkbox.getAttribute('data-price'));
      const subtotal = price * quantity;
      
      // Tìm phần tử hiển thị tổng tiền của sản phẩm
      const itemRow = checkbox.closest('.cart-item');
      const subtotalElement = itemRow.querySelector('.item-subtotal');
      
      if (subtotalElement) {
         subtotalElement.textContent = new Intl.NumberFormat('vi-VN').format(subtotal) + ' ₫';
      }
   }
   
   // Update cart summary based on selected items
   function updateCartSummary() {
      let totalItems = 0;
      let subtotal = 0;
      let shippingFee = 0;
      let discount = 0;
      
      // Lấy giá trị từ các phần tử hiển thị trong trang
      const summaryValues = document.querySelectorAll('.summary-value');
      
      let anyItemChecked = false;
      
      itemCheckboxes.forEach(checkbox => {
          if (checkbox.checked) {
              anyItemChecked = true;
              const price = parseFloat(checkbox.getAttribute('data-price'));
              const quantity = parseInt(checkbox.getAttribute('data-quantity'));
              totalItems += quantity;
              subtotal += price * quantity;
          }
      });
      
      // Nếu có sản phẩm được chọn, mới tính phí vận chuyển và áp dụng giảm giá
      if (anyItemChecked) {
          // Lấy phí vận chuyển từ giá trị hiện tại trên trang
          if (summaryValues.length >= 4) {
              shippingFee = parseFloat(summaryValues[2].textContent.replace(/[^\d]/g, '')) || 0;
              discount = parseFloat(summaryValues[3].textContent.replace(/[^\d]/g, '')) || 0;
          }
      }
      
      const total = subtotal + shippingFee - discount;
      
      // Update summary display
      summaryValues[0].textContent = totalItems;
      summaryValues[1].textContent = new Intl.NumberFormat('vi-VN').format(subtotal) + ' ₫';
      summaryValues[3].textContent = '-' + new Intl.NumberFormat('vi-VN').format(discount) + ' ₫';
      summaryValues[4].textContent = new Intl.NumberFormat('vi-VN').format(total) + ' ₫';
      
      // Hiển thị/ẩn tóm tắt đơn hàng dựa vào việc có sản phẩm được chọn hay không
      const cartSummary = document.querySelector('.cart-summary');
      const orderSummaryInfo = document.querySelectorAll('.summary-item');
      const couponSection = document.querySelector('.coupon-section');
      
      if (anyItemChecked) {
          orderSummaryInfo.forEach(item => {
              item.style.opacity = '1';
          });
          couponSection.style.opacity = '1';
          couponSection.style.pointerEvents = 'auto';
      } else {
          orderSummaryInfo.forEach(item => {
              item.style.opacity = '0.5';
          });
          couponSection.style.opacity = '0.5';
          couponSection.style.pointerEvents = 'none';
      }
      
      // Disable/enable checkout button based on selection
      const checkoutBtn = document.getElementById('checkout-btn');
      if (checkoutBtn) {
          if (anyItemChecked) {
              checkoutBtn.classList.remove('disabled');
          } else {
              checkoutBtn.classList.add('disabled');
          }
      }
      
      // Update hidden form with selected items
      updateSelectedItemsForm();
  }
   
   // Create hidden form to pass selected items to checkout
   function updateSelectedItemsForm() {
      let selectedItems = [];
      itemCheckboxes.forEach(checkbox => {
          if (checkbox.checked) {
              selectedItems.push(checkbox.getAttribute('data-id'));
          }
      });
      
      // Store selected items in session storage
      sessionStorage.setItem('selectedItems', JSON.stringify(selectedItems));
      
      // Update checkout link with selected items
      const checkoutBtn = document.getElementById('checkout-btn');
      if (checkoutBtn) {
          const baseUrl = checkoutBtn.getAttribute('href').split('?')[0];
          checkoutBtn.href = baseUrl + (selectedItems.length > 0 ? '?items=' + selectedItems.join(',') : '');
      }
   }
   
   // Thêm "Chọn tất cả" checkbox nếu chưa có
   function addSelectAllCheckbox() {
      if (!document.getElementById('select-all-items')) {
         const cartItems = document.querySelector('.cart-items');
         if (cartItems) {
            const selectAllContainer = document.createElement('div');
            selectAllContainer.className = 'select-all-container';
            selectAllContainer.innerHTML = `
               <input type="checkbox" id="select-all-items">
               <label for="select-all-items">Chọn tất cả</label>
            `;
            cartItems.parentNode.insertBefore(selectAllContainer, cartItems);
            
            // Thêm event listener
            const selectAllCheckbox = document.getElementById('select-all-items');
            selectAllCheckbox.addEventListener('change', function() {
               const isChecked = this.checked;
               itemCheckboxes.forEach(checkbox => {
                  checkbox.checked = isChecked;
               });
               updateCartSummary();
            });
         }
      }
   }
   
   // Add event listeners to checkboxes
   itemCheckboxes.forEach(checkbox => {
         checkbox.addEventListener('change', updateCartSummary);
   });
   
   // Hàm xử lý cập nhật số lượng sản phẩm
   function updateQuantity(id, newValue) {
      const input = document.querySelector(`.quantity-input[data-id="${id}"]`);
      if (!input) return;
      
      const max = parseInt(input.getAttribute('max'), 10);
      let value = parseInt(newValue, 10);
      
      // Đảm bảo giá trị nằm trong khoảng hợp lệ
      if (value < 1) {
         value = 1;
      } else if (value > max) {
         value = max;
      }
      
      // Cập nhật giá trị hiển thị
      input.value = value;
      
      // Cập nhật thuộc tính data-quantity của checkbox
      const checkbox = document.querySelector(`.item-checkbox[data-id="${id}"]`);
      if (checkbox) {
         checkbox.setAttribute('data-quantity', value);
         updateItemSubtotal(id, value);
         
         if (checkbox.checked) {
               updateCartSummary();
         }
      }

      console.log('Cập nhật số lượng cho sản phẩm có ID:', id, 'với số lượng:', value);
      
      // Gửi yêu cầu AJAX để cập nhật giỏ hàng
      updateCartWithAjax(id, value);
   }
   
   // Hàm gửi yêu cầu AJAX để cập nhật giỏ hàng
   function updateCartWithAjax(bookId, quantity) {
      // Hiển thị hiệu ứng loading
      const loadingOverlay = document.createElement('div');
      loadingOverlay.className = 'loading-overlay';
      loadingOverlay.innerHTML = '<div class="spinner-border text-primary" role="status"><span class="visually-hidden">Đang tải...</span></div>';
      document.body.appendChild(loadingOverlay);
      
      // Lấy context path từ URL hiện tại
      const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/cart'));
      
      // Tạo FormData
      const formData = new FormData();
      formData.append('bookId', bookId);
      formData.append('quantity', quantity);
      
      // Gửi yêu cầu AJAX
      fetch(contextPath + '/cart/update', {
         method: 'POST',
         body: formData
      })
      .then(response => {
         if (!response.ok) {
            throw new Error('Lỗi khi cập nhật giỏ hàng');
         }
         return response.json();
      })
      .then(data => {
         // Xóa hiệu ứng loading
         document.body.removeChild(loadingOverlay);
         if(data.success) {
            // Hiển thị thông báo thành công
            document.querySelector('.toast-body').textContent = 'Giỏ hàng đã được cập nhật';
            toast.show();
            // Cập nhật tổng quan giỏ hàng
            updateCartSummary();
         }else {
            // Hiển thị thông báo lỗi
            throw new Error(data.message || 'Có lỗi xảy ra khi cập nhật giỏ hàng');
         }
      })
      .catch(error => {
         console.error('Lỗi:', error);
         // Xóa hiệu ứng loading
         document.body.removeChild(loadingOverlay);
         
         // Hiển thị thông báo lỗi
         document.querySelector('.toast-body').textContent = 'Có lỗi xảy ra khi cập nhật giỏ hàng';
         toast.show();
      });
   }
   
   // Hàm xóa sản phẩm khỏi giỏ hàng
   function removeFromCart(bookId) {
      // Hiển thị hiệu ứng loading
      const loadingOverlay = document.createElement('div');
      loadingOverlay.className = 'loading-overlay';
      loadingOverlay.innerHTML = '<div class="spinner-border text-primary" role="status"><span class="visually-hidden">Đang tải...</span></div>';
      document.body.appendChild(loadingOverlay);
      
      // Lấy context path từ URL hiện tại
      const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/cart'));
      
      // Tạo FormData
      const formData = new FormData();
      formData.append('bookId', bookId);
      
      // Gửi yêu cầu AJAX
      fetch(contextPath + '/cart/remove', {
         method: 'POST',
         body: formData
      })
      .then(response => {
         if (!response.ok) {
            throw new Error('Lỗi khi xóa sản phẩm');
         }
         return response.json();
      })
      .then(data => {
         // Xóa hiệu ứng loading
         document.body.removeChild(loadingOverlay);
         if(data.success) {
            // Xóa sản phẩm khỏi giao diện
            const itemElement = document.querySelector(`.item-checkbox[data-id="${bookId}"]`).closest('.cart-item');
            if (itemElement) {
                  itemElement.remove();
            }
            
            // Cập nhật tổng quan giỏ hàng
            updateCartSummary();
            
            // Kiểm tra nếu giỏ hàng trống
            const cartItems = document.querySelectorAll('.cart-item');
            if (cartItems.length === 0) {
                  location.reload(); // Tải lại trang để hiển thị giỏ hàng trống
            }
            
            // Hiển thị thông báo thành công
            document.querySelector('.toast-body').textContent = 'Sản phẩm đã được xóa khỏi giỏ hàng';
            toast.show();
         } else {
            // Hiển thị thông báo lỗi
            throw new Error(data.message || 'Có lỗi xảy ra khi xóa sản phẩm');
         }
      })
      .catch(error => {
         console.error('Lỗi:', error);
         // Xóa hiệu ứng loading
         document.body.removeChild(loadingOverlay);
         
         // Hiển thị thông báo lỗi
         document.querySelector('.toast-body').textContent = 'Có lỗi xảy ra khi xóa sản phẩm';
         toast.show();
      });
   }
   
   // Hàm xóa toàn bộ giỏ hàng
   function clearCart() {
      // Hiển thị hiệu ứng loading
      const loadingOverlay = document.createElement('div');
      loadingOverlay.className = 'loading-overlay';
      loadingOverlay.innerHTML = '<div class="spinner-border text-primary" role="status"><span class="visually-hidden">Đang tải...</span></div>';
      document.body.appendChild(loadingOverlay);
      
      // Lấy context path từ URL hiện tại
      const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/cart'));
      
      // Gửi yêu cầu AJAX
      fetch(contextPath + '/cart/clear', {
         method: 'POST'
      })
      .then(response => {
         if (!response.ok) {
               throw new Error('Lỗi khi xóa giỏ hàng');
         }
         return response.json();
      })
      .then(data => {
         // Xóa hiệu ứng loading
         document.body.removeChild(loadingOverlay);
         
         // Tải lại trang
         location.reload();
      })
      .catch(error => {
         console.error('Lỗi:', error);
         // Xóa hiệu ứng loading
         document.body.removeChild(loadingOverlay);
         
         // Hiển thị thông báo lỗi
         document.querySelector('.toast-body').textContent = 'Có lỗi xảy ra khi xóa giỏ hàng';
         toast.show();
      });
   }
   
   // Hàm áp dụng mã giảm giá
   function applyCoupon() {
      const couponCode = document.getElementById('couponCode').value.trim();
      if (!couponCode) {
         document.querySelector('.toast-body').textContent = 'Vui lòng nhập mã giảm giá';
         toast.show();
         return;
      }
      
      // Hiển thị hiệu ứng loading
      const loadingOverlay = document.createElement('div');
      loadingOverlay.className = 'loading-overlay';
      loadingOverlay.innerHTML = '<div class="spinner-border text-primary" role="status"><span class="visually-hidden">Đang tải...</span></div>';
      document.body.appendChild(loadingOverlay);
      
      // Lấy context path từ URL hiện tại
      const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/cart'));
      
      // Tạo FormData
      const formData = new FormData();
      formData.append('couponCode', couponCode);
      
      // Gửi yêu cầu AJAX
      fetch(contextPath + '/cart/apply-coupon', {
         method: 'POST',
         body: formData
      })
      .then(response => {
         if (!response.ok) {
               throw new Error('Lỗi khi áp dụng mã giảm giá');
         }
         return response.json();
      })
      .then(data => {
         // Xóa hiệu ứng loading
         document.body.removeChild(loadingOverlay);
         
         if (data.success) {
               // Cập nhật giảm giá và tổng cộng
               const summaryValues = document.querySelectorAll('.summary-value');
               if (summaryValues.length >= 5) {
                  // Giảm giá
                  summaryValues[3].textContent = '-' + new Intl.NumberFormat('vi-VN').format(data.discount) + ' ₫';
                  // Tổng cộng
                  summaryValues[4].textContent = new Intl.NumberFormat('vi-VN').format(data.total) + ' ₫';
               }
               
               // Hiển thị thông báo thành công
               document.querySelector('.toast-body').textContent = 'Mã giảm giá đã được áp dụng';
               toast.show();
         } else {
               // Hiển thị thông báo lỗi
               document.querySelector('.toast-body').textContent = data.message || 'Mã giảm giá không hợp lệ';
               toast.show();
         }
      })
      .catch(error => {
         console.error('Lỗi:', error);
         // Xóa hiệu ứng loading
         document.body.removeChild(loadingOverlay);
         
         // Hiển thị thông báo lỗi
         document.querySelector('.toast-body').textContent = 'Có lỗi xảy ra khi áp dụng mã giảm giá';
         toast.show();
      });
   }
   
   // Thêm event listeners cho các nút giảm
   decreaseBtns.forEach(btn => {
      btn.addEventListener('click', function(e) {
         e.preventDefault(); // Ngăn chặn hành vi mặc định
         const id = this.getAttribute('data-id');
         const input = document.querySelector(`.quantity-input[data-id="${id}"]`);
         let value = parseInt(input.value, 10);
         if (value > 1) {
            updateQuantity(id, value - 1);
         }
      });
   });
      
   // Thêm event listeners cho các nút tăng
   increaseBtns.forEach(btn => {
      btn.addEventListener('click', function(e) {
         e.preventDefault(); // Ngăn chặn hành vi mặc định
         const id = this.getAttribute('data-id');
         const input = document.querySelector(`.quantity-input[data-id="${id}"]`);
         let value = parseInt(input.value, 10);
         const max = parseInt(input.getAttribute('max'), 10);
         if (value < max) {
            updateQuantity(id, value + 1);
         }
      });
   });

   // Thêm event listeners cho các trường nhập số lượng
   quantityInputs.forEach(input => {
      input.addEventListener('change', function() {
         const id = this.getAttribute('data-id');
         updateQuantity(id, this.value);
      });
         
      // Ngăn chặn nhập giá trị không hợp lệ
      input.addEventListener('input', function() {
         this.value = this.value.replace(/[^0-9]/g, '');
         if (this.value === '') {
            this.value = '1';
         }
      });
   });
   
   // Thêm event listener cho nút xóa sản phẩm
   removeBtns.forEach(btn => {
      btn.addEventListener('click', function(e) {
         e.preventDefault();
         const id = this.closest('form').querySelector('input[name="bookId"]').value;
         removeFromCart(id);
      });
   });
   
   // Thêm event listener cho nút xóa giỏ hàng
   if (clearCartBtn) {
      clearCartBtn.addEventListener('click', clearCart);
   }
   
   // Thêm event listener cho nút áp dụng mã giảm giá
   if (applyCouponBtn) {
      applyCouponBtn.addEventListener('click', function(e) {
         e.preventDefault();
         applyCoupon();
      });
   }
   
   // Thêm "Chọn tất cả" checkbox
   addSelectAllCheckbox();
   
   // Khởi tạo summary khi tải trang
   updateCartSummary();
});