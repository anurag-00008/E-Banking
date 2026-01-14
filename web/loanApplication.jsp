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
    <title>Loan Application - E-Banking</title>

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
        }

        /* NAVBAR */
        .navbar {
            background: #97144d;
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

        /* CONTAINER */
        .container {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        h2 {
            color: #333;
            margin-bottom: 30px;
            text-align: center;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            color: #555;
            font-weight: 600;
            margin-bottom: 5px;
        }

        input, select, textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        input:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #97144d;
        }

        button {
            width: 100%;
            padding: 12px;
            background: #97144d;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
        }

        .message {
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }

        .success {
            background: #d4edda;
            color: #155724;
        }

        .error {
            background: #f8d7da;
            color: #721c24;
        }

        .info-box {
            background: #f9e7ef;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #97144d;
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
    <h2>Apply for Loan</h2>

    <div class="info-box">
        <strong>Interest Rate:</strong> 10% per annum<br>
    </div>
    <%
        Object msgObj = request.getAttribute("msg");
        if(msgObj != null) {
    %>
        <div class="message <%= msgObj.toString().contains("success") ? "success" : "error" %>">
            <%= msgObj %>
        </div>
    <% } %>

    <form action="LoanApplicationServlet" method="post">

        <div class="form-group">
            <label>Loan Type *</label>
            <select name="loanType" required>
                <option value="">Select Loan Type</option>
                <option value="Home Loan">Home Loan</option>
                <option value="Personal Loan">Personal Loan</option>
                <option value="Education Loan">Education Loan</option>
                <option value="Vehicle Loan">Vehicle Loan</option>
                <option value="Business Loan">Business Loan</option>
            </select>
        </div>

        <div class="form-group">
            <label>Loan Amount (₹) *</label>
            <input type="number" name="loanAmount" step="1000" min="10000" required>
        </div>

        <div class="form-group">
            <label>Tenure (Months) *</label>
            <input type="number" name="tenure" min="6" max="360" required>
        </div>

        <div class="form-group">
            <label>Purpose / Remarks</label>
            <textarea name="remarks" rows="4" placeholder="Optional"></textarea>
        </div>

        <button type="submit">Apply for Loan</button>

    </form>
</div>

</body>
</html>
