package Reg;

import java.io.*;
import java.nio.file.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

@WebServlet("/SendMessageServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,  // 1MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 15     // 15MB
)
public class SendMessageServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // Support Unicode

        // Get session and form parameters
        HttpSession session = request.getSession();
        String senderEmail = (String) session.getAttribute("email");
        String receiverEmail = request.getParameter("receiver_email");
        String messageText = request.getParameter("message");
        Part filePart = request.getPart("file");

        // Validate session and message
        if (senderEmail == null || receiverEmail == null || messageText == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Handle file upload
        String filePath = null;
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // Ensure upload directory exists
            String uploadDir = getServletContext().getRealPath("/") + "uploads";  // Path to the uploads folder in the web app
            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();  // Create directory if it doesn't exist
            }

            // Save file to upload directory
            File uploadedFile = new File(uploadDir, fileName);
            try (InputStream fileContent = filePart.getInputStream()) {
                Files.copy(fileContent, uploadedFile.toPath(), StandardCopyOption.REPLACE_EXISTING);  // Save file to disk
            }

            // Save relative path to database (the file path relative to your web root)
            filePath = "uploads/" + fileName;
        }

        // Save message in database
        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/crimenew", "root", "Vishnu$20")) {
            String query = "INSERT INTO chat_messages (sender_email, receiver_email, message, file_path, timestamp) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(query)) {
                ps.setString(1, senderEmail);
                ps.setString(2, receiverEmail);
                ps.setString(3, messageText);
                ps.setString(4, filePath); // null if no file
                ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Database error: " + e.getMessage());
            return;
        }

        // Redirect back to the chat page
        response.sendRedirect("Chat.jsp?receiver_email=" + receiverEmail);
    }
}
