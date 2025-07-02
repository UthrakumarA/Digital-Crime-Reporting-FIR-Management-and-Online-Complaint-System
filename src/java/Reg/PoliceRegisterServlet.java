package Reg;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.security.MessageDigest;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/PoliceRegisterServlet")
public class PoliceRegisterServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/crimenew";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Vishnu$20"; // Change as per your DB

    private static final String FROM_EMAIL = "USPVprojects@gmail.com"; // Your Gmail
    private static final String FROM_PASSWORD = "sjbuiyegbizbihiq"; // Gmail App Password

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String badgeNumber = request.getParameter("badgeNumber");
        String rank = request.getParameter("rank");
        String station = request.getParameter("station");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        String hashedPassword = hashPassword(password);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/crimenew","root","Vishnu$20")) {

                // Check for duplicate email or badge number
                String checkQuery = "SELECT * FROM police WHERE email = ? OR badgeNumber = ?";
                try (PreparedStatement checkStmt = connection.prepareStatement(checkQuery)) {
                    checkStmt.setString(1, email);
                    checkStmt.setString(2, badgeNumber);
                    ResultSet resultSet = checkStmt.executeQuery();

                    if (resultSet.next()) {
                        request.setAttribute("error", "Email or Badge Number already exists.");
                        request.getRequestDispatcher("register.jsp").forward(request, response);
                        return;
                    }
                }

                // Insert new record (escaped `rank`)
                String insertQuery = "INSERT INTO police (name, badgeNumber, `rank`, station, email, password, phone) VALUES (?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement insertStmt = connection.prepareStatement(insertQuery)) {
                    insertStmt.setString(1, name);
                    insertStmt.setString(2, badgeNumber);
                    insertStmt.setString(3, rank);
                    insertStmt.setString(4, station);
                    insertStmt.setString(5, email);
                    insertStmt.setString(6, hashedPassword);
                    insertStmt.setString(7, phone);

                    int rowsInserted = insertStmt.executeUpdate();
                    if (rowsInserted > 0) {
                        sendEmail(email, name, email, password);
                        response.sendRedirect("registration-success.jsp?success=1");
                    } else {
                        request.setAttribute("error", "Registration failed. Please try again.");
                        request.getRequestDispatcher("register.jsp").forward(request, response);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    private String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = digest.digest(password.getBytes("UTF-8"));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashedBytes) {
                hexString.append(String.format("%02x", b));
            }
            return hexString.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private void sendEmail(String to, String name, String userId, String plainPassword) {
        String subject = "Your Police Account Registration Details";
        String body = "Dear " + name + ",\n\n"
                + "You have been successfully registered as a police officer.\n\n"
                + "Login Credentials:\n"
                + "User ID: " + userId + "\n"
                + "Password: " + plainPassword + "\n\n"
                + "Please keep this information safe.\n\n"
                + "Regards,\nCrime Reporting System";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(body);
            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
