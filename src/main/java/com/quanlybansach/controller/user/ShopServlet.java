package com.quanlybansach.controller.user;

import com.quanlybansach.dao.AuthorDAO;
import com.quanlybansach.dao.BookDAO;
import com.quanlybansach.dao.CategoryDAO;
import com.quanlybansach.dao.PublisherDAO;
import com.quanlybansach.model.Book;
import com.quanlybansach.model.Category;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
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

      switch (action) {
         case "/list":
            listBooks(request, response);
            break;
         case "/detail":
            // showBookDetail(request, response);
            break;
         case "/review":
            // showReviewPage(request, response);
            break;
         default:
            listBooks(request, response);
            break;
      }
   }

   private void listBooks(HttpServletRequest request, HttpServletResponse response) {
      
      List<Book> books = bookDAO.getAllBooks();
      List<Category> categories = categoryDAO.getAllCategories();
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
      request.setAttribute("books", paginatedBooks);
      request.setAttribute("categories", categories);
      request.setAttribute("totalPages", totalPages);
      request.setAttribute("currentPage", pageNumber);
      request.setAttribute("currentCategory", categoryId);
      request.setAttribute("currentSort", sort);
      try {
         request.getRequestDispatcher("/WEB-INF/views/user/shop.jsp").forward(request, response);
      } catch (ServletException | IOException e) {
         e.printStackTrace();
      }

   }
}