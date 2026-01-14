<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - E-Banking</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: url('images/fp.png') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            display: flex;
            justify-content: flex-start; 
            align-items: center;
            padding: 20px;
        }
        .container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
            padding: 40px;
            max-width: 500px;
            width: 100%;
            border: 1px solid #ddd;
            margin-left: 8%;
        }
        h2 { 
            color: #333; 
            text-align: center; 
            margin-bottom: 30px; 
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 2px solid #97144d; 
            padding-bottom: 10px; 
        }
        .form-group { margin-bottom: 20px; }
        label { 
            display: block; 
            color: #444; 
            font-weight: 600; 
            margin-bottom: 5px; 
            font-size: 14px;
        }
        input, select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: all 0.3s;
        }
        input:focus, select:focus { 
            outline: none; 
            border-color: #97144d; 
            box-shadow: 0 0 8px rgba(151, 20, 77, 0.2);
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
            transition: 0.3s;
        }
        button:hover { 
            background: #7c103f; 
            transform: translateY(-2px); 
            box-shadow: 0 5px 15px rgba(151, 20, 77, 0.4);
        }
        .message { padding: 10px; border-radius: 5px; margin-bottom: 20px; text-align: center; font-weight: 500; }
        .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .link { text-align: center; margin-top: 20px; }
        .link a { color: #97144d; text-decoration: none; font-weight: 600; font-size: 14px; }
        .link a:hover { text-decoration: underline; }
        @media (max-width: 768px) {
            body { justify-content: center; }
            .container { margin-left: 0; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Forgot Password</h2>
        
        <% String msg = request.getParameter("msg"); 
           if(msg != null) { %>
            <div class="message error"><%= msg %></div>
        <% } %>
        
        <form action="ForgotPasswordServlet" method="post">
            <div class="form-group">
                <label>Account Number *</label>
                <input type="text" name="account_number" required placeholder="Enter account number">
            </div>
            
            <div class="form-group">
                <label>Security Question *</label>
                <select name="security_question" required>
                    <option value="">Select Question</option>
                    <option value="What is your favorite color?">What is your favorite color?</option>
                    <option value="What is your pet's name?">What is your pet's name?</option>
                    <option value="What is your mother's maiden name?">What is your mother's maiden name?</option>
                    <option value="What city were you born in?">What city were you born in?</option>
                </select>
            </div>
            
            <div class="form-group">
                <label>Security Answer *</label>
                <input type="text" name="security_answer" required placeholder="Enter your answer">
            </div>
            
            <div class="form-group">
                <label>New Password *</label>
                <input type="password" name="new_password" minlength="6" required placeholder="Min 6 characters">
            </div>
            
            <button type="submit">Reset Password</button>
        </form>
        
        <div class="link"><a href="login.jsp">Back to Login</a></div>
    </div>
</body>
</html>
