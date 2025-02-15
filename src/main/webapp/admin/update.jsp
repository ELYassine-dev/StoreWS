<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>
   <%--  <%
    String name="";
    if(request.getSession()!=null){
    	name=request.getSession().toString();
    }else response.sendRedirect("Singin.jsp");
    
    %> --%>
     
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
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
    .update-container {
        max-width: 600px;
        margin: 2rem auto;
        padding: 2rem;
        border-radius: 15px;
        box-shadow: 0 0 20px rgba(0,0,0,0.1);
        background: white;
    }
    .form-label {
        font-weight: 500;
        color: #333;
        margin-top: 1rem;
    }
    .form-control {
        border-radius: 8px;
        border: 1px solid #ddd;
        padding: 0.75rem;
        transition: all 0.3s ease;
    }
    .form-control:focus {
        box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        border-color: #28a745;
    }
    .image-preview {
        background: #f8f9fa;
        border-radius: 8px;
        padding: 1rem;
        text-align: center;
    }
    .image-preview img {
        max-width: 200px;
        height: auto;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .btn-update {
        padding: 0.75rem 2rem;
        font-weight: 500;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-top: 1.5rem;
        transition: all 0.3s ease;
    }
    .btn-update:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(40, 167, 69, 0.2);
    }
    .return-link {
        display: inline-block;
        margin: 1rem;
        color: #6c757d;
        text-decoration: none;
        transition: color 0.3s ease;
    }
    .return-link:hover {
        color: #28a745;
    }
    .return-link i {
        margin-right: 0.5rem;
    }
    .page-title {
        color: #333;
        font-weight: 600;
        margin-bottom: 2rem;
        text-align: center;
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

<h2 class="page-title">Update Product</h2>

<div class="container">
    <a href="admin.jsp" class="return-link">
        <i class="fas fa-arrow-left"></i> Return to Admin Panel
    </a>
    
    <div class="update-container">
        <%
        int id=Integer.parseInt(request.getParameter("id"));

        String url="jdbc:mysql://localhost:3306/store";
        String user="root";
        String password="";

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con=DriverManager.getConnection(url,user,password);
            PreparedStatement pst=con.prepareStatement("SELECT type,reference,description,price,image FROM produits WHERE idpro=? ");
            pst.setInt(1, id);
            ResultSet res=pst.executeQuery();
            res.next();
        %>
        <form id="updateForm" action="${pageContext.request.contextPath}/Updatepro" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="<%= id %>" />
            
            <div class="mb-3">
                <label for="type" class="form-label">Product Type</label>
                <input type="text" name="type" id="type" required class="form-control" value="<%= res.getString(1) %>">
            </div>
            
            <div class="mb-3">
                <label for="reference" class="form-label">Reference</label>
                <input type="text" name="reference" id="reference" required class="form-control" value="<%= res.getString(2) %>">
            </div>
            
            <div class="mb-3">
                <label for="description" class="form-label">Description</label>
                <textarea name="description" id="description" required class="form-control" rows="3"><%= res.getString(3) %></textarea>
            </div>
            
            <div class="mb-3">
                <label for="price" class="form-label">Price (DH)</label>
                <div class="input-group">
                    <input type="number" name="price" id="price" required class="form-control" value="<%= res.getString(4) %>">
                    <span class="input-group-text">DH</span>
                </div>
            </div>
            
            <div class="mb-4">
                <label class="form-label">Current Image</label>
                <div class="image-preview">
                    <img src="${pageContext.request.contextPath}/img/<%= res.getString(5) %>" alt="Current Product Image" class="mb-2">
                    <div class="text-muted small">Current: <%= res.getString(5) %></div>
                </div>
            </div>
            
            <input type="hidden" name="currentImage" value="<%= res.getString(5) %>">
            
            <div class="mb-4">
                <label for="imgs" class="form-label">Upload New Image (optional)</label>
                <input type="file" name="imgs" id="imgs" class="form-control" 
                       accept="image/*" onchange="previewImage(this)">
                <div id="newImagePreview" class="mt-2 text-center" style="display: none;">
                    <img src="" alt="New Image Preview" style="max-width: 150px; height: auto;">
                </div>
            </div>

            <div class="text-center">
                <button type="button" class="btn btn-success btn-update" onclick="confirmUpdate()">
                    <i class="fas fa-save me-2"></i>Update Product
                </button>
            </div>
        </form>
        
        <!-- Custom Confirmation Modal -->
        <div class="modal fade" id="confirmUpdateModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-success text-white">
                        <h5 class="modal-title">
                            <i class="fas fa-question-circle me-2"></i>Confirm Update
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <p class="mb-0">Are you sure you want to update this product?</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>Cancel
                        </button>
                        <button type="button" class="btn btn-success" onclick="submitForm()">
                            <i class="fas fa-check me-2"></i>Yes, Update
                        </button>
                    </div>
                </div>
            </div>
        </div>

<script>
let updateModal;

function confirmUpdate() {
    // Initialize the modal if not already done
    if (!updateModal) {
        updateModal = new bootstrap.Modal(document.getElementById('confirmUpdateModal'));
    }
    updateModal.show();
}

function submitForm() {
    // Hide the modal
    updateModal.hide();
    
    // Get the form and submit it
    const form = document.getElementById('updateForm');
    if (form) {
        form.submit();
    }
}

function previewImage(input) {
    const preview = document.getElementById('newImagePreview');
    const previewImg = preview.querySelector('img');
    
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        
        reader.onload = function(e) {
            previewImg.src = e.target.result;
            preview.style.display = 'block';
        }
        
        reader.readAsDataURL(input.files[0]);
    } else {
        preview.style.display = 'none';
    }
}
</script>

        <% }catch(Exception e) {
            System.out.println("ther is an error at=>"+e);
        }
        %>
    </div>
</div>

</body>
</html>