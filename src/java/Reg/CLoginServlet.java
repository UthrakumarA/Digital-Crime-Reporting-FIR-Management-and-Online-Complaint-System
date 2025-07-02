package Reg;

import java.io.IOException;
import java.security.MessageDigest;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CLoginServlet")
public class CLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("username");
        String password = request.getParameter("password");
        String hashedPassword = hashPassword(password);

        if (hashedPassword == null) {
            request.setAttribute("error", "Password hashing failed.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            // Establish database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/crimenew", "root", "Vishnu$20");

            // Prepare SQL query to verify the user
            String sql = "SELECT * FROM police WHERE email = ? AND password = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, email);
            statement.setString(2, hashedPassword);

            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                // User successfully authenticated, create a session
                HttpSession session = request.getSession();
                session.setAttribute("name", rs.getString("name"));
                session.setAttribute("badgeNumber", rs.getString("badgeNumber"));
                session.setAttribute("email", rs.getString("email"));

                // Redirect to chat page (or dashboard)
                response.sendRedirect("chat.jsp");
            } else {
                // Invalid login details
                request.setAttribute("error", "Invalid email or password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

            // Close database resources
            rs.close();
            statement.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Server error. Please try again later.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    // Password hashing method
    private String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = digest.digest(password.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) sb.append('0');
                sb.append(hex);
            }
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
