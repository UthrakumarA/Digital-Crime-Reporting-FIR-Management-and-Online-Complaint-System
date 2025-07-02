package Reg;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Date;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.nio.file.*;
import java.sql.*;
import org.apache.pdfbox.pdmodel.*;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;
import org.apache.pdfbox.pdmodel.PDPageContentStream.AppendMode;

@WebServlet("/SaveFIR")
public class SaveFIR extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Get form parameters
        String name = safeGet(request.getParameter("name"));
        String crimeType = safeGet(request.getParameter("crimeType"));
        String ipcSection = safeGet(request.getParameter("ipcSection"));
        String description = safeGet(request.getParameter("description"));
        String base64Image = safeGet(request.getParameter("photoBase64"));

        // Generate timestamps and file names
        String dateTime = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").format(new Date());
        String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String fileName = name.replaceAll("\\s+", "_") + "_" + timestamp + ".pdf";

        // Define PDF directory and create it if doesn't exist
        String pdfDir = "C:\\Users\\byami\\Desktop\\Final Year Projects\\12.Crime_service\\12.Crime_service\\web\\pdfs";
        Files.createDirectories(Paths.get(pdfDir));
        File pdfFile = new File(pdfDir, fileName);

        byte[] imageBytes = null;
        BufferedImage bufferedImage = null;

        // Handle image decoding from Base64
        if (base64Image != null && base64Image.startsWith("data:image")) {
            try {
                String[] parts = base64Image.split(",");
                String metadata = parts[0]; // e.g., "data:image/png;base64"
                String base64Data = parts[1];

                if (metadata.contains("image/png") || metadata.contains("image/jpeg")) {
                    imageBytes = Base64.getDecoder().decode(base64Data);
                    ByteArrayInputStream bais = new ByteArrayInputStream(imageBytes);
                    bufferedImage = ImageIO.read(bais);

                    if (bufferedImage == null) {
                        throw new IOException("Image decoding failed.");
                    }
                } else {
                    System.out.println("Unsupported image format. Only PNG or JPEG allowed.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                imageBytes = null; // Ensure imageBytes is null in case of error
            }
        }

        // Generate PDF with text and image
        try (PDDocument document = new PDDocument()) {
            PDPage page = new PDPage(PDRectangle.A4);
            document.addPage(page);

            // Write text to PDF
            PDPageContentStream content = new PDPageContentStream(document, page);
            content.beginText();
            content.setFont(PDType1Font.HELVETICA_BOLD, 16);
            content.setLeading(20f);
            content.newLineAtOffset(50, 750);
            content.showText("First Information Report (FIR)");
            content.newLine();
            content.newLine();

            content.setFont(PDType1Font.HELVETICA, 12);
            content.showText("Date/Time: " + dateTime);
            content.newLine();
            content.showText("Name: " + name);
            content.newLine();
            content.showText("Crime Type: " + crimeType);
            content.newLine();
            content.showText("IPC Section: " + ipcSection);
            content.newLine();
            content.showText("Description:");
            content.newLine();
            wrapAndWriteText(content, description, 80);
            content.endText();
            content.close();

            // Add image to PDF (if valid)
            if (bufferedImage != null) {
                PDImageXObject pdImage = PDImageXObject.createFromByteArray(document, imageBytes, "photo");
                PDPageContentStream imageStream = new PDPageContentStream(document, page, AppendMode.APPEND, true, true);
                imageStream.drawImage(pdImage, 50, 400, 150, 100); // X, Y, Width, Height
                imageStream.close();
            }

            // Save the PDF
            document.save(pdfFile);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating PDF");
            return;
        }

        // Save FIR data to MySQL database
        try {
            Class.forName("com.mysql.jdbc.Driver"); // Ensure using the correct driver (MySQL 8+)
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/crimenew", "root", "password");
                 PreparedStatement ps = con.prepareStatement(
                         "INSERT INTO fir_report_2 (name, crimeType, ipcSection, description, Photo, pdf_filename, timestamp) VALUES (?, ?, ?, ?, ?, ?, NOW())")) {

                ps.setString(1, name);
                ps.setString(2, crimeType);
                ps.setString(3, ipcSection);
                ps.setString(4, description);

                // Insert image as BLOB
                if (imageBytes != null) {
                    ps.setBytes(5, imageBytes);
                } else {
                    ps.setNull(5, Types.BLOB);
                }

                ps.setString(6, fileName);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error saving to database");
            return;
        }

        // Redirect to success page
        request.setAttribute("pdfFilePath", pdfFile.getAbsolutePath());
        request.getRequestDispatcher("/FIRSuccess.jsp").forward(request, response);
    }

    // Helper method to safely get parameter values
    private String safeGet(String value) {
        return (value != null) ? value.trim() : "";
    }

    // Helper method to wrap and write long text to PDF
    private void wrapAndWriteText(PDPageContentStream content, String text, int wrapWidth) throws IOException {
        String[] words = text.split(" ");
        StringBuilder line = new StringBuilder();
        for (String word : words) {
            if (line.length() + word.length() > wrapWidth) {
                content.showText(line.toString().trim());
                content.newLine();
                line = new StringBuilder();
            }
            line.append(word).append(" ");
        }
        if (line.length() > 0) {
            content.showText(line.toString().trim());
        }
    }
}
