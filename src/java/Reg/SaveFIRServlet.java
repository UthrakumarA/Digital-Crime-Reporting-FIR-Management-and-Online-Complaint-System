package Reg;

import java.io.*;
import java.sql.*;
import java.util.Base64;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

@WebServlet("/SaveFIRServlet")
@MultipartConfig(maxFileSize = 16177215)  // max 16MB upload
public class SaveFIRServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/crimenew";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "Vishnu$20";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String crimeType = request.getParameter("crimeType");
        String ipcSection = request.getParameter("ipcSection");
        String description = request.getParameter("description");
        String photoBase64 = request.getParameter("photoBase64");       // for main photo preview base64 string
        String signatureBase64 = request.getParameter("signatureBase64"); // for signature preview base64 string
        String officerName = request.getParameter("officerName");

        // Get main photo InputStream
        InputStream photoInputStream = null;
        Part photoPart = request.getPart("photo");
        if (photoPart != null && photoPart.getSize() > 0) {
            photoInputStream = photoPart.getInputStream();
        } else if (photoBase64 != null && !photoBase64.isEmpty()) {
            try {
                String base64Data = photoBase64.contains(",") ? photoBase64.split(",")[1] : photoBase64;
                byte[] imageBytes = Base64.getDecoder().decode(base64Data);
                photoInputStream = new ByteArrayInputStream(imageBytes);
            } catch (IllegalArgumentException e) {
                photoInputStream = null;
            }
        }

        // Get signature photo InputStream
        InputStream signatureInputStream = null;
        Part signaturePart = request.getPart("signature");
        if (signaturePart != null && signaturePart.getSize() > 0) {
            signatureInputStream = signaturePart.getInputStream();
        } else if (signatureBase64 != null && !signatureBase64.isEmpty()) {
            try {
                String base64Data = signatureBase64.contains(",") ? signatureBase64.split(",")[1] : signatureBase64;
                byte[] imageBytes = Base64.getDecoder().decode(base64Data);
                signatureInputStream = new ByteArrayInputStream(imageBytes);
            } catch (IllegalArgumentException e) {
                signatureInputStream = null;
            }
        }

        Connection conn = null;
        PreparedStatement insertStmt = null;
        PreparedStatement selectStmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/crimenew","root","Vishnu$20");

            // Insert statement now includes signature column
            String insertSQL = "INSERT INTO fir_report (name, crimeType, ipcSection, description, photo, signature, officerName, timestamp) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
            insertStmt = conn.prepareStatement(insertSQL, Statement.RETURN_GENERATED_KEYS);

            insertStmt.setString(1, name);
            insertStmt.setString(2, crimeType);
            insertStmt.setString(3, ipcSection);
            insertStmt.setString(4, description);

            if (photoInputStream != null) {
                insertStmt.setBlob(5, photoInputStream);
            } else {
                insertStmt.setNull(5, Types.BLOB);
            }

            if (signatureInputStream != null) {
                insertStmt.setBlob(6, signatureInputStream);
            } else {
                insertStmt.setNull(6, Types.BLOB);
            }

            insertStmt.setString(7, officerName);

            int affectedRows = insertStmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating FIR failed, no rows affected.");
            }

            rs = insertStmt.getGeneratedKeys();
            int generatedId = -1;
            if (rs.next()) {
                generatedId = rs.getInt(1);
            } else {
                throw new SQLException("Creating FIR failed, no ID obtained.");
            }

            rs.close();
            insertStmt.close();

            // Retrieve inserted FIR to preview
            String selectSQL = "SELECT * FROM fir_report WHERE id = ?";
            selectStmt = conn.prepareStatement(selectSQL);
            selectStmt.setInt(1, generatedId);
            rs = selectStmt.executeQuery();

            if (rs.next()) {
                String dbName = rs.getString("name");
                String dbCrimeType = rs.getString("crimeType");
                String dbIpcSection = rs.getString("ipcSection");
                String dbDescription = rs.getString("description");
                Blob photoBlob = rs.getBlob("photo");
                Blob signatureBlob = rs.getBlob("signature");
                String dbOfficerName = rs.getString("officerName");

                // Convert photo blob to base64
                String encodedPhoto = "";
                if (photoBlob != null) {
                    try (InputStream inputStream = photoBlob.getBinaryStream();
                         ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
                        byte[] buffer = new byte[4096];
                        int bytesRead;
                        while ((bytesRead = inputStream.read(buffer)) != -1) {
                            outputStream.write(buffer, 0, bytesRead);
                        }
                        encodedPhoto = Base64.getEncoder().encodeToString(outputStream.toByteArray());
                    }
                }

                // Convert signature blob to base64
                String encodedSignature = "";
                if (signatureBlob != null) {
                    try (InputStream inputStream = signatureBlob.getBinaryStream();
                         ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
                        byte[] buffer = new byte[4096];
                        int bytesRead;
                        while ((bytesRead = inputStream.read(buffer)) != -1) {
                            outputStream.write(buffer, 0, bytesRead);
                        }
                        encodedSignature = Base64.getEncoder().encodeToString(outputStream.toByteArray());
                    }
                }

                // Set attributes for preview JSP
                request.setAttribute("name", dbName);
                request.setAttribute("crimeType", dbCrimeType);
                request.setAttribute("ipcSection", dbIpcSection);
                request.setAttribute("description", dbDescription);
                request.setAttribute("photoBase64", encodedPhoto);
                request.setAttribute("signatureBase64", encodedSignature);
                request.setAttribute("officerName", dbOfficerName);

                RequestDispatcher dispatcher = request.getRequestDispatcher("FIRPreview.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "FIR not found.");
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write("<h3>Server Error: " + e.getMessage() + "</h3>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (insertStmt != null) insertStmt.close(); } catch (Exception ignored) {}
            try { if (selectStmt != null) selectStmt.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }
}
