[DailyTrackerJob] thức giấc lúc 6:00 AM
└──> Gọi [EtlPipeline] kích hoạt
├──> Lấy link từ [CompetitorRepository]
├──> Chuyển cho [CrawlerFactory] -> [Shopee/LazadaCrawler] để CRAWL dữ liệu thô
├──> Lưu vào DB qua [RawDataRepository]
├──> Gọi [DataCleaner] để CHUẨN HÓA và ÉP KIỂU dữ liệu
├──> Đẩy dữ liệu sạch vào bảng Fact/Dim qua [WarehouseRepository]
├──> Gọi [PriceAggregator] để TÍNH TOÁN SO SÁNH giá giữa 5 đối thủ
├──> Chuyển kết quả cho [ReportGenerator] để dựng Dashboard dạng text
└──> Giao cho [TelegramBotService] BAN TIN NHẮN sang Telegram kết thúc chu kỳ.