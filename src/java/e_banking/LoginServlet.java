package e_banking;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

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

        String accountNumber = request.getParameter("account_number");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            String sql = "SELECT * FROM users WHERE account_number=? AND password=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, accountNumber);
            ps.setString(2, password);

            rs = ps.executeQuery();

            if(rs.next()) {
                // Successful login
                HttpSession session = request.getSession();
                session.setAttribute("account_number", rs.getString("account_number"));
                session.setAttribute("name", rs.getString("name"));
                response.sendRedirect("dashboard.jsp");
            } else {
                // Invalid login
                response.sendRedirect("login.jsp?msg=Invalid Account Number or Password!");
            }

        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?msg=Error: " + e.getMessage());
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
    }

    @Override
    public String getServletInfo() {
        return "User Login Servlet";
    }
}