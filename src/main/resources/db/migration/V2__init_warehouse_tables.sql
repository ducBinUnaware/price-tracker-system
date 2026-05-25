-- Bảng Chiều (Dimension): Lưu thông tin gốc của sản phẩm sau khi được gọt giũa sạch sẽ
CREATE TABLE IF NOT EXISTS dim_products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    competitor_link_id INT UNIQUE,            -- Mối quan hệ 1-1 với bảng link mục tiêu để đồng bộ
    clean_title VARCHAR(255) NOT NULL,        -- Tên sản phẩm đã lọc hết ký tự rác
    platform VARCHAR(50) NOT NULL,
    product_url TEXT NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (competitor_link_id) REFERENCES competitor_links(id) ON DELETE SET NULL
    ) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Bảng Sự kiện (Fact): Lưu vết lịch sử giá theo thời gian (Trái tim của Data Warehouse)
CREATE TABLE IF NOT EXISTS fact_product_prices (
    fact_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,                  -- Khóa ngoại nối sang bảng Dim sản phẩm (Mối quan hệ 1-n)
    clean_price BIGINT NOT NULL,              -- Giá tiền chuẩn số nguyên để tính toán (Ví dụ: 1250000)
    is_available BOOLEAN DEFAULT TRUE,        -- Còn hàng = 1, Hết hàng = 0
    recorded_date DATE NOT NULL,              -- Ngày ghi nhận mức giá này
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES dim_products(product_id) ON DELETE CASCADE,

    -- RÀNG BUỘC: Đảm bảo 1 sản phẩm chỉ có duy nhất 1 dòng giá trong 1 ngày (Tránh trùng lặp dữ liệu khi chạy ETL)
    UNIQUE KEY unique_product_date (product_id, recorded_date),

    -- INDEX: Đánh chỉ mục mốc thời gian để sau này truy vấn vẽ biểu đồ hoặc so sánh giá chạy siêu tốc
    INDEX idx_recorded_date (recorded_date)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;