<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Submit Complaint</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 30px;
      background: url('background_images/image3.jpg') no-repeat center center fixed;
      background-size: cover;
    }
    h1 {
      text-align: center;
      color: #333;
      margin-bottom: 30px;
    }
    .form-container {
      background-color: #fff;
      max-width: 600px;
      margin: 90px auto 0;
      padding: 35px 30px;
      border-radius: 10px;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
    label {
      margin-top: 15px;
      display: block;
      font-weight: bold;
      color: #333;
    }
    input, select, textarea, button {
      width: 100%;
      padding: 10px;
      margin-top: 5px;
      border: 1px solid #ccc;
      border-radius: 5px;
      font-size: 16px;
      box-sizing: border-box;
    }
    textarea {
      resize: vertical;
    }
    button {
      background-color: #007BFF;
      color: white;
      font-weight: bold;
      border: none;
      cursor: pointer;
      margin-top: 20px;
    }
    button:hover {
      background-color: #0056b3;
    }
    .link-container {
      text-align: center;
      margin-top: 20px;
    }
    .link-container a {
      text-decoration: none;
      color: #007BFF;
      font-weight: bold;
    }
    .link-container a:hover {
      text-decoration: underline;
    }
    #successMessage {
      color: green;
      text-align: center;
      font-weight: bold;
      margin-bottom: 15px;
    }
    #ackMessage {
      text-align: center;
      font-size: 18px;
      font-weight: bold;
      color: #000;
      margin-bottom: 10px;
    }
    #otherTypeContainer {
      display: none;
      margin-top: 10px;
    }
  </style>
</head>
<body>

<div class="form-container">
  <h1>Submit Your Complaint</h1>

  <!-- Show acknowledgment number if present -->
  <% 
    String success = request.getParameter("success");
    String ack = request.getParameter("ack");
    if ("true".equals(success) && ack != null) {
  %>
    <p id="successMessage">✅ Complaint submitted successfully!</p>
    <p id="ackMessage">Your Acknowledgement Number is: <span style="color:darkblue;"><%= ack %></span></p>
  <% } %>

  <form id="complaintForm" action="SubmitComplaintServlet" method="post">
    <label for="name">Your Name:</label>
    <input type="text" id="name" name="name" required>

    <label for="email">Email Address:</label>
    <input type="email" id="email" name="email" required>

    <label for="phone">Phone Number:</label>
    <input type="tel" id="phone" name="phone" pattern="[0-9]{10}" placeholder="10-digit number" required>

    <label for="date">Date of Incident:</label>
    <input type="date" id="date" name="date" required>

   <label for="type">Complaint Type:</label>
<select id="type" name="type" required>
    <option value="">-- Select Type --</option>

    <!-- Personal Crimes -->
    <option value="Theft">Theft</option>
    <option value="Burglary">Burglary</option>
    <option value="Robbery">Robbery</option>
    <option value="Assault">Assault</option>
    <option value="Harassment">Harassment</option>
    <option value="Domestic Violence">Domestic Violence</option>
    <option value="Kidnapping">Kidnapping</option>
    <option value="Murder">Murder</option>
    <option value="Sexual Assault">Sexual Assault</option>
    <option value="Stalking">Stalking</option>

    <!-- Property Crimes -->
    <option value="Vehicle Theft">Vehicle Theft</option>
    <option value="Property Damage">Property Damage</option>
    <option value="Trespassing">Trespassing</option>
    <option value="Arson">Arson</option>

    <!-- Financial & Cyber Crimes -->
    <option value="Fraud">Fraud</option>
    <option value="Online Scam">Online Scam</option>
    <option value="Cyber Bullying">Cyber Bullying</option>
    <option value="Hacking">Hacking</option>
    <option value="ATM Theft">ATM Theft</option>

    <!-- Social Issues -->
    <option value="Child Abuse">Child Abuse</option>
    <option value="Human Trafficking">Human Trafficking</option>
    <option value="Drug Abuse">Drug Abuse</option>
    <option value="Missing">Missing Person</option>

    <!-- Government / Civic Issues -->
    <option value="Police Misconduct">Police Misconduct</option>
    <option value="Public Disturbance">Public Disturbance</option>
    <option value="Corruption">Corruption</option>
    <option value="Illegal Construction">Illegal Construction</option>

    <!-- Others -->
    <option value="Other">Other</option>
</select>


    <div id="otherTypeContainer">
      <label for="otherType">Please specify:</label>
      <input type="text" id="otherType" placeholder="Enter custom complaint type">
    </div>

    <label for="complaint">Complaint Details:</label>
    <textarea id="complaint" name="complaint" rows="4" required placeholder="Describe your complaint here..."></textarea>

    <button type="submit">Submit Complaint</button>
  </form>

  <div class="link-container">
    <a href="PublicHomepage.jsp">Home</a>
  </div>
</div>

<script>
  const typeSelect = document.getElementById('type');
  const otherTypeInput = document.getElementById('otherType');
  const otherTypeContainer = document.getElementById('otherTypeContainer');

  typeSelect.addEventListener('change', () => {
    if (typeSelect.value === 'Other') {
      otherTypeContainer.style.display = 'block';
      otherTypeInput.setAttribute("name", "type");
    } else {
      otherTypeContainer.style.display = 'none';
      otherTypeInput.removeAttribute("name");
    }
  });

  document.getElementById("complaintForm").addEventListener("submit", function(event) {
    const confirmSubmit = confirm("Are you sure all details are correct?\nYou won't be able to edit after submission.");
    if (!confirmSubmit) {
      event.preventDefault();
    }
  });

  const successMessage = document.getElementById('successMessage');
  if (successMessage) {
    setTimeout(() => {
      successMessage.style.display = 'none';
    }, 4000);
  }
</script>

</body>
</html>
