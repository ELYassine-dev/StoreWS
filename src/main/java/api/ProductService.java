package api;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Path("/products")
public class ProductService {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/store";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getAllProducts() {
        List<Product> products = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM produits");

            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("idpro"),
                    rs.getString("type"),
                    rs.getString("reference"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getString("image")
                );
                products.add(product);
            }
            conn.close();
            return Response.ok(products).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                         .entity("Error: " + e.getMessage())
                         .build();
        }
    }

    @GET
    @Path("/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getProduct(@PathParam("id") int id) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            PreparedStatement pst = conn.prepareStatement("SELECT * FROM produits WHERE idpro = ?");
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                Product product = new Product(
                    rs.getInt("idpro"),
                    rs.getString("type"),
                    rs.getString("reference"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getString("image")
                );
                conn.close();
                return Response.ok(product).build();
            } else {
                conn.close();
                return Response.status(Response.Status.NOT_FOUND)
                             .entity("Product not found")
                             .build();
            }
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                         .entity("Error: " + e.getMessage())
                         .build();
        }
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response createProduct(Product product) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            PreparedStatement pst = conn.prepareStatement(
                "INSERT INTO produits (type, reference, description, price, image) VALUES (?, ?, ?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS
            );
            pst.setString(1, product.getType());
            pst.setString(2, product.getReference());
            pst.setString(3, product.getDescription());
            pst.setDouble(4, product.getPrice());
            pst.setString(5, product.getImage());

            int affectedRows = pst.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating product failed, no rows affected.");
            }

            ResultSet generatedKeys = pst.getGeneratedKeys();
            if (generatedKeys.next()) {
                product.setIdpro(generatedKeys.getInt(1));
            }
            conn.close();
            return Response.status(Response.Status.CREATED)
                         .entity(product)
                         .build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                         .entity("Error: " + e.getMessage())
                         .build();
        }
    }

    @PUT
    @Path("/{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response updateProduct(@PathParam("id") int id, Product product) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            PreparedStatement pst = conn.prepareStatement(
                "UPDATE produits SET type=?, reference=?, description=?, price=?, image=? WHERE idpro=?"
            );
            pst.setString(1, product.getType());
            pst.setString(2, product.getReference());
            pst.setString(3, product.getDescription());
            pst.setDouble(4, product.getPrice());
            pst.setString(5, product.getImage());
            pst.setInt(6, id);

            int affectedRows = pst.executeUpdate();
            conn.close();

            if (affectedRows > 0) {
                product.setIdpro(id);
                return Response.ok(product).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                             .entity("Product not found")
                             .build();
            }
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                         .entity("Error: " + e.getMessage())
                         .build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response deleteProduct(@PathParam("id") int id) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            PreparedStatement pst = conn.prepareStatement("DELETE FROM produits WHERE idpro=?");
            pst.setInt(1, id);

            int affectedRows = pst.executeUpdate();
            conn.close();

            if (affectedRows > 0) {
                return Response.ok("Product deleted successfully").build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                             .entity("Product not found")
                             .build();
            }
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                         .entity("Error: " + e.getMessage())
                         .build();
        }
    }
}
