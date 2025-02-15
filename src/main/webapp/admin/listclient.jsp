<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Client List - Store Electronic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            background-color: #f8f9fa;
        }
        .client-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        .page-header {
            background: linear-gradient(135deg, #0d6efd, #0dcaf0);
            color: white;
            padding: 2rem;
            margin-bottom: 2rem;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .client-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: 1.5rem;
        }
        .client-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .client-info {
            padding: 1.5rem;
        }
        .client-email {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .client-actions {
            padding: 1rem;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: flex-end;
            gap: 0.5rem;
        }
        .btn-action {
            padding: 0.5rem 1rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .table-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            padding: 1rem;
            margin-bottom: 2rem;
        }
        .table {
            margin-bottom: 0;
        }
        .table th {
            background-color: #f8f9fa;
            border-bottom: 2px solid #dee2e6;
            color: #495057;
        }
        .table td {
            vertical-align: middle;
        }
        .alert-container {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 1050;
            min-width: 300px;
        }
        .custom-alert {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            border: none;
            border-left: 4px solid #ffc107;
        }
        .success-alert {
            border-left-color: #198754;
        }
        .navbar {
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        .search-form {
            max-width: 300px;
        }
        .no-results {
            text-align: center;
            padding: 2rem;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <!-- Success Message Container -->
    <div id="successContainer" class="alert-container">
        <%
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
        %>
            <div class="alert alert-success alert-dismissible fade show success-alert" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                <%= successMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
            session.removeAttribute("successMessage");
        }
        %>
    </div>

    <!-- Alert Container -->
    <div id="alertContainer" class="alert-container" style="display: none;">
        <div class="alert alert-warning alert-dismissible fade show custom-alert" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>
            <strong>Warning!</strong> Please enter a search term.
            <button type="button" class="btn-close" onclick="closeAlert()"></button>
        </div>
    </div>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container-fluid">
            <a class="navbar-brand" href="admin.jsp">
                <i class="fas fa-store me-2"></i>Store
            </a>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="btn btn-success me-2" href="Ajouter.jsp">
                            <i class="fas fa-plus-circle me-2"></i>Add Product
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-primary" href="listclient.jsp">
                            <i class="fas fa-users me-2"></i>Clients
                        </a>
                    </li>
                </ul>
                <form class="d-flex search-form" method="GET" onsubmit="return validateSearchSubmit(event)">
                    <input class="form-control me-2" name="search" id="search" type="search" placeholder="Search clients..." aria-label="Search">
                    <button class="btn btn-outline-success" type="submit">
                        <i class="fas fa-search"></i>
                    </button>
                </form>
                <div class="ms-3 d-flex align-items-center">
                    <span class="me-3">
                        <i class="fas fa-user me-2"></i><%= session.getAttribute("admin") %>
                    </span>
                    <a class="btn btn-danger" href="/StoreWS/Logout">
                        <i class="fas fa-sign-out-alt me-2"></i>Sign Out
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <div class="client-container">
        <div class="page-header">
            <h2 class="m-0">
                <i class="fas fa-users me-2"></i>Client List
            </h2>
        </div>

        <div class="table-container">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>First Name</th>
                        <th>Last Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Address</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        String url = "jdbc:mysql://localhost:3306/store";
                        String user = "root";
                        String password = "";
                        Connection con = DriverManager.getConnection(url, user, password);
                        
                        String searchQuery = request.getParameter("search");
                        PreparedStatement pst;
                        
                        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                            // Search query
                            String sql = "SELECT * FROM client WHERE name LIKE ? OR lastname LIKE ? OR email LIKE ? OR phone LIKE ? OR adresse LIKE ?";
                            pst = con.prepareStatement(sql);
                            String searchPattern = "%" + searchQuery + "%";
                            for(int i = 1; i <= 5; i++) {
                                pst.setString(i, searchPattern);
                            }
                        } else {
                            // No search, show all clients
                            pst = con.prepareStatement("SELECT * FROM client");
                        }
                        
                        ResultSet res = pst.executeQuery();
                        boolean hasResults = false;
                        
                        while(res.next()) {
                            hasResults = true;
                    %>
                        <tr>
                            <td><%= res.getString(1) %></td>
                            <td><%= res.getString(2) %></td>
                            <td><%= res.getString(3) %></td>
                            <td><%= res.getString(4) %></td>
                            <td><%= res.getString(5) %></td>
                            <td><%= res.getString(6) %></td>
                            <td>
                                <a href="<%= request.getContextPath() %>/Delete?id=<%= res.getString(1) %>&action=deleteclient" 
                                   class="btn btn-danger btn-sm btn-action"
                                   onclick="return confirm('Are you sure you want to delete this client?')">
                                    <i class="fas fa-trash-alt"></i>
                                </a>
                            </td>
                        </tr>
                    <%
                        }
                        
                        if (!hasResults && searchQuery != null && !searchQuery.trim().isEmpty()) {
                    %>
                        <tr>
                            <td colspan="7" class="no-results">
                                <i class="fas fa-search me-2"></i>No clients found matching '<%= searchQuery %>'
                            </td>
                        </tr>
                    <%
                        }
                        
                        con.close();
                    } catch(Exception e) {
                        e.printStackTrace();
                    }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // Success message auto-hide
        document.addEventListener('DOMContentLoaded', function() {
            var successAlert = document.querySelector('#successContainer .alert');
            if (successAlert) {
                setTimeout(function() {
                    successAlert.classList.remove('show');
                    setTimeout(function() {
                        successAlert.style.display = 'none';
                    }, 150);
                }, 3000);
            }
        });

        // Search validation
        function validateSearchSubmit(event) {
            var searchTerm = document.getElementById('search').value.trim();
            if (searchTerm === '') {
                event.preventDefault();
                showAlert();
                return false;
            }
            return true;
        }

        function showAlert() {
            var alertContainer = document.getElementById('alertContainer');
            alertContainer.style.display = 'block';
            alertContainer.querySelector('.alert').classList.add('show');
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