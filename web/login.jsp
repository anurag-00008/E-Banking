<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - E-Banking</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            /* Removed the dark gradient overlay to keep the image clear */
            background: url('images/login.jpg') no-repeat center center fixed;
            /* Ensures the image fills the entire background */
            background-size: cover;
            min-height: 100vh;
            display: flex;
            /* Keeps the container towards the right */
            justify-content: flex-end; 
            align-items: center;
            padding: 20px;
        }
        .container {
            /* Solid background with slight transparency for the "glass" look without blurring the image behind it */
            background: rgba(255, 255, 255, 0.95);
            border-radius: 12px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
            padding: 40px;
            max-width: 400px;
            width: 100%;
            border: 1px solid #ddd;
            /* Spacing from the right edge */
            margin-right: 8%; 
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
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            color: #444;
            font-weight: 600;
            margin-bottom: 5px;
        }
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: all 0.3s;
        }
        input:focus {
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
            transition: all 0.3s ease;
        }
        button:hover {
            background: #7a103e;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(151, 20, 77, 0.4);
        }
        .message {
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: 500;
        }
        .success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .links {
            text-align: center;
            margin-top: 20px;
        }
        .links a {
            color: #97144d;
            text-decoration: none;
            font-weight: 600;
            display: block;
            margin: 8px 0;
            transition: color 0.3s;
            font-size: 14px;
        }
        .links a:hover {
            color: #667eea;
            text-decoration: underline;
        }

        /* Responsive for tablets and phones */
        @media (max-width: 768px) {
            body {
                justify-content: center;
            }
            .container {
                margin-right: 0;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Login</h2>
        
        <% 
            String msg = request.getParameter("msg");
            if(msg != null) { 
        %>
            <div class="message <%= msg.contains("success") ? "success" : "error" %>">
                <%= msg.replace("+", " ") %>
            </div>
        <% } %>
        
        <form action="LoginServlet" method="post">
            <div class="form-group">
                <label for="account_number">Account Number</label>
                <input type="text" id="account_number" name="account_number" required placeholder="Enter account number">
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="Enter your password">
            </div>
            
            <button type="submit">Login</button>
        </form>
        
        <div class="links">
            <a href="forgotPassword.jsp">Forgot Password?</a>
            <a href="register.jsp">New User? Register here</a>
            <a href="adminLogin.jsp">Admin Login</a>
            <a href="index.html">Back to Home Page</a>
        </div>
    </div>
</body>
</html>