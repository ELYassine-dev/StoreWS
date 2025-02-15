package client;

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
 * Servlet implementation class Loginclient
 */
@WebServlet("/Loginclient")
public class Loginclient extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Loginclient() {
        super();
        // TODO Auto-generated constructor stub
    }

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	String url = "jdbc:mysql://localhost:3306/store";
           String user = "root";
           String passe = "";
        

    	 String email = request.getParameter("email");
         String password = request.getParameter("password");

         String admin="admin@gmail.com";
         String pass="ad1234";
         HttpSession session = request.getSession();
         
         if (admin.equalsIgnoreCase(email)&& pass.equalsIgnoreCase(password)) { session.setAttribute("admin", admin);
            response.sendRedirect(request.getContextPath() + "/admin/admin.jsp");
        } else {
         try {
             Class.forName("com.mysql.cj.jdbc.Driver");
             Connection conn = DriverManager.getConnection(url, user, passe);

             // Modifié pour récupérer l'ID et le nom du client
             String sql = "SELECT id, name, email FROM client WHERE email=? AND passeword=?";
             PreparedStatement stmt = conn.prepareStatement(sql);
             stmt.setString(1, email);
             stmt.setString(2, password);

             // Use executeQuery() instead of executeUpdate()
             ResultSet rs = stmt.executeQuery();

             if (rs.next()) { // If a record is found, login is successful
                 HttpSession session1 = request.getSession();
                 session1.setAttribute("id", rs.getInt("id"));
                 session1.setAttribute("email", rs.getString("email"));
                 session1.setAttribute("name", rs.getString("name"));
                 session1.setMaxInactiveInterval(30 * 60); // Session timeout (30 mins)

                 response.sendRedirect(request.getContextPath() + "/client/home.jsp");
             } else {
                 response.sendRedirect(request.getContextPath() + "/client/Userlogin.jsp");
             }

             // Close resources
             rs.close();
             stmt.close();
             conn.close();

         } catch (Exception e) {
             e.printStackTrace();
             response.getWriter().println("Error logging into account.");
         		}
        	}
         }
    }
