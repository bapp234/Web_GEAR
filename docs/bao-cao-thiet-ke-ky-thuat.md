# BÁO CÁO THIẾT KẾ KỸ THUẬT HỆ THỐNG E-COMMERCE GAMING GEAR
**Công nghệ:** ASP.NET Core (Backend) + ReactJS / Next.js (Frontend) + WordPress Local (Headless CMS)

---

## 1. Tổng quan dự án

* **Mục tiêu**: Xây dựng hệ thống thương mại điện tử chuyên biệt kinh doanh thiết bị gaming gear (chuột, bàn phím, lót chuột, màn hình, loa...) có hiệu năng cao, mở rộng linh hoạt, bảo mật và phân tách hoàn toàn giữa tầng xử lý nghiệp vụ thương mại và tầng quản trị nội dung tiếp thị.
* **Phạm vi hệ thống**:
  * **Backend (ASP.NET Core)**: Cung cấp API xử lý giao dịch thương mại, giỏ hàng, đơn hàng, thanh toán, kho hàng và quản lý tài khoản.
  * **Headless CMS (WordPress Local)**: Tận dụng giao diện biên tập trực quan để quản lý bài viết blog, đánh giá sản phẩm, cẩm nang tư vấn và banner khuyến mãi.
  * **Frontend (ReactJS / Next.js)**: Cửa hàng trực tuyến dạng Single-Page Application (SPA) / SSR hiển thị giao diện mượt mà, tối ưu hóa tốc độ tải trang và trải nghiệm người dùng.
* **Đối tượng người dùng**:
  * **Khách hàng (Game thủ, người yêu công nghệ)**: Tìm kiếm sản phẩm, lọc thông số kỹ thuật chi tiết (DPI, loại Switch, Panel), xem đánh giá, đặt hàng và thanh toán.
  * **Biên tập viên / Content Marketer**: Quản lý nội dung bài viết tiếp thị, cẩm nang hướng dẫn và banner khuyến mãi trên WordPress.
  * **Quản trị viên cửa hàng (Admin)**: Quản lý danh mục sản phẩm, biến thể tồn kho, xử lý đơn hàng và doanh thu trên ASP.NET Core Dashboard.

---

## 2. Kiến trúc hệ thống

### Sơ đồ luồng dữ liệu & tương tác

```text
                     +-----------------------------------+
                     |     ReactJS / Next.js Frontend     |
                     |  (Storefront Cửa Hàng Gaming Gear) |
                     +-----------------------------------+
                               /               \
       (1) Luồng Giao Dịch  /                 \  (2) Luồng Nội Dung
      (Sản phẩm, Đơn hàng) /                   \  (Blog, Banner, ACF)
                          v                     v
            +--------------------+       +---------------------+
            |  ASP.NET Core API  |       |  Headless WordPress |
            |  (Identity Server) |       |   (WPGraphQL / REST)|
            +--------------------+       +---------------------+
                      |                             |
                      v                             v
            +--------------------+       +---------------------+
            | PostgreSQL Database|       |  WordPress Database |
            | (Relational + JSON)|       |      (MySQL)        |
            +--------------------+       +---------------------+
```

### Bảng phân tách luồng dữ liệu & Tần suất tương tác

| Hạng mục dữ liệu | Hệ thống xử lý chính | Phương thức giao tiếp | Mô tả luồng dữ liệu |
| :--- | :--- | :--- | :--- |
| **Sản phẩm & Biến thể** | ASP.NET Core API | RESTful API (JSON) | ReactJS gọi API lấy thông tin giá, thuộc tính kỹ thuật động và tồn kho thực tế. |
| **Giỏ hàng & Đơn hàng** | ASP.NET Core API | RESTful API (JSON) | Quản lý phiên mua hàng, giữ kho bằng Optimistic Concurrency Control. |
| **Xác thực & SSO** | ASP.NET Core (IdP) | JWT (Access/Refresh) | ASP.NET Core phát hành JWT Token; WordPress giải mã bằng Shared Secret Key. |
| **Blog & Banner** | WordPress Local | WPGraphQL / REST API | Biên tập viên cập nhật trên WordPress; ReactJS truy vấn hiển thị ngầm. |

