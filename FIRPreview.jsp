<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String firId = (String) request.getAttribute("id");
    String name = (String) request.getAttribute("name");
    String crimeType = (String) request.getAttribute("crimeType");
    String ipcSection = (String) request.getAttribute("ipcSection");
    String description = (String) request.getAttribute("description");
    String base64Image = (String) request.getAttribute("photoBase64");
    String photoType = (String) request.getAttribute("photoType");
    String officerName = (String) request.getAttribute("officerName");
    
    // Signature photo attributes
    String base64Signature = (String) request.getAttribute("signatureBase64");
    String signatureType = (String) request.getAttribute("signatureType");

    if (firId == null) firId = "";
    if (name == null) name = "";
    if (crimeType == null) crimeType = "";
    if (ipcSection == null) ipcSection = "";
    if (description == null) description = "";
    if (base64Image == null) base64Image = "";
    if (photoType == null || photoType.isEmpty()) photoType = "image/jpeg";
    if (officerName == null) officerName = "";
    if (base64Signature == null) base64Signature = "";
    if (signatureType == null || signatureType.isEmpty()) signatureType = "image/png";

    String imageFormat = photoType.toLowerCase().contains("png") ? "PNG" : "JPEG";
    String signatureFormat = signatureType.toLowerCase().contains("png") ? "PNG" : "JPEG";

    // Escape description for JS
    String descriptionForJs = description.replace("\"", "\\\"").replace("\n", " ");
