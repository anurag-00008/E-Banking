<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String accountNumber = (String) session.getAttribute("account_number");
    if (accountNumber == null) {
        response.sendRedirect("login.jsp?msg=Please login first");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Change Password - E-Banking</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

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
            max-width: 500px;
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

        input {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        input:focus {
            outline: none;
            border-color: #97144d;
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
    </style>
</head>

<body>

<div class="navbar">
    <h1>Cashy Bank</h1>
    <div>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="LogoutServlet">Logout</a>
    </div>
</div>

<div class="container">
    <h2>Change Password</h2>

    <% 
        String msg = request.getParameter("msg");
        if (msg != null) {
    %>
        <div class="message <%= msg.toLowerCase().contains("success") ? "success" : "error" %>">
            <%= msg %>
        </div>
    <% } %>

    <form action="ChangePasswordServlet" method="post">
        <div class="form-group">
            <label>Current Password *</label>
            <input type="password" name="current_password" required>
        </div>

        <div class="form-group">
            <label>New Password *</label>
            <input type="password" name="new_password" minlength="6" required>
        </div>

        <div class="form-group">
            <label>Confirm New Password *</label>
            <input type="password" name="confirm_password" minlength="6" required>
        </div>

        <button type="submit">Change Password</button>
    </form>
</div>

</body>
</html>