### Vai trò của từng thành phần
* **ReactJS / Next.js (Frontend)**: Đảm nhận toàn bộ giao diện cửa hàng, kết xuất lai (Hybrid Rendering: ISR/SSG/SSR) giúp tối ưu điểm SEO và tốc độ hiển thị.
* **ASP.NET Core (Backend API)**: Xử lý logic nghiệp vụ bán hàng có trạng thái, áp dụng kiến trúc Clean Architecture/DDD và mẫu thiết kế Repository Pattern.
* **WordPress Local (Headless CMS)**: Lưu trữ và phân phối nội dung tĩnh/bán tĩnh qua WPGraphQL hoặc REST API, loại bỏ giao diện PHP cồng kềnh phía người dùng.
* **Cơ sở dữ liệu (PostgreSQL)**: Lưu trữ dữ liệu quan hệ kết hợp tài liệu (JSONB) cho thuộc tính gaming gear phức tạp.

---

## 3. Bảng so sánh & lựa chọn công nghệ

| Thành phần | Công nghệ đề xuất | Lý do chọn | Nguồn tham khảo |
| :--- | :--- | :--- | :--- |
| **Backend Framework** | **ASP.NET Core 8 / 10** | Hiệu năng xử lý giao dịch vượt trội (TechEmpower Benchmark), bảo mật cao, hỗ trợ Clean Architecture & DDD chuẩn doanh nghiệp. | Microsoft Docs, eShop Reference |
| **Frontend Framework** | **ReactJS (Next.js)** | Hỗ trợ ISR/SSG/SSR giúp tối ưu SEO, tự động Revalidate cache khi có bài viết/banner mới từ WordPress. | Mahmood Chowdhury, DEV Community |
| **Headless CMS** | **WordPress Local** | Trải nghiệm quản trị nội dung trực quan (Gutenberg, ACF), hệ sinh thái plugin phong phú, cô lập hoàn toàn rủi ro bảo mật tầng giao diện. | Advanced Custom Fields, NeuronThemes |
| **Database** | **PostgreSQL** | Hỗ trợ cột định dạng JSONB kèm GIN Index để lưu trữ và truy vấn bộ lọc thông số kỹ thuật động (DPI, Switch, Panel) cực nhanh. | Skemato Blog, Mojtaba Azad |
| **Thư viện UI** | **shadcn/ui + Tailwind CSS** | Dung lượng bundle siêu nhẹ (không sinh mã dư thừa), toàn quyền sở hữu mã nguồn, hỗ trợ tốt Dark Mode và chuẩn tiếp cận WCAG. | ShadcnDeck, Untitled UI |
| **Authentication** | **JWT / ASP.NET Identity** | Đăng nhập đơn nhất (SSO); ASP.NET Core đóng vai trò Identity Server phát hành JWT Token để xác thực đồng thời trên cả ReactJS và WordPress. | Genix Tech, miniOrange SSO |
| **Hosting / Deploy** | **Vercel (Frontend) + Docker (Backend)** | Frontend triển khai trên mạng lưới CDN Edge Network đạt tốc độ tức thì; Backend chạy dưới dạng container hóa an toàn. | Rivulet IQ, Delicious Brains |

---

## 4. Thiết kế CMS (WordPress Headless)

### Cấu hình WordPress Local để expose API
1. **Cài đặt Plugin bắt buộc**:
   * `WPGraphQL`: Thay thế REST API mặc định để truy vấn chính xác các trường dữ liệu cần thiết trong 1 request.
   * `Advanced Custom Fields (ACF PRO)` & `WPGraphQL for ACF`: Định nghĩa các trường dữ liệu tùy biến cho banner và bài viết.
   * `JWT Authentication for WP REST API`: Cho phép WordPress tự giải mã và xác thực mã thông báo JWT từ ASP.NET Core phát hành.