%>
<!DOCTYPE html>
<html>
<head>
    <title>FIR Preview</title>
    <style>
        body {
            background-color: #f4f6f8;
            font-family: Arial, sans-serif;
            background-image: url('images.jpg');
            background-repeat: no-repeat;
            background-size: cover;
        }
        header, footer {
            background-color: #263859;
            color: white;
            text-align: center;
            padding: 20px;
        }
        .list-section {
            background: white;
            padding: 20px;
            margin: 20px auto;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            width: 80%;
        }
        #firPreview {
            background-color: #eef;
            padding: 20px;
            border-radius: 10px;
        }
        button {
            padding: 10px 18px;
            border: none;
            border-radius: 8px;
            background-color: #4CAF50;
            color: white;
            font-weight: bold;
            cursor: pointer;
            margin: 5px;
        }
        button:hover {
            background-color: #45a049;
        }
        .button-row {
            display: flex;
            justify-content: space-around;
            margin-top: 20px;
            flex-wrap: wrap;
        }
        .spinner {
            border: 5px solid #f3f3f3;
            border-top: 5px solid #4CAF50;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: auto;
            display: none;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        #progressText {
            text-align: center;
            margin-top: 10px;
            font-weight: bold;
        }
        .signature-section {
            margin-top: 20px;
        }
        .signature-section img {
            width: 300px;
            height: auto;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
</head>
<body>

<header>
    <h2>Generated FIR Preview</h2>
</header>

<div class="list-section">
    <div id="firPreview">
        <% if (!firId.isEmpty()) { %>
            <p><b>FIR ID:</b> <%= firId %></p>
        <% } %>
        <p><b>Name:</b> <%= name %></p>
        <p><b>Crime Type:</b> <%= crimeType %></p>
        <p><b>IPC Section:</b> <%= ipcSection %></p>
        <p><b>Description:</b> <%= description %></p>
    </div>

    <div id="firPreview2" style="margin-top:20px;">
        <% if (!base64Image.trim().isEmpty()) { %>
            <img src="data:<%= photoType %>;base64,<%= base64Image %>" style="width:550px; height:250px;" alt="FIR Photo" />
        <% } else { %>
            <img src="images/placeholder.jpg" alt="No photo available" style="width:550px; height:250px;" />
        <% } %>
    </div>

    <!-- Reporting Officer AFTER photo -->
    <div style="margin-top:10px;">
        <p><b>Reporting Officer:</b> <%= officerName %></p>
    </div>

    <!-- Signature photo display -->
    <div class="signature-section">
        <p><b>Officer Signature:</b></p>
        <% if (!base64Signature.trim().isEmpty()) { %>
            <img src="data:<%= signatureType %>;base64,<%= base64Signature %>" alt="Officer Signature" />
        <% } else { %>
            <p><i>No signature available</i></p>
        <% } %>
    </div>

    <div class="spinner" id="loadingSpinner"></div>
    <div id="progressText"></div>

    <div class="button-row">
        <!-- Edit Button -->
        <form id="editForm" action="FIRForm.jsp" method="post">
            <input type="hidden" name="id" value="<%= firId %>">
            <input type="hidden" name="name" value="<%= name %>">
            <input type="hidden" name="crimeType" value="<%= crimeType %>">
            <input type="hidden" name="ipcSection" value="<%= ipcSection %>">
            <input type="hidden" name="description" value="<%= description %>">
            <input type="hidden" name="photoBase64" value="<%= base64Image %>">
            <input type="hidden" name="photoType" value="<%= photoType %>">
            <input type="hidden" name="officerName" value="<%= officerName %>">
            <input type="hidden" name="signatureBase64" value="<%= base64Signature %>">
            <input type="hidden" name="signatureType" value="<%= signatureType %>">
            <button type="submit" id="editBtn">✏️ Edit</button>
        </form>

        <!-- Generate Button -->
        <button id="generatePDF">⚙️ Generate</button>

        <!-- Back Button -->
        <button id="backBtn" style="display:none;">🔙 Back</button>

        <!-- Save to Server -->
        <form id="saveForm" action="storeFIRPDF" method="post" style="display:none;">
            <input type="hidden" name="name" value="<%= name %>">
            <input type="hidden" name="crimeType" value="<%= crimeType %>">
            <input type="hidden" name="ipcSection" value="<%= ipcSection %>">
            <input type="hidden" name="description" value="<%= description %>">
            <input type="hidden" name="photoBase64" value="<%= base64Image %>">
            <input type="hidden" name="photoType" value="<%= photoType %>">
            <input type="hidden" name="officerName" value="<%= officerName %>">
            <input type="hidden" name="signatureBase64" value="<%= base64Signature %>">
            <input type="hidden" name="signatureType" value="<%= signatureType %>">
            <button type="submit">📁 Save to Server</button>
        </form>
    </div>
</div>

<footer>
    &copy; 2025 Digital Crime Reporting System
</footer>

<script>
    const { jsPDF } = window.jspdf;

    const firName = `<%= name %>`;
    const firId = `<%= firId %>`;
    const crimeType = `<%= crimeType %>`;
    const ipcSection = `<%= ipcSection %>`;
    const description = `<%= descriptionForJs %>`;
    const imageData = "data:<%= photoType %>;base64,<%= base64Image %>";
    const imageFormat = "<%= imageFormat %>";
    const officerName = `<%= officerName %>`;

    const signatureData = "data:<%= signatureType %>;base64,<%= base64Signature %>";
    const signatureFormat = "<%= signatureFormat %>";

    const spinner = document.getElementById('loadingSpinner');
    const progressText = document.getElementById('progressText');
    const backBtn = document.getElementById('backBtn');
    const generateBtn = document.getElementById('generatePDF');
    const editBtn = document.getElementById('editBtn');
    const saveForm = document.getElementById('saveForm');

    generateBtn.addEventListener("click", () => {
        spinner.style.display = 'block';
        progressText.innerText = "Generating PDF...";

        setTimeout(() => {
            const doc = new jsPDF();
            let y = 20;

            doc.setFontSize(16);
            doc.text("First Information Report (FIR)", 20, y); y += 12;
            doc.setFontSize(12);
            doc.text("Date: " + new Date().toLocaleString(), 20, y); y += 10;

            if (firId) {
                doc.text("FIR ID: " + firId, 20, y); y += 10;
            }
            doc.text("Name: " + firName, 20, y); y += 10;
            doc.text("Crime Type: " + crimeType, 20, y); y += 10;
            doc.text("IPC Section: " + ipcSection, 20, y); y += 10;

            if (officerName) {
                doc.text("Reporting Officer: " + officerName, 20, y);
                y += 10;
            }

            doc.text("Description:", 20, y); y += 10;
            const descLines = doc.splitTextToSize(description, 160);
            doc.text(descLines, 20, y); y += descLines.length * 10;

            if (imageData && imageData.startsWith("data:image") && imageData.length > 100) {
                doc.addImage(imageData, imageFormat, 20, y + 10, 100, 70);
                y += 80;
            }

            if (signatureData && signatureData.startsWith("data:image") && signatureData.length > 100) {
                doc.text("Officer Signature:", 20, y + 10);
                doc.addImage(signatureData, signatureFormat, 20, y + 20, 100, 40);
            }

            spinner.style.display = 'none';
            progressText.innerText = "Generation Complete";

            // Hide edit & generate, show back & save
            editBtn.style.display = 'none';
            generateBtn.style.display = 'none';
            backBtn.style.display = 'inline-block';
            saveForm.style.display = 'inline-block';

            // Back button logic
            backBtn.onclick = () => {
                backBtn.style.display = 'none';
                saveForm.style.display = 'none';
                editBtn.style.display = 'inline-block';
                generateBtn.style.display = 'inline-block';
                progressText.innerText = "";
            };
        }, 1500);
    });
</script>

</body>
</html>
