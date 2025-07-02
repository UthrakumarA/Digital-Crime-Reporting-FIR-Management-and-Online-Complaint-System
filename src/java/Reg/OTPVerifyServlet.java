package Reg;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/OTPVerifyServlet")
public class OTPVerifyServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("otp") == null) {
            response.sendRedirect("policeLogin.jsp");
            return;
        }

        int otpEntered = Integer.parseInt(request.getParameter("otp"));
        int otpSession = (int) session.getAttribute("otp");

        if (otpEntered == otpSession) {
            session.removeAttribute("otp"); // clear OTP
            response.sendRedirect("userdetails.jsp"); // successful login
        } else {
            request.setAttribute("error", "Invalid OTP. Please try again.");
            request.getRequestDispatcher("otpVerify.jsp").forward(request, response);
        }
    }
}
