# TÀI LIỆU ĐẶC TẢ YÊU CẦU PHẦN MỀM (SRS)
## HỆ THỐNG THƯƠNG MẠI ĐIỆN TỬ GAMING GEAR
**Công nghệ:** ASP.NET Core (Backend) + ReactJS / Next.js (Frontend) + WordPress Local (Headless CMS)

---

# 1. Giới thiệu

### 1.1 Mục đích
Tài liệu Yêu cầu Phần mềm (SRS - Software Requirements Specification) này mô tả chi tiết các yêu cầu chức năng và phi chức năng cho hệ thống Thương mại Điện tử chuyên biệt kinh doanh thiết bị Gaming Gear (chuột, bàn phím cơ, lót chuột, màn hình, loa, tai nghe). Tài liệu làm căn cứ kỹ thuật cho đội ngũ kiến trúc sư, lập trình viên backend (ASP.NET Core), lập trình viên frontend (ReactJS/Next.js), biên tập viên nội dung (WordPress) và đội ngũ kiểm thử (QA/QC) trong suốt vòng đời phát triển hệ thống [1, 5, 6].

### 1.2 Phạm vi
* **Phạm vi quản lý thương mại (ASP.NET Core Backend API + PostgreSQL)**: Xử lý danh mục sản phẩm, thuộc tính thông số kỹ thuật động (DPI, loại Switch, Panel), biến thể tồn kho (SKU), giỏ hàng, đặt hàng, xử lý tranh chấp tồn kho (Optimistic Concurrency Control), thanh toán và quản lý tài khoản khách hàng [6, 7, 12, 15].
* **Phạm vi quản lý nội dung tiếp thị (Headless WordPress Local CMS)**: Soạn thảo, xuất bản bài viết đánh giá gear, cẩm nang tối ưu độ trễ, quản lý biểu ngữ (banner) khuyến mãi qua giao diện Gutenberg và Advanced Custom Fields (ACF) [1, 2, 9].
* **Phạm vi giao diện cửa hàng (ReactJS / Next.js Storefront)**: Kết xuất giao diện cửa hàng trực tuyến mượt mà, tối ưu hóa tốc độ tải trang, điểm số Core Web Vitals và lập chỉ mục SEO [2, 3, 21].

### 1.3 Đối tượng sử dụng tài liệu
* **Đội ngũ phát triển (Developers)**: Lập trình viên Backend, Frontend và CMS sử dụng để thiết kế API, cơ sở dữ liệu và giao diện.
* **Kiến trúc sư hệ thống (Solution Architects)**: Kiểm tra tính tuân thủ kiến trúc Clean Architecture, DDD và các ràng buộc hiệu năng [6, 10].
* **Đội ngũ kiểm thử (QA/QC Engineers)**: Xây dựng kịch bản kiểm thử chức năng và kiểm thử chịu tải.
* **Quản trị viên & Content Marketers**: Hiểu rõ quy trình vận hành hệ thống và phân định ranh giới nhập liệu [1, 4].

### 1.4 Định nghĩa, thuật ngữ và từ viết tắt
| Thuật ngữ / Từ viết tắt | Định nghĩa đầy đủ | Mô tả ý nghĩa trong hệ thống |
| :--- | :--- | :--- |
| **SRS** | Software Requirements Specification | Tài liệu đặc tả yêu cầu phần mềm. |
| **Headless CMS** | Decoupled Content Management System | Mô hình CMS tách rời hoàn toàn tầng quản trị nội dung backend với tầng hiển thị giao diện frontend thông qua API [1, 2]. |
| **API** | Application Programming Interface | Giao diện lập trình ứng dụng dùng để trao đổi dữ liệu JSON. |
| **WPGraphQL** | WordPress GraphQL Plugin | Tiện ích mở rộng cung cấp giao thức truy vấn GraphQL cho WordPress [10, 26]. |
| **ACF** | Advanced Custom Fields | Plugin tạo các trường dữ liệu tùy biến cho bài viết và banner trên WordPress [9]. |
| **JWT** | JSON Web Token | Chuẩn mã thông báo dạng chuỗi mã hóa dùng để xác thực và phân quyền người dùng [1, 17]. |
| **SSO** | Single Sign-On | Cơ chế đăng nhập một lần duy nhất cho toàn bộ hệ thống kép (ASP.NET Core + WordPress) [17, 20]. |
| **OCC** | Optimistic Concurrency Control | Cơ chế kiểm soát tranh chấp đồng thời lạc quan giúp ngăn chặn bán quá tồn kho (overselling) [8, 12]. |
| **ISR / SSG / SSR** | Incremental Static Regeneration / Static Site Generation / Server-Side Rendering | Các cơ chế kết xuất lai của Next.js giúp tối ưu tốc độ tải trang và SEO [2, 3]. |
| **JSONB** | Binary JSON | Định dạng lưu trữ tài liệu JSON dạng nhị phân trong PostgreSQL, hỗ trợ chỉ mục GIN Index [14, 15]. |
| **SKU** | Stock Keeping Unit | Mã đơn vị quản lý tồn kho duy nhất cho từng sản phẩm và biến thể [11]. |

---

# 2. Yêu cầu chức năng (Functional Requirements)

