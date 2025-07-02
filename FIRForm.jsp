<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String firId = request.getParameter("id");
    String name = request.getParameter("name");
    String crimeType = request.getParameter("crimeType");
    String ipcSection = request.getParameter("ipcSection");
    String description = request.getParameter("description");
    String base64Image = request.getParameter("photoBase64");
    String officerName = request.getParameter("officerName");
    String base64Signature = request.getParameter("signatureBase64");

    if (firId == null) firId = "";
    if (name == null) name = "";
    if (crimeType == null) crimeType = "";
    if (ipcSection == null) ipcSection = "";
    if (description == null) description = "";
    if (base64Image == null) base64Image = "";
    if (officerName == null) officerName = "";
    if (base64Signature == null) base64Signature = "";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Digital Crime Reporting System</title>
    <style>
        /* Reset some default styles */
        body, h1, h2, input, select, textarea, button, label {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-image: url('background_images/image16.avif'), url('background_images/image23.jpg');
            background-position: left center, right center;
            background-repeat: no-repeat, no-repeat;
            background-size: 400px auto, 500px auto;

            color: #333;
            line-height: 1.6;
        }

        header {
            background-color: #2d3e50;
            color: #fff;
            padding: 20px 0;
            text-align: center;
        }

        .bg1 {
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 30px;
        }

        .form-section {
            background-color: #fff;
            padding: 30px 40px;
            border-radius: 15px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 500px;
        }

        h2 {
            color: #2d3e50;
            margin-bottom: 20px;
            font-size: 24px;
            text-align: center;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        input[type="text"],
        input[type="email"],
        input[type="file"],
        select,
        textarea {
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 16px;
            width: 100%;
        }

        textarea {
            height: 120px;
            resize: vertical;
        }

        label {
            font-weight: bold;
            margin-bottom: 5px;
        }

        button {
            background-color: #007bff;
            color: white;
            padding: 12px;
            font-size: 16px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        button:hover {
            background-color: #0056b3;
        }

        img {
            display: block;
            margin: 10px 0;
            border-radius: 10px;
            border: 1px solid #ccc;
        }

        #a {
            display: inline-block;
            margin-top: 20px;
            color: #007bff;
            text-decoration: none;
            font-weight: bold;
            transition: color 0.2s ease;
        }

        #a:hover {
            color: #0056b3;
        }
    </style>

    <script>
        function toggleOtherCrime() {
            var crimeType = document.getElementById('crimeType').value;
            var otherCrime = document.getElementById('otherCrime');
            if (crimeType === 'Other') {
                otherCrime.style.display = 'block';
                otherCrime.required = true;
            } else {
                otherCrime.style.display = 'none';
                otherCrime.required = false;
                otherCrime.value = '';
            }
        }

        function toggleOtherIPC() {
            var ipcSection = document.getElementById('ipcSection').value;
            var otherIPC = document.getElementById('otherIPC');
            if (ipcSection === 'Other') {
                otherIPC.style.display = 'block';
                otherIPC.required = true;
            } else {
                otherIPC.style.display = 'none';
                otherIPC.required = false;
                otherIPC.value = '';
            }
        }

        // Preview Signature Image on file select
        window.addEventListener('DOMContentLoaded', () => {
            var signatureInput = document.querySelector('input[name="signature"]');
            signatureInput.addEventListener('change', function(event) {
                const file = event.target.files[0];
                if (!file) return;
                const reader = new FileReader();
                reader.onload = function(e) {
                    let img = document.getElementById('signaturePreview');
                    if (!img) {
                        img = document.createElement('img');
                        img.id = 'signaturePreview';
                        img.style.width = '200px';
                        img.style.border = '1px solid #333';
                        img.style.borderRadius = '8px';
                        event.target.parentNode.insertBefore(img, event.target.nextSibling);
                    }
                    img.src = e.target.result;
                };
                reader.readAsDataURL(file);
            });

            // Initialize toggleOtherCrime and toggleOtherIPC on page load
            toggleOtherCrime();
            toggleOtherIPC();
        });
    </script>
</head>
<body>

<header>
    <u><h1>Digital Crime Reporting & FIR System</h1></u>
</header>

<div class="bg1" id="loginSection"><br>
    <section class="form-section">
        <u><h2><%= base64Image.isEmpty() ? "Submit FIR / Complaint:" : "Edit FIR Details:" %></h2></u>

        <form action="SaveFIRServlet" method="post" enctype="multipart/form-data">

            <%-- FIR ID (read-only if editing) --%>
            <% if (!firId.isEmpty()) { %>
                <label>FIR ID:</label>
                <input type="text" name="id" value="<%= firId %>" readonly>
            <% } %>

            <input type="text" name="name" placeholder="Your Name" value="<%= name %>" required>

           <label>Type of Crime:</label>
