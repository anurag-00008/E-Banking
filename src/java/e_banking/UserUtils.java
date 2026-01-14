package e_banking;

import java.sql.*;

public class UserUtils {

    public static boolean isBlocked(String accountNumber) {
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT status FROM users WHERE account_number=?"
            );
            ps.setString(1, accountNumber);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return "Blocked".equalsIgnoreCase(rs.getString("status"));
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
