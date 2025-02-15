<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.HashMap" %>
<%
    // Vérification de la session
    String clientEmail = (String) session.getAttribute("email");
    String name = (String) session.getAttribute("name");
    


%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Shopping Cart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        .cart-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        .cart-image:hover {
            transform: scale(1.1);
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
        .product-cell {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .product-name {
            font-weight: 500;
            color: #2c3e50;
        }
        .total-row {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        .btn-checkout {
            background-color: #2ecc71;
            border: none;
            padding: 10px 30px;
            transition: all 0.3s ease;
        }
        .btn-checkout:hover {
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

                <span style="margin:0 20px 0 40px">Welcome, <b><%= name %></b></span>
                <p class="nav-item" style="margin-top:15px; margin-left:20px">
                        <a class="btn btn-danger" href="/StoreWS/Logoutclient">
                        <i class="fas fa-sign-out-alt me-2"></i>Sign Out
                    </a>
                </p>
            </div>
        </div>
    </nav>
    <div class="container mt-5">
        <h2 class="mb-4">Your Shopping Cart</h2>

        <%
            HashMap<String, Object[]> cart = (HashMap<String, Object[]>) session.getAttribute("cart");
            Integer clientId = (Integer) session.getAttribute("id");
            if (cart == null || cart.isEmpty()) {
        %>
            <div class="alert alert-info">Your cart is empty.</div>
        <%
            } else {
                double total = 0;
        %>
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
                        double price = (int)details[1];
                        String image = (String)details[2];
                        double totalPrice = price * quantity;
                        total += totalPrice;
                    %>
                        <tr>
                            <td>
                                <div class="product-cell">
                                    <img src="<%= request.getContextPath() %>/img/<%= image %>" 
                                         alt="<%= product %>" 
                                         class="cart-image">
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
                <a href="home.jsp" class="btn btn-secondary me-2">Continue Shopping</a>
                <form action="checkout.jsp" method="post" class="d-inline">
                    <input type="hidden" name="clientId" value="<%= clientId %>">
                    <button type="submit" class="btn btn-primary btn-checkout">Proceed to Checkout</button>
                </form>
            </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