2. **Cấu hình chia sẻ tài nguyên nguồn gốc chéo (CORS)**:
   * Bổ sung headers trong tệp `functions.php` để cho phép ReactJS gọi API từ tên miền frontend:
     ```php
     header("Access-Control-Allow-Origin: https://your-react-store.com");
     header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
     header("Access-Control-Allow-Headers: Authorization, Content-Type");
     ```
3. **Cơ chế Revalidation qua Webhook**: Bổ sung hàm PHP gửi HTTP POST ra lệnh cho Next.js xóa cache ngầm ngay khi biên tập viên cập nhật nội dung.

### Phân chia ranh giới quản lý nội dung

```text
                     +---------------------------------------+
                     |        PHÂN CHIA LOẠI NỘI DUNG        |
                     +---------------------------------------+
                        /                                 \
                       /                                   \
  +-----------------------------------+   +------------------------------------+
  |     WordPress (Headless CMS)      |   |       ASP.NET Core Backend         |
  +-----------------------------------+   +------------------------------------+
  | * Bài viết Blog / Review Gear     |   | * Danh mục sản phẩm & Brand        |
  | * Cẩm nang tối ưu độ trễ / DPI    |   | * Sản phẩm & Biến thể kho (SKU)   |
  | * Banner khuyến mãi & Mã ưu đãi   |   | * Giỏ hàng & Trạng thái đơn hàng   |
  | * Trang Giới thiệu & Điều khoản   |   | * Giao dịch thanh toán & Người dùng|
  +-----------------------------------+   +------------------------------------+
```

---

## 5. Thiết kế API (ASP.NET Core)

| Endpoint | Method | Mô tả chức năng |
| :--- | :--- | :--- |
| `/api/v1/products` | `GET` | Lấy danh sách sản phẩm (có phân trang, bộ lọc theo hãng, giá, thông số JSONB). |
| `/api/v1/products/{slug}` | `GET` | Lấy chi tiết sản phẩm kèm danh sách biến thể (màu sắc, loại switch) và số lượng kho. |
| `/api/v1/categories` | `GET` | Lấy danh sách danh mục sản phẩm (Chuột, Bàn phím, Màn hình, Loa, Tai nghe). |
| `/api/v1/cart` | `GET` | Lấy thông tin giỏ hàng hiện tại của người dùng hoặc session token. |
| `/api/v1/cart/items` | `POST` | Thêm biến thể sản phẩm (`variant_id`) vào giỏ hàng. |
| `/api/v1/cart/items/{id}` | `PUT` / `DELETE` | Cập nhật số lượng hoặc xóa sản phẩm khỏi giỏ hàng. |
| `/api/v1/orders` | `POST` | Tạo đơn hàng mới, giữ hàng trong kho bằng Optimistic Concurrency Control. |
| `/api/v1/orders/user` | `GET` | Lấy lịch sử mua hàng của người dùng đang đăng nhập. |
| `/api/v1/payments/process` | `POST` | Xử lý thanh toán đơn hàng (tích hợp cổng thanh toán Stripe/VNPay). |
| `/api/v1/auth/register` | `POST` | Đăng ký tài khoản người dùng mới. |
| `/api/v1/auth/login` | `POST` | Đăng nhập và nhận cặp mã thông báo JWT Access Token & Refresh Token. |
| `/api/v1/auth/me` | `GET` | Lấy thông tin chi tiết cá nhân người dùng đang xác thực. |

---

## 6. Thiết kế giao diện (ReactJS)

