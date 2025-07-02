<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>FIR Saved</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            padding: 40px;
        }
        .container {
            max-width: 600px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: green;
        }
        p {
            font-size: 16px;
            color: #333;
        }
        a.button {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background: #007BFF;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        a.button:hover {
            background: #0056b3;
        }
        .nav-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }
        .home-link {
            text-align: center;
            margin-top: 40px;
        }
        .home-link a {
            margin-top: 20px;
        display: inline-block;
        text-decoration: none;
        color: #0066cc;
        font-weight: bold;
        }
        .home-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>FIR PDF generated and saved successfully!</h2>

    <p><b>Saved at:</b> ${requestScope.pdfFilePath}</p>

    <% 
        String pdfFile = (String) request.getAttribute("pdfFilePath");
        if (pdfFile != null) {
            String fileName = new File(pdfFile).getName();
    %>
    <div class="nav-buttons">
        <a class="button" href="downloadFIRPDF?filename=<%=fileName%>">Download FIR PDF</a>
        <a class="button" href="FIRForm.jsp">Submit Another FIR</a>
    </div>
    <% 
        } 
    %>
</div>

<!-- Centered Home Link (not a button) -->
<div class="home-link">
    <a href="userdetails.jsp">Home</a>
</div>

</body>
</html>
