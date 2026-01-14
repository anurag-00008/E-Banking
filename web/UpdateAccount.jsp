<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="e_banking.DBConnection" %>
<%
    String accountNumber = (String) session.getAttribute("account_number");
    if(accountNumber == null) {
        response.sendRedirect("login.jsp?msg=Please login first");
        return;
    }
    
    String email = "";
    String phone = "";
    String address = "";
    
    try {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement("SELECT email, phone, address FROM users WHERE account_number=?");
        ps.setString(1, accountNumber);
        ResultSet rs = ps.executeQuery();
        if(rs.next()) {
            email = rs.getString("email");
            phone = rs.getString("phone");
            address = rs.getString("address");
        }
        rs.close();
        ps.close();
        conn.close();
    } catch(Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Account - E-Banking</title>
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
        .navbar a { color: white; text-decoration: none; margin-left: 20px; }
        .container {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h2 { color: #333; margin-bottom: 30px; text-align: center; }
        .form-group { margin-bottom: 20px; }
        label { display: block; color: #555; font-weight: 600; margin-bottom: 5px; }
        input, textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        input:focus, textarea:focus { outline: none; border-color: #97144d; }
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
        .message {
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
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
        <h2>Update Account Details</h2>
        
        <% 
            String msg = request.getParameter("msg");
            if(msg != null) { 
        %>
            <div class="message <%= msg.contains("success") ? "success" : "error" %>">
                <%= msg %>
            </div>
        <% } %>
        
        <form action="UpdateAccountServlet" method="post">
            <div class="form-group">
                <label>Email *</label>
                <input type="email" name="email" value="<%= email %>" required>
            </div>
            
            <div class="form-group">
                <label>Phone Number *</label>
                <input type="text" name="phone" value="<%= phone %>" pattern="\d{10}" required>
            </div>
            
            <div class="form-group">
                <label>Address *</label>
                <textarea name="address" rows="4" required><%= address %></textarea>
            </div>
            
            <button type="submit">Update Details</button>
        </form>
    </div>
</body>
</html>