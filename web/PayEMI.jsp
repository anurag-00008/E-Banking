<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="e_banking.DBConnection" %>
<%
    String accountNumber = (String) session.getAttribute("account_number");
    if(accountNumber == null) {
        response.sendRedirect("login.jsp?msg=Please login first");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pay EMI - E-Banking</title>
    <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f7fa; }
    
    .navbar {
        background: #901c43; /* Updated to Maroon */
        color: white; padding: 15px 30px;
        display: flex; justify-content: space-between; align-items: center;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }
    .navbar a { color: white; text-decoration: none; margin-left: 20px; transition: opacity 0.3s; }
    .navbar a:hover { opacity: 0.8; }

    .container { max-width: 1000px; margin: 30px auto; padding: 0 20px; }
    h2 { color: #333; margin-bottom: 30px; text-align: center; }
    
    .form-card, .loan-card {
        background: white; padding: 30px; border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 20px;
    }
    
    .form-group { margin-bottom: 20px; }
    label { display: block; color: #555; font-weight: 600; margin-bottom: 5px; }
    
    input, select {
        width: 100%; padding: 12px; border: 2px solid #ddd;
        border-radius: 5px; font-size: 14px;
    }
    input:focus, select:focus { outline: none; border-color: #901c43; } /* Updated Focus Color */
    
    button {
        width: 100%; padding: 12px;
        background: #901c43; /* Updated Button Color */
        color: white; border: none; border-radius: 5px;
        font-size: 16px; font-weight: 600; cursor: pointer;
        transition: background 0.3s;
    }
    button:hover {
        background: #7a1538; /* Darker Maroon for Hover Effect */
    }
    
    .message {
        padding: 10px; border-radius: 5px; margin-bottom: 20px; text-align: center;
    }
    .success { background: #d4edda; color: #155724; }
    .error { background: #f8d7da; color: #721c24; }
    
    table { width: 100%; border-collapse: collapse; }
    th {
        background: #901c43; /* Updated Table Header */
        color: white; padding: 12px; text-align: left;
    }
    td { padding: 12px; border-bottom: 1px solid #eee; }
</style>
</head>
<body>
    <div class="navbar">
        <h1>E-Banking</h1>
        <div>
            <a href="dashboard.jsp">Dashboard</a>
            <a href="LogoutServlet">Logout</a>
        </div>
    </div>
    
    <div class="container">
        <h2>Pay EMI</h2>
        
        <% 
            Object msgObj = request.getAttribute("msg");
            if(msgObj != null) { 
        %>
            <div class="message <%= msgObj.toString().contains("success") ? "success" : "error" %>">
                <%= msgObj %>
            </div>
        <% } %>
        
        <!-- Approved Loans List -->
        <div class="loan-card">
            <h3 style="margin-bottom: 20px;">Your Approved Loans</h3>
            <%
                try {
                    Connection conn = DBConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement(
                        "SELECT loan_account_number, loan_type, loan_amount, interest_rate, tenure, paid_amount FROM loans WHERE account_number=? AND status='Approved'"
                    );
                    ps.setString(1, accountNumber);
                    ResultSet rs = ps.executeQuery();
                    
                    boolean hasLoans = false;
                    if(rs.next()) {
                        hasLoans = true;
            %>
                        <table>
                            <thead>
                                <tr>
                                    <th>Loan No.</th>
                                    <th>Type</th>
                                    <th>Amount</th>
                                    <th>Paid</th>
                                    <th>Remaining</th>
                                </tr>
                            </thead>
                            <tbody>
            <%
                        do {
                            String loanNo = rs.getString("loan_account_number");
                            String loanType = rs.getString("loan_type");
                            double principal = rs.getDouble("loan_amount");
                            double rate = rs.getDouble("interest_rate");
                            int tenure = rs.getInt("tenure");
                            double paidAmount = rs.getDouble("paid_amount");
                            
                            double totalInterest = principal * (rate / 100) * (tenure / 12.0);
                            double totalPayable = principal + totalInterest;
                            double remaining = totalPayable - paidAmount;
            %>
                                <tr>
                                    <td><%= loanNo %></td>
                                    <td><%= loanType %></td>
                                    <td>₹ <%= String.format("%.2f", totalPayable) %></td>
                                    <td>₹ <%= String.format("%.2f", paidAmount) %></td>
                                    <td><strong>₹ <%= String.format("%.2f", remaining) %></strong></td>
                                </tr>
            <%
                        } while(rs.next());
            %>
                            </tbody>
                        </table>
            <%
                    }
                    
                    if(!hasLoans) {
            %>
                        <p style="text-align: center; color: #999;">No approved loans found</p>
            <%
                    }
                    
                    rs.close();
                    ps.close();
                    conn.close();
                } catch(Exception e) {
                    e.printStackTrace();
                }
            %>
        </div>
        
        <!-- EMI Payment Form -->
        <div class="form-card">
            <h3 style="margin-bottom: 20px;">Pay EMI</h3>
            <form action="PayEMIServlet" method="post">
                <div class="form-group">
                    <label>Loan Account Number *</label>
                    <input type="text" name="loanAccountNumber" placeholder="e.g., LN20240101001" required>
                </div>
                
                <div class="form-group">
                    <label>EMI Amount (₹) *</label>
                    <input type="number" name="emiAmount" step="0.01" min="1" required>
                </div>
                
                <button type="submit">Pay EMI</button>
            </form>
        </div>
    </div>
</body>
</html>