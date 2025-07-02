package Reg;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ToggleStatusServlet")
public class ToggleStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        String currentStatus = request.getParameter("currentStatus");

        String newStatus = "Pending";
        if ("Pending".equalsIgnoreCase(currentStatus)) {
            newStatus = "Progress";
        } else if ("Progress".equalsIgnoreCase(currentStatus)) {
            newStatus = "Finished";
        } else if ("Finished".equalsIgnoreCase(currentStatus)) {
            newStatus = "Pending";
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // or com.mysql.cj.jdbc.Driver
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/crimenew", "root", "Vishnu$20");

            String updateQuery = "UPDATE Complaint_report SET status=? WHERE id=?";
            PreparedStatement ps = con.prepareStatement(updateQuery);
            ps.setString(1, newStatus);
            ps.setInt(2, id);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("status.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error updating status: " + e.getMessage());
        }
    }
}