| Mã YC | Tên chức năng | Mô tả chức năng | Actor | Độ ưu tiên |
| :--- | :--- | :--- | :--- | :--- |
| **FR-PRODUCT-01** | Quản lý sản phẩm cốt lõi | Cho phép tạo, sửa, xóa, ẩn/hiện sản phẩm. Lưu trữ thông tin tên, thương hiệu, giá gốc, giá so sánh và thuộc tính kỹ thuật động (DPI, Switch, Panel) vào cột JSONB [11, 15]. | Admin | High |
| **FR-PRODUCT-02** | Quản lý biến thể kho (SKU) | Thiết lập các biến thể sản phẩm cụ thể (màu sắc, loại switch, kết nối), ghi đè giá bán (`price_override`), nhập số lượng tồn kho (`stock_quantity`) và mã `sku_variant` [11]. | Admin | High |
| **FR-PRODUCT-03** | Quản lý danh mục | Tạo và sắp xếp danh mục sản phẩm đa cấp (Chuột, Bàn phím, Màn hình, Tai nghe...), giới hạn độ sâu tầng danh mục để tối ưu cấu trúc URL [11]. | Admin | High |
| **FR-SEARCH-01** | Tìm kiếm & Bộ lọc đa tiêu chí | Tìm kiếm theo từ khóa tên/SKU; hỗ trợ lọc linh hoạt theo thương hiệu, khoảng giá và các thuộc tính động trong JSONB (mắt đọc sensor, lực nhấn switch, tần số quét Hz) [11, 15]. | Customer, Guest | High |
| **FR-CART-01** | Quản lý giỏ hàng tạm thời (Guest) | Cho phép khách vãng lai thêm/sửa/xóa biến thể sản phẩm vào giỏ hàng. Lưu giỏ hàng theo `cart_token` trong PostgreSQL hoặc Redis [7, 13]. | Guest | High |
| **FR-CART-02** | Đồng bộ giỏ hàng người dùng | Tự động hợp nhất dữ liệu giỏ hàng tạm thời (`cart_token`) vào giỏ hàng định danh (`user_id`) ngay khi khách hàng thực hiện đăng nhập thành công [13]. | Customer | High |
| **FR-ORDER-01** | Đặt hàng & Xử lý tồn kho (OCC) | Khởi tạo đơn hàng từ giỏ hàng, lưu địa chỉ giao hàng. Kiểm tra và trừ số lượng tồn kho bằng cơ chế Optimistic Concurrency Control (`RowVersion` / `xmin`) để chống over-selling [8, 12]. | Customer | High |
| **FR-ORDER-02** | Tra cứu lịch sử đơn hàng | Cho phép người dùng xem danh sách các đơn hàng đã đặt, chi tiết từng mặt hàng, đơn giá tại thời điểm mua và trạng thái xử lý đơn hàng [6, 12]. | Customer | High |
| **FR-PAYMENT-01** | Thanh toán trực tuyến & COD | Tích hợp cổng thanh toán (VNPay / Stripe) hoặc chọn thanh toán khi nhận hàng (COD). Cập nhật trạng thái `payment_status` tự động qua Webhook callback [6, 7]. | Customer | High |
| **FR-USER-01** | Đăng ký & Đăng nhập tài khoản | Cho phép người dùng đăng ký tài khoản mới, đăng nhập bằng Email/Password. ASP.NET Core kiểm tra mật khẩu và cấp phát cặp Access Token & Refresh Token [6, 17]. | Guest, Customer | High |
| **FR-USER-02** | Đăng nhập đơn nhất (SSO) | Khách hàng đăng nhập trên ReactJS có thể sử dụng mã thông báo JWT để viết bình luận, gửi đánh giá hoặc xem nội dung hạn chế trên Headless WordPress mà không cần đăng nhập lại [1, 20]. | Customer | Medium |
| **FR-CMS-01** | Quản lý bài viết Blog & Review Gear | Biên tập viên soạn thảo, quản lý bài viết đánh giá chi tiết thiết bị, cẩm nang hướng dẫn trên WordPress Gutenberg; xuất bản dữ liệu qua API WPGraphQL [1, 2, 10]. | Content Editor | High |
| **FR-CMS-02** | Quản lý Banner & Khuyến mãi (ACF) | Quản lý cấu hình banner chiến dịch, liên kết khuyến mãi, mã giảm giá, thời gian đếm ngược thông qua các trường tùy biến Advanced Custom Fields (ACF) trên WordPress [9]. | Content Editor | High |
| **FR-ADMIN-01** | Quản trị đơn hàng & Trạng thái | Xem danh sách đơn hàng toàn hệ thống, lọc đơn hàng theo trạng thái (Pending, Processing, Shipped, Cancelled), cập nhật trạng thái vận chuyển và hủy đơn [6, 12]. | Admin | High |
| **FR-ADMIN-02** | Báo cáo tồn kho & Doanh thu | [Thiếu dữ liệu chi tiết trong nguồn — cần bổ sung] (Nguồn chỉ đề cập khả năng ghi log giao dịch và quản lý kho) [6]. | Admin | Medium |
| **FR-SYSTEM-01** | Tự động dọn dẹp Cache (Revalidation) | Gửi tín hiệu HTTP POST Webhook từ WordPress đến điểm cuối `/api/revalidate` của Next.js để làm mới trang tĩnh ngay khi biên tập viên cập nhật bài viết hoặc banner [3, 4]. | System | Medium |

---

# 3. Yêu cầu phi chức năng (Non-functional Requirements)

