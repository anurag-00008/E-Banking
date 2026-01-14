package e_banking;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/ChangePasswordServlet"})
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String accountNumber = (String) session.getAttribute("account_number");

        // If session expired
        if (accountNumber == null) {
            response.sendRedirect("login.jsp?msg=Please login first");
            return;
        }

        String currentPassword = request.getParameter("current_password");
        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_password");

        // New password mismatch check
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("ChangePassword.jsp?msg=Passwords do not match");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        PreparedStatement updatePs = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // Fetch current password from DB
            ps = conn.prepareStatement(
                    "SELECT password FROM users WHERE account_number = ?");
            ps.setString(1, accountNumber);
            rs = ps.executeQuery();

            if (rs.next()) {
                String dbPassword = rs.getString("password");

                // Wrong current password check
                if (!dbPassword.equals(currentPassword)) {
                    response.sendRedirect(
                        "ChangePassword.jsp?msg=You have entered wrong current password");
                    return;
                }
            } else {
                response.sendRedirect("ChangePassword.jsp?msg=Account not found");
                return;
            }

            // Update password
            updatePs = conn.prepareStatement(
                    "UPDATE users SET password = ? WHERE account_number = ?");
            updatePs.setString(1, newPassword);
            updatePs.setString(2, accountNumber);

            int rows = updatePs.executeUpdate();

            if (rows > 0) {
                response.sendRedirect(
                    "ChangePassword.jsp?msg=Password changed successfully");
            } else {
                response.sendRedirect(
                    "ChangePassword.jsp?msg=Failed to update password");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(
                "ChangePassword.jsp?msg=Something went wrong");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (updatePs != null) updatePs.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    @Override
    public String getServletInfo() {
        return "Change Password Servlet";
    }
}
