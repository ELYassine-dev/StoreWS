package api;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Invoice;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Path("/invoices")
public class InvoiceService {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/store";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getAllInvoices() {
        List<Invoice> invoices = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM facture");

            while (rs.next()) {
                Invoice invoice = new Invoice(
                    rs.getInt("id"),
                    rs.getInt("idClient"),
                    rs.getString("product"),
                    rs.getInt("quantity"),
                    rs.getDouble("price"),
                    rs.getDouble("totalPrice")
                );
                invoices.add(invoice);
            }
            conn.close();
            return Response.ok(invoices).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                         .entity("Error: " + e.getMessage())
                         .build();
        }
    }

    @GET
    @Path("/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getInvoice(@PathParam("id") int id) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            PreparedStatement pst = conn.prepareStatement("SELECT * FROM factures WHERE id = ?");
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                Invoice invoice = new Invoice(
                    rs.getInt("id"),
                    rs.getInt("idClient"),
                    rs.getString("product"),
                    rs.getInt("quantity"),
                    rs.getDouble("price"),
                    rs.getDouble("totalPrice")
                );
                conn.close();
                return Response.ok(invoice).build();
            } else {
                conn.close();
                return Response.status(Response.Status.NOT_FOUND)
                             .entity("Invoice not found")
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
    public Response createInvoice(Invoice invoice) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            PreparedStatement pst = conn.prepareStatement(
                "INSERT INTO facture (idClient, product, quantity, price,totalPrice) VALUES (?, ?, ?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS
            );
            pst.setInt(1, invoice.getClientId());
            pst.setString(2, invoice.getProduct());
            pst.setInt(3, invoice.getQuantity());
            pst.setDouble(4, invoice.getPrice());
            pst.setDouble(5, invoice.getTotalPrice());

            int affectedRows = pst.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating invoice failed, no rows affected.");
            }

            ResultSet generatedKeys = pst.getGeneratedKeys();
            if (generatedKeys.next()) {
                invoice.setId(generatedKeys.getInt(1));
            }
            conn.close();
            return Response.status(Response.Status.CREATED)
                         .entity(invoice)
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
    public Response updateInvoice(@PathParam("id") int id, Invoice invoice) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            PreparedStatement pst = conn.prepareStatement(
                "UPDATE facture SET idClient=?, product=?, quantity=?, price=?, totalPrice=? WHERE id=?"
            );
            pst.setInt(1, invoice.getClientId());
            pst.setString(2, invoice.getProduct());
            pst.setInt(3, invoice.getQuantity());
            pst.setDouble(4, invoice.getPrice());
            pst.setDouble(5, invoice.getTotalPrice());
            

            int affectedRows = pst.executeUpdate();
            conn.close();

            if (affectedRows > 0) {
                invoice.setId(id);
                return Response.ok(invoice).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                             .entity("Invoice not found")
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
    public Response deleteInvoice(@PathParam("id") int id) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            PreparedStatement pst = conn.prepareStatement("DELETE FROM facture WHERE id=?");
            pst.setInt(1, id);

            int affectedRows = pst.executeUpdate();
            conn.close();

            if (affectedRows > 0) {
                return Response.ok("Invoice deleted successfully").build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                             .entity("Invoice not found")
                             .build();
            }
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                         .entity("Error: " + e.getMessage())
                         .build();
        }
    }

    @GET
    @Path("/client/{clientId}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getInvoicesByClient(@PathParam("clientId") int clientId) {
        List<Invoice> invoices = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            PreparedStatement pst = conn.prepareStatement("SELECT * FROM facture WHERE idClient = ?");
            pst.setInt(1, clientId);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                Invoice invoice = new Invoice(
                    rs.getInt("id"),
                    rs.getInt("idClient"),
                    rs.getString("product"),
                    rs.getInt("quantity"),
                    rs.getDouble("price"),                   
                    rs.getDouble("totalPrice")
                );
                invoices.add(invoice);
            }
            conn.close();
            return Response.ok(invoices).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                         .entity("Error: " + e.getMessage())
                         .build();
        }
    }
}