### Danh sách các trang / màn hình chính
1. **Trang chủ (`HomePage`)**: Hiển thị Banner khuyến mãi động từ WordPress (ACF), Sản phẩm nổi bật từ ASP.NET Core và bài viết đánh giá gear mới nhất từ WordPress.
2. **Trang danh sách sản phẩm (`ProductListPage`)**: Bảng lọc thuộc tính đa tiêu chí (mức giá, hãng, loại switch, DPI, tần số quét) gửi query tới ASP.NET Core API.
3. **Trang chi tiết sản phẩm (`ProductDetailPage`)**: Hiển thị hình ảnh, bộ chọn biến thể (màu sắc, switch), thông số kỹ thuật (JSONB), nút mua hàng và bài viết đánh giá liên quan.
4. **Trang giỏ hàng (`CartPage`)**: Danh sách sản phẩm đã chọn, điều chỉnh số lượng, nhập mã giảm giá và tính tổng tiền.
5. **Trang thanh toán (`CheckoutPage`)**: Điền thông tin giao hàng, chọn phương thức thanh toán và gửi đơn hàng sang ASP.NET Core.
6. **Trang tin tức / Blog (`BlogListPage` & `BlogDetailPage`)**: Truy vấn danh sách và nội dung bài viết đánh giá gear từ Headless WordPress API (WPGraphQL).
7. **Trang quản lý tài khoản (`UserProfilePage`)**: Theo dõi trạng thái đơn hàng, lịch sử mua hàng và thông tin cá nhân.

### Thư viện UI đề xuất & Lý do
* **Storefront người dùng**: Đề xuất bộ đôi **`shadcn/ui` + `Tailwind CSS`**.
  * *Lý do*: Không làm phình dung lượng file JavaScript (do sao chép mã nguồn trực tiếp), giúp đạt điểm tối đa Core Web Vitals. Cho phép tự do tùy biến phong cách thiết kế hầm hố, hiện đại mang chất Gaming (Dark Mode mặc định) và tích hợp sẵn chuẩn truy cập WCAG.
* **Admin Dashboard (Quản trị)**: Đề xuất **`Material UI (MUI)`** hoặc **`Ant Design`** nhờ có sẵn các thành phần bảng dữ liệu (DataGrid) và biểu mẫu quản lý phức tạp.

---

## 7. Rủi ro & lưu ý kỹ thuật

* **Đồng bộ trạng thái xác thực (SSO)**:
  * *Rủi ro*: Người dùng phải đăng nhập hai lần khi chuyển qua lại giữa tính năng mua hàng và bình luận blog.
  * *Giải pháp*: Sử dụng ASP.NET Core làm Máy chủ xác thực (Identity Server) phát hành mã thông báo JWT. WordPress cài đặt plugin `JWT Authentication` sử dụng chung chìa khóa mã hóa (Shared Key) để tự giải mã xác thực.
* **Kiểm soát tranh chấp tồn kho (Flash Sale)**:
  * *Rủi ro*: Bán quá số lượng thực tế trong kho (overselling) khi nhiều game thủ cùng nhấn đặt mua một sản phẩm giới hạn.
  * *Giải pháp*: Triển khai phương pháp **Kiểm soát tranh chấp lạc quan (Optimistic Concurrency Control)** thông qua Entity Framework Core bằng thuộc tính `RowVersion` (hoặc `xmin` trên PostgreSQL).
* **Bảo mật**:
  * Đặt máy chủ WordPress sau tường lửa (chỉ mở quyền truy cập `wp-admin` qua IP nội bộ/VPN) và vô hiệu hóa XML-RPC.
  * Bắt buộc mã hóa HTTPS và tận dụng cơ chế sanitize tự động của React để ngăn chặn tấn công XSS.
* **Hiệu năng & SEO**:
  * *Rủi ro*: Ứng dụng React dạng Client-Side Rendering (CSR) thuần túy khiến con bọ Google không lập chỉ mục được dữ liệu sản phẩm.
  * *Giải pháp*: Nâng cấp lên **Next.js** áp dụng cơ chế kết xuất **Incremental Static Regeneration (ISR)** cho trang sản phẩm và bài viết blog.
  * Áp dụng **Bộ nhớ đệm đa tầng (Multi-level Caching)** tại ASP.NET Core (In-Memory Cache + Redis) giúp giữ thời gian phản hồi API dưới 50ms.

