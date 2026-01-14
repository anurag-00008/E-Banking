package e_banking;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

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

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String pan = request.getParameter("pan");
        String aadhar = request.getParameter("aadhar");
        String address = request.getParameter("address");
        String accountType = request.getParameter("account_type");
        String securityQuestion = request.getParameter("security_question");
        String securityAnswer = request.getParameter("security_answer");

        // Server-side validation for PAN and Aadhar
        if (!pan.matches("\\d{10}") || !aadhar.matches("\\d{12}")) {
            request.setAttribute("msg", "Invalid PAN or Aadhar number format.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (accountType == null || accountType.trim().isEmpty()) accountType = "Savings";

        String accountNumber = "ACC" + System.currentTimeMillis();
        double initialBalance = 100000.00;

        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // Check for duplicates: PAN, Email, Aadhar
            checkStmt = conn.prepareStatement(
                "SELECT * FROM users WHERE pan=? OR email=? OR aadhar=?"
            );
            checkStmt.setString(1, pan);
            checkStmt.setString(2, email);
            checkStmt.setString(3, aadhar);
            rs = checkStmt.executeQuery();

            if (rs.next()) {
                StringBuilder msg = new StringBuilder("Duplicate detected: ");
                if (pan.equals(rs.getString("pan"))) msg.append("PAN ");
                if (email.equals(rs.getString("email"))) msg.append("Email ");
                if (aadhar.equals(rs.getString("aadhar"))) msg.append("Aadhar ");

                request.setAttribute("msg", msg.toString().trim());
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Insert new user
            String sql = "INSERT INTO users (account_number, name, email, password, phone, pan, aadhar, address, account_type, balance, security_question, security_answer, status) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Active')";
            ps = conn.prepareStatement(sql);
            ps.setString(1, accountNumber);
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, password);
            ps.setString(5, phone);
            ps.setString(6, pan);
            ps.setString(7, aadhar);
            ps.setString(8, address);
            ps.setString(9, accountType);
            ps.setDouble(10, initialBalance);
            ps.setString(11, securityQuestion);
            ps.setString(12, securityAnswer);
            ps.executeUpdate();

            // Registration success message
            request.setAttribute("msg", "Registration successful! Your Account No: " + accountNumber);
            request.getRequestDispatcher("register.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "Error: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(checkStmt != null) checkStmt.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
    }

    @Override
    public String getServletInfo() {
        return "User Registration Servlet";
    }
}