<select name="crimeType" id="crimeType" onchange="toggleOtherCrime()" required>
    <option value="">-- Select Crime Type --</option>
    <option value="Murder" <%= "Murder".equals(crimeType) ? "selected" : "" %>>Murder</option>
    <option value="Theft" <%= "Theft".equals(crimeType) ? "selected" : "" %>>Theft</option>
    <option value="Fraud" <%= "Fraud".equals(crimeType) ? "selected" : "" %>>Fraud</option>
    <option value="Kidnapping" <%= "Kidnapping".equals(crimeType) ? "selected" : "" %>>Kidnapping</option>
    <option value="Cyber Crime" <%= "Cyber Crime".equals(crimeType) ? "selected" : "" %>>Cyber Crime</option>
    <option value="Assault" <%= "Assault".equals(crimeType) ? "selected" : "" %>>Assault</option>
    <option value="Domestic Violence" <%= "Domestic Violence".equals(crimeType) ? "selected" : "" %>>Domestic Violence</option>
    <option value="Human Trafficking" <%= "Human Trafficking".equals(crimeType) ? "selected" : "" %>>Human Trafficking</option>
    <option value="Drugs Possession" <%= "Drugs Possession".equals(crimeType) ? "selected" : "" %>>Drugs Possession</option>
    <option value="Harassment" <%= "Harassment".equals(crimeType) ? "selected" : "" %>>Harassment</option>
    <option value="Bribery" <%= "Bribery".equals(crimeType) ? "selected" : "" %>>Bribery</option>
    <option value="Arson" <%= "Arson".equals(crimeType) ? "selected" : "" %>>Arson</option>
    <option value="Burglary" <%= "Burglary".equals(crimeType) ? "selected" : "" %>>Burglary</option>
    <option value="Extortion" <%= "Extortion".equals(crimeType) ? "selected" : "" %>>Extortion</option>
    <option value="Money Laundering" <%= "Money Laundering".equals(crimeType) ? "selected" : "" %>>Money Laundering</option>
    <option value="Illegal Arms Possession" <%= "Illegal Arms Possession".equals(crimeType) ? "selected" : "" %>>Illegal Arms Possession</option>
    <option value="Riot" <%= "Riot".equals(crimeType) ? "selected" : "" %>>Riot</option>
    <option value="Stalking" <%= "Stalking".equals(crimeType) ? "selected" : "" %>>Stalking</option>
    <option value="Terrorism" <%= "Terrorism".equals(crimeType) ? "selected" : "" %>>Terrorism</option>
    <option value="Vandalism" <%= "Vandalism".equals(crimeType) ? "selected" : "" %>>Vandalism</option>
    <option value="Trespassing" <%= "Trespassing".equals(crimeType) ? "selected" : "" %>>Trespassing</option>
    <option value="Illegal Surveillance" <%= "Illegal Surveillance".equals(crimeType) ? "selected" : "" %>>Illegal Surveillance</option>
    <option value="Blackmail" <%= "Blackmail".equals(crimeType) ? "selected" : "" %>>Blackmail</option>
    <option value="Other" <%= "Other".equals(crimeType) ? "selected" : "" %>>Other</option>
</select>

            <input type="text" name="otherCrime" id="otherCrime" placeholder="Specify other crime type" style="display:none; margin-top:10px;" value="<%= "Other".equals(crimeType) ? name : "" %>">


           <label>IPC Section:</label>