| Loại yêu cầu | Yêu cầu cụ thể & Số liệu đo lường | Giải pháp & Công nghệ áp dụng |
| :--- | :--- | :--- |
| **Hiệu năng (Performance)** | * Thời gian phản hồi API đọc dữ liệu sản phẩm: `< 50ms` [5].<br>* Thời gian tải trang ban đầu (TTFB): `10 – 50ms` qua CDN [2, 4].<br>* Điểm chỉ số LCP (Largest Contentful Paint): `< 1.5s` [21].<br>* Điểm chỉ số CLS (Cumulative Layout Shift): `< 0.1` [21]. | * Bộ nhớ đệm đa tầng (In-Memory Cache + Redis) tại ASP.NET Core Backend [7].<br>* Kiến trúc kết xuất lai Hybrid Rendering (SSG/ISR/SSR) với Next.js [2, 3].<br>* Tối ưu dung lượng Frontend bằng `shadcn/ui` và `Tailwind CSS` [21, 22]. |
| **Bảo mật (Security)** | * Mã hóa mật khẩu người dùng, mã hóa truyền thông 100% qua HTTPS.<br>* Thời gian sống Access Token: `15 - 30 phút` (In-Memory); Refresh Token: `7 - 14 ngày` (`HttpOnly Cookie`, `SameSite=Strict`) [17].<br>* Phòng chống các lỗ hổng OWASP: XSS, CSRF, SQL Injection, Overselling [5, 12]. | * Cấu hình ASP.NET Core Identity Server phát hành mã thông báo JWT ký số HMAC-SHA256 [6, 17].<br>* Cách ly máy chủ WordPress local sau tường lửa, giới hạn truy cập IP vùng `wp-admin`, vô hiệu hóa XML-RPC [1, 2]. |
| **Khả năng mở rộng (Scalability)** | * Cơ sở dữ liệu hỗ trợ lưu trữ và lọc trên `500k+ SKUs` sản phẩm mà không suy giảm tốc độ truy vấn [11, 15].<br>* Khả năng mở rộng độc lập giữa tầng giao diện hiển thị và tầng xử lý giao dịch [1, 4]. | * Thiết kế thuộc tính sản phẩm dạng lai (Relational + JSONB) kết hợp chỉ mục GIN Index trên PostgreSQL [14, 15].<br>* Phân tách kiến trúc Frontend (Vercel CDN Edge) và Backend API (Docker Containerization) [2, 24]. |
| **Khả dụng (Availability)** | * Chỉ tiêu thời gian hoạt động hệ thống (Uptime): `[Thiếu dữ liệu — cần bổ sung]` (Khuyến nghị đạt 99.9%).<br>* Chỉ tiêu thời gian phục hồi sau sự cố (RTO/RPO): `[Thiếu dữ liệu — cần bổ sung]`. | * Đóng gói ứng dụng Backend bằng Docker Container, hỗ trợ triển khai đa thể hiện (Multi-instance) [8, 24]. |
| **SEO (Search Engine Optimization)** | * Tỉ lệ đạt chỉ số Core Web Vitals: `85 - 95%` [21].<br>* Crawler của các máy tìm kiếm (Googlebot) lập chỉ mục 100% trang sản phẩm và bài viết blog [2, 3].<br>* Tránh lãng phí Crawl Budget do hệ thống lọc thuộc tính đa tầng [11]. | * Sử dụng Next.js kết xuất HTML sẵn từ Server (ISR/SSR) thay cho React SPA CSR thuần túy [1, 3].<br>* Nhúng dữ liệu cấu trúc `Schema.org/Product` (`name`, `sku`, `offers`, `aggregateRating`, `image`).<br>* Quản lý Faceted Taxonomy bằng thẻ `canonical` và cấu hình `robots.txt` disallow [11]. |
| **Khả năng bảo trì (Maintainability)** | * Mã nguồn Backend được phân tách rõ ràng, tuân thủ nguyên lý SOLID, cô lập hoàn toàn logic nghiệp vụ cốt lõi [8, 10].<br>* Mã nguồn Frontend tổ chức theo dạng thành phần tái sử dụng (Component-based) có định kiểu an toàn [6, 7]. | * Triển khai kiến trúc Clean Architecture kết hợp Domain-Driven Design (DDD) gồm 4 lớp: Domain, Infrastructure, Service, Presentation [6, 10].<br>* Xây dựng Frontend bằng ReactJS / Next.js kết hợp TypeScript và Tailwind CSS [7, 21]. |

---

# 4. Kiến trúc hệ thống

### 4.1 Sơ đồ kiến trúc luồng dữ liệu (ASCII Diagram)

```text
+-----------------------------------------------------------------------------------+
|                                 REACTJS / NEXT.JS FRONTEND                        |
|                           (Storefront UI - Gaming Gear Store)                     |
+-----------------------------------------------------------------------------------+
             |                                              |
             | (1) REST API (HTTPS/JSON)                    | (2) WPGraphQL / REST API
             |     - Product Catalog & Filters              |     - Blog Posts & Reviews
             |     - Cart & Checkout Operations             |     - Banner Promo (ACF)
             |     - User Identity / JWT                    |     - Static Pages
             v                                              v
+-----------------------------------+             +---------------------------------+
|        ASP.NET Core API           |             |      Headless WordPress CMS    |
|   (Business Logic & Identity)     |             |      (Content Management)       |
+-----------------------------------+             +---------------------------------+
             |                                              |
             | Entity Framework Core                        | MySQL Driver
             v                                              v
+-----------------------------------+             +---------------------------------+
|        PostgreSQL Database        |             |        WordPress Database       |
|    (Relational + JSONB Schema)    |             |             (MySQL)             |
+-----------------------------------+             +---------------------------------+
```

### 4.2 Cấu trúc project ASP.NET Core theo Clean Architecture

```text
Backend (ASP.NET Core Solution)
├── Ecommerce.Domain (Lõi thực thể & Logic nghiệp vụ)
│   ├── Entities/ (Product, ProductVariant, Category, Brand, ShoppingCart, Order...)
│   ├── Enums/ (OrderStatus, PaymentStatus, SwitchType...)
│   ├── Interfaces/ (IUnitOfWork, IProductRepository, IOrderRepository...)
│   └── ValueObjects/ (Address, Money...)
├── Ecommerce.Application (Tầng điều phối ứng dụng & Use Cases)
│   ├── Products/ (Queries, Commands, DTOs, Handlers MediatR)
│   ├── Orders/ (Queries, Commands, DTOs, Handlers MediatR)
│   ├── Common/ (Behaviors, Exceptions, Mappings AutoMapper)
│   └── Interfaces/ (ICurrentUserService, IDateTime...)
├── Ecommerce.Infrastructure (Tầng kết nối dữ liệu & Dịch vụ ngoài)
│   ├── Persistence/ (ApplicationDbContext, EF Configurations, Migrations)
│   ├── Repositories/ (GenericRepository, ProductRepository...)
│   ├── Identity/ (ApplicationUser, IdentityService, JwtTokenGenerator)
│   └── ExternalServices/ (VnPayService, StripeService, EmailSender)
└── Ecommerce.Presentation (Tầng tiếp nhận yêu cầu API)
    ├── Controllers/ (ProductsController, OrdersController, AuthController...)
    ├── Middlewares/ (ExceptionHandlingMiddleware, SecurityHeadersMiddleware)
    └── Program.cs
```

### 4.3 Bảng phân định thành phần hệ thống

