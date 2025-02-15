<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Enumeration" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        .checkout-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 6px;
        }
        .product-cell {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .product-name {
            font-weight: 500;
            color: #2c3e50;
        }
        .table {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .table th {
            background-color: #f8f9fa;
            color: #2c3e50;
        }
        .total-row {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        .client-info {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }
        .btn-confirm {
            background-color: #2ecc71;
            border: none;
            padding: 10px 30px;
            transition: all 0.3s ease;
        }
        .btn-confirm:hover {
            background-color: #27ae60;
            transform: translateY(-2px);
        }
    </style>
</head>
<body class="bg-light">
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

    <div class="container mt-5">
        <h2 class="mb-4">Checkout - Invoice</h2>

        <%
            // Récupérer l'ID client
            Integer clientId = (Integer) session.getAttribute("id");
            if (clientId == null) {
                clientId = (Integer) session.getAttribute("clientId");
            }
            if (clientId == null) {
                clientId = (Integer) request.getAttribute("clientId");
            }
            if (clientId == null) {
                String clientIdParam = request.getParameter("clientId");
                if (clientIdParam != null && !clientIdParam.isEmpty()) {
                    try {
                        clientId = Integer.parseInt(clientIdParam);
                    } catch (NumberFormatException e) {
                        out.println("<div class='alert alert-danger'>Error parsing clientId parameter</div>");
                    }
                }
            }
            
            String clientName = (String) session.getAttribute("name");
            String clientEmail = (String) session.getAttribute("email");
            
            HashMap<String, Object[]> cart = (HashMap<String, Object[]>) session.getAttribute("cart");
            if (cart == null || cart.isEmpty()) {
        %>
            <div class="alert alert-info">No products in the cart.</div>
        <%
            } else {
                double total = 0;
        %>
            <div class="client-info">
                <h3>Client Information</h3>
                <p><strong>Name:</strong> <%= clientName %></p>
                <p><strong>Email:</strong> <%= clientEmail %></p>
            </div>

            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Quantity</th>
                            <th>Price per Unit</th>
                            <th>Total</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% for (String product : cart.keySet()) { 
                        Object[] details = cart.get(product);
                        int quantity = (int)details[0];
                        double price = ((Integer)details[1]).doubleValue();
                        String image = (String)details[2];
                        double totalPrice = price * quantity;
                        total += totalPrice;
                    %>
                        <tr>
                            <td>
                                <div class="product-cell">
                                    <img src="<%= request.getContextPath() %>/img/<%= image %>" 
                                         alt="<%= product %>" 
                                         class="checkout-image">
                                    <span class="product-name"><%= product %></span>
                                </div>
                            </td>
                            <td><%= quantity %></td>
                            <td><%= price %> DH</td>
                            <td><%= totalPrice %> DH</td>
                        </tr>
                    <% } %>
                        <tr class="total-row">
                            <td colspan="3" class="text-end"><strong>Total to Pay:</strong></td>
                            <td><strong><%= total %> DH</strong></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                <a href="cart.jsp" class="btn btn-secondary me-2">Back to Cart</a>
                <form action="<%= request.getContextPath() %>/client/SaveFactureServlet" method="post" class="d-inline">
                    <input type="hidden" name="clientId" value="<%= clientId %>">
                    <button type="submit" class="btn btn-primary btn-confirm">Confirm Order</button>
                </form>
            </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
