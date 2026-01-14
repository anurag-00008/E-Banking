package e_banking;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "FundTransferServlet", urlPatterns = {"/FundTransferServlet"})
public class FundTransferServlet extends HttpServlet {
    
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

        HttpSession session = request.getSession();
        String fromAccount = request.getParameter("fromAccount");
        String toAccount = request.getParameter("toAccount");
        String amountStr = request.getParameter("amount");
        String remarks = request.getParameter("remarks");

        // Input Validation
        if (fromAccount == null || toAccount == null || fromAccount.equals(toAccount)) {
            request.setAttribute("msg", "Invalid account details");
            request.getRequestDispatcher("fundtransfer.jsp").forward(request, response);
            return;
        }

        double amount;
        try {
            amount = Double.parseDouble(amountStr);
            if(amount <= 0){
                request.setAttribute("msg", "Amount must be greater than zero");
                request.getRequestDispatcher("fundtransfer.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("msg", "Invalid amount");
            request.getRequestDispatcher("fundtransfer.jsp").forward(request, response);
            return;
        }

        try {
            // Check if sender is blocked
            if (UserUtils.isBlocked(fromAccount)) {
                request.setAttribute("msg", "Your account is blocked. Fund transfer not allowed.");
                request.getRequestDispatcher("fundtransfer.jsp").forward(request, response);
                return;
            }

            // Check if recipient is blocked
            if (UserUtils.isBlocked(toAccount)) {
                request.setAttribute("msg", "Recipient account is blocked. Cannot transfer.");
                request.getRequestDispatcher("fundtransfer.jsp").forward(request, response);
                return;
            }

            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                conn = DBConnection.getConnection();
                conn.setAutoCommit(false); // Start transaction

                double senderBalance;
                double recipientBalance;

                // Check sender balance
                ps = conn.prepareStatement("SELECT balance FROM users WHERE account_number=?");
                ps.setString(1, fromAccount);
                rs = ps.executeQuery();
                if (!rs.next()) {
                    conn.rollback();
                    request.setAttribute("msg", "Sender account not found");
                    request.getRequestDispatcher("fundtransfer.jsp").forward(request, response);
                    return;
                }
                senderBalance = rs.getDouble("balance");
                rs.close(); ps.close();

                if (senderBalance < amount) {
                    conn.rollback();
                    request.setAttribute("msg", "Insufficient balance");
                    request.getRequestDispatcher("fundtransfer.jsp").forward(request, response);
                    return;
                }

                // Check recipient exists
                ps = conn.prepareStatement("SELECT balance FROM users WHERE account_number=?");
                ps.setString(1, toAccount);
                rs = ps.executeQuery();
                if (!rs.next()) {
                    conn.rollback();
                    request.setAttribute("msg", "Recipient account not found");
                    request.getRequestDispatcher("fundtransfer.jsp").forward(request, response);
                    return;
                }
                recipientBalance = rs.getDouble("balance");
                rs.close(); ps.close();

                // Deduct from sender
                ps = conn.prepareStatement("UPDATE users SET balance=? WHERE account_number=?");
                ps.setDouble(1, senderBalance - amount);
                ps.setString(2, fromAccount);
                ps.executeUpdate();
                ps.close();

                // Add to recipient
                ps = conn.prepareStatement("UPDATE users SET balance=? WHERE account_number=?");
                ps.setDouble(1, recipientBalance + amount);
                ps.setString(2, toAccount);
                ps.executeUpdate();
                ps.close();

                // Insert transaction record
                ps = conn.prepareStatement(
                        "INSERT INTO transactions (from_account, to_account, amount, remarks) VALUES (?,?,?,?)");
                ps.setString(1, fromAccount);
                ps.setString(2, toAccount);
                ps.setDouble(3, amount);
                ps.setString(4, remarks);
                ps.executeUpdate();
                ps.close();

                conn.commit(); // Commit transaction

                // Fetch updated sender balance
                double updatedBalance = 0;
                ps = conn.prepareStatement("SELECT balance FROM users WHERE account_number=?");
                ps.setString(1, fromAccount);
                rs = ps.executeQuery();
                if (rs.next()) updatedBalance = rs.getDouble("balance");

                // Forward to JSP with success message and updated balance
                request.setAttribute("msg", "Fund transfer successful!");
                request.setAttribute("balance", updatedBalance);
                request.getRequestDispatcher("fundtransfer.jsp").forward(request, response);

            } catch (SQLException ex) {
                try { if(conn != null) conn.rollback(); } catch(Exception e) {}
                ex.printStackTrace();
                request.setAttribute("msg", "Error occurred during transfer");
                request.getRequestDispatcher("fundtransfer.jsp").forward(request, response);
            } finally {
                try { if(rs != null) rs.close(); } catch(Exception e) {}
                try { if(ps != null) ps.close(); } catch(Exception e) {}
                try { if(conn != null) { conn.setAutoCommit(true); conn.close(); } } catch(Exception e) {}
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "Unexpected error occurred");
            request.getRequestDispatcher("fundtransfer.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Fund Transfer Servlet";
    }
}