package Reg;

import java.io.IOException;
import java.util.Random;
import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.util.Properties;

@WebServlet("/ResendOTPServlet")
public class ResendOTPServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Method to generate random 6-digit OTP
    private int generateOTP() {
        Random rand = new Random();
        return 100000 + rand.nextInt(900000); // Generates a number between 100000 and 999999
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get user email from session or database
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("email");

        if (userEmail == null) {
            response.sendRedirect("PoliceLogin.jsp");
            return;
        }

        int otp = generateOTP();
        session.setAttribute("otp", otp); // Save new OTP in session

        // (Optional) Send OTP via email (JavaMail API example)
        final String fromEmail = "USPVprojects@gmail.com"; // your email
        final String password = "sjbuiyegbizbihiq"; // Gmail app password

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com"); 
        props.put("mail.smtp.port", "587"); 
        props.put("mail.smtp.auth", "true"); 
        props.put("mail.smtp.starttls.enable", "true");

        Session mailSession = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(userEmail));
            message.setSubject("Your Resend OTP for Login Verification");
            message.setText("Dear Officer,\n\nYour Resend OTP is: " + otp + "\n\nRegards,\nCrime Portal");

            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }

        // Redirect back to OTP input page
        response.sendRedirect("otpVerify.jsp");
    }
}
