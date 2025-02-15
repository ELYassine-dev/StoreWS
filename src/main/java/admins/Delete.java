package admins;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import connections.SingleConnection;

/**
 * Servlet implementation class Delete
 */
@WebServlet("/Delete")
public class Delete extends HttpServlet {
	private static final long serialVersionUID = 1L;
  
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
//		HttpSession session=request.getSession();
//		if(session.getAttribute("name")!=null) {
//			
		int id=Integer.parseInt(request.getParameter("id"));
		String action=request.getParameter("action");
//		System.out.println("the id is  "+id);
		
		PrintWriter out=response.getWriter();
		String url="jdbc:mysql://localhost:3306/store";
		String user="root";
		String pass="";
		try (Connection conn = SingleConnection.getConnection()) {
			
			/////////delete clients
			
			if("deleteclient".equalsIgnoreCase(action)) {
				String sql = "DELETE FROM client WHERE id=?";
	            PreparedStatement stmt = conn.prepareStatement(sql);
	            stmt.setInt(1, id);
	            stmt.executeUpdate();
	            request.getSession().setAttribute("successMessage", "Client deleted successfully!");
//	            response.sendRedirect("admin/admin.jsp");
	            response.getWriter().println("client deleted successfully!");
	      
			}
			//////////////delete products
			else if("deleteproduct".equalsIgnoreCase(action)){
				
			
            String sql = "DELETE FROM produits WHERE idpro=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            int result = stmt.executeUpdate();
            
            if (result > 0) {
                request.getSession().setAttribute("successMessage", "Product deleted successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Product not found or already deleted.");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/admin.jsp"); 

            }
			
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Error deleting product: " + e.getMessage());
        }
	
	
	
	
	
	
	
	}

	
}
