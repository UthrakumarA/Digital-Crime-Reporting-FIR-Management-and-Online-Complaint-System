<%-- 
    Document   : adminpage
    Created on : 29 Feb, 2020, 1:20:42 PM
    Author     : Lenovo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <style>
body {
    font-family: Arial, sans-serif;
    background: url('background_images/image3.jpg') no-repeat center center fixed;
    background-size: cover;
    margin: 0;
}

ul {
  list-style-type: none;
  margin: 0;
  padding: 0;
  overflow: hidden;
  background: rgba(0, 0, 0, 0.6); /* semi-transparent background */
  backdrop-filter: blur(8px);    /* optional glass effect */
}

li {
  float: left;
}

li a {
  display: block;
  color: white;
  text-align: center;
  padding: 14px 16px;
  text-decoration: none;
}

li a:hover:not(.active) {
  background-color: #111;
}

.active {
  background-color: #4CAF50;
}

</style>

    </head>
    <body>
       <ul>
  <li><a class="active" href="index.jsp">Home</a></li>
  
   <li><a href="register.jsp">Police Registration</a></li>
   <li><a href="login.jsp">Chat Login</a></li>
   <li><a href="missing.jsp">Missing People</a></li>
   <li><a href="crimearea.jsp">Crime Areas</a></li>
    
           
</ul>
    </body>
</html>


