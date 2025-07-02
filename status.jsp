<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Complaint Status</title>
  <style>
    body {
      font-family: Arial, sans-serif;
     background: url('background_images/image14.jpg') no-repeat center center fixed;
            background-size: cover;
      padding: 30px;
    }

    h1 {
      text-align: center;
      color: #333;
      margin-bottom: 30px;
    }

    .complaints-container {
      background: white;
      padding: 20px;
      margin: auto;
      width: 70%;
      border-radius: 10px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }

    .complaint {
      border-bottom: 1px solid #ccc;
      padding: 15px 0;
    }

    .status {
      font-weight: bold;
      padding: 5px 10px;
      border-radius: 5px;
      display: inline-block;
    }

    .pending {
      background-color: #fdd;
      color: red;
    }

    .progress {
      background-color: #fff3cd;
      color: #856404;
    }

    .finished {
      background-color: #dfd;
      color: green;
    }

    button {
      padding: 6px 12px;
      margin-top: 10px;
      background-color: #007bff;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }

    button:hover {
      background-color: #0056b3;
    }

    hr {
      border: none;
      border-top: 1px solid #ddd;
      margin: 20px 0;
    }
     a {
        margin-top: 20px;
        display: inline-block;
        text-decoration: none;
        color: #0066cc;
        font-weight: bold;
    }

    a:hover {
        text-decoration: underline;
    }
  </style>
</head>
<body>

  <h1>Complaint Status</h1>

  <div class="complaints-container">
    <%
      try {
        Class.forName("com.mysql.cj.jdbc.Driver"); // or com.mysql.cj.jdbc.Driver for MySQL 8+
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/crimenew", "root", "Vishnu$20");

        String query = "SELECT * FROM Complaint_report";
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
          int id = rs.getInt("id"); // assuming 'id' is the primary key
          String name = rs.getString("name");
          String email = rs.getString("email");
          String phone = rs.getString("phone");
          String date = rs.getString("incident_date");
          String type = rs.getString("complaint_type");
          String complaint = rs.getString("complaint_detail");
          String status = rs.getString("status");

          String statusClass = "pending";
          if ("Progress".equalsIgnoreCase(status)) statusClass = "progress";
          else if ("Finished".equalsIgnoreCase(status)) statusClass = "finished";
    %>
      <div class="complaint">
        <p><strong>Name:</strong> <%= name %></p>
        <p><strong>Email:</strong> <%= email %></p>
        <p><strong>Phone:</strong> <%= phone %></p>
        <p><strong>Date:</strong> <%= date %></p>
        <p><strong>Type:</strong> <%= type %></p>
        <p><strong>Complaint:</strong> <%= complaint %></p>
        <p>Status: 
          <span class="status <%= statusClass %>"><%= status %></span>
        </p>

        <form method="post" action="ToggleStatusServlet">
          <input type="hidden" name="id" value="<%= id %>"/>
          <input type="hidden" name="currentStatus" value="<%= status %>"/>
          <button type="submit">Toggle Status</button>
        </form>

        <hr/>
      </div>
    <%
        }
        rs.close();
        ps.close();
        con.close();
      } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
      }
    %>
  </div>
  

</body>
</html>
