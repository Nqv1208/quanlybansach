// Payment method selection
document.addEventListener('DOMContentLoaded', function() {
   const paymentMethods = document.querySelectorAll('.payment-method');
   const shippingOptions = document.querySelectorAll('.shipping-option');
   
   // Initialize shipping options
   shippingOptions.forEach(option => {
      option.addEventListener('click', function() {
            const radio = this.querySelector('input[type="radio"]');
            radio.checked = true;
            
            // Trigger the change event
            const event = new Event('change');
            radio.dispatchEvent(event);
            
            // Highlight selected option
            shippingOptions.forEach(opt => opt.classList.remove('active-option'));
            this.classList.add('active-option');
      });
   });

   // Initialize payment methods
   paymentMethods.forEach(method => {
      method.addEventListener('click', function() {
            // Clear active class from all methods
            paymentMethods.forEach(m => m.classList.remove('active'));
            
            // Add active class to clicked method
            this.classList.add('active');
            
            // Check the radio button
            const radio = this.querySelector('input[type="radio"]');
            radio.checked = true;
            
            // Hide all expandable content
            document.querySelector('.bank-details').style.display = 'none';
            document.querySelector('.card-payment-form').style.display = 'none';
            
            // Show the appropriate expandable content
            const paymentType = this.getAttribute('data-payment');
            if (paymentType === 'bank-transfer') {
               document.querySelector('.bank-details').style.display = 'block';
            } else if (paymentType === 'credit-card') {
               document.querySelector('.card-payment-form').style.display = 'block';
            }
      });
   });

   // Shipping method change
   const shippingRadios = document.querySelectorAll('input[name="shippingMethod"]');
   const shippingFeeDisplay = document.getElementById('shippingFee');
   const totalAmountDisplay = document.getElementById('totalAmount');
   
   // Get values from page
   const subtotalElement = document.querySelector('[data-subtotal]');
   const discountElement = document.querySelector('[data-discount]');
   
   // Parse values or use defaults
   const subtotal = subtotalElement ? parseFloat(subtotalElement.getAttribute('data-subtotal')) : 0;
   const discount = discountElement ? parseFloat(discountElement.getAttribute('data-discount')) : 0;

   shippingRadios.forEach(radio => {
      radio.addEventListener('change', function() {
            let shippingFee = 30000; // Default standard shipping
            
            if (this.value === 'fast') {
               shippingFee = 50000;
            } else if (this.value === 'express') {
               shippingFee = 80000;
            }
            
            const total = subtotal + shippingFee - discount;
            
            // Update display
            shippingFeeDisplay.textContent = new Intl.NumberFormat('vi-VN').format(shippingFee) + '₫';
            totalAmountDisplay.textContent = new Intl.NumberFormat('vi-VN').format(total) + '₫';
            
            // Highlight the selected shipping option
            const selectedOption = this.closest('.shipping-option');
            if (selectedOption) {
               shippingOptions.forEach(opt => opt.classList.remove('active-option'));
               selectedOption.classList.add('active-option');
            }
      });
   });
   
   // Add active class to initial selections
   const initialShippingOption = document.querySelector('input[name="shippingMethod"]:checked')?.closest('.shipping-option');
   if (initialShippingOption) {
      initialShippingOption.classList.add('active-option');
   }
   
   // Form validation
   const checkoutForm = document.getElementById('checkoutForm');
   if (checkoutForm) {
      checkoutForm.addEventListener('submit', function(event) {
            const fullName = document.getElementById('fullName').value;
            const phone = document.getElementById('phone').value;
            const email = document.getElementById('email').value;
            const address = document.getElementById('address').value;
            const province = document.getElementById('province').value;
            const district = document.getElementById('district').value;
            const ward = document.getElementById('ward').value;
            
            if (!fullName || !phone || !email || !address || !province || !district || !ward) {
               event.preventDefault();
               alert('Vui lòng điền đầy đủ thông tin giao hàng!');
            }
            
            // Validate payment method for credit card
            const creditCardPayment = document.getElementById('paymentCard');
            if (creditCardPayment && creditCardPayment.checked) {
               const cardNumber = document.getElementById('cardNumber').value;
               const cardExpiry = document.getElementById('cardExpiry').value;
               const cardCvc = document.getElementById('cardCvc').value;
               const cardName = document.getElementById('cardName').value;
               
               if (!cardNumber || !cardExpiry || !cardCvc || !cardName) {
                  event.preventDefault();
                  alert('Vui lòng điền đầy đủ thông tin thẻ tín dụng!');
               }
            }
      });
   }
   
   // Add custom styles for active shipping options
   const style = document.createElement('style');
   style.textContent = `
      .shipping-option {
            cursor: pointer;
      }
      .shipping-option:hover {
            border-color: #0d6efd !important;
            background-color: rgba(13, 110, 253, 0.03);
      }
      .shipping-option.active-option {
            border-color: #0d6efd !important;
            background-color: rgba(13, 110, 253, 0.05);
      }
      .payment-method {
            cursor: pointer;
      }
      .payment-method:hover {
            border-color: #0d6efd !important;
            background-color: rgba(13, 110, 253, 0.03);
      }
      .payment-method.active {
            border-color: #0d6efd !important;
            background-color: rgba(13, 110, 253, 0.05);
      }
   `;
   document.head.appendChild(style);
});