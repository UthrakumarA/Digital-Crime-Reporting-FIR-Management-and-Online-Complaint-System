<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<%
    String yourName = (String) session.getAttribute("name");
    String yourEmail = (String) session.getAttribute("email");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Police Chat System</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #eaeaea; }
        .container { display: flex; height: 100vh; }
        .sidebar {
            width: 260px; background-color: #1d1f2f; color: #fff; padding: 20px; overflow-y: auto;
            border-right: 2px solid #333;
        }
        .sidebar h3 { font-size: 20px; margin-bottom: 5px; }
        .sidebar p { font-size: 13px; color: #ccc; margin-bottom: 20px; }
        .sidebar hr { border: 0.5px solid #555; margin: 15px 0; }
        .sidebar h4 { font-size: 16px; margin-bottom: 10px; color: #b0b3c2; }
        .officer {
            padding: 8px; margin-bottom: 10px; background-color: #2e3045; border-radius: 5px;
            cursor: pointer; transition: background 0.2s, color 0.2s;
        }
        .officer:hover { background-color: #4a4d67; color: #fff; }
        .chat-area { flex-grow: 1; display: flex; flex-direction: column; }
        .chat-header {
            background-color: #343549; color: #fff; padding: 15px 20px;
            font-size: 18px; font-weight: bold; border-bottom: 2px solid #2e2f3f;
        }
        
        .chat-header {
    position: relative; /* Required for absolute positioning of child elements */
    background-color: #343549;
    color: #fff;
    padding: 15px 20px;
    font-size: 18px;
    font-weight: bold;
    border-bottom: 2px solid #2e2f3f;
}

.chat-header .home-link {
    position: absolute;
    right: 20px;  /* Move to the right side */
    top: 50%;     /* Center vertically */
    transform: translateY(-50%); /* Perfect vertical centering */
    
    color: #ffffff;
    text-decoration: none;
    font-size: 14px;
    background-color: #007bff;
    padding: 5px 5px;
    border-radius: 5px;
}

.chat-header .home-link:hover {
    background-color: #0056b3;
    text-decoration: underline;
}

        .chat-body {
            flex-grow: 1; padding: 20px; background: 
        linear-gradient(rgba(255, 255, 255, 0.6), rgba(255, 255, 255, 0.6)),
        url('background_images/image15.png') no-repeat center center;
    background-size: cover;background-size: 1000px auto;
    background-blend-mode: lighten; overflow-y: auto;
            display: flex; flex-direction: column;
        }
        .chat-footer {
            display: flex; padding: 15px; background-color: #ddd; border-top: 2px solid #bbb;
        }
        .chat-footer input[type="text"] {
            flex-grow: 1; padding: 12px; border: 1px solid #ccc;
            border-radius: 6px; font-size: 14px;
        }
        .chat-footer button {
            background-color: #007bff; color: white; border: none;
            padding: 12px 20px; margin-left: 10px;
            border-radius: 6px; font-size: 14px; cursor: pointer;
        }
        .chat-footer button:hover { background-color: #0056b3; }
        .message {
            margin-bottom: 10px; max-width: 60%; padding: 10px;
            border-radius: 10px; font-size: 14px; line-height: 1.4;
        }
        .sent { background-color: #dcf8c6; align-self: flex-end; }
        .received { background-color: 	#e0e0e0; align-self: flex-start; }
    </style>
</head>
<body>
<div class="container">
    <!-- Sidebar -->
    <div class="sidebar">
        <h3><%= yourName %></h3>
        <p><b>You:</b><br><%= yourEmail %></p>
        <hr>
        <h4>Officers</h4>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/crimenew", "root", "Vishnu$20");
                PreparedStatement ps = con.prepareStatement("SELECT name, email FROM police WHERE email != ?");
                ps.setString(1, yourEmail);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    String officerName = rs.getString("name");
                    String officerEmail = rs.getString("email");
        %>
        <div class="officer" onclick="startChat('<%= officerEmail %>', '<%= officerName %>')">
            <%= officerName %><br><small>(<%= officerEmail %>)</small>
        </div>
        <%
                }
                con.close();
            } catch (Exception e) {
                out.println("Error loading officers: " + e.getMessage());
            }
        %>
    </div>

    <!-- Chat Area -->
    <div class="chat-area">
        <div class="chat-header">
            Chat with: <span id="chatWith">Select an officer</span>
            <div class="chat-header">
    <a href="userdetails.jsp" class="home-link">Home</a>
</div>

        </div>
        <div id="chatMessages" class="chat-body">
            <!-- Messages will be dynamically loaded -->
        </div>
        <div class="chat-footer">
            <input type="file" id="fileInput" />
            <input type="text" id="messageInput" placeholder="Type your message..." />
            <button onclick="sendMessage()">Send</button>
        </div>
    </div>
</div>

<script>
    let currentReceiver = null;
    let currentReceiverName = null;

    function startChat(email, name) {
        currentReceiver = email;
        currentReceiverName = name;
        document.getElementById("chatWith").innerText = name;
        loadMessages();
    }

    function loadMessages() {
        if (!currentReceiver) return;
        fetch("LoadMessagesServlet?receiver_email=" + encodeURIComponent(currentReceiver))
            .then(response => response.text())
            .then(data => {
                document.getElementById("chatMessages").innerHTML = data;
                document.getElementById("chatMessages").scrollTop = document.getElementById("chatMessages").scrollHeight;
            });
    }

    function sendMessage() {
        const message = document.getElementById("messageInput").value.trim();
        const fileInput = document.getElementById("fileInput");
        const file = fileInput.files[0];

        if (!message && !file) {
            alert("Please enter a message or select a file.");
            return;
        }

        let formData = new FormData();
        formData.append("receiver_email", currentReceiver);
        formData.append("message", message);
        if (file) {
            formData.append("file", file);
        }

        fetch("SendMessageServlet", {
            method: "POST",
            body: formData
        }).then(() => {
            document.getElementById("messageInput").value = "";
            fileInput.value = "";
            loadMessages();
        });
    }

    setInterval(loadMessages, 5000); // Auto-refresh messages
</script>
</body>
</html>
