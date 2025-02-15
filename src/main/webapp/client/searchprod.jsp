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
<title>products finding</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

</head>
<body>

<!-- //navbar -->

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

<script>
function validateSearch() {
    var searchTerm = document.getElementById('search').value.trim();
    if (searchTerm === '') {
        alert('Please enter a search term');
        return false;
    }
    return true;
}
</script>

<div style="margin-top:30px;margin-left:30px">
<a href="home.jsp">Return</a>
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
                        <a href="Edit.jsp" class="btn btn-primary">Buy</a>
                        <a href="Delete.jsp" class="btn btn-warning" style="margin-left: 80px">Add</a>
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