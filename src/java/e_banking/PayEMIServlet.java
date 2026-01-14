package e_banking;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "PayEMIServlet", urlPatterns = {"/PayEMIServlet"})
public class PayEMIServlet extends HttpServlet {
    private static final double FIXED_INTEREST_RATE = 10.0; // 10% per annum

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
        String accountNumber = (String) session.getAttribute("account_number");

        if(accountNumber == null){
            response.sendRedirect("login.jsp?msg=Please login first");
            return;
        }

        String loanAccountNumber = request.getParameter("loanAccountNumber");
        double emiAmount = Double.parseDouble(request.getParameter("emiAmount"));

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Check user balance
            ps = conn.prepareStatement("SELECT balance FROM users WHERE account_number=?");
            ps.setString(1, accountNumber);
            rs = ps.executeQuery();
            if(!rs.next()){
                request.setAttribute("msg", "Account not found.");
                request.getRequestDispatcher("PayEMI.jsp").forward(request, response);
                return;
            }
            double balance = rs.getDouble("balance");
            rs.close(); ps.close();

            if(balance < emiAmount){
                request.setAttribute("msg", "Insufficient balance.");
                request.getRequestDispatcher("PayEMI.jsp").forward(request, response);
                return;
            }

            // Get loan details
            ps = conn.prepareStatement(
                "SELECT loan_amount, paid_amount, tenure FROM loans " +
                "WHERE loan_account_number=? AND account_number=? AND status='Approved'"
            );
            ps.setString(1, loanAccountNumber);
            ps.setString(2, accountNumber);
            rs = ps.executeQuery();
            if(!rs.next()){
                request.setAttribute("msg", "Loan not found or not approved.");
                request.getRequestDispatcher("PayEMI.jsp").forward(request, response);
                return;
            }
            double principal = rs.getDouble("loan_amount");
            double paidAmount = rs.getDouble("paid_amount");
            int tenure = rs.getInt("tenure"); // months
            rs.close(); ps.close();

            // Calculate total interest
            double totalInterest = principal * (FIXED_INTEREST_RATE / 100) * (tenure / 12.0);
            double totalPayable = principal + totalInterest;
            double remainingAmount = totalPayable - paidAmount;

            if(emiAmount > remainingAmount){
                request.setAttribute("msg", "EMI cannot exceed remaining balance Rs." + String.format("%.2f", remainingAmount));
                request.getRequestDispatcher("PayEMI.jsp").forward(request, response);
                return;
            }

            // Deduct EMI from user balance
            ps = conn.prepareStatement("UPDATE users SET balance = balance - ? WHERE account_number=?");
            ps.setDouble(1, emiAmount);
            ps.setString(2, accountNumber);
            ps.executeUpdate();
            ps.close();

            // Update loan paid_amount
            ps = conn.prepareStatement("UPDATE loans SET paid_amount = paid_amount + ? WHERE loan_account_number=?");
            ps.setDouble(1, emiAmount);
            ps.setString(2, loanAccountNumber);
            ps.executeUpdate();
            ps.close();

            // Insert transaction
            ps = conn.prepareStatement(
                "INSERT INTO transactions (from_account, to_account, amount, remarks) VALUES (?,?,?,?)"
            );
            ps.setString(1, accountNumber);
            ps.setString(2, loanAccountNumber);
            ps.setDouble(3, emiAmount);
            ps.setString(4, "EMI Payment (Interest + Principal)");
            ps.executeUpdate();
            ps.close();

            conn.commit();

            double remainingAfterPayment = remainingAmount - emiAmount;
            request.setAttribute("msg", "EMI Rs." + emiAmount + " paid successfully. Remaining amount: Rs." + String.format("%.2f", remainingAfterPayment));
            request.getRequestDispatcher("PayEMI.jsp").forward(request, response);

        } catch(Exception e){
            try { if(conn!=null) conn.rollback(); } catch(Exception ex){}
            e.printStackTrace();
            request.setAttribute("msg", "Error occurred during EMI payment.");
            request.getRequestDispatcher("PayEMI.jsp").forward(request, response);
        } finally {
            try{ if(rs!=null) rs.close(); } catch(Exception e){}
            try{ if(ps!=null) ps.close(); } catch(Exception e){}
            try{ if(conn!=null) { conn.setAutoCommit(true); conn.close(); } } catch(Exception e){}
        }
    }

    @Override
    public String getServletInfo() {
        return "Pay EMI Servlet";
    }
}