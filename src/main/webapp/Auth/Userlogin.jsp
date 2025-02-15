<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    
     <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
    <% if (errorMessage != null) { %>
        <Script>alert( <%= errorMessage %>)</Script>
       </p>
    <% } %>
    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>singin</title>
<link rel="stylesheet" href="css/bootstrap.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">

</head>
<body>

  <div class="container">
    <div class="row">
      <div class="col-sm-9 col-md-7 col-lg-5 mx-auto">
        <div class="card border-0 shadow rounded-3 my-5">
          <div class="card-body p-4 p-sm-5">
            <h5 class="card-title text-center mb-5 fw-light fs-5"> Login </h5>
<form action="/StoreWS/Loginclient" method="post">

              <div class="form-floating mb-3">
                <input type="email" class="form-control" id="email" name="email" required placeholder="name@example.com">
                <label for="floatingInput">Email address</label>
              </div>
              <div class="form-floating mb-3">
                <input type="password" class="form-control" id="password" name="password" placeholder="Password">
                <label for="floatingPassword">Password</label>
              </div>

              <div class="form-check mb-3">
                <input class="form-check-input" type="checkbox" value="" id="rememberPasswordCheck">
                <label class="form-check-label" for="rememberPasswordCheck">
                  Remember password
                </label>
              </div>
              <div class="d-grid">
                <button class="btn btn-primary btn-login text-uppercase fw-bold mb-4" type="submit">Sign  in</button>
              </div>
             <div><p> Create an acount: <a href="Userregister.jsp">SingUp</a> </p>
             </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>


</body>
</html>