<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Track Your Complaint</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background: url('background_images/image14.jpg') no-repeat center center fixed;
      background-size: cover;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
    }

    .track-container {
      background: rgba(255, 255, 255, 0.95);
      padding: 30px 40px;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.2);
      text-align: center;
      width: 400px;
    }

    h2 {
      margin-bottom: 20px;
      color: #333;
    }

    input[type="text"] {
      width: 90%;
      padding: 10px;
      font-size: 16px;
      margin-bottom: 20px;
      border-radius: 5px;
      border: 1px solid #ccc;
    }

    input[type="submit"] {
      background-color: #007bff;
      color: white;
      border: none;
      padding: 10px 20px;
      font-size: 16px;
      border-radius: 5px;
      cursor: pointer;
    }

    input[type="submit"]:hover {
      background-color: #0056b3;
    }
  </style>
</head>
<body>

  <div class="track-container">
    <h2>Track Your Complaint</h2>
    <form method="get" action="View.jsp">
      <input type="text" name="ackNumber" placeholder="Enter Acknowledgement Number" required />
      <br/>
      <input type="submit" value="Track Status" />
    </form>
  </div>

</body>
</html>
