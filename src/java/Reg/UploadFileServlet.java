import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;


@WebServlet("/UploadFileServlett")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024) // 10MB max
public class UploadFileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sender = request.getParameter("sender_email");
        String receiver = request.getParameter("receiver_email");
        Part filePart = request.getPart("file");

        String fileName = filePart.getSubmittedFileName();
        InputStream fileContent = filePart.getInputStream();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/crimenew", "root", "password");

            String sql = "INSERT INTO police_chat (sender_email, receiver_email, message, file_name, file_data, timestamp) VALUES (?, ?, '', ?, ?, NOW())";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, sender);
            ps.setString(2, receiver);
            ps.setString(3, fileName);
            ps.setBlob(4, fileContent);

            ps.executeUpdate();
            con.close();
            response.sendRedirect("chat.jsp"); // or back to main chat UI
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error uploading file: " + e.getMessage());
        }
    }
}
