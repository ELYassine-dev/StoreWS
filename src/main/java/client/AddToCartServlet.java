package client;
import java.io.IOException;
import java.util.HashMap;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AddToCartServlet", urlPatterns = {"/client/AddToCartServlet"})
public class AddToCartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String product = request.getParameter("product");
        double price = Double.parseDouble(request.getParameter("price"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String image = request.getParameter("image");

        HttpSession session = request.getSession();
        HashMap<String, Object[]> cart = (HashMap<String, Object[]>) session.getAttribute("cart");

        if (cart == null) {
            cart = new HashMap<>();
        }

        if (cart.containsKey(product)) {
            Object[] details = cart.get(product);
            details[0] = (int)details[0] + quantity; // Update quantity
        } else {
            cart.put(product, new Object[]{quantity, (int) price, image});
        }

        session.setAttribute("cart", cart);
        response.sendRedirect(request.getContextPath() + "/client/cart.jsp"); // Redirect to the cart page
    }
}