| Thành phần | Công nghệ | Vai trò | Giao tiếp với |
| :--- | :--- | :--- | :--- |
| **Storefront Frontend** | ReactJS / Next.js | Hiển thị giao diện cửa hàng, bộ lọc sản phẩm, giỏ hàng, thanh toán và bài viết blog [1, 7]. | ASP.NET Core API qua RESTful API (HTTPS/JSON); WordPress qua WPGraphQL/REST [1, 26]. |
| **Backend Commerce API** | ASP.NET Core 8 | Xử lý logic nghiệp vụ bán hàng, quản lý đơn hàng, giỏ hàng, tồn kho và cấp phát JWT [5, 6]. | ReactJS Frontend (nhận/trả REST JSON); PostgreSQL Database (qua EF Core) [6, 12]. |
| **Headless CMS** | WordPress Local | Quản lý bài viết đánh giá gear, cẩm nang tư vấn, banner khuyến mãi tùy biến qua ACF [1, 9]. | ReactJS Frontend qua WPGraphQL API hoặc REST API [1, 10]. |
| **Commerce Database** | PostgreSQL | Lưu trữ dữ liệu quan hệ (người dùng, đơn hàng, tồn kho) và cột JSONB lưu thông số kỹ thuật động [12, 15]. | ASP.NET Core API qua Entity Framework Core (Npgsql Provider) [6, 14]. |
| **CMS Database** | MySQL | Lưu trữ bài viết, trang tĩnh, danh mục tin tức và cấu hình ACF của WordPress [2, 10]. | Headless WordPress CMS qua native PHP MySQL Driver [1, 2]. |

---

# 5. Thiết kế cơ sở dữ liệu

### 5.1 Sơ đồ quan hệ ERD dạng text

```text
[categories] (1) <--- (N) [products] (1) <--- (N) [product_variants]
                               |                       |
                               v                       +--- (1) <--- (N) [cart_items] ---> (N) ---> (1) [shopping_carts]
                        [brands] (1) <--- (N)          |
                                                       +--- (1) <--- (N) [order_items] ---> (N) ---> (1) [orders] ---> (1) ---> (1) [payments]
                                                       |
                                                       +--- (1) <--- (N) [inventory]
```

### 5.2 Bảng chi tiết từng Entity trong Commerce Database

#### 1. Bảng `products` (Product Entity)
| Tên trường | Kiểu dữ liệu | Khóa / Ràng buộc | Ghi chú |
| :--- | :--- | :--- | :--- |
| `id` | BIGINT | Primary Key, Auto Increment | Mã định danh duy nhất sản phẩm. |
| `sku` | VARCHAR(50) | UNIQUE, NOT NULL | Mã SKU gốc quản lý sản phẩm. |
| `name` | VARCHAR(255) | NOT NULL | Tên sản phẩm gaming gear. |
| `slug` | VARCHAR(255) | UNIQUE, NOT NULL | Chuỗi đường dẫn phục vụ SEO. |
| `price` | DECIMAL(12,2) | NOT NULL | Giá bán niêm yết chuẩn. |
| `compare_at_price` | DECIMAL(12,2) | NULL | Giá gạch (giá gốc trước giảm). |
| `specifications` | JSONB | NOT NULL | Lưu thông số kỹ thuật động (DPI, Switch, Panel...). |
| `brand_id` | BIGINT | Foreign Key (`brands.id`), NOT NULL | Mã thương hiệu sản xuất. |
| `category_id` | BIGINT | Foreign Key (`categories.id`), NOT NULL | Mã danh mục sản phẩm. |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Thời điểm tạo bản ghi. |

#### 2. Bảng `product_variants` (ProductVariant Entity)
| Tên trường | Kiểu dữ liệu | Khóa / Ràng buộc | Ghi chú |
| :--- | :--- | :--- | :--- |
| `id` | BIGINT | Primary Key, Auto Increment | Mã định danh biến thể. |
| `product_id` | BIGINT | Foreign Key (`products.id`), NOT NULL | Thuộc về sản phẩm gốc nào. |
| `sku_variant` | VARCHAR(50) | UNIQUE, NOT NULL | Mã SKU riêng của biến thể kho. |
| `name` | VARCHAR(150) | NOT NULL | Tên biến thể (vd: "Màu Đen - Switch Red"). |
| `price_override` | DECIMAL(12,2) | NULL | Giá bán riêng cho biến thể nếu có. |
| `stock_quantity` | INT | NOT NULL, DEFAULT 0 | Số lượng tồn kho thực tế. |
| `is_active` | BOOLEAN | DEFAULT TRUE | Trạng thái cho phép kinh doanh. |

#### 3. Bảng `categories` (Category Entity)
| Tên trường | Kiểu dữ liệu | Khóa / Ràng buộc | Ghi chú |
| :--- | :--- | :--- | :--- |
| `id` | BIGINT | Primary Key, Auto Increment | Mã danh mục. |
| `name` | VARCHAR(100) | NOT NULL | Tên danh mục (Chuột, Bàn phím, Màn hình...). |
| `slug` | VARCHAR(100) | UNIQUE, NOT NULL | Đường dẫn SEO danh mục. |
| `parent_id` | BIGINT | Foreign Key (`categories.id`), NULL | Tham chiếu danh mục cha (đa cấp). |

#### 4. Bảng `brands` (Brand Entity)
| Tên trường | Kiểu dữ liệu | Khóa / Ràng buộc | Ghi chú |
| :--- | :--- | :--- | :--- |
| `id` | BIGINT | Primary Key, Auto Increment | Mã thương hiệu. |
| `name` | VARCHAR(100) | NOT NULL | Tên hãng (Razer, Logitech, Corsair...). |
| `slug` | VARCHAR(100) | UNIQUE, NOT NULL | Đường dẫn SEO thương hiệu. |
| `logo_url` | VARCHAR(500) | NULL | Đường dẫn ảnh logo thương hiệu. |

