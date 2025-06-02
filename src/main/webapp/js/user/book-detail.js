document.addEventListener('DOMContentLoaded', function() {
   // Khởi tạo toast
   const cartToast = document.getElementById('cartToast');
   if (cartToast) {
      const toast = new bootstrap.Toast(cartToast);
      
      // Hiển thị toast khi form được submit
      const addToCartForm = document.getElementById('addToCartForm');
      if (addToCartForm) {
         addToCartForm.addEventListener('submit', function() {
            // Cập nhật số lượng từ input
            document.getElementById('cartQuantity').value = document.querySelector('.quantity-input').value;
            toast.show()
         });
      }
      
      const buyNowForm = document.getElementById('buyNowForm');
      if (buyNowForm) {
         buyNowForm.addEventListener('submit', function() {
            // Cập nhật số lượng từ input
            document.getElementById('buyQuantity').value = document.querySelector('.quantity-input').value;
         });
      }
   }
   
   // Quantity control
   const decreaseBtn = document.querySelector('.decrease-btn');
   const increaseBtn = document.querySelector('.increase-btn');
   const quantityInput = document.querySelector('.quantity-input');
   
   if (decreaseBtn && increaseBtn && quantityInput) {
      decreaseBtn.addEventListener('click', function() {
         let value = parseInt(quantityInput.value, 10);
         value = isNaN(value) ? 1 : value;
         if (value > 1) {
            value--;
            quantityInput.value = value;
         }
      });
      
      increaseBtn.addEventListener('click', function() {
         let value = parseInt(quantityInput.value, 10);
         value = isNaN(value) ? 1 : value;
         const max = parseInt(quantityInput.getAttribute('max'), 10);
         if (value < max) {
            value++;
            quantityInput.value = value;
         }
      });
      
      quantityInput.addEventListener('change', function() {
         let value = parseInt(this.value, 10);
         const max = parseInt(this.getAttribute('max'), 10);
         value = isNaN(value) ? 1 : value;
         if (value < 1) {
            this.value = 1;
         } else if (value > max) {
            this.value = max;
         }
      });
   }
});