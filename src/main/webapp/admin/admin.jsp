<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>  
<%@ page import="java.sql.*" %>  
    
      
    
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
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<!-- Add Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
    #alertContainer, #successContainer {
        position: fixed;
        top: 20px;
        left: 50%;
        transform: translateX(-50%);
        z-index: 1050;
        min-width: 300px;
    }
    #alertContainer {
        display: none;
    }
    .custom-alert {
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        border: none;
        border-left: 4px solid #ffc107;
    }
    .success-alert {
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        border: none;
        border-left: 4px solid #198754;
    }
    .modal-content {
        border: none;
        border-radius: 15px;
        box-shadow: 0 0 30px rgba(0,0,0,0.2);
    }
    .modal-header {
        border-radius: 15px 15px 0 0;
        border-bottom: none;
    }
    .modal-footer {
        border-top: none;
        padding: 1rem 1.5rem;
    }
    .modal-body {
        font-size: 1.1rem;
        padding: 2rem;
    }
    .btn-close-white {
        filter: brightness(0) invert(1);
    }
</style>
</head>
<body>

<!-- Success Message Container -->
<div id="successContainer">
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

<!-- ///// Nav Bar -->

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

    // Search validation - only validate when search button is clicked
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

<!-- /////// Cards Section -->
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
    <div class="container" style="margin-top: 80px;">
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
              <img class="card-img-top" src="<%= request.getContextPath() %>/img/<%= res.getString(6) %>" alt="Card image" style="width: 100%; height: 160px;">
                 
                    <div class="card-body">
                        <h2 class="card-title"><%= res.getString(2) %></h2>
                        <p class="card-text"><%= res.getString(4) %></p>
                        <span >Price :<span style="font-weight:bold;"> <%= res.getString(5) %> DH</span> </span><br>

                        <!-- Edit and Delete Buttons -->
                        
                        <a href="<%= request.getContextPath() %>/admin/update.jsp?id=<%= res.getString(1) %>" class="btn btn-primary">
                            <i class="fas fa-edit me-2"></i>Edit
                        </a>
                        <button type="button" onclick="confirmDelete(<%= res.getString(1) %>)" class="btn btn-danger" style="margin-left: 80px">
                            <i class="fas fa-trash-alt me-2"></i>Delete
                        </button>
                    </div>
                </div>
            </div>
            <%
                count++;
                }
            %>
        </div> <!-- End of the last row -->
    </div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">
                    <i class="fas fa-exclamation-triangle me-2"></i>Confirm Deletion
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <p class="mb-0">Are you sure you want to delete this product? This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-2"></i>Cancel
                </button>
                <button type="button" class="btn btn-danger" onclick="executeDelete()">
                    <i class="fas fa-trash-alt me-2"></i>Yes, Delete
                </button>
            </div>
        </div>
    </div>
</div>

<script>
let deleteModal;
let productIdToDelete;

function confirmDelete(productId) {
    productIdToDelete = productId;
    // Initialize the modal if not already done
    if (!deleteModal) {
        deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
    }
    deleteModal.show();
}

function executeDelete() {
    if (productIdToDelete) {
        // Redirect to delete URL
        window.location.href = '<%= request.getContextPath() %>/Delete?id=' + productIdToDelete + '&action=deleteproduct';
    }
}
</script>

<%
        // Closing Resources
        res.close();
        pst.close();
        con.close();
    } catch(Exception e) {
        System.out.println("ther is an error at=>"+e);
    }
%>

</body>
</html>