---

## 8. Nguồn tham khảo

1. **Nghiên Cứu Hệ Thống Thương Mại Điện Tử Gaming Gear: Kiến Trúc Phân Tách ASP.NET Core, ReactJS và Headless WordPress**.
2. **Headless WordPress with React (2026): A Practical Guide for Developers and Tech Leads** - Mahmood Chowdhury [Link](https://mahmoodchowdhury.com/blog/how-to-integrate-react-into-wordpress/).
3. **Headless WordPress: The Complete Guide for 2025** - NeuronThemes Blog [Link](https://neuronthemes.com/headless-wordpress-complete-guide/).
4. **WordPress Is Not Dead — It's Headless: A Complete React Integration Guide** - DEV Community [Link](https://dev.to/kushang_tailor/wordpress-is-not-dead-its-headless-a-complete-react-integration-guide-3ool).
5. **The Complete Guide to Headless WordPress: When and Why to Decouple** - Rivulet IQ [Link](https://www.rivuletiq.com/complete-guide-headless-wordpress-development/).
6. **ACF | Creating Headless WordPress Sites with React** - Advanced Custom Fields [Link](https://www.advancedcustomfields.com/blog/wordpress-react/).
7. **Where to Start With Headless WordPress** - Delicious Brains [Link](https://deliciousbrains.com/where-to-start-with-headless-wordpress/).
8. **17 Best React UI Libraries in 2026 (Ranked by Use Case)** - ShadcnDeck [Link](https://www.shadcndeck.com/blog/best-react-ui-libraries-2026).
9. **15 Best React UI Component Libraries in 2026 (+ Alternatives to MUI & Shadcn)** - Untitled UI [Link](https://www.untitledui.com/blog/react-component-libraries).
10. **E-commerce Database Design: Complete Schema Example (2025)** - Skemato Blog [Link](https://skemato.com/blog/ecommerce-database-design-example).
11. **E-commerce Product Catalog Architecture: SKU, Taxonomy & Attributes** - CodeSolTech [Link](https://www.codesoltech.com/blog/e-commerce-product-catalog-architecture/).
12. **Ecommerce Database Design: ER Diagram for Online Shopping** - Redgate [Link](https://www.red-gate.com/blog/er-diagram-for-online-shop/).
13. **How to Design a Shopping Cart Database** - AppMaster [Link](https://appmaster.io/blog/how-to-design-a-shopping-cart-database).
14. **ASP.NET OAuth Single Sign-On (SSO)** - miniOrange [Link](https://plugins.miniorange.com/asp-net-oauth-2-0-single-sign-on-sso-module).
15. **Azure AD single sign-on (SSO) integration in .Net core application** - Genix Technologies [Link](https://www.genixtec.com/azure-ad-single-sign-on-sso-integration-in-net-core-application/).
16. **ASP.NET Core SAML Single Sign-On (SSO) Using WordPress as IDP** - miniOrange [Link](https://plugins.miniorange.com/asp-net-core-saml-single-sign-on-sso-using-wordpress-as-idp).
17. **GitHub - dotnet/eShop: A reference .NET application implementing an eCommerce site** [Link](https://github.com/dotnet/eshop).
18. **MohamadNach/fullstack-ecommerce-app: React, C sharp fullstack e-commerce project** - GitHub [Link](https://github.com/MohamadNach/fullstack-ecommerce-app).
19. **Ecommerce App using ASP.NET Core and React** - GitHub [Link](https://github.com/VictorLCosta/eCommerce-App).
20. **10+ Open Source ASP.NET Core Projects 2026** - ThemeSelection [Link](https://themeselection.com/blog/asp-net-core-projects-with-source-code/).
21. **ASP.NET Core, an open-source web development framework** [Link](https://dotnet.microsoft.com/en-us/apps/aspnet).
