<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Security Check
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
    <title>Admin Dashboard - E-Banking</title>

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
            background:#97144d; /* Maroon Brand Color */
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

        /* ADMIN PROFILE BOX (Matches Account Box) */
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

        /* STATUS STRIP (Matches Balance Strip) */
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
            font-size:24px; /* Slightly smaller than currency to fit text */
            color:#9c1458;
            margin-top:8px;
            font-weight: bold;
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

<div class="navbar">
    <div style="display:flex;align-items:center;gap:15px;">
        <span class="toggle-btn" onclick="toggleSidebar()">☰</span>
        <h2>Dashboard</h2>
    </div>
    <div>
        Welcome, <%= adminUsername %> |
        <a href="AdminLogoutServlet">Logout</a>
    </div>
</div>

<div class="dashboard">

    <div class="sidebar">
        <h3>Management</h3>

        <a href="adminUsers.jsp"><span>User Management</span></a>
        <a href="adminLoans.jsp"><span>Loan Management</span></a>
        <a href="adminTransactions.jsp"><span>All Transactions</span></a>
        <a href="adminFeedback.jsp"><span>Feedback</span></a>
    </div>

    <div class="main">

        <div class="account-box">
            <h3>Admin Profile</h3>

            <div class="detail-row">
                <span>Username</span>
                <strong><%= adminUsername %></strong>
            </div>

            <div class="detail-row">
                <span>Role</span>
                <strong>Super Administrator</strong>
            </div>

            <div class="detail-row">
                <span>Access Level</span>
                <strong>Full Control</strong>
            </div>
            <div class="detail-row">
                <span>Security</span>
                <strong>Highly Secure</strong>
            </div>
        </div>

        <div class="balance-strip">
            <div class="balanceHeading">System Status</div>
            <div class="balanceAmount">
                Operational 
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