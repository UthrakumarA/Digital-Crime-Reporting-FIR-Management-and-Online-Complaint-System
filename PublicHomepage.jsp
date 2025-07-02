<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Welcome to Online Crime Reporting</title>
  <style>
    body {
      margin: 0;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: url('background_images/image25.png') no-repeat center center fixed;
           background-size: cover;
      color: #333;
    }

    header {
      background-color: #2c3e50;
      color: white;
      padding: 20px 0;
      text-align: center;
    }

    header h1 {
      margin: 0;
    }

    nav {
      text-align: center;
      background-color: #34495e;
    }

    nav a {
      display: inline-block;
      padding: 14px 20px;
      color: white;
      text-decoration: none;
      font-weight: bold;
    }

    nav a:hover {
      background-color: #1abc9c;
    }

    .container {
      max-width: 900px;
      margin: 40px auto;
      padding: 20px;
      background: white;
      backdrop-filter: blur(8px); 
      border-radius: 10px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .intro {
      text-align: center;
      margin-bottom: 30px;
    }

    .intro h2 {
      color: #2c3e50;
    }

    .features {
      display: flex;
      flex-wrap: wrap;
      justify-content: space-around;
      gap: 20px;
    }

    .feature {
      flex: 1 1 250px;
      background-color: #ecf0f1;
      padding: 20px;
      border-radius: 8px;
      text-align: center;
    }

    .feature h3 {
      color: #007BFF;
    }

    footer {
      text-align: center;
      padding: 15px;
      background-color: #2c3e50;
      color: white;
      margin-top: 40px;
    }
  </style>
</head>
<body>

  <header>
    <h1>Online Crime & Complaint Reporting System</h1>
  </header>

  <nav>
    <a href="index.jsp">Home</a>
    <a href="registerComplaint.jsp"> Complaint</a>
    <a href="trackComplaint.jsp">View Complaint Status</a>
    <a href="carea.jsp">Crime Areas</a>
    
  </nav>

  <div class="container">
    <div class="intro">
      <h2>Welcome!</h2>
      <p>This portal allows citizens to report crimes or complaints online and track their status anytime.</p>
    </div>

    <div class="features">
      <div class="feature">
        <h3>File Complaint</h3>
        <p>Easily report crimes from anywhere using our simple complaint form.</p>
      </div>
      <div class="feature">
        <h3>Track Status</h3>
        <p>Check whether your complaint is in progress, pending, or resolved.</p>
      </div>
      <div class="feature">
        <h3>Secure & Confidential</h3>
        <p>All data is handled securely with your privacy in mind.</p>
      </div>
    </div>
  </div>

  <footer>
    &copy; 2025 Online Crime Reporting System. All rights reserved.
  </footer>

</body>
</html>
