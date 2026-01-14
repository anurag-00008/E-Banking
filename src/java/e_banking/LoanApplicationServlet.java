package e_banking;

import java.io.IOException;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "LoanApplicationServlet", urlPatterns = {"/LoanApplicationServlet"})
public class LoanApplicationServlet extends HttpServlet {

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

        if (accountNumber == null) {
            response.sendRedirect("login.jsp?msg=Please login first");
            return;
        }

        // Block check
        if (UserUtils.isBlocked(accountNumber)) {
            request.setAttribute("msg", "Your account is blocked. You cannot apply for a loan. Contact admin.");
            request.getRequestDispatcher("loanApplication.jsp").forward(request, response);
            return;
        }

        String loanType = request.getParameter("loanType");
        String loanAmountStr = request.getParameter("loanAmount");
        String tenureStr = request.getParameter("tenure");
        String remarks = request.getParameter("remarks");

        double loanAmount;
        int tenure;

        try {
            loanAmount = Double.parseDouble(loanAmountStr);
            tenure = Integer.parseInt(tenureStr);

            if (loanAmount <= 0 || tenure <= 0) {
                request.setAttribute("msg", "Loan amount and tenure must be greater than zero");
                request.getRequestDispatcher("loanApplication.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("msg", "Invalid loan amount or tenure");
            request.getRequestDispatcher("loanApplication.jsp").forward(request, response);
            return;
        }

        String prefix = "LN";
        String datePart = new SimpleDateFormat("yyyyMMdd").format(new Date());

        Connection conn = null;
        PreparedStatement psSeq = null;
        PreparedStatement psInsert = null;
        ResultSet rsSeq = null;

        try {
            conn = DBConnection.getConnection();

            // Generate loan account number
            int seq = 1;
            psSeq = conn.prepareStatement(
                "SELECT COUNT(*) AS count FROM loans WHERE loan_account_number LIKE ?"
            );
            psSeq.setString(1, prefix + datePart + "%");
            rsSeq = psSeq.executeQuery();
            if (rsSeq.next()) seq = rsSeq.getInt("count") + 1;

            String loanAccountNumber = prefix + datePart + String.format("%03d", seq);

            // Insert loan with status 'Pending' and fixed interest rate
            psInsert = conn.prepareStatement(
                "INSERT INTO loans (loan_account_number, account_number, loan_type, loan_amount, interest_rate, tenure, remarks, status, paid_amount) VALUES (?,?,?,?,?,?,?,?,?)"
            );
            psInsert.setString(1, loanAccountNumber);
            psInsert.setString(2, accountNumber);
            psInsert.setString(3, loanType);
            psInsert.setDouble(4, loanAmount);
            psInsert.setDouble(5, FIXED_INTEREST_RATE); // store interest rate
            psInsert.setInt(6, tenure);
            psInsert.setString(7, remarks);
            psInsert.setString(8, "Pending");
            psInsert.setDouble(9, 0); // paid amount starts at 0

            int result = psInsert.executeUpdate();
            if(result > 0){
                request.setAttribute("msg", "Loan applied successfully! Loan No: " + loanAccountNumber + ". Wait for admin approval.");
            } else {
                request.setAttribute("msg", "Failed to submit application");
            }

            request.getRequestDispatcher("loanApplication.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "Error occurred. Please try again later.");
            request.getRequestDispatcher("loanApplication.jsp").forward(request, response);
        } finally {
            try { if(rsSeq != null) rsSeq.close(); } catch(Exception e) {}
            try { if(psSeq != null) psSeq.close(); } catch(Exception e) {}
            try { if(psInsert != null) psInsert.close(); } catch(Exception e) {}
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
    }

    @Override
    public String getServletInfo() {
        return "Loan Application Servlet";
    }
}