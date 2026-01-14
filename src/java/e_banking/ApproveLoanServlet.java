package e_banking;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "ApproveLoanServlet", urlPatterns = {"/ApproveLoanServlet"})
public class ApproveLoanServlet extends HttpServlet {
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check admin session
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("admin_username") == null) {
            response.sendRedirect("adminLogin.jsp?msg=Please login as admin first");
            return;
        }
        
        String action = request.getParameter("action"); // "approve" or "reject"
        String loanIdStr = request.getParameter("id");
        
        if(action == null || loanIdStr == null) {
            response.sendRedirect("adminLoans.jsp?msg=Invalid request");
            return;
        }
        
        int loanId;
        try {
            loanId = Integer.parseInt(loanIdStr);
        } catch(NumberFormatException e) {
            response.sendRedirect("adminLoans.jsp?msg=Invalid loan ID");
            return;
        }
        
        Connection conn = null;
        PreparedStatement psCheck = null;
        PreparedStatement psUpdate = null;
        PreparedStatement psCredit = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Get loan details
            psCheck = conn.prepareStatement(
                "SELECT loan_account_number, account_number, loan_amount, status FROM loans WHERE id=?"
            );
            psCheck.setInt(1, loanId);
            rs = psCheck.executeQuery();
            
            if(!rs.next()) {
                conn.rollback();
                response.sendRedirect("adminLoans.jsp?msg=Loan not found");
                return;
            }
            
            String loanAccountNumber = rs.getString("loan_account_number");
            String accountNumber = rs.getString("account_number");
            double loanAmount = rs.getDouble("loan_amount");
            String currentStatus = rs.getString("status");
            
            rs.close();
            psCheck.close();
            
            // Check if already processed
            if(!"Pending".equals(currentStatus)) {
                conn.rollback();
                response.sendRedirect("adminLoans.jsp?msg=Loan already " + currentStatus);
                return;
            }
            
            String newStatus;
            String message;
            
            if("approve".equalsIgnoreCase(action)) {
                newStatus = "Approved";
                
                // Credit loan amount to user's account
                psCredit = conn.prepareStatement(
                    "UPDATE users SET balance = balance + ? WHERE account_number=?"
                );
                psCredit.setDouble(1, loanAmount);
                psCredit.setString(2, accountNumber);
                int updated = psCredit.executeUpdate();
                psCredit.close();
                
                if(updated == 0) {
                    conn.rollback();
                    response.sendRedirect("adminLoans.jsp?msg=Failed to credit loan amount");
                    return;
                }
                
                // Record transaction
                PreparedStatement psTransaction = conn.prepareStatement(
                    "INSERT INTO transactions (from_account, to_account, amount, remarks) VALUES (?,?,?,?)"
                );
                psTransaction.setString(1, "BANK-LOAN");
                psTransaction.setString(2, accountNumber);
                psTransaction.setDouble(3, loanAmount);
                psTransaction.setString(4, "Loan Approved - " + loanAccountNumber);
                psTransaction.executeUpdate();
                psTransaction.close();
                
                message = "Loan approved successfully! Amount credited to customer account.";
                
            } else if("reject".equalsIgnoreCase(action)) {
                newStatus = "Rejected";
                message = "Loan rejected successfully.";
            } else {
                conn.rollback();
                response.sendRedirect("adminLoans.jsp?msg=Invalid action");
                return;
            }
            
            // Update loan status
            psUpdate = conn.prepareStatement("UPDATE loans SET status=? WHERE id=?");
            psUpdate.setString(1, newStatus);
            psUpdate.setInt(2, loanId);
            psUpdate.executeUpdate();
            psUpdate.close();
            
            conn.commit();
            
            response.sendRedirect("adminLoans.jsp?msg=" + message.replace(" ", "+"));
            
        } catch(Exception e) {
            try {
                if(conn != null) conn.rollback();
            } catch(Exception ex) {}
            e.printStackTrace();
            response.sendRedirect("adminLoans.jsp?msg=Error: " + e.getMessage());
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(psCheck != null) psCheck.close(); } catch(Exception e) {}
            try { if(psUpdate != null) psUpdate.close(); } catch(Exception e) {}
            try { if(psCredit != null) psCredit.close(); } catch(Exception e) {}
            try { if(conn != null) { conn.setAutoCommit(true); conn.close(); } } catch(Exception e) {}
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Admin Loan Approval Servlet - Approve or Reject Loan Applications";
    }
}