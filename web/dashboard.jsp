<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="e_banking.DBConnection" %>

<%
    String accountNumber = (String) session.getAttribute("account_number");
    String name = (String) session.getAttribute("name");

    if (accountNumber == null) {
        response.sendRedirect("login.jsp?msg=Please login first");
        return;
    }

    double balance = 0;
    String email = "";
    String phone = "";
    String accountType = "";

    try {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(
            "SELECT balance, email, phone, account_type FROM users WHERE account_number=?"
        );
        ps.setString(1, accountNumber);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            balance = rs.getDouble("balance");
            email = rs.getString("email");
            phone = rs.getString("phone");
            accountType = rs.getString("account_type");
        }

        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - E-Banking</title>

    <style>
        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
            font-family:"Segoe UI", Arial, sans-serif;
        }

        body{
            background:#f1f3f6;
        }

        /* NAVBAR */
        .navbar{
            height:60px;
            background:#97144d;
            color:#fff;
            display:flex;
            align-items:center;
            justify-content:space-between;
            padding:0 30px;
        }

        .navbar h2{
            font-size:20px;
            font-weight:500;
        }

        .navbar a{
            color:white;
            text-decoration:none;
            background:#b71c6d;
            padding:7px 14px;
            border-radius:4px;
            font-size:14px;
        }

        /* LAYOUT */
        .dashboard{
            display:flex;
            min-height:calc(100vh - 60px);
        }

        /* SIDEBAR */
        .sidebar{
            width:230px;
            background:#ffffff;
            border-right:1px solid #ddd;
            padding:20px;
            transition:0.3s ease;
        }

        .sidebar h3{
            font-size:15px;
            margin-bottom:15px;
            color:#666;
        }

        .sidebar a{
            display:block;
            padding:10px 12px;
            margin-bottom:8px;
            text-decoration:none;
            color:#333;
            font-size:14px;
            border-radius:4px;
        }

        .sidebar a:hover{
            background:#f3e5f5;
            color:#9c1458;
        }

        /* MAIN */
        .main{
            flex:1;
            padding:30px;
            transition:0.3s ease;
        }

        /* ACCOUNT DETAILS */
        .account-box{
            background:#ffffff;
            padding:25px;
            border-radius:4px;
        }

        .account-box h3{
            font-size:16px;
            color:#333;
            margin-bottom:20px;
            border-bottom:1px solid #ddd;
            padding-bottom:8px;
        }

        .detail-row{
            display:flex;
            justify-content:space-between;
            padding:12px 0;
            border-bottom:1px solid #eee;
            font-size:14px;
        }

        .detail-row span{
            color:#777;
        }

        .detail-row strong{
            color:#333;
        }

        /* BALANCE STRIP */
        .balance-strip{
            background:#ffffff;
            border-left:5px solid #9c1458;
            padding:25px;
            margin-top:25px;
            border-radius:4px;
            display:flex;
            flex-direction:column;
            align-items:center;
        }

        .balanceHeading{
            font-size:14px;
            color:#777;
        }

        .balanceAmount{
            font-size:32px;
            color:#9c1458;
            margin-top:8px;
        }

        /* TOGGLE */
        .toggle-btn{
            font-size:22px;
            cursor:pointer;
        }

        .sidebar.collapsed{
            width:70px;
        }

        .sidebar.collapsed h3{
            display:none;
        }

        .sidebar.collapsed a span{
            display:none;
        }

        .sidebar.collapsed a{
            text-align:center;
            font-size:18px;
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<div class="navbar">
    <div style="display:flex;align-items:center;gap:15px;">
        <span class="toggle-btn" onclick="toggleSidebar()">☰</span>
        <h2>Dashboard</h2>
    </div>
    <div>
        Welcome, <%= name %> |
        <a href="LogoutServlet">Logout</a>
    </div>
</div>

<!-- DASHBOARD -->
<div class="dashboard">

    <!-- SIDEBAR -->
    <div class="sidebar">
        <h3>Menu</h3>

        
        <a href="fundtransfer.jsp"><span>Fund Transfer</span></a>
        <a href="TransactionServlet"><span>Transactions</span></a>
        <a href="loanApplication.jsp"><span>Loans</span></a>
        <a href="PayEMI.jsp"><span>Pay EMI</span></a>
        <a href="UpdateAccount.jsp"><span>Profile</span></a>
        <a href="ChangePassword.jsp"><span>Change Password</span></a>
        <a href="feedback.jsp"><span>Feedback</span></a>
    </div>

    <!-- MAIN CONTENT -->
    <div class="main">

        <div class="account-box">
            <h3>Account Information</h3>

            <div class="detail-row">
                <span>Account Number</span>
                <strong><%= accountNumber %></strong>
            </div>

            <div class="detail-row">
                <span>Account Type</span>
                <strong><%= accountType %></strong>
            </div>

            <div class="detail-row">
                <span>Email</span>
                <strong><%= email %></strong>
            </div>

            <div class="detail-row">
                <span>Phone</span>
                <strong><%= phone %></strong>
            </div>
        </div>

        <div class="balance-strip">
            <div class="balanceHeading">Available Balance</div>
            <div class="balanceAmount">
                ₹ <%= String.format("%.2f", balance) %>
            </div>
        </div>

    </div>
</div>

<script>
function toggleSidebar(){
    document.querySelector('.sidebar').classList.toggle('collapsed');
}
</script>

</body>
</html>
