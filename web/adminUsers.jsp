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
<title>User Management | Cashy Bank Admin</title>

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

body{
    background:#f4f6f9;
    color:#333;
}

/* ===== NAVBAR ===== */
.navbar{
    background:#97144d;
    color:#fff;
    padding:16px 40px;
    display:flex;
    justify-content:space-between;
    align-items:center;
    box-shadow:0 4px 12px rgba(0,0,0,0.12);
}

.navbar h1{
    font-size:22px;
    font-weight:700;
    letter-spacing:0.5px;
}

.navbar a{
    color:#fff;
    text-decoration:none;
    margin-left:24px;
    font-size:14px;
    font-weight:500;
    opacity:0.9;
}

.navbar a:hover{
    opacity:1;
}

/* ===== CONTAINER ===== */
.container{
    max-width:1250px;
    margin:40px auto;
    padding:0 24px;
}

/* PAGE HEADER */
.page-header{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:28px;
}

.page-header h2{
    font-size:26px;
    color:#97144d;
    font-weight:700;
}

/* ===== TABLE CARD ===== */
.table-card{
    background:#fff;
    border-radius:16px;
    box-shadow:0 18px 40px rgba(0,0,0,0.08);
    overflow:hidden;
}

/* TABLE */
table{
    width:100%;
    border-collapse:collapse;
}

thead{
    background:#97144d;
}

th{
    color:#fff;
    padding:16px 18px;
    font-size:13px;
    font-weight:600;
    letter-spacing:0.6px;
    text-transform:uppercase;
    text-align:left;
}

td{
    padding:16px 18px;
    font-size:14px;
    border-bottom:1px solid #eee;
    color:#444;
}

tbody tr:hover{
    background:#fff5f9;
}

/* ===== STATUS BADGES ===== */
.status{
    padding:6px 14px;
    border-radius:20px;
    font-size:12px;
    font-weight:600;
    display:inline-block;
}

.status-active{
    background:#e8f7ee;
    color:#1f9254;
}

.status-blocked{
    background:#fdecea;
    color:#b42318;
}

/* EMPTY STATE */
.empty-box{
    padding:70px;
    text-align:center;
    color:#999;
}

/* RESPONSIVE */
@media(max-width:900px){
    table{
        min-width:900px;
    }
}
</style>
</head>

<body>

<!-- NAVBAR -->
<div class="navbar">
    <h1>Cashy Bank </h1>
    <div>
        <a href="adminDashboard.jsp">Dashboard</a>
        <a href="AdminLogoutServlet">Logout</a>
    </div>
</div>

<div class="container">

    <!-- PAGE HEADER -->
    <div class="page-header">
        <h2>User Management</h2>
    </div>

    <!-- TABLE CARD -->
    <div class="table-card">
        <%
            try {
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(
                    "SELECT account_number, name, email, phone, account_type, balance, status FROM users ORDER BY created_at DESC"
                );
                ResultSet rs = ps.executeQuery();

                if(rs.next()){
        %>
        <table>
            <thead>
                <tr>
                    <th>Account No</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Account Type</th>
                    <th>Balance</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
        <%
            do{
        %>
                <tr>
                    <td><%= rs.getString("account_number") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getString("phone") %></td>
                    <td><%= rs.getString("account_type") %></td>
                    <td>₹ <%= String.format("%.2f", rs.getDouble("balance")) %></td>
                    <td>
                        <span class="status <%= rs.getString("status").equals("Active") ? "status-active" : "status-blocked" %>">
                            <%= rs.getString("status") %>
                        </span>
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
            <div class="empty-box">
                <h3>No users found</h3>
            </div>
        <%
                }
                rs.close();
                ps.close();
                conn.close();
            } catch(Exception e){
                e.printStackTrace();
            }
        %>
    </div>
</div>

</body>
</html>
