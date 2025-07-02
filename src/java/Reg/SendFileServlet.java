package Reg;

import java.io.*;
import java.nio.file.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SendFileServlet")
@MultipartConfig
public class SendFileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String senderEmail = (String) request.getSession().getAttribute("email");
        String receiverEmail = request.getParameter("receiver_email");
        String message = request.getParameter("message");
        Part filePart = request.getPart("file");

        String fileName = null;
        String filePath = null;

        if (filePart != null && filePart.getSize() > 0) {
            fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // Use a safe fixed directory (make sure it exists and is writable)
            String basePath = "C:/uploaded_docs/";
            File uploadDir = new File(basePath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            filePath = basePath + fileName;
            filePart.write(filePath);
            System.out.println("File saved to: " + filePath);
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/crimenew", "root", "Vishnu$20");
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO chat (sender_email, receiver_email, message, file_name, file_path, timestamp) VALUES (?, ?, ?, ?, ?, NOW())"
            );
            ps.setString(1, senderEmail);
            ps.setString(2, receiverEmail);
            ps.setString(3, message);
            ps.setString(4, fileName);
            ps.setString(5, filePath);
            ps.executeUpdate();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.setContentType("text/plain");
        response.getWriter().write("File sent successfully.");
    }
}
