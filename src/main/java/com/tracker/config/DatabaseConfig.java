package com.tracker.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ConcurrentModificationException;
import java.util.Properties;
import java.util.logging.Logger;

public class DatabaseConfig {
    private final Logger logger = Logger.getLogger(DatabaseConfig.class.getName());
    private HikariDataSource dataSource;
    private static volatile DatabaseConfig instance;

    private DatabaseConfig(){
        try(InputStream input= getClass().getClassLoader().getResourceAsStream("application.properties")) {
            Properties prop = new Properties();
            if (input == null) {
                logger.severe("Sorry, unable to find application.properties");
                return;
            }

            prop.load(input);

            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(prop.getProperty("db.url"));
            config.setUsername(prop.getProperty("db.username"));
            config.setPassword(prop.getProperty("db.password"));

            config.setMaximumPoolSize(Integer.parseInt(prop.getProperty("db.hikari.maximum-pool-size", "10")));
            config.setMinimumIdle(Integer.parseInt(prop.getProperty("db.hikari.minimum-idle", "2")));
            config.setIdleTimeout(Long.parseLong(prop.getProperty("db.hikari.idle-timeout", "30000")));
            config.setConnectionTimeout(Long.parseLong(prop.getProperty("db.hikari.connection-timeout", "20000")));

            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

            this.dataSource = new HikariDataSource(config);
            logger.info("Khởi tạo HikariCP Connection Pool (Singleton) thành công!");
        } catch (Exception e) {
            logger.severe("Lỗi khi khởi tạo HikariCP Connection Pool: " + e.getMessage());
        }
    }

    public static DatabaseConfig getInstance() {
        if (instance == null) {
            synchronized (DatabaseConfig.class) {
                if (instance == null) {
                    instance = new DatabaseConfig();
                }
            }
        }
        return instance;
    }

    public Connection getConnection() throws Exception {
        if (dataSource == null) {
            throw new SQLException("DataSource chưa được khởi tạo.");
        }
        return dataSource.getConnection();
    }

    public void close() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            logger.info("HikariCP Connection Pool đã được đóng.");
        }
    }
}