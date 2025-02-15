package client;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/client/SaveFactureServlet")
public class SaveFactureServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer clientId = (Integer) session.getAttribute("id");
        HashMap<String, Object[]> cart = (HashMap<String, Object[]>) session.getAttribute("cart");
        
        if (clientId != null && cart != null && !cart.isEmpty()) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            
            try {
                // Établir la connexion à la base de données
                String url = "jdbc:mysql://localhost:3306/store";
                String user = "root";
                String password = "";
                
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(url, user, password);
                
                // Préparer la requête SQL pour insérer une facture
                String sql = "INSERT INTO facture (idClient, product, quantity, price, totalPrice) VALUES (?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                
                // Pour chaque produit dans le panier
                for (String product : cart.keySet()) {
                    Object[] details = cart.get(product);
                    int quantity = (int) details[0];
                    double price = ((Integer) details[1]).doubleValue();
                    double totalPrice = price * quantity;
                    
                    pstmt.setInt(1, clientId);
                    pstmt.setString(2, product);
                    pstmt.setInt(3, quantity);
                    pstmt.setDouble(4, price);
                    pstmt.setDouble(5, totalPrice);
                    
                    pstmt.executeUpdate();
                }
                
                // Vider le panier après la commande
                session.removeAttribute("cart");
                
                // Rediriger vers une page de confirmation
                response.sendRedirect(request.getContextPath() + "/client/confirmation.jsp");
                
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("Error saving facture: " + e.getMessage());
            } finally {
                try {
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/client/cart.jsp");
        }
    }
}
