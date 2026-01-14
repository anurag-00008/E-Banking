<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <title>Fund Transfer - E-Banking</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
        }
        .navbar {
            background: linear-gradient(135deg, #97144d);
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar a {
            color: white;
            text-decoration: none;
            margin-left: 20px;
        }
        .container {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h2 { color: #333; margin-bottom: 30px; text-align: center; }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            color: #555;
            font-weight: 600;
            margin-bottom: 5px;
        }
        input, textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        input:focus, textarea:focus {
            outline: none;
            border-color: #667eea;
        }
        button {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #97144d);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
        }
        button:hover { transform: translateY(-2px); }
        .message {
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
        .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .balance-display {
            background: #e7f3ff;
            padding: 15px;
            border-radius: 5px;
            text-align: center;
            margin-bottom: 20px;
            border: 2px solid #667eea;
        }
        .balance-display h3 {
            color: #667eea;
            margin-bottom: 5px;
        }
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
        <h2>Fund Transfer</h2>
        
        <% 
            Object msgObj = request.getAttribute("msg");
            Object balanceObj = request.getAttribute("balance");
            if(msgObj != null) { 
        %>
            <div class="message <%= msgObj.toString().contains("success") ? "success" : "error" %>">
                <%= msgObj %>
            </div>
        <% } %>
        
        <% if(balanceObj != null) { %>
            <div class="balance-display">
                <h3>Updated Balance</h3>
                <div style="font-size: 24px; font-weight: bold; color: #333;">
                    ₹ <%= String.format("%.2f", (Double)balanceObj) %>
                </div>
            </div>
        <% } %>
        
        <form action="FundTransferServlet" method="post">
            <div class="form-group">
                <label>From Account</label>
                <input type="text" name="fromAccount" value="<%= accountNumber %>" readonly>
            </div>
            
            <div class="form-group">
                <label>To Account Number *</label>
                <input type="text" name="toAccount" required>
            </div>
            
            <div class="form-group">
                <label>Amount *</label>
                <input type="number" name="amount" step="0.01" min="1" required>
            </div>
            
            <div class="form-group">
                <label>Remarks</label>
                <textarea name="remarks" rows="3" placeholder="Optional"></textarea>
            </div>
            
            <button type="submit">Transfer</button>
        </form>
    </div>
</body>
</html>