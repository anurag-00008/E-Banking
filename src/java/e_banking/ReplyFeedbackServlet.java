package e_banking;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "ReplyFeedbackServlet", urlPatterns = {"/ReplyFeedbackServlet"})
public class ReplyFeedbackServlet extends HttpServlet {
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String feedbackIdStr = request.getParameter("feedbackId");
        String replyText = request.getParameter("reply_text");

        if(feedbackIdStr == null || feedbackIdStr.isEmpty() || replyText == null || replyText.isEmpty()) {
            response.sendRedirect("adminFeedback.jsp?msg=Invalid request");
            return;
        }

        int feedbackId = Integer.parseInt(feedbackIdStr);

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();

            // Update feedback with reply and change status to 'Replied'
            ps = conn.prepareStatement(
                "UPDATE feedback SET reply_text=?, status='Replied' WHERE id=?"
            );
            ps.setString(1, replyText);
            ps.setInt(2, feedbackId);

            int updated = ps.executeUpdate();
            if(updated > 0){
                response.sendRedirect("adminFeedback.jsp?msg=Reply sent successfully");
            } else {
                response.sendRedirect("adminFeedback.jsp?msg=Feedback not found");
            }

        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminFeedback.jsp?msg=Error sending reply");
        } finally {
            try{ if(ps != null) ps.close(); } catch(Exception e){}
            try{ if(conn != null) conn.close(); } catch(Exception e){}
        }
    }

    @Override
    public String getServletInfo() {
        return "Reply Feedback Servlet";
    }
}