<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - E-Banking</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            /* background updated to your image path; overlay removed for a clear picture */
            background: url('images/register1.png') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            display: flex;
            /* Moves the container to the right side */
            justify-content: flex-start;
 
            align-items: center;
            padding: 40px 20px;
        }
        .container {
            /* High opacity white for readability over a clear background */
            background: rgba(255, 255, 255, 0.95);
            border-radius: 12px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.5);
            padding: 40px;
            max-width: 650px; 
            width: 100%;
            border: 1px solid #ddd;
            /* Adds spacing from the right edge */
            margin-left: 18%;
 
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
            margin-bottom: 18px;
        }
        label {
            display: block;
            color: #444;
            font-weight: 600;
            margin-bottom: 5px;
            font-size: 14px;
        }
        input[type="text"],
        input[type="email"],
        input[type="password"],
        select,
        textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: all 0.3s;
        }
        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: #97144d;
            box-shadow: 0 0 8px rgba(151, 20, 77, 0.2);
        }
        .row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        button {
            width: 100%;
            padding: 14px;
            background: #97144d;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
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
        .link {
            text-align: center;
            margin-top: 15px;
            font-size: 14px;
        }
        .link a {
            color: #97144d;
            text-decoration: none;
            font-weight: 600;
        }
        .link a:hover {
            text-decoration: underline;
        }

        /* Centering for mobile view */
        @media (max-width: 768px) {
            body {
                justify-content: center;
            }
            .container {
                margin-right: 0;
            }
            .row {
                grid-template-columns: 1fr;
                gap: 0;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Open Account</h2>
        
        <% if(request.getAttribute("msg") != null) { %>
            <div class="message <%= request.getAttribute("msg").toString().contains("success") ? "success" : "error" %>">
                <%= request.getAttribute("msg") %>
            </div>
        <% } %>
        
        <form action="RegisterServlet" method="post">
            <div class="form-group">
                <label for="name">Full Name *</label>
                <input type="text" id="name" name="name" required placeholder="Enter your full name">
            </div>
            
            <div class="row">
                <div class="form-group">
                    <label for="email">Email *</label>
                    <input type="email" id="email" name="email" required placeholder="name@example.com">
                </div>
                <div class="form-group">
                    <label for="phone">Phone Number *</label>
                    <input type="text" id="phone" name="phone" pattern="\d{10}" title="Enter 10 digit phone number" required placeholder="10-digit mobile">
                </div>
            </div>
            
            <div class="row">
                <div class="form-group">
                    <label for="pan">PAN Number *</label>
                    <input type="text" id="pan" name="pan" required placeholder="Enter PAN">
                </div>
                <div class="form-group">
                    <label for="aadhar">Aadhar Number *</label>
                    <input type="text" id="aadhar" name="aadhar" pattern="\d{12}" title="Enter 12 digit Aadhar" required placeholder="12-digit Aadhar">
                </div>
            </div>
            
            <div class="form-group">
                <label for="address">Address *</label>
                <textarea id="address" name="address" rows="2" required placeholder="Current Residential Address"></textarea>
            </div>
            
            <div class="row">
                <div class="form-group">
                    <label for="account_type">Account Type *</label>
                    <select id="account_type" name="account_type" required>
                        <option value="">Select Type</option>
                        <option value="Savings">Savings Account</option>
                        <option value="Current">Current Account</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="password">Create Password *</label>
                    <input type="password" id="password" name="password" minlength="6" required placeholder="Min 6 characters">
                </div>
            </div>
            
            <div class="row">
                <div class="form-group">
                    <label for="security_question">Security Question *</label>
                    <select id="security_question" name="security_question" required>
                        <option value="">Select Question</option>
                        <option value="What is your favorite color?">Favorite color?</option>
                        <option value="What is your pet's name?">Pet's name?</option>
                        <option value="What is your mother's maiden name?">Mother's maiden name?</option>
                        <option value="What city were you born in?">Birth city?</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="security_answer">Security Answer *</label>
                    <input type="text" id="security_answer" name="security_answer" required placeholder="Your answer">
                </div>
            </div>
            
            <button type="submit">Create Secure Account</button>
        </form>
        
        <div class="link">
            Already have an account? <a href="login.jsp">Login here</a>
        </div>
        <div class="link">
            <a href="index.html">Back to Home Page</a>
        </div>
    </div>
</body>
</html>