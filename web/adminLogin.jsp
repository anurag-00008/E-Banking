<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login - E-Banking</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            /* Updated to use your clear image without dark overlay as requested previously */
            background: url('images/admin.png') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            display: flex;
            
            /* MOVED TO RIGHT: Changed center to flex-end */
            justify-content: flex-end; 
            align-items: center;
            padding: 20px;
        }
        .container {
            /* Glassmorphism effect */
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.5);
            padding: 40px;
            max-width: 400px;
            width: 100%;
            
            /* RIGHT SPACING: Adds a gap from the right edge */
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
            border: 2px solid #ddd;
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
            margin: 10px 0;
            transition: color 0.3s;
        }
        .links a:hover {
            color: #667eea;
            text-decoration: underline;
        }

        /* Mobile adjustment: center it on small screens for better UX */
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
        <h2>Admin Login</h2>
        
        <% 
            String msg = request.getParameter("msg");
            if(msg != null) { 
        %>
            <div class="message error"><%= msg.replace("+", " ") %></div>
        <% } %>
        
        <form action="AdminLoginServlet" method="post">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" required placeholder="Enter admin username">
            </div>
            
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" required placeholder="Enter password">
            </div>
            
            <button type="submit">Login</button>
        </form>
        
        <div class="links">
            <a href="login.jsp">User Login</a>
            <a href="index.html">Back to Home Page</a>
        </div>
    </div>
</body>
</html>