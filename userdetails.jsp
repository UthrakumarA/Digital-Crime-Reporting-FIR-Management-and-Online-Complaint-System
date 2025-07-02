<%-- 
    Document   : userdetails
    Created on : 4 Mar, 2020, 11:35:05 AM
    Author     : Lenovo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
       
        <title>User Details</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <style>
ul {
  list-style-type: none;
  margin: 0;
  padding: 0;
  overflow: hidden;
  background-color: #333;
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
  <li><a href="userreport.jsp">Crime report</a></li>
  <li><a href="mis.jsp">Missing People</a></li>
  <li><a href="status.jsp">Complaint Status</a></li>
   <li><a href="FIRForm.jsp">FIR Reports</a><li>
   <li><a href="ViewFIR.jsp">View FIR LIST</a><li>
   <li><a href="login.jsp">Chat</a><li>
  
</ul>
        <br></br><br><br>
        
        <div>
            <center>
            <img src="background_images/image28.jpg" width="1200" height="550">
            </center>
        </div>
    </body>
</html>
