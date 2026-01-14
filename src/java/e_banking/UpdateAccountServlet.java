package e_banking;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "UpdateAccountServlet", urlPatterns = {"/UpdateAccountServlet"})
public class UpdateAccountServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account_number") == null) {
            response.sendRedirect("login.jsp?msg=Please login first");
            return;
        }

        String accountNumber = (String) session.getAttribute("account_number");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement("UPDATE users SET email=?, phone=?, address=? WHERE account_number=?");

            ps.setString(1, email);
            ps.setString(2, phone);
            ps.setString(3, address);
            ps.setString(4, accountNumber);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("UpdateAccount.jsp?msg=Details updated successfully!");
            } else {
                response.sendRedirect("UpdateAccount.jsp?msg=Update failed. Try again!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("UpdateAccount.jsp?msg=Error occurred!");
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
    }

    @Override
    public String getServletInfo() {
        return "Update Account Servlet";
    }
}