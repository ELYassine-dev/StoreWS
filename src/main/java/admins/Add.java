package admins;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/Add")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,  // 1 MB
    maxFileSize = 1024 * 1024 * 10,    // 10 MB
    maxRequestSize = 1024 * 1024 * 100  // 100 MB
)
public class Add extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            // Get form data
            String type = request.getParameter("type");
            String reference = request.getParameter("reference");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            
            // Handle image upload
            Part imagePart = request.getPart("imgs");
            String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            
            // Get the real path for the images directory
            String uploadPath = request.getServletContext().getRealPath("") + File.separator + "img";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs(); // Create directories recursively
            }
            
            // Save the image file
            String filePath = uploadPath + File.separator + fileName;
            try (InputStream input = imagePart.getInputStream()) {
                Files.copy(input, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
            }
            
            // Database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/store";
            String dbUser = "root";
            String dbPassword = "";
            
            conn = DriverManager.getConnection(url, dbUser, dbPassword);
            
            // Now proceed with the insert
            String sql = "INSERT INTO produits (type, reference, description, price, image) VALUES (?, ?, ?, ?, ?)";
            pst = conn.prepareStatement(sql);
            pst.setString(1, type);
            pst.setString(2, reference);
            pst.setString(3, description);
            pst.setDouble(4, price);
            pst.setString(5, fileName);
            
            int result = pst.executeUpdate();
            
            if (result > 0) {
                // Set success message
                request.getSession().setAttribute("successMessage", "Product added successfully!");
                // Successful insertion
                response.sendRedirect(request.getContextPath() + "/admin/admin.jsp");
                return;
            } else {
                throw new SQLException("Failed to insert product");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Error adding product: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/Ajouter.jsp");
        } finally {
            if (pst != null) {
                try {
                    pst.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
