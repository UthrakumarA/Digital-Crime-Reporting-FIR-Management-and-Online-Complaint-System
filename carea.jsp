<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
    <title>Crime Area Information</title>
    <link rel="stylesheet" type="text/css" href="css/normalize_1.css" />
    <link rel="stylesheet" type="text/css" href="css/demo.css" />
    <link rel="stylesheet" type="text/css" href="css/component.css" />
    <style>
        body {
            text-align: center;
        }
        input[type="checkbox"] {
            width: 30px;
            height: 30px;
        }
        table {
            margin: 0 auto;
        }
        th, td {
            padding: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>Crime Area Information</h1>
        </header>
        <div class="component">
            <table border="1">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Place</th>
                        <th>District</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/crimenew", "root", "Vishnu$20");
                            Statement st = con.createStatement();
                            String query = "SELECT * FROM crime";
                            ResultSet rs1 = st.executeQuery(query);
                            while (rs1.next()) {
                    %>
                    <tr>
                        <td><%= rs1.getString("name") %></td>
                        <td><%= rs1.getString("place") %></td>
                        <td><%= rs1.getString("dist") %></td>
                    </tr>
                    <%
                            }
                            rs1.close();
                            st.close();
                            con.close();
                        } catch(Exception e) {
                            out.println("Error: " + e.getMessage());
                        }
                    %>
                </tbody>
            </table>
            <br>
            <a href="index.jsp">HOME</a>  
        </div>
    </div>

    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
    <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery-throttle-debounce/1.1/jquery.ba-throttle-debounce.min.js"></script>
    <script src="js/jquery.stickyheader.js"></script>
</body>
</html> 