<select name="ipcSection" id="ipcSection" onchange="toggleOtherIPC()" required>
    <option value="IPC 302 - Murder" <%= "IPC 302 - Murder".equals(crimeType) ? "selected" : "" %>>IPC 302 - Murder</option>
    <option value="IPC 379 - Theft" <%= "IPC 379 - Theft".equals(crimeType) ? "selected" : "" %>>IPC 379 - Theft</option>
    <option value="IPC 420 - Fraud" <%= "IPC 420 - Fraud".equals(crimeType) ? "selected" : "" %>>IPC 420 - Fraud</option>
    <option value="IPC 363 - Kidnapping" <%= "IPC 363 - Kidnapping".equals(crimeType) ? "selected" : "" %>>IPC 363 - Kidnapping</option>
    <option value="IT Act 66 - Cyber Crime" <%= "IT Act 66 - Cyber Crime".equals(crimeType) ? "selected" : "" %>>IT Act 66 - Cyber Crime</option>
    <option value="IPC 351 - Assault" <%= "IPC 351 - Assault".equals(crimeType) ? "selected" : "" %>>IPC 351 - Assault</option>
    <option value="DV Act 2005 - Domestic Violence" <%= "DV Act 2005 - Domestic Violence".equals(crimeType) ? "selected" : "" %>>DV Act 2005 - Domestic Violence</option>
    <option value="IPC 370 - Human Trafficking" <%= "IPC 370 - Human Trafficking".equals(crimeType) ? "selected" : "" %>>IPC 370 - Human Trafficking</option>
    <option value="NDPS Act - Drugs Possession" <%= "NDPS Act - Drugs Possession".equals(crimeType) ? "selected" : "" %>>NDPS Act - Drugs Possession</option>
    <option value="IPC 354A - Harassment" <%= "IPC 354A - Harassment".equals(crimeType) ? "selected" : "" %>>IPC 354A - Harassment</option>
    <option value="IPC 171E - Bribery" <%= "IPC 171E - Bribery".equals(crimeType) ? "selected" : "" %>>IPC 171E - Bribery</option>
    <option value="IPC 435 - Arson" <%= "IPC 435 - Arson".equals(crimeType) ? "selected" : "" %>>IPC 435 - Arson</option>
    <option value="IPC 457 - Burglary" <%= "IPC 457 - Burglary".equals(crimeType) ? "selected" : "" %>>IPC 457 - Burglary</option>
    <option value="IPC 384 - Extortion" <%= "IPC 384 - Extortion".equals(crimeType) ? "selected" : "" %>>IPC 384 - Extortion</option>
    <option value="PMLA 2002 - Money Laundering" <%= "PMLA 2002 - Money Laundering".equals(crimeType) ? "selected" : "" %>>PMLA 2002 - Money Laundering</option>
    <option value="Arms Act 1959 - Illegal Arms Possession" <%= "Arms Act 1959 - Illegal Arms Possession".equals(crimeType) ? "selected" : "" %>>Arms Act 1959 - Illegal Arms Possession</option>
    <option value="IPC 147 - Riot" <%= "IPC 147 - Riot".equals(crimeType) ? "selected" : "" %>>IPC 147 - Riot</option>
    <option value="IPC 354D - Stalking" <%= "IPC 354D - Stalking".equals(crimeType) ? "selected" : "" %>>IPC 354D - Stalking</option>
    <option value="UAPA Act - Terrorism" <%= "UAPA Act - Terrorism".equals(crimeType) ? "selected" : "" %>>UAPA Act - Terrorism</option>
    <option value="IPC 427 - Vandalism" <%= "IPC 427 - Vandalism".equals(crimeType) ? "selected" : "" %>>IPC 427 - Vandalism</option>
    <option value="IPC 447 - Trespassing" <%= "IPC 447 - Trespassing".equals(crimeType) ? "selected" : "" %>>IPC 447 - Trespassing</option>
    <option value="IT Act 66E - Illegal Surveillance" <%= "IT Act 66E - Illegal Surveillance".equals(crimeType) ? "selected" : "" %>>IT Act 66E - Illegal Surveillance</option>
    <option value="IPC 503 - Blackmail" <%= "IPC 503 - Blackmail".equals(crimeType) ? "selected" : "" %>>IPC 503 - Blackmail</option>
    <option value="Other" <%= "Other".equals(crimeType) ? "selected" : "" %>>Other</option>
</select>

            <input type="text" name="otherIPC" id="otherIPC" placeholder="Specify other IPC Section" style="display:none; margin-top:10px;" value="<%= "Other".equals(ipcSection) ? ipcSection : "" %>">

            <label>Description:</label>
            <textarea name="description" placeholder="Provide detailed description" required><%= description %></textarea>

            <%-- Photo Preview and Upload --%>
            <% if (!base64Image.isEmpty()) { %>
                <label>Previously Uploaded Photo:</label><br>
                <img src="data:image/png;base64,<%= base64Image %>" style="width: 250px; border: 1px solid #333; border-radius: 8px;"><br>
                <input type="hidden" name="photoBase64" value="<%= base64Image %>">
            <% } %>
            <label><%= base64Image.isEmpty() ? "Upload Photo:" : "Upload New Photo (optional):" %></label>
            <input type="file" name="photo" accept="image/*"><br>

            <%-- Officer Name --%>
            <label>Reported Police Officer Name (optional):</label>
            <input type="text" name="officerName" value="<%= officerName %>" placeholder="Officer Name (if known)">

            <%-- Signature Preview and Upload --%>
            <% if (!base64Signature.isEmpty()) { %>
                <label>Previously Uploaded Signature:</label><br>
                <img src="data:image/png;base64,<%= base64Signature %>" style="width: 200px; border: 1px solid #333; border-radius: 8px;"><br>
                <input type="hidden" name="signatureBase64" value="<%= base64Signature %>">
            <% } %>
            <label><%= base64Signature.isEmpty() ? "Upload Signature Image:" : "Upload New Signature (optional):" %></label>
            <input type="file" name="signature" accept="image/*"><br>

            <button type="submit"><%= base64Image.isEmpty() ? "Submit FIR" : "Update FIR" %></button>
        </form>

        <a id="a" href="home.jsp">Back to Home</a>
    </section>
</div>

</body>
</html>
