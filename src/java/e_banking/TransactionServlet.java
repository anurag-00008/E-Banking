package e_banking;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "TransactionServlet", urlPatterns = {"/TransactionServlet"})
public class TransactionServlet extends HttpServlet {

    public static class Transaction {
        public String fromAccount;
        public String toAccount;
        public double amount;
        public String remarks;
        public Timestamp date;

        public Transaction(String fromAccount, String toAccount, double amount, String remarks, Timestamp date) {
            this.fromAccount = fromAccount;
            this.toAccount = toAccount;
            this.amount = amount;
            this.remarks = remarks;
            this.date = date;
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String accountNumber = (String) session.getAttribute("account_number");

        if(accountNumber == null){
            response.sendRedirect("login.jsp?msg=Please login first");
            return;
        }

        List<Transaction> transactions = new ArrayList<Transaction>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement("SELECT * FROM transactions WHERE from_account=? OR to_account=? ORDER BY transaction_date DESC");
            ps.setString(1, accountNumber);
            ps.setString(2, accountNumber);
            rs = ps.executeQuery();
            while(rs.next()){
                transactions.add(new Transaction(
                    rs.getString("from_account"),
                    rs.getString("to_account"),
                    rs.getDouble("amount"),
                    rs.getString("remarks"),
                    rs.getTimestamp("transaction_date")
                ));
            }
            request.setAttribute("transactions", transactions);
            request.getRequestDispatcher("Transaction.jsp").forward(request, response);

        } catch(Exception e){
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?msg=Error loading transactions");
        } finally {
            try{ if(rs!=null) rs.close(); } catch(Exception e){}
            try{ if(ps!=null) ps.close(); } catch(Exception e){}
            try{ if(conn!=null) conn.close(); } catch(Exception e){}
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Transaction Servlet";
    }
}