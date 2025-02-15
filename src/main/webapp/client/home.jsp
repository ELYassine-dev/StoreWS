<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>  
    <%@ page session="true" %> <%-- Enables session handling --%>
     <%
     String email = (String) session.getAttribute("email");
        String name = (String) session.getAttribute("name");
        if (email == null) {
            response.sendRedirect("Userlogin.jsp"); // Redirect if not logged in
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
<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <div class="container-fluid">
       <a class="navbar-brand" href="home.jsp">
                <i class="fas fa-store me-2"></i>Store
            </a>
 
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="nav nav-pills nav-fill me-auto mb-2 mb-lg-0">
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="home.jsp">Home</a>
        </li>
 
        <li class="nav-item">
                        <a class="nav-link" href="historic.jsp" style="margin-left:20px">Order history</a>
        </li>
      
      </ul>
      
            <form class="d-flex" style="margin-left:150px" action="searchprod.jsp" role="search" onsubmit="return validateSearch()">
          <input class="form-control me-2 " name="search" id="search" type="search" placeholder="Search" aria-label="Search">
          <button class="btn btn-success" type="submit">Search</button>
        </form>      
             
                        <span style="margin:0 20px 0 40px">Welcome, <b><%= name %></b></span>
      <p class="nav-item" style="margin-top:15px; margin-left:20px">
                    
                        <a class="btn btn-danger" href="/StoreWS/Logoutclient">
                        <i class="fas fa-sign-out-alt me-2"></i>Sign Out
                    </a>
                </p>
       
       
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

<%
    String url = "jdbc:mysql://localhost:3306/store";
    String user = "root";
    String password = "";
    
    try {
        // Loading JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Establishing Connection
        Connection con = DriverManager.getConnection(url, user, password);
        
        // Executing Query to Fetch Product Data
        PreparedStatement pst = con.prepareStatement("SELECT * FROM produits");
        ResultSet res = pst.executeQuery();
        
        int count = 0;  // Counter to track number of cards
%>
    <div class="container" style="margin-top: 60px;">
        <div class="row mb-3">
        <% 
            // Loop through the results and display products as cards
            while (res.next()) {
                if (count % 4 == 0 && count != 0) {
                    out.print("</div><div class='row'>");  // Start a new row after every 4 cards
                }
        %>
            <!-- Card Layout -->
            <div class="col-md-3">
                <div class="card" style="width: 100%;">
					<img class="card-img-top" src="<%= request.getContextPath() %>/img/<%= res.getString(6) %>" 
					alt="Card image" style="width: 100%; height: 160px;">
				                 
                    <div class="card-body">
                        <h2 class="card-title"><%= res.getString(2) %></h2>
                        <p class="card-text"><%= res.getString(4) %></p>
                        <span style="">Price : <%= res.getString(5) %> DH</span><br>

                        <!-- Edit and Delete Buttons --><!--
                        <a href="Edit.jsp" class="btn btn-prima  ry">Buy</a>-->
                        <a href="quantity.jsp?product=<%= res.getString(2) %>&price=<%= res.getString(5) %>&image=<%= res.getString(6) %>" 
                        class="btn btn-primary" style="margin-left:150px;paddin-left:20px">Buy</a>
                        
                    </div>
                </div>
            </div>
        <% 
            count++; // Increment the card count
            } 
        %>
        </div> <!-- End of the last row -->
    </div>
<%
        // Closing Resources
        res.close();
        pst.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace(); // Print detailed error for debugging
    }
%>


</body>
</html>