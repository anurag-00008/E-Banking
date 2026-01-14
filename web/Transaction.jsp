<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="e_banking.TransactionServlet.Transaction" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    String accountNumber = (String) session.getAttribute("account_number");
    if(accountNumber == null){
        response.sendRedirect("login.jsp?msg=Please login first");
        return;
    }

    @SuppressWarnings("unchecked")
    List<Transaction> transactions =
        (List<Transaction>) request.getAttribute("transactions");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Transaction History</title>

<style>
    *{
        margin:0;
        padding:0;
        box-sizing:border-box;
        font-family:Segoe UI, Arial, sans-serif;
    }

    body{
        background:#f5f7fa;
    }

    /* NAVBAR */
    .navbar{
        background:#97144d;
        color:white;
        padding:16px 40px;
        display:flex;
        justify-content:space-between;
        align-items:center;
    }

    .navbar h1{
        font-size:22px;
        font-weight:600;
    }

    .navbar a{
        color:white;
        text-decoration:none;
        margin-left:20px;
        font-size:14px;
    }

    /* CONTENT */
    .content{
        width:80%;
        margin:40px auto;
    }

    .title{
        text-align:center;
        font-size:18px;
        font-weight:600;
        color:#333;
        margin-bottom:10px;
    }

    .title-line{
        width:220px;
        height:2px;
        background:#97144d;
        margin:0 auto 25px auto;
    }

    /* TABLE */
    table{
        width:100%;
        border-collapse:collapse;
        background:white;
        border:1px solid #97144d;
    }

    th{
        background:#f3e1ea;
        color:#333;
        padding:12px;
        border-bottom:2px solid #97144d;
        font-size:14px;
        text-align:left;
    }

    td{
        padding:12px;
        border-bottom:1px solid #ddd;
        font-size:14px;
    }

    .credit{
        color:green;
        font-weight:600;
    }

    .debit{
        color:red;
        font-weight:600;
    }
</style>
</head>

<body>

<!-- NAVBAR -->
<div class="navbar">
    <h1>E-Banking</h1>
    <div>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="LogoutServlet">Logout</a>
    </div>
</div>

<!-- CONTENT -->
<div class="content">

    <div class="title">Transaction History</div>
    <div class="title-line"></div>

    <table>
        <tr>
            <th>Date</th>
            <th>From Account</th>
            <th>To Account</th>
            <th>Amount</th>
            <th>Remarks</th>
        </tr>

        <%
            if(transactions != null && !transactions.isEmpty()){
                SimpleDateFormat sdf =
                    new SimpleDateFormat("dd-MMM-yyyy hh:mm a");

                for(Transaction t : transactions){
                    boolean isCredit =
                        t.toAccount.equals(accountNumber);
        %>
        <tr>
            <td><%= sdf.format(t.date) %></td>
            <td><%= t.fromAccount %></td>
            <td><%= t.toAccount %></td>
            <td class="<%= isCredit ? "credit" : "debit" %>">
                <%= isCredit ? "+" : "-" %>₹ <%= String.format("%.2f", t.amount) %>
            </td>
            <td><%= t.remarks != null ? t.remarks : "-" %></td>
        </tr>
        <%
                }
            }
        %>
    </table>

</div>

</body>
</html>
