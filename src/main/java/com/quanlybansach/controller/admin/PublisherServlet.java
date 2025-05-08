package com.quanlybansach.controller.admin;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.quanlybansach.dao.PublisherDAO;
import com.quanlybansach.model.Publisher;

@WebServlet(urlPatterns = {"/admin/publishers/*"})
public class PublisherServlet extends HttpServlet {
   private static final long serialVersionUID = 1L;
   private PublisherDAO publisherDAO;

   @Override
   public void init() {
      publisherDAO = new PublisherDAO();
   }

   @Override
   public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      String action = request.getPathInfo();
      if (action == null) {
         action = "/list";
      }

      switch (action) {
         case "/list":
            listPublishers(request, response);
            break;
         case "/show":
            showPublisher(request, response);
            break;
         case "/new":
            showNewForm(request, response);
            break;
         case "/edit":
            showNewForm(request, response);
            break;
         case "/delete":
            showPublisher(request, response);
            break;
         default:
            listPublishers(request, response);
            break;
      }
   }

   private void showNewForm(HttpServletRequest request, HttpServletResponse response) {
      // TODO Auto-generated method stub
      throw new UnsupportedOperationException("Unimplemented method 'showNewForm'");
   }

   private void showPublisher(HttpServletRequest request, HttpServletResponse response) {
      // TODO Auto-generated method stub
      throw new UnsupportedOperationException("Unimplemented method 'showPublisher'");
   }

   private void listPublishers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      List<Publisher> listPublishers = publisherDAO.getAllPublishers();
      request.setAttribute("listPublishers", listPublishers); 
           
      request.getRequestDispatcher("/WEB-INF/views/admin/publishers.jsp").forward(request, response);
   }
   
}
