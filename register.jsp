<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Police Registration</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: url('background_images/image12.png') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .register-container {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            width: 400px;
            margin-left: 350px; /* Move slightly to the right */
        }
        input, select {
            width: 95%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        button {
            width: 100%;
            padding: 12px;
            background: #28a745;
            border: none;
            color: white;
            font-size: 16px;
            border-radius: 6px;
            cursor: pointer;
        }
        button:hover {
            background: #218838;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        .login-link {
            text-align: center;
            margin-top: 15px;
        }
        .login-link a {
            color: #007bff;
            text-decoration: none;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
        .back-link:hover {
        background-color: #007bff;;
}
    </style>
</head>
<body>
    <div class="register-container">
        <h2>Police Registration</h2>
        <form action="PoliceRegisterServlet" method="post">
            <input type="text" name="name" placeholder="Full Name" required>
            <input type="text" name="badgeNumber" placeholder="Badge Number" required>
            <select name="rank" required>
                <option value="">Select Rank</option>
                <option value="Inspector">Inspector</option>
                <option value="Sub-Inspector">Sub-Inspector</option>
                <option value="Head Constable">Head Constable</option>
                <option value="Constable">Constable</option>
            </select>
                 <label for="station">station Name:</label>
            <input type="text" name="station" placeholder="Police Station" required>
                  <label for="email">Email ID:</label>
            <input type="email" name="email" placeholder="Email Address" required>
                 <label for="phone">Phone Number:</label>
            <input type="tel" id="phone" name="phone" pattern="[0-9]{10}" placeholder="10-digit number" required>
                 <label for="password">Password:</label>
            <input type="password" name="password" placeholder="Create Password" required>
            <button type="submit">Register</button>
        </form>
        <div class="login-link">
            <p>Already registered? <a href="PoliceLogin.jsp">Login here</a></p>
             
        </div>
         <div class="login-link">
         <a href="adminpage.jsp">Back</a>
         </div>
        
    </div>
</body>
</html>