#### 5. Bảng `shopping_carts` (Cart Entity)
| Tên trường | Kiểu dữ liệu | Khóa / Ràng buộc | Ghi chú |
| :--- | :--- | :--- | :--- |
| `id` | BIGINT | Primary Key, Auto Increment | Mã giỏ hàng. |
| `user_id` | UUID | Foreign Key (`users.id`), NULL | Khóa ngoại người dùng (NULL nếu là vãng lai). |
| `cart_token` | VARCHAR(100) | UNIQUE, NOT NULL | Token định danh giỏ hàng tạm thời. |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Thời gian khởi tạo giỏ. |

#### 6. Bảng `cart_items` (CartItem Entity)
| Tên trường | Kiểu dữ liệu | Khóa / Ràng buộc | Ghi chú |
| :--- | :--- | :--- | :--- |
| `id` | BIGINT | Primary Key, Auto Increment | Mã mục trong giỏ. |
| `cart_id` | BIGINT | Foreign Key (`shopping_carts.id`), NOT NULL | Khóa ngoại tham chiếu giỏ hàng. |
| `variant_id` | BIGINT | Foreign Key (`product_variants.id`), NOT NULL | Biến thể sản phẩm được chọn. |
| `quantity` | INT | NOT NULL, CHECK (`quantity` > 0) | Số lượng chọn mua. |

#### 7. Bảng `orders` (Order Entity)
| Tên trường | Kiểu dữ liệu | Khóa / Ràng buộc | Ghi chú |
| :--- | :--- | :--- | :--- |
| `id` | BIGINT | Primary Key, Auto Increment | Mã định danh đơn hàng. |
| `user_id` | UUID | Foreign Key (`users.id`), NULL | Mã khách hàng đặt đơn. |
| `order_number` | VARCHAR(100) | UNIQUE, NOT NULL | Mã đơn hàng (vd: ORD-20260913-001). |
| `total_amount` | DECIMAL(12,2) | NOT NULL | Tổng giá trị đơn hàng. |
| `status` | VARCHAR(50) | NOT NULL, DEFAULT 'Pending' | Trạng thái (Pending, Processing, Shipped, Cancelled). |
| `shipping_address` | TEXT | NOT NULL | Địa chỉ giao hàng đầy đủ. |
| `payment_status` | VARCHAR(50) | NOT NULL, DEFAULT 'Unpaid' | Trạng thái thanh toán (Unpaid, Paid). |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Ngày giờ chốt đơn hàng. |

#### 8. Bảng `order_items` (OrderItem Entity)
| Tên trường | Kiểu dữ liệu | Khóa / Ràng buộc | Ghi chú |
| :--- | :--- | :--- | :--- |
| `id` | BIGINT | Primary Key, Auto Increment | Mã chi tiết đơn hàng. |
| `order_id` | BIGINT | Foreign Key (`orders.id`), NOT NULL | Mã đơn hàng tham chiếu. |
| `variant_id` | BIGINT | Foreign Key (`product_variants.id`), NOT NULL | Biến thể sản phẩm mua. |
| `quantity` | INT | NOT NULL | Số lượng mua. |
| `unit_price` | DECIMAL(12,2) | NOT NULL | Đơn giá mua tại thời điểm chốt. |

#### 9. Bảng `users` (User Entity)
| Tên trường | Kiểu dữ liệu | Khóa / Ràng buộc | Ghi chú |
| :--- | :--- | :--- | :--- |
| `id` | UUID | Primary Key, DEFAULT `gen_random_uuid()` | Mã định danh duy nhất người dùng. |
| `email` | VARCHAR(255) | UNIQUE, NOT NULL | Email đăng nhập. |
| `password_hash` | VARCHAR(255) | NOT NULL | Chuỗi băm mật khẩu bảo mật. |
| `full_name` | VARCHAR(150) | NOT NULL | Họ và tên đầy đủ. |
| `phone_number` | VARCHAR(20) | NULL | Số điện thoại liên hệ. |
| `role` | VARCHAR(50) | NOT NULL, DEFAULT 'Customer' | Vai trò (Customer, Admin). |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Thời gian tạo tài khoản. |

#### 10. Bảng `payments` (Payment Entity)
| Tên trường | Kiểu dữ liệu | Khóa / Ràng buộc | Ghi chú |
| :--- | :--- | :--- | :--- |
| `id` | BIGINT | Primary Key, Auto Increment | Mã giao dịch. |
| `order_id` | BIGINT | Foreign Key (`orders.id`), NOT NULL | Mã đơn hàng tương ứng. |
| `payment_method` | VARCHAR(50) | NOT NULL | Phương thức (COD, VNPay, Stripe). |
| `transaction_id` | VARCHAR(255) | NULL | Mã giao dịch từ cổng thanh toán. |
| `amount` | DECIMAL(12,2) | NOT NULL | Số tiền thanh toán. |
| `status` | VARCHAR(50) | NOT NULL, DEFAULT 'Pending' | Trạng thái (Pending, Completed, Failed). |
| `created_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Thời gian thanh toán. |

#### 11. Bảng `inventory` (Inventory Entity)
| Tên trường | Kiểu dữ liệu | Khóa / Ràng buộc | Ghi chú |
| :--- | :--- | :--- | :--- |
| `id` | BIGINT | Primary Key, Auto Increment | Mã bản ghi kho. |
| `variant_id` | BIGINT | Foreign Key (`product_variants.id`), UNIQUE | Biến thể sản phẩm trong kho. |
| `quantity` | INT | NOT NULL, DEFAULT 0 | Số lượng khả dụng trong kho. |
| `reserved_quantity` | INT | DEFAULT 0 | Số lượng đang giữ chờ chốt đơn. |
| `warehouse_location` | VARCHAR(100) | NULL | Vị trí ô/kệ kho hàng. |
| `updated_at` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Thời gian cập nhật kho. |

### 5.3 Cấu trúc JSONB mẫu cho thuộc tính động (`specifications`)

**Chuột Gaming:**
```json
{
  "sensor": "Focus Pro 30K Optical",
  "max_dpi": 30000,
  "polling_rate_hz": 4000,
  "switch_type": "Razer Optical Gen-3",
  "weight_grams": 63,
  "connectivity": ["2.4GHz Wireless", "Bluetooth", "USB-C Cable"],
  "rgb_lighting": true
}
```

**Bàn Phím Cơ Gaming:**
```json
{
  "layout": "TKL (87 keys)",
  "switch_type": "Cherry MX Red Linear",
  "keycap_material": "PBT Double-shot",
  "hotswap": true,
  "connectivity": ["USB-C Cable", "2.4GHz Wireless"],
  "plate_material": "Aluminum"
}
```

---

# 6. Ví dụ code minh hoạ

### 6.1 ASP.NET Core: Repository + Service + Controller (Lấy danh sách sản phẩm có phân trang, lọc)

**Repository (`ProductRepository.cs`)**:
```csharp
using Ecommerce.Domain.Entities;
using Ecommerce.Domain.Interfaces;
using Ecommerce.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace Ecommerce.Infrastructure.Repositories
{
    public class ProductRepository : IProductRepository
    {
        private readonly ApplicationDbContext _context;

        public ProductRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<(List<Product> Items, int TotalCount)> GetFilteredProductsAsync(
            string? categorySlug, string? brand, decimal? minPrice, decimal? maxPrice, int page, int pageSize)
        {
            var query = _context.Products
                .Include(p => p.Category)
                .Include(p => p.Variants)
                .AsNoTracking();

            if (!string.IsNullOrEmpty(categorySlug))
                query = query.Where(p => p.Category.Slug == categorySlug);

            if (!string.IsNullOrEmpty(brand))
                query = query.Where(p => p.Brand == brand);

            if (minPrice.HasValue)
                query = query.Where(p => p.Price >= minPrice.Value);

            if (maxPrice.HasValue)
                query = query.Where(p => p.Price <= maxPrice.Value);

            int totalCount = await query.CountAsync();

            var items = await query
                .OrderByDescending(p => p.CreatedAt)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            return (items, totalCount);
        }
    }
}
```

**Controller (`ProductsController.cs`)**:
```csharp
using Ecommerce.Application.DTOs;
using Ecommerce.Application.Services;
using Microsoft.AspNetCore.Mvc;

