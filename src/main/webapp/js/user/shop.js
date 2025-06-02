document.addEventListener('DOMContentLoaded', function() {
   // Context path detection
   const contextPath = window.location.pathname.includes('/shop') 
      ? window.location.pathname.substring(0, window.location.pathname.indexOf('/shop')) 
      : '';

   // Create filter form to handle all filter options
   const filterForm = document.createElement('form');
   filterForm.id = 'filterForm';
   filterForm.method = 'get';
   filterForm.action = contextPath + '/shop';
   document.body.appendChild(filterForm);

   // Handle reset filters button - redirects to shop with no parameters
   const resetFiltersBtn = document.querySelector('.filter-sidebar .btn-outline-danger');
   if (resetFiltersBtn) {
      resetFiltersBtn.addEventListener('click', function(e) {
         e.preventDefault();
         window.location.href = this.getAttribute('href');
      });
   }

   // Function to update URL with filters instead of using form submission
   function updateUrlWithFilters(paramName, paramValue) {
      const currentUrl = new URL(window.location.href);
      const searchParams = currentUrl.searchParams;
   
      if (paramValue && paramValue.trim() !== '') {
         searchParams.set(paramName, paramValue);
      } else {
         searchParams.delete(paramName);
      }
   
      searchParams.set('page', 1);
   
      // Force to /shop/search
      const baseUrl = contextPath + '/shop/search';
      window.location.href = baseUrl + '?' + searchParams.toString();
   }

 // New: Multi-select category filter
document.querySelectorAll('.category-filter').forEach(checkbox => {
   checkbox.addEventListener('change', function () {
      const selected = [...document.querySelectorAll('.category-filter:checked')]
         .map(cb => cb.value)
         .join(',');

      updateUrlWithFilters('category', selected);
   });
});

// New: Multi-select author filter
document.querySelectorAll('.author-filter').forEach(checkbox => {
   checkbox.addEventListener('change', function () {
      const selected = [...document.querySelectorAll('.author-filter:checked')]
         .map(cb => cb.value)
         .join(',');

      updateUrlWithFilters('author', selected);
   });
});

   // Handle rating filter radio buttons
   document.querySelectorAll('input[name="rating"]').forEach(radio => {
      radio.addEventListener('change', function() {
         updateUrlWithFilters('rating', this.value);
      });
   });

   // Handle sort select dropdown
   const sortSelect = document.querySelector('.sort-select');
   if (sortSelect) {
      sortSelect.addEventListener('change', function() {
         updateUrlWithFilters('sort', this.value);
      });
   }

   // Handle price range filter
   const minPriceInput = document.getElementById('minPriceInput');
   const maxPriceInput = document.getElementById('maxPriceInput');
   const applyPriceFilter = document.getElementById('applyPriceFilter');

   minPriceInput?.addEventListener('input', function () {
      this.value = this.value.replace(/[^0-9]/g, '');
   });

   maxPriceInput?.addEventListener('input', function () {
      this.value = this.value.replace(/[^0-9]/g, '');
   });

   if (minPriceInput && maxPriceInput && applyPriceFilter) {
      // Apply price filter
      applyPriceFilter.addEventListener('click', function(e) {
         e.preventDefault();
         const currentUrl = new URL(window.location.href);
         const searchParams = currentUrl.searchParams;
         
         const minPrice = minPriceInput.value.trim();
         const maxPrice = maxPriceInput.value.trim();
         
         // Only add parameters if they have values
         if (minPrice) {
            searchParams.set('minPrice', minPrice);
         } else {
            searchParams.delete('minPrice');
         }
         
         if (maxPrice) {
            searchParams.set('maxPrice', maxPrice);
         } else {
            searchParams.delete('maxPrice');
         }
         
         // Reset to page 1 when filtering
         searchParams.set('page', 1);
         
         // Navigate to the new URL with updated parameters
         window.location.href = currentUrl.toString();
      });
   }

   // Handle search form submission
   const searchForm = document.querySelector('.filter-section form');
   if (searchForm) {
      searchForm.addEventListener('submit', function(e) {
         e.preventDefault();
         const keyword = this.querySelector('input[name="keyword"]').value;
         updateUrlWithFilters('keyword', keyword);
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
            updateUrlWithFilters('page', page);
         }
      });
   });

   // Initialize filter selections based on URL parameters
   function initializeFilterSelections() {
      const urlParams = new URLSearchParams(window.location.search);
      
      // Check multiple category checkboxes
      if (urlParams.has('category')) {
         const ids = urlParams.get('category').split(',');
         ids.forEach(id => {
            const cb = document.querySelector(`.category-filter[value="${id}"]`);
            if (cb) cb.checked = true;
         });
      }
      
      // Check multiple author checkboxes
      if (urlParams.has('author')) {
         const ids = urlParams.get('author').split(',');
         ids.forEach(id => {
            const cb = document.querySelector(`.author-filter[value="${id}"]`);
            if (cb) cb.checked = true;
         });
      }
      
      // Check the appropriate rating radio
      if (urlParams.has('rating')) {
         const rating = urlParams.get('rating');
         const ratingRadio = document.querySelector(`input[name="rating"][value="${rating}"]`);
         if (ratingRadio) {
            ratingRadio.checked = true;
         }
      }
      
      // Set the price range inputs if applicable
      if (urlParams.has('minPrice') && minPriceInput) {
          minPriceInput.value = urlParams.get('minPrice');
      }
      
      if (urlParams.has('maxPrice') && maxPriceInput) {
          maxPriceInput.value = urlParams.get('maxPrice');
      }
      
      // Set the sort select if applicable
      if (urlParams.has('sort') && sortSelect) {
         sortSelect.value = urlParams.get('sort');
      }
   }
   
   // Initialize filter selections
   initializeFilterSelections();
});