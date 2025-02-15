<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Commands</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">

</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <div class="container-fluid">
    <a class="navbar-brand" href="home.jsp" style="margin-right:100px">Store</a>
 
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="home.jsp">Home</a>
        </li>
        <li class="nav-item" style="margin-left:20px">
          <a class="nav-link" href="#">Commandes</a>
        </li> 

       
        <li class="nav-item">
          <a class="nav-link " href="historic.jsp" style="margin-left:20px">History</a>
        </li>
            <form class="d-flex" style="margin-left:200px" action="searchprod.jsp" role="search">
          <input class="form-control me-2 " name="search" id="search" type="search" placeholder="Search" aria-label="Search">
          <button class="btn btn-success" type="submit">Search</button>
        </form>      
      
      </ul>
             
         
        <p class="nav-item" style="margin-top:15px">
         <button class="btn btn-success"><a class="nav-link" href="Auth/Userregister.jsp">Sing-Out</a></button> 
        </p>
       
       
  </div>

</nav>
</body>
</html>