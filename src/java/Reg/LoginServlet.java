package Reg;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.security.MessageDigest;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("username"); // email field
        String password = request.getParameter("password");
        String hashedPassword = hashPassword(password);

        if (hashedPassword == null) {
            request.setAttribute("error", "Password hashing failed.");
            request.getRequestDispatcher("policeLogin.jsp").forward(request, response);
            return;
        }

        String dbURL = "jdbc:mysql://localhost:3306/crimenew";
        String dbUser = "root";
        String dbPassword = "Vishnu$20"; // your DB password

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/crimenew","root","Vishnu$20");

            String sql = "SELECT * FROM police WHERE email = ? AND password = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, email);
            statement.setString(2, hashedPassword);

            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                // Login successful - Generate OTP
                int otp = (int)(Math.random() * 900000) + 100000;

                HttpSession session = request.getSession();
                session.setAttribute("name", rs.getString("name"));
                session.setAttribute("badgeNumber", rs.getString("badgeNumber"));
                session.setAttribute("email", rs.getString("email"));
                session.setAttribute("otp", otp);

                sendOTPEmail(email, otp); // Send OTP to email

                response.sendRedirect("otpVerify.jsp"); // Go to OTP entry page
            } else {
                request.setAttribute("error", "Invalid email or password.");
                request.getRequestDispatcher("policeLogin.jsp").forward(request, response);
            }

            rs.close();
            statement.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Server error. Please try again later.");
            request.getRequestDispatcher("policeLogin.jsp").forward(request, response);
        }
    }

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

    private void sendOTPEmail(String recipientEmail, int otp) {
        final String fromEmail = "USPVprojects@gmail.com"; // your email
        final String password = "sjbuiyegbizbihiq"; // Gmail app password

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Your OTP for Login Verification");
            message.setText("Dear Officer,\n\nYour OTP is: " + otp + "\n\nRegards,\nCrime Portal");

            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
