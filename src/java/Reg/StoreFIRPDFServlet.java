package Reg;

import org.apache.pdfbox.pdmodel.*;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;
import org.apache.pdfbox.pdmodel.graphics.state.PDExtendedGraphicsState;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.Base64;

@WebServlet("/storeFIRPDF")
public class StoreFIRPDFServlet extends HttpServlet {
    private static final String PDF_DIRECTORY = "C:\\Users\\byami\\Desktop\\Final Year Projects\\12.Crime_service\\12.Crime_service\\web\\pdfs";
    private static final String HEADER_IMAGE_PATH = "C:\\Users\\byami\\Desktop\\Final Year Projects\\12.Crime_service\\12.Crime_service\\web\\background_images\\image26.png";
    private static final String BACKGROUND_IMAGE_PATH = "C:\\Users\\byami\\Desktop\\Final Year Projects\\12.Crime_service\\12.Crime_service\\web\\background_images\\image22.png";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve parameters
        String name = request.getParameter("name");
        String crimeType = request.getParameter("crimeType");
        String ipcSection = request.getParameter("ipcSection");
        String description = request.getParameter("description");
        String photoBase64 = request.getParameter("photoBase64");
        String signatureBase64 = request.getParameter("signatureBase64"); // for signature preview base64 string
        String officerName = request.getParameter("officerName");

        String fileName = "FIR_" + name.replaceAll("\\s+", "_") + ".pdf";

        File pdfDir = new File(PDF_DIRECTORY);
        if (!pdfDir.exists()) {
            pdfDir.mkdirs();
        }

        File pdfFile = new File(pdfDir, fileName);

        // Decode Base64 images
        byte[] photoBytes = decodeBase64Image(photoBase64);
        byte[] signatureBytes = decodeBase64Image(signatureBase64);