namespace Ecommerce.Presentation.Controllers
{
    [ApiController]
    [Route("api/v1/[controller]")]
    public class ProductsController : ControllerBase
    {
        private readonly IProductService _productService;

        public ProductsController(IProductService productService)
        {
            _productService = productService;
        }

        [HttpGet]
        public async Task<IActionResult> GetProducts([FromQuery] ProductFilterDto filter)
        {
            if (filter.Page <= 0) filter.Page = 1;
            if (filter.PageSize <= 0 || filter.PageSize > 50) filter.PageSize = 10;

            var result = await _productService.GetProductsAsync(filter);
            return Ok(result);
        }
    }
}
```

### 6.2 Entity Framework Core: Định nghĩa Entity & DbContext Configuration

**Fluent API Configuration (`ProductConfiguration.cs`)**:
```csharp
using Ecommerce.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Ecommerce.Infrastructure.Persistence.Configurations
{
    public class ProductConfiguration : IEntityTypeConfiguration<Product>
    {
        public void Configure(EntityTypeBuilder<Product> builder)
        {
            builder.ToTable("products");

            builder.HasKey(p => p.Id);
            builder.HasIndex(p => p.Sku).IsUnique();
            builder.HasIndex(p => p.Slug).IsUnique();

            builder.Property(p => p.Name).HasMaxLength(255).IsRequired();
            builder.Property(p => p.Price).HasPrecision(12, 2).IsRequired();
            builder.Property(p => p.Specifications).HasColumnType("jsonb").IsRequired();

            builder.HasOne(p => p.Category)
                   .WithMany()
                   .HasForeignKey(p => p.CategoryId)
                   .OnDelete(DeleteBehavior.Restrict);

            builder.HasMany(p => p.Variants)
                   .WithOne(v => p.Product)
                   .HasForeignKey(v => v.ProductId)
                   .OnDelete(DeleteBehavior.Cascade);
        }
    }
}
```

### 6.3 ReactJS Component: Gọi API lấy danh sách sản phẩm và hiển thị

```tsx
import React, { useEffect, useState } from 'react';
import axios from 'axios';

interface Product {
  id: number;
  sku: string;
  name: string;
  slug: string;
  price: number;
  brand: string;
  categoryName: string;
}

interface PagedResult {
  items: Product[];
  totalCount: number;
  page: number;
  pageSize: number;
}

