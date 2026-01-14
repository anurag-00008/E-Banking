package e_banking;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/ForgotPasswordServlet"})
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accountNumber = request.getParameter("account_number");
        String securityQuestion = request.getParameter("security_question");
        String securityAnswer = request.getParameter("security_answer");
        String newPassword = request.getParameter("new_password");

        if(accountNumber == null || accountNumber.isEmpty() ||
           securityQuestion == null || securityQuestion.isEmpty() ||
           securityAnswer == null || securityAnswer.isEmpty() ||
           newPassword == null || newPassword.isEmpty()) {
            response.sendRedirect("forgotPassword.jsp?msg=All fields are required!");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        PreparedStatement psUpdate = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // Check account and security answer
            String sql = "SELECT * FROM users WHERE account_number=? AND security_question=? AND security_answer=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, accountNumber);
            ps.setString(2, securityQuestion);
            ps.setString(3, securityAnswer);

            rs = ps.executeQuery();

            if(rs.next()) {
                // Update password
                String updateSql = "UPDATE users SET password=? WHERE account_number=?";
                psUpdate = conn.prepareStatement(updateSql);
                psUpdate.setString(1, newPassword);
                psUpdate.setString(2, accountNumber);
                psUpdate.executeUpdate();

                response.sendRedirect("login.jsp?msg=Password updated successfully! Please login.");
            } else {
                response.sendRedirect("forgotPassword.jsp?msg=Invalid account number or incorrect security answer!");
            }

        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("forgotPassword.jsp?msg=Error: " + e.getMessage());
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(psUpdate != null) psUpdate.close(); } catch(Exception e) {}
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("forgotPassword.jsp");
    }

    @Override
    public String getServletInfo() {
        return "Forgot Password Servlet";
    }
}