        try (PDDocument document = new PDDocument()) {
            PDPage page = new PDPage(PDRectangle.A4);
            document.addPage(page);

            PDPageContentStream content = new PDPageContentStream(document, page);

            // Draw background image with transparency
            try {
                PDImageXObject backgroundImage = PDImageXObject.createFromFile(BACKGROUND_IMAGE_PATH, document);
                content.saveGraphicsState();
                PDExtendedGraphicsState graphicsState = new PDExtendedGraphicsState();
                graphicsState.setNonStrokingAlphaConstant(0.3f);
                content.setGraphicsStateParameters(graphicsState);

                float squareSize = 300f;
                float centerX = (page.getMediaBox().getWidth() - squareSize) / 2;
                float centerY = (page.getMediaBox().getHeight() - squareSize) / 2;
                content.drawImage(backgroundImage, centerX, centerY, squareSize, squareSize);
                content.restoreGraphicsState();
            } catch (IOException e) {
                System.err.println("Background image not found: " + e.getMessage());
            }

            // Draw header image
            try {
                PDImageXObject headerImage = PDImageXObject.createFromFile(HEADER_IMAGE_PATH, document);
                float headerImgHeight = 70;
                content.drawImage(headerImage, 0, page.getMediaBox().getHeight() - headerImgHeight,
                        page.getMediaBox().getWidth(), headerImgHeight);
            } catch (IOException e) {
                System.err.println("Header image not found: " + e.getMessage());
            }

            // Draw FIR Box layout
            float margin = 10;
            float padding = 20;
            float pageWidth = page.getMediaBox().getWidth();
            float pageHeight = page.getMediaBox().getHeight();

            float boxX = margin;
            float boxY = margin;
            float boxWidth = pageWidth - 2 * margin;
            float boxHeight = pageHeight - 2 * margin - 70;

            content.setStrokingColor(0, 0, 0);
            content.setLineWidth(1.5f);
            content.addRect(boxX, boxY, boxWidth, boxHeight);
            content.stroke();

            // Title: Centered
            String title = "First Information Report (FIR)";
            float fontSize = 16;
            PDType1Font font = PDType1Font.HELVETICA_BOLD;

            float titleWidth = font.getStringWidth(title) / 1000 * fontSize;
            float titleX = boxX + (boxWidth - titleWidth) / 2;
            float titleY = boxY + boxHeight - padding;

            content.setFont(font, fontSize);
            content.beginText();
            content.newLineAtOffset(titleX, titleY);
            content.showText(title);
            content.endText();

            // Write fields below title
            content.setFont(PDType1Font.HELVETICA_BOLD, 12);
            int y = (int) (boxY + boxHeight - padding - 40);
            int x = (int) (boxX + padding);

            y = writeLine(content, "Name: " + name, x, y);
            y = writeLine(content, "Crime Type: " + crimeType, x, y);
            y = writeLine(content, "IPC Section: " + ipcSection, x, y);
            
            
            y = writeMultilineText(content, "Description: " + description, x, y, (int) (boxWidth - 2 * padding));
            y -= 10;

            // Draw photo image if present
            if (photoBytes != null) {
                PDImageXObject photo = PDImageXObject.createFromByteArray(document, photoBytes, "photo");
                float imgWidth = 300;
                float imgHeight = 200;
                float imgX = boxX + (boxWidth - imgWidth) / 2;
                float imgY = y - imgHeight - 20;
                if (imgY > margin) {
                    content.drawImage(photo, imgX, imgY, imgWidth, imgHeight);
                    y = (int) imgY - 30;
                }
            }

           // Draw signature if present
if (signatureBytes != null) {
    PDImageXObject signature = PDImageXObject.createFromByteArray(document, signatureBytes, "signature");
    float sigWidth = 150;
    float sigHeight = 50;
    float sigX = boxX + boxWidth - sigWidth - padding;
    float sigY = y - sigHeight - 20;
    if (sigY > margin) {
        content.drawImage(signature, sigX, sigY, sigWidth, sigHeight);
        y = (int) sigY - 30;
    }

    // Draw label "Reported Officer Name:"
    content.beginText();
    content.setFont(PDType1Font.HELVETICA_BOLD, 12);
    content.newLineAtOffset(sigX, sigY + sigHeight + 5); // position above the signature
    content.showText("Reported Officer Name:");
    content.endText();

    // Draw officer name below signature
content.beginText();
content.setFont(PDType1Font.HELVETICA_BOLD, 12);
content.newLineAtOffset(sigX + 50, sigY - 15);  // moved 35 right and 5 down compared to before
content.showText(officerName != null ? officerName : "");
content.endText();

}

            content.close();

            document.save(pdfFile);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "PDF generation failed: " + e.getMessage());
            return;
        }

         // Save FIR data into MySQL
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/crimenew", "root", "Vishnu$20");
                 PreparedStatement ps = con.prepareStatement(
                         "INSERT INTO fir_report_2 (name, crimeType, ipcSection, description, Photo, signature, officerName, pdf_filename, timestamp) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())"
                 )) {
                ps.setString(1, name);
                ps.setString(2, crimeType);
                ps.setString(3, ipcSection);
                ps.setString(4, description);
                if (photoBytes != null) {
                    ps.setBytes(5, photoBytes);
                } else {
                    ps.setNull(5, Types.BLOB);
                }
                if (signatureBytes != null) {
                    ps.setBytes(6, signatureBytes);
                } else {
                    ps.setNull(6, Types.BLOB);
                }
                ps.setString(7, officerName);
                ps.setString(8, fileName);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Database save failed");
            return;
        }

        // Forward to success page with PDF file path attribute
        request.setAttribute("pdfFilePath", pdfFile.getAbsolutePath());
        request.getRequestDispatcher("/FIRSuccess.jsp").forward(request, response);
    }

    private byte[] decodeBase64Image(String base64Image) {
        if (base64Image == null || base64Image.trim().isEmpty()) {
            return null;
        }
        if (base64Image.contains(",")) {
            base64Image = base64Image.split(",")[1];
        }
        try {
            return Base64.getDecoder().decode(base64Image);
        } catch (IllegalArgumentException e) {
            System.err.println("Failed to decode base64 image: " + e.getMessage());
            return null;
        }
    }

    private int writeLine(PDPageContentStream content, String text, int x, int y) throws IOException {
    if (text == null || text.trim().isEmpty()) {
        return y;
    }

    // Split text into label and value using the first colon
    int colonIndex = text.indexOf(":");
    if (colonIndex == -1) {
        // If no colon, write the whole text normally
        content.beginText();
        content.setFont(PDType1Font.HELVETICA, 12);
        content.newLineAtOffset(x, y);
        content.showText(text);
        content.endText();
    } else {
        String label = text.substring(0, colonIndex + 1).trim(); // include the colon
        String value = text.substring(colonIndex + 1).trim();

        // Write label in bold
        content.beginText();
        content.setFont(PDType1Font.HELVETICA_BOLD, 12);
        content.newLineAtOffset(x, y);
        content.showText(label + " ");
        content.endText();
        
        

        // Compute width of bold label to position value correctly
        float labelWidth = PDType1Font.HELVETICA_BOLD.getStringWidth(label + " ") / 1000 * 12;

        // Write value in normal font
        content.beginText();
        content.setFont(PDType1Font.HELVETICA, 12);
        content.newLineAtOffset(x + labelWidth, y);
        content.showText(value);
        content.endText();
    }

    return y - 25;
}

    private int writeMultilineText(PDPageContentStream content, String text, int x, int y, int maxWidth) throws IOException {
    int lineHeight = 18;
    int fontSize = 12;
    int currentY = y;

    String label = "";
    String body = text;

    if (text.contains(":")) {
        int index = text.indexOf(":") + 1;
        label = text.substring(0, index); // e.g., "Description:"
        body = text.substring(index).trim(); // the rest of the description
    }

    // Calculate label width in bold
    float labelWidth = PDType1Font.HELVETICA_BOLD.getStringWidth(label + " ") / 1000 * fontSize;

    // Start with bold label
    content.setFont(PDType1Font.HELVETICA_BOLD, fontSize);
    content.beginText();
    content.newLineAtOffset(x, currentY);
    content.showText(label);
    content.endText();

    // Switch to regular font and start body right after label
    content.setFont(PDType1Font.HELVETICA, fontSize);

    // Initialize line with remaining width
    String[] words = body.split("\\s+");
    StringBuilder line = new StringBuilder();
    float spaceUsed = labelWidth;
    int startX = x;

    for (String word : words) {
        String tempLine = line + word + " ";
        float width = PDType1Font.HELVETICA.getStringWidth(tempLine) / 1000 * fontSize;

        if (spaceUsed + width > maxWidth) {
            // Draw current line
            content.beginText();
            content.newLineAtOffset(startX + labelWidth, currentY);
            content.showText(line.toString());
            content.endText();

            // Reset for next line
            line = new StringBuilder(word + " ");
            currentY -= lineHeight;
            spaceUsed = 0;
            labelWidth = 0; // on next lines, don't offset for label
        } else {
            line.append(word).append(" ");
        }
    }

    // Draw last line
    if (line.length() > 0) {
        content.beginText();
        content.newLineAtOffset(startX + labelWidth, currentY);
        content.showText(line.toString());
        content.endText();
        currentY -= lineHeight;
    }

    return currentY;
}

}
