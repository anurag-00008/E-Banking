<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="e_banking.DBConnection" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Management - Admin</title>
    <style>
    /* Global Reset & Typography */
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: #f5f7fa; /* Light gray background */
        color: #333;
    }

    /* Navbar - Updated to Maroon Brand Color */
    .navbar {
        background: #901c43; /* Specific maroon from image */
        color: white;
        padding: 15px 30px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }
    .navbar h1 {
        font-size: 24px;
        font-weight: bold;
    }
    .navbar a {
        color: white;
        text-decoration: none;
        margin-left: 20px;
        padding: 8px 15px;
        border-radius: 4px;
        transition: background 0.3s, opacity 0.3s;
        font-size: 14px;
    }
    .navbar a:hover {
        background: rgba(255,255,255,0.1);
    }

    /* Container & Layout */
    .container {
        max-width: 1200px;
        margin: 30px auto;
        padding: 0 20px;
    }
    h2 {
        color: #333;
        margin-bottom: 30px;
        text-align: center;
    }

    /* Alerts / Messages */
    .message {
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 20px;
        text-align: center;
        font-size: 14px;
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

    /* Stats Grid */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }
    .stat-card {
        background: white;
        padding: 25px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        text-align: center;
    }
    .stat-card h3 {
        color: #666;
        font-size: 14px;
        margin-bottom: 10px;
    }
    .stat-card .value {
        font-size: 32px;
        font-weight: bold;
        color: #901c43; /* Maroon Number */
    }

    /* Feedback Cards */
    .feedback-grid {
        display: grid;
        gap: 20px;
    }
    .feedback-card {
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        padding: 25px;
        transition: transform 0.3s, box-shadow 0.3s;
        border: 1px solid #eee;
    }
    .feedback-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.1);
    }

    /* Feedback Header */
    .feedback-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 15px;
        padding-bottom: 15px;
        border-bottom: 1px solid #eee;
    }
    .feedback-info {
        flex: 1;
    }
    .feedback-info h3 {
        color: #333;
        margin-bottom: 5px;
        font-size: 16px;
    }
    .feedback-info p {
        color: #666;
        font-size: 13px;
    }

    /* Status Badges */
    .feedback-status {
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
    }
    .status-pending {
        background: #fff3cd;
        color: #856404;
    }
    .status-replied {
        background: #d4edda;
        color: #155724;
    }

    /* Feedback Content Box */
    .feedback-text {
        background: #f8f9fa;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 15px;
        border-left: 4px solid #901c43; /* Maroon accent for customer query */
        font-size: 14px;
        line-height: 1.5;
    }

    /* Reply Section */
    .reply-section {
        margin-top: 15px;
        padding-top: 15px;
        border-top: 1px solid #eee;
    }
    .reply-text {
        background: #e7f3ff;
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 10px;
        border-left: 4px solid #10b981; /* Green accent for admin reply */
        font-size: 14px;
        line-height: 1.5;
        color: #0c5460;
    }

    /* Form Elements */
    .reply-form textarea {
        width: 100%;
        padding: 12px;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-family: inherit;
        font-size: 14px;
        resize: vertical;
        min-height: 100px;
        transition: border-color 0.3s;
    }
    .reply-form textarea:focus {
        outline: none;
        border-color: #901c43; /* Maroon focus border */
    }

    /* Buttons */
    .btn-reply {
        margin-top: 10px;
        padding: 10px 20px;
        background: #901c43; /* Maroon Primary Button */
        color: white;
        border: none;
        border-radius: 4px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: background 0.3s;
    }
    .btn-reply:hover {
        background: #7a1538; /* Darker Maroon on hover */
    }

    /* Filters */
    .filter-section {
        background: white;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 20px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
    .filter-section select {
        padding: 8px 12px;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-size: 14px;
        margin-right: 10px;
        outline: none;
    }
    .filter-section select:focus {
        border-color: #901c43;
    }

    /* Empty State */
    .no-data {
        text-align: center;
        padding: 50px;
        color: #999;
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }
</style>
</head>
<body>
    <div class="navbar">
        <h1>Cashy Bank</h1>
        <div>
            <a href="adminDashboard.jsp">Dashboard</a>
            <a href="AdminLogoutServlet">Logout</a>
        </div>
    </div>
    
    <div class="container">
        <h2>Customer Feedback Management</h2>
        
        <% 
            String msg = request.getParameter("msg");
            if(msg != null) { 
        %>
            <div class="message <%= msg.contains("success") ? "success" : "error" %>">
                <%= msg.replace("+", " ") %>
            </div>
        <% } %>
        
        <!-- Statistics Section -->
        <%
            int totalFeedback = 0, pendingFeedback = 0, repliedFeedback = 0;
            
            try {
                Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(
                    "SELECT status, COUNT(*) as count FROM feedback GROUP BY status"
                );
                ResultSet rs = ps.executeQuery();
                
                while(rs.next()) {
                    String status = rs.getString("status");
                    int count = rs.getInt("count");
                    totalFeedback += count;
                    
                    if("Pending".equals(status)) {
                        pendingFeedback = count;
                    } else if("Replied".equals(status)) {
                        repliedFeedback = count;
                    }
                }
                
                rs.close();
                ps.close();
                conn.close();
            } catch(Exception e) {
                e.printStackTrace();
            }
        %>
        
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Feedback</h3>
                <div class="value"><%= totalFeedback %></div>
            </div>
            <div class="stat-card">
                <h3>Pending Replies</h3>
                <div class="value" style="color: #ffc107;"><%= pendingFeedback %></div>
            </div>
            <div class="stat-card">
                <h3>Replied</h3>
                <div class="value" style="color: #28a745;"><%= repliedFeedback %></div>
            </div>
        </div>
        
        <div class="filter-section">
            <label style="font-weight: 600; margin-right: 10px;">Filter by Status:</label>
            <select id="statusFilter" onchange="filterFeedback()">
                <option value="all">All Feedback</option>
                <option value="Pending">Pending</option>
                <option value="Replied">Replied</option>
            </select>
        </div>
        
        <div class="feedback-grid">
            <%
                try {
                    Connection conn = DBConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement(
                        "SELECT f.id, f.account_number, u.name, u.email, f.feedback_text, " +
                        "f.reply_text, f.status, f.created_at " +
                        "FROM feedback f " +
                        "JOIN users u ON f.account_number = u.account_number " +
                        "ORDER BY f.created_at DESC"
                    );
                    ResultSet rs = ps.executeQuery();
                    
                    boolean hasRecords = false;
                    SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy hh:mm a");
                    
                    while(rs.next()) {
                        hasRecords = true;
                        int id = rs.getInt("id");
                        String accountNumber = rs.getString("account_number");
                        String customerName = rs.getString("name");
                        String email = rs.getString("email");
                        String feedbackText = rs.getString("feedback_text");
                        String replyText = rs.getString("reply_text");
                        String status = rs.getString("status");
                        Timestamp createdAt = rs.getTimestamp("created_at");
                        
                        String statusClass = "Pending".equals(status) ? "status-pending" : "status-replied";
            %>
                        <div class="feedback-card" data-status="<%= status %>">
                            <div class="feedback-header">
                                <div class="feedback-info">
                                    <h3><%= customerName %> (<%= accountNumber %>)</h3>
                                    <p><%= email %> • <%= createdAt != null ? sdf.format(createdAt) : "" %></p>
                                </div>
                                <span class="feedback-status <%= statusClass %>"><%= status %></span>
                            </div>
                            
                            <div class="feedback-text">
                                <strong>Customer Feedback:</strong><br>
                                <%= feedbackText %>
                            </div>
                            
                            <% if("Replied".equals(status) && replyText != null) { %>
                                <div class="reply-section">
                                    <div class="reply-text">
                                        <strong>Admin Reply:</strong><br>
                                        <%= replyText %>
                                    </div>
                                </div>
                            <% } else { %>
                                <div class="reply-section">
                                    <form action="ReplyFeedbackServlet" method="post" class="reply-form">
                                        <input type="hidden" name="feedbackId" value="<%= id %>">
                                        <textarea name="reply_text" placeholder="Type your reply here..." required></textarea>
                                        <button type="submit" class="btn-reply">Send Reply</button>
                                    </form>
                                </div>
                            <% } %>
                        </div>
            <%
                    }
                    
                    if(!hasRecords) {
            %>
                        <div class="no-data">
                            <h3>No Feedback Found</h3>
                            <p>No customers have submitted feedback yet</p>
                        </div>
            <%
                    }
                    
                    rs.close();
                    ps.close();
                    conn.close();
                } catch(Exception e) {
                    e.printStackTrace();
                    out.println("<div class='no-data'><h3>Error loading data</h3><p>" + e.getMessage() + "</p></div>");
                }
            %>
        </div>
    </div>
    
    <script>
        function filterFeedback() {
            var filter = document.getElementById("statusFilter").value;
            var cards = document.querySelectorAll(".feedback-card");
            
            cards.forEach(function(card) {
                var status = card.getAttribute("data-status");
                if(filter === "all" || status === filter) {
                    card.style.display = "block";
                } else {
                    card.style.display = "none";
                }
            });
        }
    </script>
</body>
</html>