<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, Reg.ViewAllFIRServlet.FIR" %>
<%@ page import="java.util.Base64" %>
<!DOCTYPE html>
<html>
<head>
    <title>FIR Records (Search & Filter)</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        input, select { padding: 6px; margin: 10px 5px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        th { background-color: #f0f0f0; }
        button { padding: 6px 10px; margin: 2px; cursor: pointer; }
        iframe { width: 100%; height: 600px; display: none; border: 1px solid #999; margin-top: 20px; }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
</head>
<body>

<h2>FIR Record Management</h2>

<!-- 🔍 Filter Inputs -->
<label>Crime Type:
    <select id="filterCrime" onchange="filterTable()">
        <option value="">All</option>
        <option value="Murder">Murder</option>
        <option value="Theft">Theft</option>
        <option value="Fraud">Fraud</option>
        <option value="Kidnapping">Kidnapping</option>
    </select>
</label>

<label>Name:
    <input type="text" id="filterName" onkeyup="filterTable()" placeholder="Enter name...">
</label>

<label>Date:
    <input type="date" id="filterDate" onchange="filterTable()">
</label>

<table id="firTable">
    <thead>
        <tr>
            <th>FIR ID</th>
            <th>Name</th>
            <th>Crime Type</th>
            <th>IPC Section</th>
            <th>Date</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
    <%
        List<FIR> firList = (List<FIR>) request.getAttribute("firList");
        if (firList != null) {
            for (FIR fir : firList) {
                String base64Image = Base64.getEncoder().encodeToString(fir.photo);
                String safeDescription = fir.description.replace("'", "\\'").replace("\n", " ");
                String safeIPC = fir.ipcSection.replace("'", "\\'");
    %>
        <tr>
            <td><%= fir.id %></td>
            <td><%= fir.name %></td>
            <td><%= fir.crimeType %></td>
            <td><%= fir.ipcSection %></td>
            <td><%= fir.timestamp.toString().substring(0, 10) %></td>
            <td>
                <button onclick="viewFIR(
                    '<%= fir.name %>', '<%= fir.crimeType %>', '<%= safeIPC %>',
                    '<%= safeDescription %>', 'data:image/jpeg;base64,<%= base64Image %>'
                )">View</button>

                <button onclick="downloadFIR(
                    '<%= fir.name %>', '<%= fir.crimeType %>', '<%= safeIPC %>',
                    '<%= safeDescription %>', 'data:image/jpeg;base64,<%= base64Image %>'
                )">Download</button>

                <a href="EditFIRServlet?id=<%= fir.id %>">
                    <button>Edit</button>
                </a>

                <form action="DeleteFIRServlet" method="post" style="display:inline;">
                    <input type="hidden" name="id" value="<%= fir.id %>">
                    <button type="submit" onclick="return confirm('Delete FIR ID <%= fir.id %>?')">Delete</button>
                </form>
            </td>
        </tr>
    <%
            }
        }
    %>
    </tbody>
</table>

<iframe id="pdfPreview"></iframe>

<!-- 🔧 JavaScript -->
<script>
    const { jsPDF } = window.jspdf;

    function generateFIRPDF(name, crimeType, ipcSection, description, imageData) {
        const doc = new jsPDF();
        doc.setFontSize(14);
        doc.text("First Information Report (FIR)", 70, 15);

        doc.setFontSize(12);
        let y = 30;

        doc.text("Name: " + name, 20, y); y += 10;
        doc.text("Crime Type: " + crimeType, 20, y); y += 10;
        doc.text("IPC Section: " + ipcSection, 20, y); y += 10;
        doc.text("Description:", 20, y); y += 10;

        const lines = doc.splitTextToSize(description, 160);
        doc.text(lines, 20, y); y += lines.length * 10;

        doc.text("Photo Evidence:", 20, y); y += 5;
        doc.addImage(imageData, 'JPEG', 20, y, 100, 70);
        return doc;
    }

    function viewFIR(name, crimeType, ipcSection, description, imageData) {
        const doc = generateFIRPDF(name, crimeType, ipcSection, description, imageData);
        const pdfData = doc.output("bloburl");
        const iframe = document.getElementById("pdfPreview");
        iframe.style.display = "block";
        iframe.src = pdfData;
    }

    function downloadFIR(name, crimeType, ipcSection, description, imageData) {
        const doc = generateFIRPDF(name, crimeType, ipcSection, description, imageData);
        doc.save("FIR_" + name.replace(/\s/g, "_") + ".pdf");
    }

    function filterTable() {
        const crimeFilter = document.getElementById("filterCrime").value.toLowerCase();
        const nameFilter = document.getElementById("filterName").value.toLowerCase();
        const dateFilter = document.getElementById("filterDate").value;

        const rows = document.getElementById("firTable").getElementsByTagName("tbody")[0].getElementsByTagName("tr");

        for (let i = 0; i < rows.length; i++) {
            const cells = rows[i].getElementsByTagName("td");
            const name = cells[1].innerText.toLowerCase();
            const crime = cells[2].innerText.toLowerCase();
            const date = cells[4].innerText;

            const matchesCrime = !crimeFilter || crime.includes(crimeFilter);
            const matchesName = !nameFilter || name.includes(nameFilter);
            const matchesDate = !dateFilter || date === dateFilter;

            rows[i].style.display = (matchesCrime && matchesName && matchesDate) ? "" : "none";
        }
    }
</script>

</body>
</html>
