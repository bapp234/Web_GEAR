# TÀI LIỆU CẤU HÌNH MÔI TRƯỜNG MẪU (ENVIRONMENT CONFIGURATION)
**Dự án:** Website Thương mại Điện tử Gaming Gear  
**Stack:** ASP.NET Core 8 (Backend) + Next.js / ReactJS (Frontend) + WordPress Local (Headless CMS) + PostgreSQL + Redis + MySQL

---

# 1. Backend ASP.NET Core — appsettings.Development.json mẫu

Dưới đây là file cấu hình `appsettings.Development.json` mẫu đặt tại thư mục gốc của project Presentation/API (`Ecommerce.Presentation/appsettings.Development.json`).

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning",
      "Microsoft.EntityFrameworkCore.Database.Command": "Information"
    }
  },
  "AllowedHosts": "*",
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Port=5432;Database=gaming_gear_db;Username=postgres;Password=SecurePassword123!;SearchPath=public",
    "RedisCache": "localhost:6379"
  },
  "JwtSettings": {
    "SecretKey": "CHANGE_ME_SUPER_SECRET_KEY_FOR_JWT_SIGNING_AT_LEAST_256_BITS_LONG",
    "Issuer": "GamingGearIdentityServer",
    "Audience": "GamingGearStorefront",
    "AccessTokenExpirationMinutes": 30,
    "RefreshTokenExpirationDays": 14
  },
  "CorsSettings": {
    "AllowedOrigins": [
      "http://localhost:3000",
      "https://your-gaming-store.com"
    ]
  },
  "WordPressSettings": {
    "BaseUrl": "http://localhost:8000",
    "GraphQLUrl": "http://localhost:8000/graphql",
    "RevalidateSecret": "CHANGE_ME_REVALIDATE_SECRET_TOKEN"
  },
  "PaymentGateway": {
    "VnPay": {
      "TmnCode": "CHANGE_ME_VNPAY_TMN_CODE",
      "HashSecret": "CHANGE_ME_VNPAY_HASH_SECRET",
      "BaseUrl": "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html",
      "ReturnUrl": "http://localhost:3000/checkout/vnpay-return"
    }
  }
}
```

---

# 2. Frontend ReactJS/Next.js — .env.local mẫu

Dưới đây là tệp `.env.local.example` mẫu đặt tại thư mục gốc của dự án Frontend Next.js. Lập trình viên sao chép tệp này thành `.env.local` để chạy môi trường phát triển cục bộ.

```env
# ==========================================
# CẤU HÌNH KẾT NỐI API BACKEND (ASP.NET CORE)
# ==========================================
NEXT_PUBLIC_API_BASE_URL=http://localhost:5000/api/v1

# ==========================================
# CẤU HÌNH KẾT NỐI HEADLESS WORDPRESS (CMS)
# ==========================================
NEXT_PUBLIC_WORDPRESS_GRAPHQL_URL=http://localhost:8000/graphql

# ==========================================
# CẤU HÌNH WEBHOOK ISR REVALIDATION
# ==========================================
REVALIDATE_SECRET_TOKEN=CHANGE_ME_REVALIDATE_SECRET_TOKEN

# ==========================================
# CẤU HÌNH CỔNG THANH TOÁN (CLIENT SIDE)
# ==========================================
NEXT_PUBLIC_VNPAY_RETURN_URL=http://localhost:3000/checkout/vnpay-return

# ==========================================
# CẤU HÌNH CHẾ ĐỘ DEBUG & TÊN ỨNG DỤNG
# ==========================================
NEXT_PUBLIC_SITE_NAME="Gaming Gear Store"
NEXT_PUBLIC_ENABLE_ANALYTICS=false
```

---

# 3. WordPress — wp-config.php mẫu (Các dòng cấu hình Headless)

Thêm các dòng cấu hình dưới đây vào tệp `wp-config.php` của WordPress Local (đặt trước dòng `/* That's all, stop editing! Happy publishing. */`).

```php
/** =========================================================
 * 1. CẤU HÌNH KẾT NỐI CƠ SỞ DỮ LIỆU MYSQL (DOCKER COMPOSE)
 * ========================================================= */
define( 'DB_NAME', 'wp_headless' );
define( 'DB_USER', 'wp_user' );
define( 'DB_PASSWORD', 'WpPassword123!' );
define( 'DB_HOST', 'localhost:3306' ); // Hoặc 'mysql_db:3306' khi chạy trong Docker network
define( 'DB_CHARSET', 'utf8mb4' );
define( 'DB_COLLATE', '' );

/** =========================================================
 * 2. CẤU HÌNH CORS CHO HEADLESS WORDPRESS (WPGRAPHQL / REST)
 * ========================================================= */
define( 'WORDPRESS_REACT_FRONTEND_URL', 'http://localhost:3000' );

// Tự động thêm Header CORS cho các truy vấn từ Next.js Frontend
if ( isset( $_SERVER['HTTP_ORIGIN'] ) ) {
    $allowed_origins = array( 'http://localhost:3000', 'https://your-gaming-store.com' );
    if ( in_array( $_SERVER['HTTP_ORIGIN'], $allowed_origins, true ) ) {
        header( "Access-Control-Allow-Origin: " . $_SERVER['HTTP_ORIGIN'] );
        header( "Access-Control-Allow-Methods: GET, POST, OPTIONS" );
        header( "Access-Control-Allow-Credentials: true" );
        header( "Access-Control-Allow-Headers: Authorization, Content-Type, X-Requested-With" );
        if ( 'OPTIONS' === $_SERVER['REQUEST_METHOD'] ) {
            status_header( 200 );
            exit();
        }
    }
}

