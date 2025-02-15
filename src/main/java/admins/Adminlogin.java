package admins;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Servlet implementation class Adminlogin
 */
@WebServlet("/Adminlogin")
public class Adminlogin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Adminlogin() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	
	
		 String email = request.getParameter("email");
         String password = request.getParameter("password");

         String url = "jdbc:mysql://localhost:3306/store";
         String user = "root";
         String passe = "";

         try {
             Class.forName("com.mysql.cj.jdbc.Driver");
             Connection conn = DriverManager.getConnection(url, user, passe);

       String admin="admin@gmail.com";
       String pass="ad1234";
             if (admin.equalsIgnoreCase(admin)&& pass.equalsIgnoreCase(pass)) { // If a record is found, login is successful
                 HttpSession session = request.getSession();
                 session.setAttribute("admin", admin);
                 session.setMaxInactiveInterval(30 * 60); // Session timeout (30 mins)

                 response.sendRedirect(request.getContextPath() + "/admin/admin.jsp");
             } else {
                 response.sendRedirect(request.getContextPath() + "/Auth/adminlogin.jsp");
             }

             // Close resources
            
             conn.close();

         } catch (Exception e) {
             e.printStackTrace();
             response.getWriter().println("Error logging into account.");
         }
	
	
	
	
	
	}

}