export const ProductListCatalog: React.FC = () => {
  const [data, setData] = useState<PagedResult | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [category, setCategory] = useState<string>('');

  useEffect(() => {
    const fetchProducts = async () => {
      setLoading(true);
      try {
        const response = await axios.get<PagedResult>('http://localhost:5000/api/v1/products', {
          params: { page: 1, pageSize: 12, category: category || undefined }
        });
        setData(response.data);
      } catch (err) {
        console.error('Lỗi tải sản phẩm:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchProducts();
  }, [category]);

  if (loading) return <div className="p-4 text-center">Đang tải sản phẩm Gaming Gear...</div>;

  return (
    <div className="container mx-auto p-4">
      <h1 className="text-2xl font-bold mb-4">Danh Sách Gaming Gear</h1>
      
      <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-6">
        {data?.items.map((product) => (
          <div key={product.id} className="border rounded-lg p-4 shadow hover:shadow-lg transition">
            <h2 className="font-semibold text-lg">{product.name}</h2>
            <p className="text-gray-500 text-sm">Hãng: {product.brand}</p>
            <p className="text-red-600 font-bold mt-2">
              {product.price.toLocaleString('vi-VN')} VNĐ
            </p>
          </div>
        ))}
      </div>
    </div>
  );
};
```

### 6.4 Truy vấn WPGraphQL: Lấy bài viết Blog từ Headless WordPress

```tsx
import React, { useEffect, useState } from 'react';

const GET_BLOG_POSTS_QUERY = `
  query GetLatestGearReviews {
    posts(first: 6, where: { categoryName: "Review Gear" }) {
      nodes {
        id
        title
        slug
        excerpt
        date
      }
    }
  }
`;

export const BlogLatestReviews: React.FC = () => {
  const [posts, setPosts] = useState<any[]>([]);

  useEffect(() => {
    fetch('http://localhost:8000/graphql', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ query: GET_BLOG_POSTS_QUERY })
    })
      .then(res => res.json())
      .then(result => setPosts(result.data?.posts?.nodes || []));
  }, []);

  return (
    <section className="my-8">
      <h2 className="text-xl font-bold mb-4">Bài Viết Đánh Giá Gear Mới Nhất</h2>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {posts.map((post) => (
          <article key={post.id} className="border p-4 rounded bg-gray-50">
            <h3 className="font-semibold text-md text-blue-800">{post.title}</h3>
            <div dangerouslySetInnerHTML={{ __html: post.excerpt }} />
          </article>
        ))}
      </div>
    </section>
  );
};
```

---

# 7. Tích hợp WordPress Headless CMS & SSO Authentication

### 7.1 Danh sách Plugin bắt buộc cài đặt
1. **`WPGraphQL`**: Chuyển đổi toàn bộ dữ liệu WordPress sang cấu hình GraphQL.
2. **`Advanced Custom Fields (ACF PRO)`**: Tạo các trường dữ liệu tùy biến cho banner khuyến mãi và bài đánh giá sản phẩm.
3. **`WPGraphQL for ACF`**: Expose các trường ACF tùy biến vào Schema của WPGraphQL.
4. **`JWT Authentication for WP REST API`**: Giải mã và xác thực token JWT được cấp phát từ ASP.NET Core.

### 7.2 Cấu hình CORS & Webhook Revalidate

**Cấu hình CORS trong `functions.php` của WordPress**:
```php
add_action('init', function() {
    header("Access-Control-Allow-Origin: https://your-gaming-store.com");
    header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
    header("Access-Control-Allow-Headers: Authorization, Content-Type");
    if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
        status_header(200);
        exit();
    }
});
```

**Cấu hình Webhook Revalidate khi cập nhật bài viết**:
```php
add_action('save_post', 'notify_nextjs_for_cache_invalidation', 10, 3);
function notify_nextjs_for_cache_invalidation($post_id, $post, $update) {
    if (!$update || wp_is_post_revision($post_id) || $post->post_status !== 'publish') {
        return;
    }
    
    $nextjs_api_url = 'https://your-gaming-store.com/api/revalidate';
    wp_remote_post($nextjs_api_url, array(
        'method'    => 'POST',
        'headers'   => array('Content-Type' => 'application/json'),
        'body'      => json_encode(array(
            'secret' => 'SECURE_REVALIDATION_TOKEN',
            'slug'   => $post->post_name
        )),
        'blocking'  => false,
    ));
}
```

### 7.3 Sơ đồ luồng xác thực SSO giữa ASP.NET Core và WordPress

```text
+--------------+               (1) Submit Credentials               +-------------------+
|   ReactJS    | -------------------------------------------------> |   ASP.NET Core    |
|  Frontend    | <------------------------------------------------- | Identity Server   |
+--------------+             (2) Return JWT Access Token            +-------------------+
       |
       | (3) Request Protected Blog Content
       |     Authorization: Bearer <JWT>
       v
+--------------+             (4) Self-verify Signature              +-------------------+
|   Headless   | <------------------------------------------------- | Validates JWT or  |
|  WordPress   | -------------------------------------------------> | Reads Shared Key  |
+--------------+               (5) Return Content                   +-------------------+
```

---

# 8. Rủi ro, Kế hoạch vận hành & Nguồn tham khảo

### 8.1 Bảng rủi ro kỹ thuật & Giải pháp

| Nhóm rủi ro | Nguyên nhân | Giải pháp kỹ thuật | Công nghệ áp dụng |
| :--- | :--- | :--- | :--- |
| **Bán quá tồn kho (Overselling)** | Nhấn mua hàng đồng thời trong đợt Flash Sale [12]. | Kiểm soát tranh chấp đồng thời lạc quan (OCC) [8]. | EF Core `RowVersion` / PostgreSQL `xmin` [8, 12]. |
| **SEO bị giảm điểm do SPA** | Bot Google không render được mã JavaScript [2, 3]. | Chuyển sang kiến trúc kết xuất kết hợp (Hybrid Rendering) [1, 3]. | Next.js ISR & SSG [2, 3]. |
| **CORS Block API** | Khác tên miền / port giữa Frontend và CMS [1]. | Cấu hình Header Allow-Origin tại máy chủ web [1]. | File `.htaccess` / `functions.php` [1]. |
| **Quá tải Database khi xem hàng** | Lượng truy vấn đọc sản phẩm tăng đột biến [14]. | Triển khai bộ nhớ đệm đa tầng (Multi-level Caching) [7]. | In-Memory Cache + Redis [7]. |

### 8.2 Kế hoạch triển khai với Docker Compose

```yaml
version: '3.8'
services:
  postgres_db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: gaming_gear_db
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: SecurePassword123!
    ports:
      - "5432:5432"

  wordpress_cms:
    image: wordpress:cli-php8.2
    environment:
      WORDPRESS_DB_HOST: mysql_db
      WORDPRESS_DB_USER: wp_user
      WORDPRESS_DB_PASSWORD: WpPassword123!
      WORDPRESS_DB_NAME: wp_headless
    ports:
      - "8000:80"

  mysql_db:
    image: mysql:8.0
    environment:
      MYSQL_DATABASE: wp_headless
      MYSQL_USER: wp_user
      MYSQL_PASSWORD: WpPassword123!
      MYSQL_ROOT_PASSWORD: RootPassword123!
