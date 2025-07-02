<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>All FIR List</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f0f0f5;
      padding: 30px;
    }
    h1 {
      text-align: center;
      color: #333;
    }
    .search-container {
      text-align: center;
      margin-bottom: 20px;
    }
    .search-container input {
      padding: 10px;
      width: 300px;
      font-size: 16px;
      border-radius: 5px;
      border: 1px solid #ccc;
    }
    .search-container button {
      padding: 10px;
      background-color: #4CAF50;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      margin-left: 10px;
    }
    .search-container button:hover {
      background-color: #45a049;
    }
    .table-container {
      background: white;
      padding: 20px;
      width: 90%;
      margin: auto;
      border-radius: 10px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 10px;
    }
    th, td {
      padding: 12px 15px;
      text-align: left;
      border-bottom: 1px solid #ddd;
    }
    th {
      background-color: #4CAF50;
      color: white;
    }
    tr:hover {
      background-color: #f1f1f1;
    }
    .view-pdf-btn {
      background-color: #4CAF50;
      color: white;
      padding: 5px 10px;
      border: none;
      border-radius: 5px;
      text-decoration: none;
    }
    .view-pdf-btn:hover {
      background-color: #45a049;
    }
    .highlighted {
      background-color: #d0f0d0;
      font-weight: bold;
      border-radius: 3px;
      padding: 2px;
    }
  </style>

  <script>
    function clearHighlights() {
      const cells = document.querySelectorAll("#firTable td");
      cells.forEach(cell => {
        const span = cell.querySelector('.highlighted');
        if (span) {
          cell.innerHTML = cell.textContent; // reset cell
        }
      });
    }

    function highlightMatch(text, keyword) {
      const pattern = new RegExp("(" + keyword + ")", "gi");
      return text.replace(pattern, '<span class="highlighted">$1</span>');
    }

    function searchTable() {
      var input = document.getElementById("searchInput");
      var filter = input.value.toLowerCase().trim();
      var table = document.getElementById("firTable");
      var tr = table.getElementsByTagName("tr");

      clearHighlights();

      for (var i = 1; i < tr.length; i++) {
        var td = tr[i].getElementsByTagName("td");
        var matchFound = false;

        for (var j = 0; j < td.length; j++) {
          if (td[j]) {
            // Skip highlighting if this cell has an anchor tag (e.g. PDF link)
            if (!td[j].querySelector('a')) {
              var originalText = td[j].textContent || td[j].innerText;
              if (originalText.toLowerCase().includes(filter)) {
                td[j].innerHTML = highlightMatch(originalText, filter);
                matchFound = true;
              }
            } else {
              // Check for matches in link text without modifying HTML
              if (td[j].textContent.toLowerCase().includes(filter)) {
                matchFound = true;
              }
            }
          }
        }

        tr[i].style.display = matchFound ? "" : "none";
      }
    }

    var recognition;
    if ('webkitSpeechRecognition' in window) {
      recognition = new webkitSpeechRecognition();
      recognition.continuous = false;
      recognition.interimResults = false;
      recognition.lang = "en-US";

      recognition.onresult = function(event) {
        var voiceInput = event.results[0][0].transcript.trim();
        if (voiceInput.length > 0) {
          document.getElementById("searchInput").value = voiceInput;
          setTimeout(() => searchTable(), 300);
        }
      };

      recognition.onerror = function(event) {
        console.error("Speech recognition error: " + event.error);
      };
    }

    function startVoiceSearch() {
      if (recognition) recognition.start();
    }
  </script>

</head>
<body>

<h1>All FIR List</h1>

<div class="search-container">
  <input type="text" id="searchInput" onkeyup="searchTable()" placeholder="Search by Name or Crime Type...">
  <button onclick="startVoiceSearch()">🎤 Voice Search</button>
</div>

<div class="table-container">
  <table id="firTable">
    <tr>
      <th>Name</th>
      <th>Crime Type</th>
      <th>PDF File</th>
      <th>Action</th>
    </tr>
    <%
      try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/crimenew", "root", "Vishnu$20");

        String query = "SELECT name, crimeType, pdf_filename FROM fir_report_2";
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
          String name = rs.getString("name");
          String crimeType = rs.getString("crimeType");
          String pdfFilename = rs.getString("pdf_filename");
    %>
    <tr>
      <td><%= name %></td>
      <td><%= crimeType %></td>
      <td><%= pdfFilename %></td>
      <td>
        <a href="ViewFIRPDFServlet?file=<%= java.net.URLEncoder.encode(pdfFilename, "UTF-8") %>" class="view-pdf-btn" target="_blank">View PDF</a>
      </td>
    </tr>
    <%
        }
        rs.close();
        ps.close();
        con.close();
      } catch (Exception e) {
        out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
      }
    %>
  </table>
</div>

</body>
</html>