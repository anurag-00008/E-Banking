<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="e_banking.DBConnection" %>
<%
    String adminUsername = (String) session.getAttribute("admin_username");
    if(adminUsername == null) {
        response.sendRedirect("adminLogin.jsp?msg=Please login first");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Loan Management - Admin</title>
    <style>
    /* Global Reset & Font */
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { 
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
        background: #f5f7fa; /* Matches the light gray background in the image */
        color: #333;
    }

    /* Navbar - Updated to Maroon */
    .navbar {
        background: #901c43; /* The specific maroon color from your screenshot */
        color: white; 
        padding: 15px 30px;
        display: flex; 
        justify-content: space-between; 
        align-items: center;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }
    .navbar h1 { font-size: 1.2rem; font-weight: bold; }
    .navbar a { 
        color: white; 
        text-decoration: none; 
        margin-left: 20px; 
        font-size: 14px; 
        opacity: 0.9; 
        transition: opacity 0.3s; 
    }
    .navbar a:hover { opacity: 1; }

    /* Layout Container */
    .container { max-width: 1400px; margin: 30px auto; padding: 0 20px; }
    h2 { color: #333; margin-bottom: 30px; text-align: center; }

    /* Alerts / Messages */
    .message {
        padding: 15px; border-radius: 5px; margin-bottom: 20px; text-align: center;
    }
    .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
    .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

    /* Stats Grid */
    .stats-grid {
        display: grid; 
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 20px; 
        margin-bottom: 30px;
    }
    .stat-card {
        background: white; 
        padding: 25px; 
        border-radius: 8px; /* Slightly sharper corners like the image form */
        box-shadow: 0 2px 10px rgba(0,0,0,0.05); /* Softer shadow */
        text-align: center;
    }
    .stat-card h3 {
        color: #666; 
        font-size: 14px; 
        margin-bottom: 10px;
    }
    .stat-card .value {
        font-size: 32px; 
        font-weight: bold; 
        color: #901c43; /* Updated to match Brand Maroon */
    }

    /* Filters */
    .filter-section {
        background: white; 
        padding: 20px; 
        border-radius: 8px; 
        margin-bottom: 20px; 
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    .filter-section select {
        padding: 10px; 
        border: 1px solid #ccc; /* Thinner border like the input fields in image */
        border-radius: 4px; 
        font-size: 14px;
        outline: none;
    }
    .filter-section select:focus {
        border-color: #901c43; /* Highlights in Maroon */
    }

    /* Tables */
    .table-container {
        background: white; 
        border-radius: 8px; 
        box-shadow: 0 2px 10px rgba(0,0,0,0.05); 
        overflow-x: auto;
    }
    table { width: 100%; border-collapse: collapse; }
    
    th {
        background: #901c43; /* Header background updated to Maroon */
        color: white; 
        padding: 15px; 
        text-align: left;
        font-weight: 500;
    }
    td { padding: 15px; border-bottom: 1px solid #eee; color: #444; }

    /* Status Indicators */
    .status-pending { color: #d97706; font-weight: 600; }
    .status-approved { color: #059669; font-weight: 600; }
    .status-rejected { color: #dc2626; font-weight: 600; }

    /* Buttons */
    .btn {
        padding: 8px 16px; 
        border: none; 
        border-radius: 4px; 
        cursor: pointer; 
        font-size: 14px; 
        margin-right: 5px; 
        transition: all 0.3s; 
        font-weight: 600;
        color: white;
    }
    /* Primary Action Button (Matches the 'Transfer' button in image) */
    .btn-primary {
        background: #901c43;
        color: white;
    }
    .btn-primary:hover {
        background: #7a1538;
    }

    /* Semantic Buttons (Keep these distinct for Admin actions) */
    .btn-approve {
        background: #10b981; /* Fresh Green */
    }
    .btn-approve:hover {
        background: #059669;
        transform: translateY(-1px);
    }
    .btn-reject {
        background: #ef4444; /* Bright Red */
    }
    .btn-reject:hover {
        background: #dc2626;
        transform: translateY(-1px);
    }
</style>
</head>
<body>
    <div class="navbar">
        <h1>Cashy Bank</h1>
        <div>
            <a href="adminDashboard.jsp">Dashboard</a>
            <a href="AdminLogoutServlet">Logout</a>
        </div>
    </div>
    
    <div class="container">
        <h2>Loan Management & Approval</h2>
        
        <% 
            String msg = request.getParameter("msg");
            if(msg != null) { 
        %>
            <div class="message <%= msg.contains("success") || msg.contains("approved") || msg.contains("credited") ? "success" : "error" %>">
                <%= msg.replace("+", " ") %>
            </div>
        <% } %>
        
        <%
            int totalLoans = 0, pendingLoans = 0, approvedLoans = 0, rejectedLoans = 0;
            double totalLoanAmount = 0;
            
            try {
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(
                    "SELECT status, COUNT(*) as count, SUM(loan_amount) as total FROM loans GROUP BY status"
                );
                ResultSet rs = ps.executeQuery();
                
                while(rs.next()) {
                    String status = rs.getString("status");
                    int count = rs.getInt("count");
                    double amount = rs.getDouble("total");
                    totalLoans += count;
                    totalLoanAmount += amount;
                    
                    if("Pending".equals(status)) pendingLoans = count;
                    if("Approved".equals(status)) approvedLoans = count;
                    if("Rejected".equals(status)) rejectedLoans = count;
                }
                rs.close();
                ps.close();
                conn.close();
            } catch(Exception e) {
                e.printStackTrace();
            }
        %>
        
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Loan Applications</h3>
                <div class="value"><%= totalLoans %></div>
            </div>
            <div class="stat-card">
                <h3>Pending Approval</h3>
                <div class="value" style="color: #ffc107;"><%= pendingLoans %></div>
            </div>
            <div class="stat-card">
                <h3>Approved</h3>
                <div class="value" style="color: #28a745;"><%= approvedLoans %></div>
            </div>
            <div class="stat-card">
                <h3>Rejected</h3>
                <div class="value" style="color: #dc3545;"><%= rejectedLoans %></div>
            </div>
            <div class="stat-card">
                <h3>Total Loan Amount</h3>
                <div class="value" style="font-size: 20px;">₹ <%= String.format("%.0f", totalLoanAmount) %></div>
            </div>
        </div>
        
        <div class="filter-section">
            <label style="font-weight: 600; margin-right: 10px;">Filter by Status:</label>
            <select id="statusFilter" onchange="filterTable()">
                <option value="all">All Loans</option>
                <option value="Pending">Pending</option>
                <option value="Approved">Approved</option>
                <option value="Rejected">Rejected</option>
            </select>
        </div>
        
        <div class="table-container">
            <%
                try {
                    Connection conn = DBConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement(
                        "SELECT l.id, l.loan_account_number, l.account_number, u.name, l.loan_type, " +
                        "l.loan_amount, l.interest_rate, l.tenure, l.remarks, l.status, l.created_at " +
                        "FROM loans l " +
                        "JOIN users u ON l.account_number = u.account_number " +
                        "ORDER BY l.created_at DESC"
                    );
                    ResultSet rs = ps.executeQuery();
                    
                    if(rs.next()) {
            %>
                        <table id="loanTable">
                            <thead>
                                <tr>
                                    <th>Loan No.</th>
                                    <th>Account No.</th>
                                    <th>Customer Name</th>
                                    <th>Type</th>
                                    <th>Amount</th>
                                    <th>Rate</th>
                                    <th>Tenure</th>
                                    <th>Remarks</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
            <%
                        do {
                            int id = rs.getInt("id");
                            String loanNo = rs.getString("loan_account_number");
                            String accountNo = rs.getString("account_number");
                            String customerName = rs.getString("name");
                            String loanType = rs.getString("loan_type");
                            double amount = rs.getDouble("loan_amount");
                            double rate = rs.getDouble("interest_rate");
                            int tenure = rs.getInt("tenure");
                            String remarks = rs.getString("remarks");
                            String status = rs.getString("status");
                            
                            String statusClass = "status-pending";
                            if(status.equals("Approved")) statusClass = "status-approved";
                            if(status.equals("Rejected")) statusClass = "status-rejected";
            %>
                                <tr data-status="<%= status %>">
                                    <td><%= loanNo %></td>
                                    <td><%= accountNo %></td>
                                    <td><%= customerName %></td>
                                    <td><%= loanType %></td>
                                    <td>₹ <%= String.format("%.2f", amount) %></td>
                                    <td><%= rate %>%</td>
                                    <td><%= tenure %> months</td>
                                    <td><%= remarks != null ? remarks : "-" %></td>
                                    <td class="<%= statusClass %>"><%= status %></td>
                                    <td>
                                        <% if("Pending".equals(status)) { %>
                                            <a href="ApproveLoanServlet?action=approve&id=<%= id %>"
                                               onclick="return confirm('Approve this loan? Amount will be credited to customer account.');">
                                                <button class="btn btn-approve">✓ Approve</button>
                                            </a>
                                            <a href="ApproveLoanServlet?action=reject&id=<%= id %>"
                                               onclick="return confirm('Reject this loan application?');">
                                                <button class="btn btn-reject">✗ Reject</button>
                                            </a>
                                        <% } else { %>
                                            <span style="color: #999;">-</span>
                                        <% } %>
                                    </td>
                                </tr>
            <%
                        } while(rs.next());
            %>
                            </tbody>
                        </table>
            <%
                    } else {
            %>
                        <div style="text-align: center; padding: 50px; color: #999;">
                            <h3>No loans found</h3>
                        </div>
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
    </div>
    
    <script>
        function filterTable() {
            var filter = document.getElementById("statusFilter").value;
            var table = document.getElementById("loanTable");
            if(!table) return;
            
            var rows = table.getElementsByTagName("tbody")[0].getElementsByTagName("tr");
            
            for(var i = 0; i < rows.length; i++) {
                var status = rows[i].getAttribute("data-status");
                if(filter === "all" || status === filter) {
                    rows[i].style.display = "";
                } else {
                    rows[i].style.display = "none";
                }
            }
        }
    </script>
</body>
</html>