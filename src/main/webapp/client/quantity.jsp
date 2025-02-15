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

    // Récupérer les paramètres
    String product = request.getParameter("product");
    String price = request.getParameter("price");
    String image = request.getParameter("image");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quantity Selection</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .product-image {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .image-container {
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }
        .quantity-section {
            max-width: 500px;
            margin: 0 auto;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .card {
            border: none;
            box-shadow: none;
        }
        .card-title {
            font-size: 1.5rem;
            color: #2c3e50;
            margin-bottom: 1rem;
        }
        .card-text {
            font-size: 1.2rem;
            color: #27ae60;
            font-weight: bold;
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

    <div class="container mt-4">
        <div class="row">
            <div class="col-md-6">
                <div class="image-container">
                    <img src="<%= request.getContextPath() %>/img/<%= image %>" 
                         alt="<%= product %>" 
                         class="product-image">
                </div>
            </div>
            <div class="col-md-6">
                <div class="quantity-section">
                    <h2>Select Quantity</h2>
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title"><%= product %></h5>
                            <p class="card-text">Price: <%= price %> DH</p>
                            <form action="<%= request.getContextPath() %>/client/AddToCartServlet" method="post">
                                <input type="hidden" name="product" value="<%= product %>">
                                <input type="hidden" name="price" value="<%= price %>">
                                <input type="hidden" name="image" value="<%= image %>">
                                <div class="mb-3">
                                    <label for="quantity" class="form-label">Quantity:</label>
                                    <input type="number" class="form-control" id="quantity" name="quantity" value="1" min="1" required>
                                </div>
                                <button type="submit" class="btn btn-primary">Add to Cart</button>
                                <a href="products.jsp" class="btn btn-secondary">Cancel</a>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
