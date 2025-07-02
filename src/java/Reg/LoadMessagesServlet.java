package Reg;

import java.io.IOException;
import java.sql.*;
import java.io.File;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoadMessagesServlet")
public class LoadMessagesServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String receiverEmail = request.getParameter("receiver_email");
        String senderEmail = (String) request.getSession().getAttribute("email");

        response.setContentType("text/html;charset=UTF-8");

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/crimenew", "root", "Vishnu$20")) {
            String query = "SELECT sender_email, message, file_path, timestamp FROM chat_messages " +
                           "WHERE (sender_email = ? AND receiver_email = ?) OR (sender_email = ? AND receiver_email = ?) " +
                           "ORDER BY timestamp";
            try (PreparedStatement ps = con.prepareStatement(query)) {
                ps.setString(1, senderEmail);
                ps.setString(2, receiverEmail);
                ps.setString(3, receiverEmail);
                ps.setString(4, senderEmail);

                ResultSet rs = ps.executeQuery();
                StringBuilder messageHtml = new StringBuilder();

                while (rs.next()) {
                    String msgSender = rs.getString("sender_email");
                    String msgText = rs.getString("message");
                    String filePath = rs.getString("file_path");
                    Timestamp timestamp = rs.getTimestamp("timestamp");

                    String alignmentClass = msgSender.equals(senderEmail) ? "sent" : "received";

                    messageHtml.append("<div class='message ").append(alignmentClass).append("'>");

                    if (msgText != null && !msgText.trim().isEmpty()) {
                        messageHtml.append("<p>").append(escapeHtml(msgText)).append("</p>");
                    }

                    if (filePath != null && !filePath.isEmpty()) {
                        File file = new File(filePath);
                        String fileName = file.getName();

                        // Direct download link for client-side download
                        messageHtml.append("<a href='").append(filePath)
                                   .append("' download='").append(fileName)
                                   .append("'>")
                                   .append("<i class='fa fa-file'></i> ")
                                   .append(fileName)
                                   .append("</a><br>");
                    }

                    messageHtml.append("<small>").append(timestamp.toString()).append("</small>");
                    messageHtml.append("</div>");
                }

                response.getWriter().write(messageHtml.toString());
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("<p>Error loading messages.</p>");
        }
    }

    // Escapes HTML special characters to prevent XSS
    private String escapeHtml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }
}
