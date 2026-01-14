package e_banking;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "FeedbackServlet", urlPatterns = {"/FeedbackServlet"})
public class FeedbackServlet extends HttpServlet {

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
        HttpSession session = request.getSession();
        String accountNumber = (String) session.getAttribute("account_number");

        if(accountNumber == null){
            response.sendRedirect("login.jsp?msg=Please login first");
            return;
        }

        String feedbackText = request.getParameter("feedback_text");

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement("INSERT INTO feedback(account_number, feedback_text) VALUES(?,?)");
            ps.setString(1, accountNumber);
            ps.setString(2, feedbackText);
            ps.executeUpdate();

            response.sendRedirect("feedback.jsp?msg=Feedback submitted successfully!");

        } catch(Exception e){
            e.printStackTrace();
            response.sendRedirect("feedback.jsp?msg=Error submitting feedback");
        } finally {
            try{ if(ps!=null) ps.close(); } catch(Exception e){}
            try{ if(conn!=null) conn.close(); } catch(Exception e){}
        }
    }

    @Override
    public String getServletInfo() {
        return "Feedback Servlet";
    }
}