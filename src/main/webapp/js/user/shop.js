document.addEventListener('DOMContentLoaded', function() {
   // Create filter form to handle all filter options
   const filterForm = document.createElement('form');
   filterForm.id = 'filterForm';
   filterForm.method = 'get';
   filterForm.action = contextPath + '/shop';
   document.body.appendChild(filterForm);

   // Handle category filter checkboxes
   document.querySelectorAll('.category-filter').forEach(checkbox => {
      checkbox.addEventListener('change', function() {
            const categoryId = this.value;
            
            // Uncheck other categories if this one is checked
            if (this.checked) {
               document.querySelectorAll('.category-filter').forEach(cb => {
                  if (cb !== this) {
                        cb.checked = false;
                  }
               });
            }
            
            updateFilter('category', this.checked ? categoryId : '');
      });
   });

   // Handle author filter checkboxes
   document.querySelectorAll('.author-filter').forEach(checkbox => {
      checkbox.addEventListener('change', function() {
            const authorId = this.value;
            
            // Uncheck other authors if this one is checked
            if (this.checked) {
               document.querySelectorAll('.author-filter').forEach(cb => {
                  if (cb !== this) {
                        cb.checked = false;
                  }
               });
            }
            
            updateFilter('author', this.checked ? authorId : '');
      });
   });

   // Handle rating filter radio buttons
   document.querySelectorAll('input[name="rating"]').forEach(radio => {
      radio.addEventListener('change', function() {
            updateFilter('rating', this.value);
      });
   });

   // Handle sort select dropdown
   const sortSelect = document.querySelector('.sort-select');
   if (sortSelect) {
      sortSelect.addEventListener('change', function() {
            updateFilter('sort', this.value);
      });
   }

   // Handle price range filter
   const priceRange = document.getElementById('priceRange');
   const minPriceDisplay = document.getElementById('minPrice');
   const maxPriceDisplay = document.getElementById('maxPrice');
   const applyPriceBtn = document.querySelector('.filter-section .btn');

   if (priceRange && applyPriceBtn) {
      priceRange.addEventListener('input', function() {
            const value = this.value;
            maxPriceDisplay.textContent = new Intl.NumberFormat('vi-VN').format(value) + '₫';
      });
      
      applyPriceBtn.addEventListener('click', function() {
            updateFilter('maxPrice', priceRange.value);
            updateFilter('minPrice', '0');
      });
   }

   // Handle search form submission
   const searchForm = document.querySelector('.filter-section form');
   if (searchForm) {
      searchForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const keyword = this.querySelector('input[name="keyword"]').value;
            updateFilter('keyword', keyword);
      });
   }

   // Function to update filters and submit form
   function updateFilter(name, value) {
      let input = filterForm.querySelector(`input[name="${name}"]`);
      
      if (!input) {
            input = document.createElement('input');
            input.type = 'hidden';
            input.name = name;
            filterForm.appendChild(input);
      }
      
      input.value = value;
      
      // Keep existing pagination, sort, and other parameters
      preserveExistingParameters(filterForm);
      
      // Submit the form
      filterForm.submit();
   }

   // Function to preserve existing parameters from URL
   function preserveExistingParameters(form) {
      const urlParams = new URLSearchParams(window.location.search);
      
      // List of parameters to preserve if they exist in URL
      const paramsToPreserve = [
            'sort', 'page', 'keyword', 'category', 'author', 
            'minPrice', 'maxPrice', 'rating', 'stock'
      ];
      
      paramsToPreserve.forEach(param => {
            // Only preserve if not already set in the current form submission
            if (urlParams.has(param) && !form.querySelector(`input[name="${param}"]`)) {
               const input = document.createElement('input');
               input.type = 'hidden';
               input.name = param;
               input.value = urlParams.get(param);
               form.appendChild(input);
            }
      });
   }

   // Handle pagination links
   document.querySelectorAll('.pagination .page-link').forEach(link => {
      link.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Extract page number from the link's href
            const hrefParams = new URLSearchParams(this.getAttribute('href').split('?')[1]);
            const page = hrefParams.get('page');
            
            if (page) {
               updateFilter('page', page);
            }
      });
   });

   // Initialize filter form with current URL parameters
   function initializeFilterForm() {
      const urlParams = new URLSearchParams(window.location.search);
      
      // Create hidden inputs for all current parameters
      urlParams.forEach((value, key) => {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = key;
            input.value = value;
            filterForm.appendChild(input);
      });
      
      // Check the appropriate category checkbox
      if (urlParams.has('category')) {
            const categoryId = urlParams.get('category');
            const categoryCheckbox = document.querySelector(`.category-filter[value="${categoryId}"]`);
            if (categoryCheckbox) {
               categoryCheckbox.checked = true;
            }
      }
      
      // Check the appropriate author checkbox
      if (urlParams.has('author')) {
            const authorId = urlParams.get('author');
            const authorCheckbox = document.querySelector(`.author-filter[value="${authorId}"]`);
            if (authorCheckbox) {
               authorCheckbox.checked = true;
            }
      }
      
      // Check the appropriate rating radio
      if (urlParams.has('rating')) {
            const rating = urlParams.get('rating');
            const ratingRadio = document.querySelector(`input[name="rating"][value="${rating}"]`);
            if (ratingRadio) {
               ratingRadio.checked = true;
            }
      }
      
      // Set the price range if applicable
      if (urlParams.has('maxPrice') && priceRange) {
            priceRange.value = urlParams.get('maxPrice');
            maxPriceDisplay.textContent = new Intl.NumberFormat('vi-VN').format(priceRange.value) + '₫';
      }
      
      // Set the sort select if applicable
      if (urlParams.has('sort') && sortSelect) {
            sortSelect.value = urlParams.get('sort');
      }
   }

   function searchBooks() {
      
      const formData = new FormData();
      formData.append('keyword', document.querySelector('input[name="keyword"]').value);
      formData.append('category', document.querySelector('input[name="category"]').value);
      formData.append('author', document.querySelector('input[name="author"]').value);
      formData.append('minPrice', document.querySelector('input[name="minPrice"]').value);
      formData.append('maxPrice', document.querySelector('input[name="maxPrice"]').value);
      formData.append('rating', document.querySelector('input[name="rating"]').value);
      formData.append('sort', document.querySelector('.sort-select').value);

      // Lấy context path từ URL hiện tại
      const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/shop'));

      fetch(contextPath + '/shop/search', {
            method: 'POST',
            body: formData
      })
      .then(response => {
         if (!response.ok) {
            throw new Error('Lỗi khi tìm kiếm sách');
         }
         return response.json();
      })
      .then(data => {
         // Handle the response data (e.g., update the book list)
         const bookList = document.querySelector('.products-list');
         bookList.innerHTML = ''; // Clear existing books
         
         data.books.forEach(book => {
            bookItem.innerHTML = `
               <div class="col-lg-4 col-md-6 mb-4">
                     <div class="card h-100">
                        <!-- Category Badge -->
                        <span class="category-badge">${book.categoryName}</span>
                        
                        <!-- Stock Status -->
                        <c:choose>
                           <c:when test="${book.stockQuantity > 10}">
                                 <span class="stock-status in-stock">Còn hàng</span>
                           </c:when>
                           <c:when test="${book.stockQuantity > 0 && book.stockQuantity <= 10}">
                                 <span class="stock-status low-stock">Sắp hết</span>
                           </c:when>
                           <c:otherwise>
                                 <span class="stock-status out-of-stock">Hết hàng</span>
                           </c:otherwise>
                        </c:choose>
                        
                        <div class="card-img-container">
                           <img src="${book.imageUrl}" class="card-img-top" alt="${book.title}">
                        </div>
                        <div class="card-body">
                           <h5 class="card-title">${book.title}</h5>
                           <p class="card-author">${book.authorName}</p>
                           <div class="d-flex align-items-center mb-2">
                                 <div class="me-2">
                                    <c:forEach begin="1" end="5" var="i">
                                       <c:choose>
                                             <c:when test="${i <= book.avgRating}">
                                                <i class="fas fa-star text-warning"></i>
                                             </c:when>
                                             <c:when test="${i <= book.avgRating + 0.5}">
                                                <i class="fas fa-star-half-alt text-warning"></i>
                                             </c:when>
                                             <c:otherwise>
                                                <i class="far fa-star text-warning"></i>
                                             </c:otherwise>
                                       </c:choose>
                                    </c:forEach>
                                 </div>
                                 <small class="text-muted">(${book.reviewCount})</small>
                           </div>
                           <p class="card-price"><fmt:formatNumber value="${book.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></p>
                           <div class="d-flex gap-2">
                                 <a href="${pageContext.request.contextPath}/book-detail?id=${book.bookId}" class="btn btn-outline-primary flex-grow-1">Chi tiết</a>
                                 <!-- <c:if test="${book.stockQuantity > 0}">
                                    <button type="button" class="btn btn-primary btn-add-to-cart" data-book-id="${book.bookId}" data-quantity="1">
                                       <i class="fas fa-cart-plus"></i>
                                    </button>
                                 </c:if> -->
                           </div>
                        </div>
                     </div>
               </div>
            `;
            bookList.appendChild(bookItem);
         });
      })
      .catch(error => {
         console.error('Error:', error);
         alert('Có lỗi xảy ra khi tìm kiếm sách. Vui lòng thử lại sau.');
      });
   }
   
   // Initialize the filter form with current parameters
   initializeFilterForm();
});