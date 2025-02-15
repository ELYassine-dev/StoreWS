package api;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import models.Client;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Path("/clients")
public class ClientService {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/store";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getAllClients() {
        List<Client> clients = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM client");

            while (rs.next()) {
                Client client = new Client(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("lastname"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("adresse")
                );
                clients.add(client);
            }
            conn.close();
            return Response.ok(clients).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                         .entity("Error: " + e.getMessage())
                         .build();
        }
    }

    @GET
    @Path("/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getClient(@PathParam("id") int id) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            PreparedStatement pst = conn.prepareStatement("SELECT * FROM client WHERE id = ?");
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                Client client = new Client(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("lastname"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("adresse")
                );
                conn.close();
                return Response.ok(client).build();
            } else {
                conn.close();
                return Response.status(Response.Status.NOT_FOUND)
                             .entity("Client not found")
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
    public Response createClient(Client client) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            PreparedStatement pst = conn.prepareStatement(
                "INSERT INTO client (name, lastname, email, phone, adresse) VALUES (?, ?, ?, ?, ?)",
                
                Statement.RETURN_GENERATED_KEYS
            );
            pst.setString(1, client.getName());
            pst.setString(2, client.getLastname());
            pst.setString(3, client.getEmail());
            pst.setString(4, client.getPhone());
            pst.setString(5, client.getAdresse());

            int affectedRows = pst.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating client failed, no rows affected.");
            }

            ResultSet generatedKeys = pst.getGeneratedKeys();
            if (generatedKeys.next()) {
                client.setId(generatedKeys.getInt(1));
            }
            conn.close();
            return Response.status(Response.Status.CREATED)
                         .entity(client)
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
    public Response updateClient(@PathParam("id") int id, Client client) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            PreparedStatement pst = conn.prepareStatement(
                "UPDATE client SET name=?, lastname=?, email=?, phone=?, adresse=? WHERE id=?"
            );
            pst.setString(1, client.getName());
            pst.setString(2, client.getLastname());
            pst.setString(3, client.getEmail());
            pst.setString(4, client.getPhone());
            pst.setString(5, client.getAdresse());
            pst.setInt(6, id);

            int affectedRows = pst.executeUpdate();
            conn.close();

            if (affectedRows > 0) {
                client.setId(id);
                return Response.ok(client).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                             .entity("Client not found")
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
    public Response deleteClient(@PathParam("id") int id) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            PreparedStatement pst = conn.prepareStatement("DELETE FROM client WHERE id=?");
            pst.setInt(1, id);

            int affectedRows = pst.executeUpdate();
            conn.close();

            if (affectedRows > 0) {
                return Response.ok("Client deleted successfully").build();
            } else {
                return Response.status(Response.Status.NOT_FOUND)
                             .entity("Client not found")
                             .build();
            }
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                         .entity("Error: " + e.getMessage())
                         .build();
        }
    }
}
