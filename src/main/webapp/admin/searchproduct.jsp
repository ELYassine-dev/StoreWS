<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>  
    <%@ page session="true" %> <%-- Enables session handling --%>
     <%
        String email = (String) session.getAttribute("admin");
        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/Auth/Userlogin.jsp");
        }
    %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Store Electronic</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
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

<!-- //navbar -->


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
                <form class="d-flex search-form" action="searchclient.jsp" method="GET" onsubmit="return validateSearchSubmit(event)">
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


<!-- Alert Container -->
<div id="alertContainer">
    <div class="alert alert-warning alert-dismissible fade show custom-alert" role="alert">
        <i class="fas fa-exclamation-circle me-2"></i>
        <strong>Warning!</strong> Please enter a search term.
        <button type="button" class="btn-close" onclick="closeAlert()"></button>
    </div>
</div>

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

<div style="margin-top:30px;margin-left:30px">
<a href="admin.jsp">Return</a>
</div>
<!-- search with cards -->


<%
    String url = "jdbc:mysql://localhost:3306/store";
    String user = "root";
    String password = "";
    
    try {
        // Loading JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Establishing Connection
        Connection con = DriverManager.getConnection(url, user, password);
        String type = request.getParameter("search");
        
        if (type != null && !type.trim().isEmpty()) {
            // Executing Query to Fetch Product Data
            PreparedStatement pst = con.prepareStatement("SELECT * FROM produits WHERE type LIKE ?");
            pst.setString(1, "%" + type + "%");
            ResultSet res = pst.executeQuery();
            
            boolean hasResults = false;
            int count = 0;  // Counter to track number of cards
%>
    <div class="container" style="margin-top: 50px;">
        <div class="row mb-3">
        <% 
            // Loop through the results and display products as cards
            while (res.next()) {
                hasResults = true;
                if (count % 4 == 0 && count != 0) {
                    out.print("</div><div class='row'>");  // Start a new row after every 4 cards
                }
        %>
            <!-- Card Layout -->
            <div class="col-md-3">
                <div class="card" style="width: 100%;">
                    <img class="card-img-top" src="<%= request.getContextPath() %>/img/<%= res.getString(6) %>" alt="Card image" style="width: 100%; height: 160px;">
                    <div class="card-body">
                        <h2 class="card-title"><%= res.getString(2) %></h2>
                        <p class="card-text"><%= res.getString(4) %></p>
                        <span style="">Price : <%= res.getString(5) %> DH</span><br>

                        <!-- Edit and Delete Buttons -->
                        <a href="Edit.jsp?id=<%= res.getString(1) %>" class="btn btn-primary">Edit</a>
                        <a href="Delete.jsp?id=<%= res.getString(1) %>" class="btn btn-danger" style="margin-left: 80px">Delete</a>
                    </div>
                </div>
            </div>
        <% 
            count++; // Increment the card count
            }
            
            if (!hasResults) {
        %>
            <div class="alert alert-info text-center" role="alert">
                No products found matching your search term "<%= type %>". Please try a different search.
            </div>
        <%
            }
        %>
        </div> <!-- End of the last row -->
    </div>
<%
            // Closing Resources
            res.close();
            pst.close();
            con.close();
        }
    } catch (Exception e) {
        e.printStackTrace(); // Print detailed error for debugging
        %>
        <div class="alert alert-danger text-center" role="alert">
            An error occurred while searching. Please try again.
        </div>
        <%
    }
%>

</body>
</html>