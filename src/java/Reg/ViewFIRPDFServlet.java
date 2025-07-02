package Reg;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;

@WebServlet("/ViewFIRPDFServlet")
public class ViewFIRPDFServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Fetch the 'file' parameter instead of 'name'
        String filename = request.getParameter("file");
        if (filename == null || filename.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "File is required.");
            return;
        }

        // Path where PDFs are saved
        String pdfDir = "C:\\Users\\byami\\Desktop\\Final Year Projects\\12.Crime_service\\12.Crime_service\\web\\pdfs";
        File pdfFile = new File(pdfDir, filename); // Using the filename from the URL

        if (!pdfFile.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "PDF not found for File: " + filename);
            return;
        }

        // Set content type
        response.setContentType("application/pdf");
        response.setContentLength((int) pdfFile.length());

        // Stream the file to client
        try (BufferedInputStream in = new BufferedInputStream(new FileInputStream(pdfFile));
             OutputStream out = response.getOutputStream()) {

            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
