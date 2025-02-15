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

@WebServlet("/ProductServlet")
@MultipartConfig
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Get form data
            String type = request.getParameter("type");
            String reference = request.getParameter("reference");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            Part imagePart = request.getPart("imgs");
            
            // Handle image upload
            String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            
            // Create images directory if it doesn't exist
            String uploadPath = getServletContext().getRealPath("") + File.separator + "img";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            
            // Save the image file
            try (InputStream input = imagePart.getInputStream()) {
                Files.copy(input, new File(uploadPath + File.separator + fileName).toPath(),
                        StandardCopyOption.REPLACE_EXISTING);
            }
            
            // Database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/store";
            String dbUser = "root";
            String dbPassword = "";
            
            try (Connection conn = DriverManager.getConnection(url, dbUser, dbPassword)) {
                String sql = "INSERT INTO produits (type, reference, description, price, image) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement pst = conn.prepareStatement(sql)) {
                    pst.setString(1, type);
                    pst.setString(2, reference);
                    pst.setString(3, description);
                    pst.setDouble(4, price);
                    pst.setString(5, fileName);
                    
                    pst.executeUpdate();
                }
            }
            
            // Redirect to admin page after successful addition
            response.sendRedirect(request.getContextPath() + "/admin/admin.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            // In case of error, redirect back to add product page
            response.sendRedirect(request.getContextPath() + "/admin/Ajouter.jsp");
        }
    }
}
