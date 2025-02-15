<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New Product - Store Electronic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            background-color: #f8f9fa;
        }
        .add-product-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
            background: white;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .page-header {
            background: linear-gradient(135deg, #0d6efd, #0dcaf0);
            color: white;
            padding: 2rem;
            margin-bottom: 2rem;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .form-label {
            font-weight: 500;
            color: #495057;
            margin-bottom: 0.5rem;
        }
        .form-control {
            border-radius: 8px;
            border: 1px solid #ced4da;
            padding: 0.75rem;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.25rem rgba(13,110,253,0.25);
        }
        .btn-submit {
            padding: 0.75rem 2rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        #imagePreview {
            max-width: 200px;
            margin-top: 1rem;
            border-radius: 8px;
            display: none;
        }
        .back-link {
            display: inline-block;
            margin-bottom: 1rem;
            color: #6c757d;
            text-decoration: none;
            transition: color 0.3s ease;
        }
        .back-link:hover {
            color: #0d6efd;
        }
    </style>
</head>
<body>
    <%@ page import="java.sql.*"%> 
    <%@ page session="true" %> <%-- Enables session handling --%>
    <%
        String email = (String) session.getAttribute("admin");
        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/Auth/Userlogin.jsp");
        }
    %>
   
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

    <div class="container">
        <div class="add-product-container">
            <a href="admin.jsp" class="back-link">
                <i class="fas fa-arrow-left me-2"></i>Back to Products
            </a>
            
            <div class="page-header">
                <h2 class="m-0">
                    <i class="fas fa-plus-circle me-2"></i>Add New Product
                </h2>
            </div>

            <%-- Display error message if any --%>
            <% 
            String errorMessage = (String) session.getAttribute("errorMessage");
            if (errorMessage != null) {
            %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <%= errorMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <%
                session.removeAttribute("errorMessage");
            }
            %>

            <form action="<%= request.getContextPath() %>/Add" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                <input type="hidden" name="action" value="create">
                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="type" class="form-label">Product Type</label>
                            <input type="text" name="type" id="type" class="form-control" required>
                            <div class="invalid-feedback">
                                Please enter a product type.
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="reference" class="form-label">Reference</label>
                            <input type="text" name="reference" id="reference" class="form-control" required>
                            <div class="invalid-feedback">
                                Please enter a reference.
                            </div>
                        </div>
                    </div>

                    <div class="col-12">
                        <div class="mb-3">
                            <label for="description" class="form-label">Description</label>
                            <textarea name="description" id="description" class="form-control" rows="4" required></textarea>
                            <div class="invalid-feedback">
                                Please enter a description.
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="price" class="form-label">Price (DH)</label>
                            <div class="input-group">
                                <input type="number" name="price" id="price" class="form-control" required step="0.01" min="0">
                                <span class="input-group-text">DH</span>
                                <div class="invalid-feedback">
                                    Please enter a valid price.
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="imgs" class="form-label">Product Image</label>
                            <input type="file" name="imgs" id="imgs" class="form-control" accept="image/*" required onchange="previewImage(this)">
                            <div class="invalid-feedback">
                                Please select an image.
                            </div>
                            <img id="imagePreview" src="#" alt="Image Preview" class="img-fluid">
                        </div>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <button type="submit" class="btn btn-primary btn-submit">
                        <i class="fas fa-save me-2"></i>Add Product
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Image preview functionality
        function previewImage(input) {
            const preview = document.getElementById('imagePreview');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                }
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.style.display = 'none';
            }
        }

        // Form validation
        (function() {
            'use strict';
            const forms = document.querySelectorAll('.needs-validation');
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>
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
    <div id="alertContainer">
        <div class="alert alert-warning alert-dismissible fade show custom-alert" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>
            <strong>Warning!</strong> Please enter a search term.
            <button type="button" class="btn-close" onclick="closeAlert()"></button>
        </div>
    </div>
</body>
</html>