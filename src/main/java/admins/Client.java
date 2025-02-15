package admins;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

/**
 * Servlet implementation class Client
 */
@WebServlet("/Client")
public class Client extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Client() {
        super();
        // TODO Auto-generated constructor stub
    }

	
//	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//		// TODO Auto-generated method stub
//		response.getWriter().append("Served at: ").append(request.getContextPath());
//	}

    @Override

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
     HttpSession session=request.getSession();
	
     String name = request.getParameter("name");
     String lastname = request.getParameter("lastname");
     String adresse = request.getParameter("adresse");
     String phone = request.getParameter("phone");
     String city = request.getParameter("city");
     String email = request.getParameter("email");
     String passeword = request.getParameter("password");
 	String query="SELECT email From client WHERE email=? ";

     String url="jdbc:mysql://localhost:3306/store";
 	String user="root";
 	String password="";
	if(request.getParameter("email")!=null) {		

 	try {
 		Class.forName("com.mysql.cj.jdbc.Driver");
 		Connection conn=DriverManager.getConnection(url,user,password);
		if(!email.equalsIgnoreCase(query)) {
 		PreparedStatement stmt = conn.prepareStatement("INSERT INTO client (name, lastname, adresse, phone, city,email,passeword) VALUES (?, ?, ?, ?,?,?,?)");
         stmt.setString(1, name);
         stmt.setString(2, lastname);
         stmt.setString(3, adresse);
         stmt.setString(4, phone);
         stmt.setString(5, city); 
         stmt.setString(6, email); 
         stmt.setString(7, passeword); 
         stmt.execute();  
         session.setAttribute("email",email);	
         response.sendRedirect(request.getContextPath()+"/client/home.jsp");
//         response.getWriter().println("Product added successfully!");
     	stmt.close();
		conn.close();
		}else if(email.equalsIgnoreCase(query)) {
			session.setAttribute("email",email);
	         response.sendRedirect(request.getContextPath()+"/client/home.jsp");
					}
     } catch (Exception e) {
         e.printStackTrace();
         response.getWriter().println("Error creating account.");
     }
 }



	
	
	
	}
	}

