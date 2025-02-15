<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>
     <%@ include file="userLayout.jsp" %>
    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>find</title>
</head>
<body>


<center>
<div>
<table style="margin-top:100px" class="table">

<tr>
<th>Titre</th>
<th>Auteur</th>
<th>Status</th>
<th>Description</th>
<th>Image</th>
<th>Borrow a book</th>
</tr>
<%

String url="jdbc:mysql://localhost:3306/Bibliothèque";
String user="root";
String password="";
String search=request.getParameter("search");
try{
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection con=DriverManager.getConnection(url,user,password);
	PreparedStatement pst = con.prepareStatement("SELECT * FROM livres where titre=? or auteur=?");
	pst.setString(1, search);
	pst.setString(2, search);
	
	ResultSet res=pst.executeQuery();
	while(res.next()){
%>
<tr>
	    <td><%= res.getString("titre") %></td>
	    <td><%= res.getString("auteur") %></td>
	    <td><%= res.getString("disponible")%></td>
	    <td><%= res.getString("description") %></td>  
      <td>	<img alt="upload image" class="rounded-circle" src="image/<%= res.getString("image") %>" width="130px" height="130px">

	    	    <% 
	    String book=java.net.URLEncoder.encode(res.getString("titre"),"UTF-8");
	    String other=java.net.URLEncoder.encode(res.getString("auteur"),"UTF-8");
	   String image=java.net.URLEncoder.encode(res.getString("image"),"UTF-8");
	    %>
	     <td><a href="borrowbook.jsp?titre=<%= book %>&auteur=<%= other%>&image=<%= image%> "><button class="btn btn-primary">Borrow</button></a></td>
	   	</tr>
	    	   
	    	    </tr>
	    	    
	    	    
	    	    
	    	    

<%

	}
	res.close();
	pst.close();
	con.close();
	
	}catch(Exception e){
		System.out.println(" there is an error =>"+e);
		}
	
%>






</table>

<div align="center mt-3">
<a href="home.jsp"><button class="btn btn-primary">Return</button></a>
</div>

</div>

</center>

</body>
</html>