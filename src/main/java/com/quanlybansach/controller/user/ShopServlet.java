package com.quanlybansach.controller.user;

import com.quanlybansach.dao.AuthorDAO;
import com.quanlybansach.dao.BookDAO;
import com.quanlybansach.dao.CategoryDAO;
import com.quanlybansach.dao.PublisherDAO;
import com.quanlybansach.model.Author;
import com.quanlybansach.model.Book;
import com.quanlybansach.model.Category;
import com.quanlybansach.service.BookService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

@WebServlet("/shop/*")
public class ShopServlet extends HttpServlet {
   
   private BookDAO bookDAO;
   private CategoryDAO categoryDAO;
   private AuthorDAO authorDAO;
   private PublisherDAO publisherDAO;
   private static final int BOOKS_PER_PAGE = 9;


   @Override
   public void init() throws ServletException {
      bookDAO = new BookDAO();
      categoryDAO = new CategoryDAO();
      authorDAO = new AuthorDAO();
      publisherDAO = new PublisherDAO();
   }

   @Override
   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

      String action = request.getPathInfo();
      if (action == null || action.isEmpty()) {
         action = "/list";
      }

      System.out.println("Requested action: " + action);

      switch (action) {
         case "/list":
            listBooks(request, response);
            break;
         case "/search":
            searchBooks(request, response);
            break;
         default:
            listBooks(request, response);
            break;
      }
   }

   private void searchBooks(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      // Get all filter parameters
      String keyword = request.getParameter("keyword");
      String authorParam = request.getParameter("author");
      String categoryParam = request.getParameter("category");
      String minPriceParam = request.getParameter("minPrice");
      String maxPriceParam = request.getParameter("maxPrice");
      String ratingParam = request.getParameter("rating");

      if (keyword == null) {
         keyword = "";
      }
      
      // Price range filter
      BigDecimal minPrice = new BigDecimal(0);
      BigDecimal maxPrice = new BigDecimal(1000000);
      
      if (minPriceParam != null && !minPriceParam.isEmpty()) {
         try {
            minPrice = new BigDecimal(minPriceParam);
         } catch (NumberFormatException e) {
            // Keep default
         }
      }
      
      if (maxPriceParam != null && !maxPriceParam.isEmpty()) {
         try {
            maxPrice = new BigDecimal(maxPriceParam);
         } catch (NumberFormatException e) {
            // Keep default
         }
      }
      
      // Rating filter
      float minRating = 0;
      if (ratingParam != null && !ratingParam.isEmpty()) {
         try {
            minRating = Float.parseFloat(ratingParam);
         } catch (NumberFormatException e) {
            minRating = 0;
         }
      }
      
      // Prepare parameters for BookService.searchBooks
      String[] categoriesId = (categoryParam != null && !categoryParam.isEmpty()) ? categoryParam.split(",") : new String[0];
      String[] authorsId = (authorParam != null && !authorParam.isEmpty()) ? authorParam.split(",") : new String[0];
      
      String priceRange = minPrice.compareTo(BigDecimal.ZERO) != 0 || maxPrice.compareTo(new BigDecimal(1000000)) != 0 
                        ? minPrice.toString() + "," + maxPrice.toString() 
                        : null;
      String rating = minRating > 0 ? String.valueOf(minRating) : null;
      
      try {
         BookService bookService = new BookService();
         
         // Get pagination parameters
         int pageNumber = 1;
         String pageParam = request.getParameter("page");
         if (pageParam != null && !pageParam.isEmpty()) {
            try {
               pageNumber = Integer.parseInt(pageParam);
               if (pageNumber < 1) {
                  pageNumber = 1;
               }
            } catch (NumberFormatException e) {
               pageNumber = 1;
            }
         }
         
         // Get sort parameter
         String sort = request.getParameter("sort");
         
         // Call BookService to search books
         System.out.println("Searching books with parameters: " +
               "keyword=" + keyword + ", categoriesId=" + String.join(",", categoriesId) +
               ", priceRange=" + priceRange + ", authorsId=" + String.join(",", authorsId) +
               ", rating=" + rating + ", page=" + pageNumber + ", sort=" + sort);
         List<Book> searchResults = bookService.searchBooks(keyword, categoriesId, priceRange, authorsId, rating);

         for (Book book : searchResults) {
            System.out.println( book.toString());
         }
         
         // Apply sorting if specified
         if (sort != null && !sort.isEmpty()) {
            switch (sort) {
               case "price-asc":
                  Collections.sort(searchResults, Comparator.comparing(Book::getPrice));
                  break;
               case "price-desc":
                  Collections.sort(searchResults, Comparator.comparing(Book::getPrice).reversed());
                  break;
               case "rating":
                  Collections.sort(searchResults, Comparator.comparing(Book::getAvgRating).reversed());
                  break;
               case "bestseller":
                  Collections.sort(searchResults, Comparator.comparing(Book::getTotalSold).reversed());
                  break;
               case "newest":
               default:
                  Collections.sort(searchResults, Comparator.comparing(Book::getPublicationDate, 
                        Comparator.nullsLast(Comparator.reverseOrder())));
                  break;
            }
         }
         
         // Apply pagination
         int totalBooks = searchResults.size();
         int totalPages = bookService.getTotalPages(totalBooks, BOOKS_PER_PAGE);
         List<Book> paginatedBooks = bookService.getBooksPaginated(searchResults, pageNumber, BOOKS_PER_PAGE);
         
         // Get all categories for filter sidebar
         List<Category> categories = categoryDAO.getAllCategories();
         List<Author> authors = authorDAO.getAllAuthors();

         int start = (pageNumber - 1) * BOOKS_PER_PAGE + 1;
         int end = Math.min(pageNumber * BOOKS_PER_PAGE, totalBooks);
         request.setAttribute("startIndex", start);
         request.setAttribute("endIndex", end);
         
         request.setAttribute("books", paginatedBooks);
         request.setAttribute("categories", categories);
         request.setAttribute("authors", authors);
         request.setAttribute("totalPages", totalPages);
         request.setAttribute("currentPage", pageNumber);
         request.setAttribute("currentSort", sort);
         request.setAttribute("totalBooks", totalBooks);
         request.setAttribute("booksPerPage", BOOKS_PER_PAGE);
            
         // Forward to shop.jsp
         request.getRequestDispatcher("/WEB-INF/views/user/shop.jsp").forward(request, response);
         
      } catch (SQLException e) {
         e.printStackTrace();
         response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred");
      }
   }

   private void listBooks(HttpServletRequest request, HttpServletResponse response) {
      
      List<Book> books = bookDAO.getAllBooks();
      List<Category> categories = categoryDAO.getAllCategories();
      List<Author> authors = authorDAO.getAllAuthors();
      String sort = request.getParameter("sort");
      String categoryId = request.getParameter("categoryId");
      String page = request.getParameter("page");
      int pageNumber = 1;
      if (page != null && !page.isEmpty()) {
         try {
            pageNumber = Integer.parseInt(page);
         } catch (NumberFormatException e) {
            pageNumber = 1;
         }
      }
      int totalBooks = books.size();
      int totalPages = (int) Math.ceil((double) totalBooks / BOOKS_PER_PAGE);
      int startIndex = (pageNumber - 1) * BOOKS_PER_PAGE;
      int endIndex = Math.min(startIndex + BOOKS_PER_PAGE, totalBooks);
      List<Book> paginatedBooks = books.subList(startIndex, endIndex);
      if (categoryId != null && !categoryId.isEmpty()) {
         int catId = Integer.parseInt(categoryId);
         paginatedBooks = bookDAO.getBooksByCategory(catId);
         totalBooks = paginatedBooks.size();
         totalPages = (int) Math.ceil((double) totalBooks / BOOKS_PER_PAGE);
         startIndex = (pageNumber - 1) * BOOKS_PER_PAGE;
         endIndex = Math.min(startIndex + BOOKS_PER_PAGE, totalBooks);
         paginatedBooks = paginatedBooks.subList(startIndex, endIndex);
      }
      if (sort != null && !sort.isEmpty()) {
         if (sort.equals("asc")) {
            Collections.sort(paginatedBooks, Comparator.comparing(Book::getPrice));
         } else if (sort.equals("desc")) {
            Collections.sort(paginatedBooks, Comparator.comparing(Book::getPrice).reversed());
         }
      }

      int start = (pageNumber - 1) * BOOKS_PER_PAGE + 1;
      int end = Math.min(pageNumber * BOOKS_PER_PAGE, totalBooks);
      request.setAttribute("startIndex", start);
      request.setAttribute("endIndex", end);
      
      request.setAttribute("books", paginatedBooks);
      request.setAttribute("categories", categories);
      request.setAttribute("authors", authors);
      request.setAttribute("totalPages", totalPages);
      request.setAttribute("currentPage", pageNumber);
      request.setAttribute("currentSort", sort);
      request.setAttribute("totalBooks", totalBooks);
      request.setAttribute("booksPerPage", BOOKS_PER_PAGE);
      try {
         request.getRequestDispatcher("/WEB-INF/views/user/shop.jsp").forward(request, response);
      } catch (ServletException | IOException e) {
         e.printStackTrace();
      }

   }
}