# 📈 Hệ Thống Tự Động Theo Dõi & So Sánh Giá Đối Thủ (Price Tracker System)

Dự án xây dựng hệ thống tự động cào dữ liệu giá từ 5 đối thủ trên sàn TMĐT, xử lý lưu trữ vào hệ thống Kho dữ liệu nhỏ (Mini Data Warehouse), tính toán biến động và tự động gửi báo cáo Dashboard qua Telegram vào mỗi buổi sáng.

---

## 📂 1. Cấu Trúc Thư Mục Dự Án (Layered Architecture)

```text
price-tracker-system/
│
├── .gitignore
├── pom.xml (hoặc build.gradle)
├── README.md
│
└── src/
    ├── main/
    │   ├── java/
    │   │   └── com/
    │   │       └── tracker/
    │   │           ├── PriceTrackerApplication.java       # Entry Point - Khởi chạy hệ thống
    │   │           │
    │   │           ├── config/                            # Tầng cấu hình kết nối
    │   │           │   ├── DatabaseConfig.java            # Quản lý Connection Pool (HikariCP)
    │   │           │   └── TelegramConfig.java            # Cấu hình Token & Chat ID Telegram
    │   │           │
    │   │           ├── crawler/                           # Mô-đun 1: Thu thập dữ liệu (Crawl)
    │   │           │   ├── BaseCrawler.java               # Cấu hình chống chặn (User-Agent, Delay)
    │   │           │   ├── ShopeeCrawler.java
    │   │           │   ├── LazadaCrawler.java
    │   │           │   ├── TikiCrawler.java
    │   │           │   └── CrawlerFactory.java            # Khởi tạo Crawler động theo tên sàn
    │   │           │
    │   │           ├── model/                             # Tầng thực thể dữ liệu (Entities)
    │   │           │   ├── RawPriceData.java              # Dữ liệu thô vừa cào về
    │   │           │   ├── ProductDim.java                # Bảng thông tin cố định sản phẩm (Dimension)
    │   │           │   └── PriceFact.java                 # Bảng lịch sử biến động giá (Fact)
    │   │           │
    │   │           ├── repository/                        # Tầng tương tác Cơ sở dữ liệu (DAO)
    │   │           │   ├── RawDataRepository.java         # Ghi/Xóa dữ liệu ở bảng tạm (Staging)
    │   │           │   ├── WarehouseRepository.java       # Ghi dữ liệu sạch vào Fact/Dim
    │   │           │   └── CompetitorRepository.java      # Lấy danh sách link sản phẩm cần cào
    │   │           │
    │   │           ├── warehouse/                         # Mô-đun 2: Xử lý ETL Kho dữ liệu
    │   │           │   ├── EtlPipeline.java               # Điều phối luồng (Extract-Transform-Load)
    │   │           │   ├── DataCleaner.java               # Làm sạch, ép kiểu dữ liệu rác về dạng số
    │   │           │   └── PriceAggregator.java           # Tính toán chênh lệch giá, tìm bên rẻ nhất
    │   │           │
    │   │           ├── notification/                      # Mô-đun 3: Đầu ra & Báo cáo
    │   │           │   ├── TelegramBotService.java        # Gọi API gửi tin nhắn sang Telegram
    │   │           │   └── ReportGenerator.java           # Tạo nội dung Dashboard bằng văn bản/Markdown
    │   │           │
    │   │           └── scheduler/                         # Bộ lập lịch chạy ngầm tự động
    │   │               └── DailyTrackerJob.java           # Định giờ kích hoạt hệ thống hàng sáng
    │   │
    │   └── resources/
    │       ├── application.properties                     # Chứa thông tin tài khoản DB, token Bot
    │       ├── logback.xml                                # Ghi nhật ký lỗi hệ thống (crawler.log)
    │       └── db/
    │           └── migration/                             # Các file SQL khởi tạo cấu trúc DB
    │               ├── V1__init_raw_tables.sql            # Tạo bảng Staging chứa dữ liệu thô
    │               └── V2__init_warehouse_tables.sql      # Tạo bảng chuẩn Data Warehouse