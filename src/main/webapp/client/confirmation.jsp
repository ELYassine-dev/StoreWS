<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .confirmation-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 30px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .success-icon {
            color: #28a745;
            font-size: 4rem;
            margin-bottom: 20px;
        }
        .order-details {
            margin-top: 30px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }
        .print-button {
            background-color: #17a2b8;
            color: white;
            transition: all 0.3s ease;
        }
        .print-button:hover {
            background-color: #138496;
            transform: translateY(-2px);
        }
        .continue-shopping {
            background-color: #28a745;
            color: white;
            transition: all 0.3s ease;
        }
        .continue-shopping:hover {
            background-color: #218838;
            transform: translateY(-2px);
        }
        @media print {
            .no-print {
                display: none;
            }
            .confirmation-container {
                box-shadow: none;
                margin: 0;
            }
        }
    </style>
</head>
<body class="bg-light">
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
                        <a class="nav-link" href="historic.jsp" style="margin-left:20px">Order history</a>
                    </li>
                </ul>

                <span style="margin:0 20px 0 40px">Welcome, <b><%= session.getAttribute("name") %></b></span>
                <p class="nav-item" style="margin-top:15px; margin-left:20px">
                          <a class="btn btn-danger" href="/StoreWS/Logoutclient">
                        <i class="fas fa-sign-out-alt me-2"></i>Sign Out
                    </a>
                </p>
            </div>
        </div>
    </nav>

    <div class="confirmation-container">
        <div class="text-center">
            <i class="fas fa-check-circle success-icon"></i>
            <h2 class="mb-4">Thank you for your purchase!</h2>
            <p class="lead mb-4">Your order has been placed successfully.</p>
        </div>

        <div class="order-details">
            <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                
                try {
                    String url = "jdbc:mysql://localhost:3306/store";
                    String user = "root";
                    String password = "";
                    
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(url, user, password);
                    
                    Integer clientId = (Integer) session.getAttribute("id");
                    String sql = "SELECT * FROM facture WHERE idClient = ? ORDER BY id DESC LIMIT 1";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, clientId);
                    rs = pstmt.executeQuery();
                    
                    double total = 0;
            %>
            <h4 class="mb-4">Order Details</h4>
            <table class="table">
                <thead>
                    <tr>
                        <th>Product</th>
                        <th>Quantity</th>
                        <th>Price</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        while(rs.next()) {
                            String product = rs.getString("product");
                            int quantity = rs.getInt("quantity");
                            double price = rs.getDouble("price");
                            double totalPrice = rs.getDouble("totalPrice");
                            total += totalPrice;
                    %>
                    <tr>
                        <td><%= product %></td>
                        <td><%= quantity %></td>
                        <td><%= price %> DH</td>
                        <td><%= totalPrice %> DH</td>
                    </tr>
                    <%
                        }
                    %>
                    <tr class="table-active">
                        <td colspan="3" class="text-end"><strong>Total:</strong></td>
                        <td><strong><%= total %> DH</strong></td>
                    </tr>
                </tbody>
            </table>
            <%
                } catch(Exception e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if(rs != null) rs.close();
                        if(pstmt != null) pstmt.close();
                        if(conn != null) conn.close();
                    } catch(SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>
        </div>

        <div class="text-center mt-4">
            <button onclick="window.print()" class="btn print-button me-3 no-print">
                <i class="fas fa-print me-2"></i>Print Invoice
            </button>
            <a href="home.jsp" class="btn continue-shopping no-print">
                <i class="fas fa-shopping-cart me-2"></i>Continue Shopping
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
