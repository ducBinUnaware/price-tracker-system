-- Bảng cấu hình mục tiêu đi cào của hệ thống
create table if not exists compertitor_links (
    id INT primary key auto_increment,
    platform_name VARCHAR(255) not null,
    product_name VARCHAR(255) not null,
    platform_url TEXT not null,
    is_active BOOLEAN not null default true,
    created_at TIMESTAMP default CURRENT_TIMESTAMP,
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Bảng tạm chứa dữ liệu thô (Dữ liệu bẩn, sẽ được làm sạch/xóa mỗi ngày)
CREATE TABLE IF NOT EXISTS staging_raw_prices (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    competitor_link_id INT,
    platform_name VARCHAR(50),
    raw_title TEXT,                           -- Tên cào được từ sàn (chưa xử lý)
    raw_price VARCHAR(100),                   -- Ví dụ: "1.250.000 đ" hoặc "Hết hàng"
    crawl_date DATE,                          -- Ngày cào (Y-m-d)
    crawl_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'PENDING',     -- PENDING, PROCESSED, ERROR
    FOREIGN KEY (competitor_link_id) REFERENCES competitor_links(id) ON DELETE CASCADE
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;