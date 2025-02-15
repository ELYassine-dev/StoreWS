package admins;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

import connections.SingleConnection;

/**
 * Servlet implementation class Deleteclient
 */
@WebServlet("/Deleteclient")
public class Deleteclient extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Deleteclient() {
        super();
        // TODO Auto-generated constructor stub
    }
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			
//			HttpSession session=request.getSession();
//			if(session.getAttribute("name")!=null) {
//				
			int id=Integer.parseInt(request.getParameter("id"));
//			System.out.println("the id is  "+id);
			
			PrintWriter out=response.getWriter();
			String url="jdbc:mysql://localhost:3306/store";
			String user="root";
			String pass="";
			try (Connection conn = SingleConnection.getConnection()) {
				
	            String sql = "DELETE FROM client WHERE id=?";
	            PreparedStatement stmt = conn.prepareStatement(sql);
	            stmt.setInt(1, id);
	            stmt.executeUpdate();
//	            response.sendRedirect("admin/admin.jsp");
	  response.sendRedirect(request.getContextPath() + "/admin/listclient.jsp"); 

			} catch (Exception e) {
	            e.printStackTrace();
	            response.getWriter().println("Error deleting client.");
	        }
		
		

	}
	}
