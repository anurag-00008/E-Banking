<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="e_banking.DBConnection" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    String adminUsername = (String) session.getAttribute("admin_username");
    if(adminUsername == null) {
        response.sendRedirect("adminLogin.jsp?msg=Please login first");
        return;
    }

    // --- 1. CAPTURE FILTER PARAMETERS ---
    String pFromAccount = request.getParameter("fromAccount");
    String pToAccount = request.getParameter("toAccount");
    String pDateFrom = request.getParameter("dateFrom");
    String pDateTo = request.getParameter("dateTo");

    // Helper to keep nulls as empty strings for the input values
    String valFromAccount = (pFromAccount == null) ? "" : pFromAccount;
    String valToAccount = (pToAccount == null) ? "" : pToAccount;
    String valDateFrom = (pDateFrom == null) ? "" : pDateFrom;
    String valDateTo = (pDateTo == null) ? "" : pDateTo;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Transactions - Admin</title>
    <style>
        /* Global Reset & Typography */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f7fa; color: #333; }

        /* Navbar */
        .navbar { background: #901c43; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .navbar h1 { font-size: 24px; font-weight: bold; }
        .navbar a { color: white; text-decoration: none; margin-left: 20px; padding: 8px 15px; border-radius: 4px; transition: background 0.3s; font-size: 14px; }
        .navbar a:hover { background: rgba(255,255,255,0.2); }

        /* Layout */
        .container { max-width: 1400px; margin: 30px auto; padding: 0 20px; }
        h2 { color: #333; margin-bottom: 30px; text-align: center; }

        /* Stats Grid */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); text-align: center; }
        .stat-card h3 { color: #666; font-size: 14px; margin-bottom: 10px; }
        .stat-card .value { font-size: 32px; font-weight: bold; color: #901c43; }

        /* Filters */
        .filter-section { background: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .filter-form { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; align-items: end; }
        .filter-group { display: flex; flex-direction: column; }
        .filter-group label { font-weight: 600; margin-bottom: 8px; color: #333; font-size: 14px; }
        .filter-group input { padding: 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; outline: none; }
        .filter-group input:focus { border-color: #901c43; }
        
        /* Buttons */
        .btn-filter { padding: 10px 20px; background: #901c43; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: 600; font-size: 14px; transition: background 0.3s; }
        .btn-filter:hover { background: #7a1538; transform: translateY(-1px); }
        
        .btn-reset { padding: 10px 20px; background: #6c757d; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: 600; font-size: 14px; text-decoration: none; text-align: center; }
        .btn-reset:hover { background: #5a6268; }

        /* Table Styling */
        .table-container { background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #901c43; color: white; padding: 15px; text-align: left; font-weight: 600; white-space: nowrap; }
        td { padding: 15px; border-bottom: 1px solid #eee; color: #444; font-size: 14px; }
        tr:hover { background: #fcfcfc; }

        /* Monetary Values */
        .amount-positive { color: #10b981; font-weight: 600; }
        .no-data { text-align: center; padding: 60px; color: #999; }
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
        <h2> All Transactions</h2>
        
        <%
            int totalTransactions = 0;
            double totalAmount = 0;
            int todayCount = 0;
            double todayAmount = 0;
            
            try {
                Connection conn = DBConnection.getConnection();
                
                // Stats Logic
                PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) as count, SUM(amount) as total FROM transactions");
                ResultSet rs1 = ps1.executeQuery();
                if(rs1.next()) {
                    totalTransactions = rs1.getInt("count");
                    totalAmount = rs1.getDouble("total");
                    // Handle null sum
                    if(rs1.wasNull()) totalAmount = 0;
                }
                rs1.close();
                ps1.close();
                
                PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) as count, SUM(amount) as total FROM transactions WHERE TRUNC(transaction_date) = TRUNC(SYSDATE)");
                ResultSet rs2 = ps2.executeQuery();
                if(rs2.next()) {
                    todayCount = rs2.getInt("count");
                    todayAmount = rs2.getDouble("total");
                    if(rs2.wasNull()) todayAmount = 0;
                }
                rs2.close();
                ps2.close();
                conn.close();
            } catch(Exception e) {
                e.printStackTrace();
            }
        %>
        
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Transactions</h3>
                <div class="value"><%= totalTransactions %></div>
            </div>
            <div class="stat-card">
                <h3>Total Amount</h3>
                <div class="value">₹ <%= String.format("%.2f", totalAmount) %></div>
            </div>
            <div class="stat-card">
                <h3>Today's Transactions</h3>
                <div class="value" style="color: #28a745;"><%= todayCount %></div>
            </div>
            <div class="stat-card">
                <h3>Today's Amount</h3>
                <div class="value" style="color: #28a745;">₹ <%= String.format("%.2f", todayAmount) %></div>
            </div>
        </div>
        
        <div class="filter-section">
            <form action="" method="GET" class="filter-form">
                <div class="filter-group">
                    <label for="fromAccount">From Account</label>
                    <input type="text" id="fromAccount" name="fromAccount" value="<%= valFromAccount %>" placeholder="Enter account number">
                </div>

                <div class="filter-group">
                    <label for="toAccount">To Account</label>
                    <input type="text" id="toAccount" name="toAccount" value="<%= valToAccount %>" placeholder="Enter account number">
                </div>

                <div class="filter-group">
                    <label for="dateFrom">Date From</label>
                    <input type="date" id="dateFrom" name="dateFrom" value="<%= valDateFrom %>">
                </div>

                <div class="filter-group">
                    <label for="dateTo">Date To</label>
                    <input type="date" id="dateTo" name="dateTo" value="<%= valDateTo %>">
                </div>

                <div class="filter-group" style="flex-direction: row; gap: 10px;">
                    <button type="submit" class="btn-filter">Apply Filter</button>
                    <a href="allTransactions.jsp" class="btn-reset">Reset</a>
                </div>
            </form>
        </div>
        
        <div class="table-container">
            <%
                try {
                    Connection conn = DBConnection.getConnection();
                    
                    // --- 2. BUILD DYNAMIC QUERY ---
                    StringBuilder query = new StringBuilder("SELECT t.id, t.from_account, t.to_account, t.amount, t.remarks, t.transaction_date ");
                    query.append("FROM transactions t WHERE 1=1 "); // 1=1 allows easy appending of AND clauses
                    
                    List<Object> params = new ArrayList<>();
                    
                    if(valFromAccount != null && !valFromAccount.trim().isEmpty()) {
                        query.append("AND LOWER(t.from_account) LIKE ? ");
                        params.add("%" + valFromAccount.toLowerCase() + "%");
                    }
                    
                    if(valToAccount != null && !valToAccount.trim().isEmpty()) {
                        query.append("AND LOWER(t.to_account) LIKE ? ");
                        params.add("%" + valToAccount.toLowerCase() + "%");
                    }
                    
                    // Date Filter: >= Start Date
                    if(valDateFrom != null && !valDateFrom.isEmpty()) {
                        // Assuming Oracle DB, using TO_DATE
                        query.append("AND TRUNC(t.transaction_date) >= TO_DATE(?, 'YYYY-MM-DD') ");
                        params.add(valDateFrom);
                    }
                    
                    // Date Filter: <= End Date
                    if(valDateTo != null && !valDateTo.isEmpty()) {
                        query.append("AND TRUNC(t.transaction_date) <= TO_DATE(?, 'YYYY-MM-DD') ");
                        params.add(valDateTo);
                    }
                    
                    query.append("ORDER BY t.transaction_date DESC");
                    
                    PreparedStatement ps = conn.prepareStatement(query.toString());
                    
                    // Set parameters dynamically
                    for(int i=0; i<params.size(); i++) {
                        ps.setObject(i+1, params.get(i));
                    }
                    
                    ResultSet rs = ps.executeQuery();
                    
                    boolean hasRecords = false;
                    if(rs.next()) {
                        hasRecords = true;
                        SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy hh:mm a");
            %>
                        <table>
                            <thead>
                                <tr>
                                    <th>Transaction ID</th>
                                    <th>From Account</th>
                                    <th>To Account</th>
                                    <th>Amount</th>
                                    <th>Remarks</th>
                                    <th>Transaction Date</th>
                                </tr>
                            </thead>
                            <tbody>
            <%
                        do {
                            int id = rs.getInt("id");
                            String fromAccount = rs.getString("from_account");
                            String toAccount = rs.getString("to_account");
                            double amount = rs.getDouble("amount");
                            String remarks = rs.getString("remarks");
                            Timestamp transactionDate = rs.getTimestamp("transaction_date");
            %>
                                <tr>
                                    <td>#<%= id %></td>
                                    <td><%= fromAccount %></td>
                                    <td><%= toAccount %></td>
                                    <td class="amount-positive">₹ <%= String.format("%.2f", amount) %></td>
                                    <td><%= remarks != null ? remarks : "-" %></td>
                                    <td><%= transactionDate != null ? sdf.format(transactionDate) : "-" %></td>
                                </tr>
            <%
                        } while(rs.next());
            %>
                            </tbody>
                        </table>
            <%
                    }
                    
                    if(!hasRecords) {
            %>
                        <div class="no-data">
                            <h3>No Transactions Found</h3>
                            <p>Try adjusting your filters to see results</p>
                        </div>
            <%
                    }
                    
                    rs.close();
                    ps.close();
                    conn.close();
                } catch(Exception e) {
                    e.printStackTrace();
                    out.println("<div class='no-data'><h3>Error loading data</h3><p>" + e.getMessage() + "</p></div>");
                }
            %>
        </div>
    </div>
</body>
</html>