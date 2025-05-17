package com.quanlybansach.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Part;

/**
 * Utility class for Servlet related operations
 */
public class ServletUtils {
    
    /**
     * Get file name from Part
     * 
     * @param part The Part from which to extract the file name
     * @return The file name
     */
    public static String getFileName(Part part) {
        if (part == null) {
            return null;
        }
        
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                String fileName = item.substring(item.indexOf("=") + 2, item.length() - 1);
                return fileName;
            }
        }
        
        return null;
    }
    
    /**
     * Get base URL of the application
     * 
     * @param request HttpServletRequest
     * @return Base URL including protocol, server name, port and context path
     */
    public static String getBaseUrl(HttpServletRequest request) {
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();
        
        StringBuilder url = new StringBuilder();
        url.append(scheme).append("://").append(serverName);
        
        if ((serverPort != 80) && (serverPort != 443)) {
            url.append(":").append(serverPort);
        }
        
        url.append(contextPath);
        
        if (!contextPath.endsWith("/")) {
            url.append("/");
        }
        
        return url.toString();
    }
    
    /**
     * Get the client's IP address
     * 
     * @param request HttpServletRequest
     * @return Client's IP address
     */
    public static String getClientIPAddress(HttpServletRequest request) {
        String ipAddress = request.getHeader("X-Forwarded-For");
        
        if (ipAddress == null || ipAddress.length() == 0 || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("Proxy-Client-IP");
        }
        
        if (ipAddress == null || ipAddress.length() == 0 || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("WL-Proxy-Client-IP");
        }
        
        if (ipAddress == null || ipAddress.length() == 0 || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getRemoteAddr();
        }
        
        // In case of multiple proxies, first address is the client's
        if (ipAddress != null && ipAddress.contains(",")) {
            ipAddress = ipAddress.split(",")[0].trim();
        }
        
        return ipAddress;
    }
    
    /**
     * Get page number from request parameter
     * 
     * @param request HttpServletRequest
     * @param defaultValue Default page number if parameter is missing or invalid
     * @return Page number
     */
    public static int getPageNumber(HttpServletRequest request, int defaultValue) {
        String pageParam = request.getParameter("page");
        
        if (pageParam == null || pageParam.trim().isEmpty()) {
            return defaultValue;
        }
        
        try {
            int page = Integer.parseInt(pageParam);
            return page > 0 ? page : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    
    /**
     * Convert string to integer safely
     * 
     * @param str String to convert
     * @param defaultValue Default value if conversion fails
     * @return Converted integer or default value
     */
    public static int parseInt(String str, int defaultValue) {
        if (str == null || str.trim().isEmpty()) {
            return defaultValue;
        }
        
        try {
            return Integer.parseInt(str);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
} 