/** =========================================================
 * 3. CẤU HÌNH JWT AUTHENTICATION PLUGIN (SSO DÙNG CHUNG)
 * ========================================================= */
// Khóa bí mật ký số JWT đồng bộ với ASP.NET Core Identity Server
define( 'JWT_AUTH_SECRET_KEY', 'CHANGE_ME_SUPER_SECRET_KEY_FOR_JWT_SIGNING_AT_LEAST_256_BITS_LONG' );
define( 'JWT_AUTH_CORS_ENABLE', true );

/** =========================================================
 * 4. TỐI ƯU HIỆU NĂNG CHO HEADLESS CMS
 * ========================================================= */
define( 'WP_POST_REVISIONS', 5 );           // Giới hạn 5 bản lưu vết bài viết
define( 'AUTOSAVE_INTERVAL', 160 );         // Khoảng thời gian tự động lưu (giây)
define( 'DISABLE_WP_CRON', false );         // Giữ WP Cron cho Webhook
```

---

# 4. Bảng tổng hợp biến môi trường (Environment Variables Summary)

| Tên biến / Key | Thuộc hệ thống nào | Giá trị mẫu / Placeholder | Mô tả | Bắt buộc / Tùy chọn |
| :--- | :--- | :--- | :--- | :--- |
| `ConnectionStrings:DefaultConnection` | ASP.NET Core | `Host=localhost;Port=5432;Database=gaming_gear_db;Username=postgres;Password=SecurePassword123!` | Chuỗi kết nối đến cơ sở dữ liệu PostgreSQL. | Bắt buộc |
| `ConnectionStrings:RedisCache` | ASP.NET Core | `localhost:6379` | Chuỗi kết nối dịch vụ bộ nhớ đệm Redis. | Tùy chọn |
| `JwtSettings:SecretKey` | ASP.NET Core | `CHANGE_ME_SUPER_SECRET_KEY_FOR_JWT_SIGNING_AT_LEAST_256_BITS_LONG` | Khóa bí mật dùng để ký số mã thông báo JWT Access Token. | Bắt buộc |
| `JwtSettings:Issuer` | ASP.NET Core | `GamingGearIdentityServer` | Tên nhà cấp phát mã thông báo JWT. | Bắt buộc |
| `JwtSettings:Audience` | ASP.NET Core | `GamingGearStorefront` | Tên đối tượng tiêu thụ mã thông báo JWT. | Bắt buộc |
| `JwtSettings:AccessTokenExpirationMinutes` | ASP.NET Core | `30` | Thời gian sống của Access Token (phút). | Bắt buộc |
| `JwtSettings:RefreshTokenExpirationDays` | ASP.NET Core | `14` | Thời gian sống của Refresh Token (ngày). | Bắt buộc |
| `CorsSettings:AllowedOrigins` | ASP.NET Core | `["http://localhost:3000"]` | Danh sách domain Frontend được phép truy cập API. | Bắt buộc |
| `WordPressSettings:GraphQLUrl` | ASP.NET Core | `http://localhost:8000/graphql` | Điểm cuối WPGraphQL để lấy dữ liệu tiếp thị từ WordPress. | Tùy chọn |
| `NEXT_PUBLIC_API_BASE_URL` | Next.js Frontend | `http://localhost:5000/api/v1` | URL gốc của ASP.NET Core Backend API. | Bắt buộc |
| `NEXT_PUBLIC_WORDPRESS_GRAPHQL_URL` | Next.js Frontend | `http://localhost:8000/graphql` | URL truy vấn WPGraphQL từ Frontend client-side. | Bắt buộc |
| `REVALIDATE_SECRET_TOKEN` | Next.js & WordPress | `CHANGE_ME_REVALIDATE_SECRET_TOKEN` | Mã bí mật xác thực Webhook xóa đệm tĩnh (ISR Revalidation). | Bắt buộc |
| `DB_NAME` | WordPress | `wp_headless` | Tên cơ sở dữ liệu MySQL của WordPress. | Bắt buộc |
| `DB_USER` | WordPress | `wp_user` | Tên người dùng kết nối MySQL. | Bắt buộc |
| `DB_PASSWORD` | WordPress | `WpPassword123!` | Mật khẩu kết nối MySQL. | Bắt buộc |
| `DB_HOST` | WordPress | `localhost:3306` | Địa chỉ IP / Hostname và cổng của MySQL server. | Bắt buộc |
| `JWT_AUTH_SECRET_KEY` | WordPress Plugin | `CHANGE_ME_SUPER_SECRET_KEY_FOR_JWT_SIGNING_AT_LEAST_256_BITS_LONG` | Khóa giải mã JWT đồng bộ với ASP.NET Core để xác thực SSO. | Bắt buộc |
| `WORDPRESS_REACT_FRONTEND_URL` | WordPress | `http://localhost:3000` | Domain ứng dụng ReactJS Frontend dùng để cấu hình CORS. | Bắt buộc |
