package admins;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.nio.file.Files;
import java.nio.file.Paths;

@WebServlet("/Updatepro")
@MultipartConfig
public class Updatepro extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPDATE_QUERY = "UPDATE produits SET type=?, reference=?, description=?, price=?, image=? WHERE idpro=?";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Retrieve parameters from request
            int id = Integer.parseInt(request.getParameter("id"));
            String type = request.getParameter("type");
            String reference = request.getParameter("reference");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            String currentImage = request.getParameter("currentImage");
            
            // Initialize imageFilename with current image
            String imageFilename = currentImage;

            // Get uploaded file part
            Part filePart = request.getPart("imgs");
            
            // Only process the image if a new one was uploaded
            if (filePart != null && filePart.getSize() > 0) {
                imageFilename = filePart.getSubmittedFileName();
                if (imageFilename == null || imageFilename.isEmpty()) {
                    imageFilename = currentImage; // Keep current image if no new file
                } else {
                    // Get the real path for the images directory
                    String applicationPath = request.getServletContext().getRealPath("");
                    String uploadPath = applicationPath + File.separator + "img";
                    
                    // Create the upload folder if it doesn't exist
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    // Construct the file path
                    String filePath = uploadPath + File.separator + imageFilename;
                    
                    // Delete old file if it exists and is different
                    if (!imageFilename.equals(currentImage)) {
                        File oldFile = new File(uploadPath + File.separator + currentImage);
                        if (oldFile.exists()) {
                            oldFile.delete();
                        }
                    }
                    
                    // Save the file
                    try (InputStream input = filePart.getInputStream()) {
                        Files.copy(input, Paths.get(filePath));
                    } catch (Exception e) {
                        out.println("<script type='text/javascript'>");
                        out.println("alert('Error uploading image: " + e.getMessage() + "');");
                        out.println("window.location.href='" + request.getContextPath() + "/admin/update.jsp?id=" + id + "';");
                        out.println("</script>");
                        return;
                    }
                }
            }

            // Database connection parameters
            String url = "jdbc:mysql://localhost:3306/store";
            String user = "root";
            String pass = "";

            // Update database
            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 PreparedStatement stmt = conn.prepareStatement(UPDATE_QUERY)) {

                stmt.setString(1, type);
                stmt.setString(2, reference);
                stmt.setString(3, description);
                stmt.setDouble(4, price);
                stmt.setString(5, imageFilename);
                stmt.setInt(6, id);

                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    // Ensure we're using an absolute path for redirection
                    String contextPath = request.getContextPath();
                    response.sendRedirect(contextPath + "/admin/admin.jsp");
                    return; // Add return to prevent further processing
                } else {
                    out.println("<script type='text/javascript'>");
                    out.println("alert('Failed to update product. Please try again.');");
                    out.println("window.location.href='" + request.getContextPath() + "/admin/update.jsp?id=" + id + "';");
                    out.println("</script>");
                }
            } catch (Exception e) {
                out.println("<script type='text/javascript'>");
                out.println("alert('Database error: " + e.getMessage() + "');");
                out.println("window.location.href='" + request.getContextPath() + "/admin/update.jsp?id=" + id + "';");
                out.println("</script>");
            }
        } catch (Exception e) {
            out.println("<script type='text/javascript'>");
            out.println("alert('System error: " + e.getMessage() + "');");
            out.println("window.location.href='" + request.getContextPath() + "/admin/admin.jsp';");
            out.println("</script>");
        }
    }
}