```

### 8.3 Danh sách Nguồn tham khảo

1. **Headless WordPress with React (2026): A Practical Guide for Developers and Tech Leads**, [https://mahmoodchowdhury.com/blog/how-to-integrate-react-into-wordpress/](https://mahmoodchowdhury.com/blog/how-to-integrate-react-into-wordpress/)
2. **Headless WordPress: The Complete Guide for 2025 - NeuronThemes Blog**, [https://neuronthemes.com/headless-wordpress-complete-guide/](https://neuronthemes.com/headless-wordpress-complete-guide/)
3. **WordPress Is Not Dead — It's Headless: A Complete React Integration Guide**, [https://dev.to/kushang_tailor/wordpress-is-not-dead-its-headless-a-complete-react-integration-guide-3ool](https://dev.to/kushang_tailor/wordpress-is-not-dead-its-headless-a-complete-react-integration-guide-3ool)
4. **The Complete Guide to Headless WordPress: When and Why to Decouple - Rivulet IQ**, [https://www.rivuletiq.com/complete-guide-headless-wordpress-development/](https://www.rivuletiq.com/complete-guide-headless-wordpress-development/)
5. **ASP.NET Core, an open-source web development framework**, [https://dotnet.microsoft.com/en-us/apps/aspnet](https://dotnet.microsoft.com/en-us/apps/aspnet)
6. **MohamadNach/fullstack-ecommerce-app: React, C sharp fullstack e-commerce project - GitHub**, [https://github.com/MohamadNach/fullstack-ecommerce-app](https://github.com/MohamadNach/fullstack-ecommerce-app)
7. **Ecommerce App using ASP.NET Core and React - GitHub**, [https://github.com/VictorLCosta/eCommerce-App](https://github.com/VictorLCosta/eCommerce-App)
8. **10+ Open Source ASP.NET Core Projects 2026 - ThemeSelection**, [https://themeselection.com/blog/asp-net-core-projects-with-source-code/](https://themeselection.com/blog/asp-net-core-projects-with-source-code/)
9. **ACF | Creating Headless WordPress Sites with React - Advanced Custom Fields**, [https://www.advancedcustomfields.com/blog/wordpress-react/](https://www.advancedcustomfields.com/blog/wordpress-react/)
10. **Where to Start With Headless WordPress - Delicious Brains**, [https://deliciousbrains.com/where-to-start-with-headless-wordpress/](https://deliciousbrains.com/where-to-start-with-headless-wordpress/)
11. **E-commerce Product Catalog Architecture: SKU, Taxonomy & Attributes**, [https://www.codesoltech.com/blog/e-commerce-product-catalog-architecture/](https://www.codesoltech.com/blog/e-commerce-product-catalog-architecture/)
12. **E-commerce Database Design: Complete Schema Example (2025) | Skemato Blog**, [https://skemato.com/blog/ecommerce-database-design-example](https://skemato.com/blog/ecommerce-database-design-example)
13. **How to Design a Shopping Cart Database | AppMaster**, [https://appmaster.io/blog/how-to-design-a-shopping-cart-database](https://appmaster.io/blog/how-to-design-a-shopping-cart-database)
14. **How to Choose the Right Database for Your E-commerce Platform - SME News**, [https://smenews.digital/how-to-choose-the-right-database-for-your-e-commerce-platform/](https://smenews.digital/how-to-choose-the-right-database-for-your-e-commerce-platform/)
15. **Database Design for Product Management | by Mojtaba Azad - Medium**, [https://mojtabaazad.medium.com/database-design-for-product-management-9280fd7c66fe](https://mojtabaazad.medium.com/database-design-for-product-management-9280fd7c66fe)
16. **Ecommerce Database Design: ER Diagram for Online Shopping - Redgate**, [https://www.red-gate.com/blog/er-diagram-for-online-shop/](https://www.red-gate.com/blog/er-diagram-for-online-shop/)
17. **ASP.NET OAuth Single Sign-On (SSO) - Plugins - miniOrange**, [https://plugins.miniorange.com/asp-net-oauth-2-0-single-sign-on-sso-module](https://plugins.miniorange.com/asp-net-oauth-2-0-single-sign-on-sso-module)
18. **C# ASP.NET Single Sign-On Implementation - Stack Overflow**, [https://stackoverflow.com/questions/14309090/c-sharp-asp-net-single-sign-on-implementation](https://stackoverflow.com/questions/14309090/c-sharp-asp-net-single-sign-on-implementation)
19. **Azure AD single sign-on (SSO) integration in .Net core application - Genix Technologies**, [https://www.genixtec.com/azure-ad-single-sign-on-sso-integration-in-net-core-application/](https://www.genixtec.com/azure-ad-single-sign-on-sso-integration-in-net-core-application/)
20. **ASP.NET SAML Single Sign-On (SSO) using WordPress as IDP - Plugins - miniOrange**, [https://plugins.miniorange.com/aspnet-saml-sso-using-wordpress-as-idp](https://plugins.miniorange.com/aspnet-saml-sso-using-wordpress-as-idp)
21. **17 Best React UI Libraries in 2026 (Ranked by Use Case) | ShadcnDeck**, [https://www.shadcndeck.com/blog/best-react-ui-libraries-2026](https://www.shadcndeck.com/blog/best-react-ui-libraries-2026)
22. **15 Best React UI Component Libraries in 2026 (+ Alternatives to MUI & Shadcn) - Untitled UI**, [https://www.untitledui.com/blog/react-component-libraries](https://www.untitledui.com/blog/react-component-libraries)
23. **Best approach for SSO for Asp.Net application with Login from external application with multiple ADFS**, [https://stackoverflow.com/questions/32072602/best-approach-for-sso-for-asp-net-application-with-login-from-external-applicati](https://stackoverflow.com/questions/32072602/best-approach-for-sso-for-asp-net-application-with-login-from-external-applicati)
24. **GitHub - dotnet/eShop: A reference .NET application implementing an eCommerce site**, [https://github.com/dotnet/eshop](https://github.com/dotnet/eshop)
25. **Top .NET (ASP.NET Core) Open-Source Projects | by Ashish Patel | .NET Hub - Medium**, [https://medium.com/dotnet-hub/top-net-asp-net-core-open-source-projects-6261569bdb06](https://medium.com/dotnet-hub/top-net-asp-net-core-open-source-projects-6261569bdb06)
26. **ASP.NET Core SAML Single Sign-On (SSO) Using WordPress as IDP**, [https://plugins.miniorange.com/asp-net-core-saml-single-sign-on-sso-using-wordpress-as-idp](https://plugins.miniorange.com/asp-net-core-saml-single-sign-on-sso-using-wordpress-as-idp)
