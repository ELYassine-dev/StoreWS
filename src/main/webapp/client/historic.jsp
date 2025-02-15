<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Vérification de la session
    Integer clientId = (Integer) session.getAttribute("id");
String clientEmail = (String) session.getAttribute("email");
String name = (String) session.getAttribute("name");
    
    if (clientId == null || clientEmail == null) {
        response.sendRedirect("Auth/Userlogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Historique des commandes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .total-row {
            font-weight: bold;
            background-color: #f9f9f9;
        }
        #alertContainer {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 1050;
            display: none;
            min-width: 300px;
        }
        .custom-alert {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            border: none;
            border-left: 4px solid #ffc107;
        }
    </style>
</head>
<body>

    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container-fluid">
         <a class="navbar-brand" href="home.jsp">
                <i class="fas fa-store me-2"></i>Store
            </a>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="nav nav-pills nav-fill me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link" aria-current="page" href="home.jsp">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="historic.jsp" style="margin-left:20px">Order history</a>
                    </li>
                </ul>

                <form class="d-flex" style="margin-left:200px" action="searchprod.jsp" role="search" onsubmit="return validateSearch()">
                    <input class="form-control me-2" name="search" id="search" type="search" placeholder="Search" aria-label="Search">
                    <button class="btn btn-success" type="submit">Search</button>
                </form>
                        <span style="margin:0 20px 0 40px">Welcome, <b><%= name %></b></span>
                

                <p class="nav-item" style="margin-top:15px; margin-left:20px">
                          <a class="btn btn-danger" href="/StoreWS/Logoutclient">
                        <i class="fas fa-sign-out-alt me-2"></i>Sign Out
                    </a>
                </p>
            </div>
        </div>
    </nav>

    <!-- Alert Container -->
    <div id="alertContainer">
        <div class="alert alert-warning alert-dismissible fade show custom-alert" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>
            <strong>Warning!</strong> Please enter a search term.
            <button type="button" class="btn-close" onclick="closeAlert()"></button>
        </div>
    </div>

    <div class="container mt-4">
        <h2 class="text-center mb-4">Order history</h2>
        
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            double totalGlobal = 0;
            int index = 1;
            
            try {
                String url = "jdbc:mysql://localhost:3306/store";
                String user = "root";
                String password = "";
                
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(url, user, password);
                
                String sql = "SELECT product, quantity, price, totalPrice FROM facture WHERE idClient = ? ORDER BY id DESC";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, clientId);
                rs = pstmt.executeQuery();
        %>
                <div class="table-responsive">
                    <table class="table table-striped table-bordered">
                        <thead class="table-light">
                            <tr>
                                <th>Index</th>
                                <th>Product</th>
                                <th>Quantity</th>
                                <th>Unit price (DH)</th>
                                <th>Total (DH)</th>
                            </tr>
                        </thead>
                        <tbody>
        <%
                while(rs.next()) {
                    String product = rs.getString("product");
                    int quantity = rs.getInt("quantity");
                    double price = rs.getDouble("price");
                    double totalPrice = rs.getDouble("totalPrice");
                    totalGlobal += totalPrice;
        %>
                            <tr>
                                <td><%= index++ %></td>
                                <td><%= product %></td>
                                <td><%= quantity %></td>
                                <td><%= price %></td>
                                <td><%= totalPrice %></td>
                            </tr>
        <%
                }
                if (index == 1) { // Aucune commande trouvée
        %>
                            <tr>
                                <td colspan="5" class="text-center">Aucune commande trouvée</td>
                            </tr>
        <%
                } else {
        %>
                            <tr class="table-info">
                                <td colspan="4" style="text-align: left;"><strong>Total Purchase Amount:</strong></td>
                                <td><strong><%= totalGlobal %> DH</strong></td>
                            </tr>
        <%
                }
        %>
                        </tbody>
                    </table>
                </div>
        <%
            } catch(Exception e) {
                out.println("<div class='alert alert-danger'>Erreur: " + e.getMessage() + "</div>");
            } finally {
                try {
                    if(rs != null) rs.close();
                    if(pstmt != null) pstmt.close();
                    if(conn != null) conn.close();
                } catch(SQLException e) {
                    out.println("<div class='alert alert-danger'>Erreur lors de la fermeture des ressources: " + e.getMessage() + "</div>");
                }
            }
        %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script>
        function validateSearch() {
            var searchTerm = document.getElementById('search').value.trim();
            if (searchTerm === '') {
                showAlert();
                return false;
            }
            return true;
        }

        function showAlert() {
            var alertContainer = document.getElementById('alertContainer');
            alertContainer.style.display = 'block';
            alertContainer.querySelector('.alert').classList.add('show');
            // Auto-hide after 3 seconds
            setTimeout(function() {
                closeAlert();
            }, 3000);
        }

        function closeAlert() {
            var alertContainer = document.getElementById('alertContainer');
            var alert = alertContainer.querySelector('.alert');
            alert.classList.remove('show');
            setTimeout(function() {
                alertContainer.style.display = 'none';
            }, 150);
        }
    </script>
</body>
</html>