package Reg;

import java.io.IOException;
import java.sql.*;
import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SubmitComplaintServlet")
public class SubmitComplaintServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/crimenew";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "Vishnu$20"; // ✅ Update if needed

    private static final String EMAIL_FROM = "USPVprojects@gmail.com"; // ✅ Your Gmail
    private static final String EMAIL_PASSWORD = "sjbuiyegbizbihiq";   // ✅ Your Gmail App Password

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String date = request.getParameter("date");
        String type = request.getParameter("type");
        String complaint = request.getParameter("complaint");

        // ✅ Generate Acknowledgement Number (e.g., ACK-1715452023456)
        String ackNumber = "TNPCS-" + System.currentTimeMillis();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/crimenew","root","Vishnu$20");

            String query = "INSERT INTO Complaint_report (name, email, phone, incident_date, complaint_type, complaint_detail, status, ack_number) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, date);
            ps.setString(5, type);
            ps.setString(6, complaint);
            ps.setString(7, "Pending");
            ps.setString(8, ackNumber);  // Save ack number in DB

            ps.executeUpdate();

            ps.close();
            con.close();

            // ✅ Send Email Notification
            sendEmail(email, name, ackNumber);

            // Redirect with success message
            response.sendRedirect("complaint-success.jsp?success=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
        }
    }

    private void sendEmail(String toEmail, String userName, String ackNumber) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props,
            new javax.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
                }
            });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(EMAIL_FROM));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("Complaint Registered Successfully");
        message.setText("Dear " + userName + ",\n\n"
                + "Your complaint has been successfully registered.\n"
                + "Acknowledgement Number: " + ackNumber + "\n\n"
                + "Please keep this number for future reference.\n"
                + "Thank you for reporting.\n"
                + "Crime Reporting System");

        Transport.send(message);
    }
}
