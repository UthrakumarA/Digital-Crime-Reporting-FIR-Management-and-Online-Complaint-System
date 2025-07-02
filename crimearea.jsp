<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dangerous Area</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        
    body {
       font-family: Arial, sans-serif;
background: url('background_images/image18.avif') no-repeat left center fixed;
background-size: 600px auto; /* adjust width, auto height */
background-repeat: no-repeat;
background-color:  #B4BEC6;
background-position: left center;
background-attachment: fixed;

margin: 0;
padding: 0;
display: flex;
justify-content: flex-start; /* align content to the left */
align-items: center;
height: 100vh;
flex-direction: column;
padding-left: 350px; /* space so content doesn’t overlap image */
    }

    h1 {
        color: #333;
        margin-bottom: 90px;
    }

    form {
        background: #ffffff;
        padding: 30px 40px;
        border-radius: 15px;
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        text-align: center;
    }

    input[type="text"] {
        width: 250px;
        padding: 10px;
        margin: 10px 0;
        border: 1px solid #ccc;
        border-radius: 8px;
        font-size: 16px;
    }

    input[type="submit"] {
        background-color: #4CAF50;
        color: white;
        padding: 10px 25px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-size: 16px;
        margin-top: 15px;
    }

    input[type="submit"]:hover {
        background-color: #45a049;
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
<body align="center">
   
    
    <h1>Most Dangerous Crime Areas</h1>

    <form action="area" method="post">
        <input type="text" name="name" required placeholder="Crime name"><br><br>
        <input type="text" name="place" required placeholder="Crime place"><br><br>
        <input type="text" name="dist" required placeholder="Crime district"><br><br>
        <input type="submit" value="Submit">
    </form>

    <br>
    <a href="adminpage.jsp">Back</a>
</body>
</html>
