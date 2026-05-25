package com.tracker;

import com.tracker.config.DatabaseConfig;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.logging.Logger;

public class PriceTrackerApplication {
    private static final Logger logger = Logger.getLogger(PriceTrackerApplication.class.getName());

    public static void main(String[] args) {
        try(Connection conn= DatabaseConfig.getInstance().getConnection()) {
            if (conn != null && !conn.isClosed()){
                logger.info("🚀 SUCCESS: Kết nối MySQL thành công qua Singleton!");

                String sql = "SELECT 1";
                try (PreparedStatement stmt = conn.prepareStatement(sql);
                     ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        logger.info("Kiểm tra phản hồi từ Database: PING = " + rs.getInt(1));
                    }
                }
            }
        } catch (Exception e) {
            logger.severe("❌ Lỗi kết nối MySQL: " + e.getMessage());
        }
    }
}