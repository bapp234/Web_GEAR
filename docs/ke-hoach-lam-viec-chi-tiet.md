# KẾ HOẠCH LÀM VIỆC CHI TIẾT DỰ ÁN E-COMMERCE GAMING GEAR
**Mô hình quản lý:** GitHub Milestones & Issues (Chi tiết từng tác vụ, phân loại nhóm & định nghĩa hoàn thành)
**Thời gian thực hiện:** 2 tuần (14 ngày làm việc thực tế)

---

# Milestone 1: Hạ tầng hệ thống, Database, WordPress Headless & Core API (Tuần 1, ngày 1 - ngày 7)

## Mục tiêu milestone
- Thiết lập toàn bộ cấu trúc dự án (Clean Architecture Backend, Next.js Frontend, WordPress Local CMS).
- Hoàn thành thiết kế và khởi tạo cơ sở dữ liệu PostgreSQL (11 bảng quan hệ + thuộc tính động JSONB).
- Cấu hình WordPress Headless CMS (WPGraphQL, ACF, CORS).
- Xây dựng hoàn chỉnh bộ API thương mại cốt lõi (Sản phẩm, Giỏ hàng, Đơn hàng với cơ chế OCC, Xác thực JWT).
- Hoàn thành khung giao diện Frontend (Design System, Header, Banner Carousel từ WordPress).

## Danh sách Issue
| # | Tên Issue | Label | Mô tả ngắn | Definition of Done | Phụ thuộc vào Issue # | Ước lượng |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **#1** | Khởi tạo Repository & Project Skeleton | `backend`, `frontend`, `cms` | Khởi tạo C# Solution (Clean Architecture 4 lớp), Next.js App (TypeScript, Tailwind), và Docker Compose cho PostgreSQL & WordPress. | Code compile 0 lỗi, lệnh `docker compose up` khởi chạy thành công PostgreSQL và WordPress Local. | Không | 1 ngày |
| **#2** | Định nghĩa Schema PostgreSQL & EF Core Migrations | `backend` | Viết Entities, Fluent API Configurations cho 11 bảng (Product, Variant, Category, Brand, Cart, Order, User, Payment, Inventory...) với cột `specifications` dạng `jsonb`. | Chạy `dotnet ef database update` thành công, DB tạo đủ 11 bảng chuẩn ràng buộc và chỉ mục GIN Index trên cột JSONB. | #1 | 1 ngày |
| **#3** | Cấu hình WordPress Local Headless CMS & Plugins | `cms` | Cài đặt WPGraphQL, Advanced Custom Fields (ACF PRO), WPGraphQL for ACF, JWT Auth plugin và cấu hình CORS. | WPGraphQL Playground truy vấn thành công danh sách bài viết blog và các trường ACF Banner tùy biến. | #1 | 0.5 ngày |
| **#4** | Xây dựng Auth API & Identity Service (Ver 1 - đơn giản hóa) | `backend` | Viết API `/api/v1/auth/register` và `/login`, phát hành JWT Access Token (15m) và Refresh Token (`HttpOnly Cookie`). | Postman test đăng ký/đăng nhập trả về mã HTTP 200 kèm JWT Token ký số HMAC-SHA256 hợp lệ. | #2 | 0.5 ngày |
| **#5** | Xây dựng Product Repository & Engine lọc thuộc tính JSONB | `backend` | Lập trình `ProductRepository` và `ProductService` hỗ trợ phân trang, lọc theo danh mục, hãng, khoảng giá và các thuộc tính động trong JSONB. | Unit test / Integration test truy vấn lọc sản phẩm theo JSONB specs trả về dữ liệu chính xác và phân trang chuẩn. | #2 | 1 ngày |
| **#6** | Implement REST API Product Catalog (`/api/v1/products`) | `backend` | Viết `ProductsController` và `CategoriesController` expose các endpoint REST API công khai. | Swagger UI gọi API lấy danh sách, chi tiết sản phẩm kèm JSONB specs phản hồi với thời gian `< 50ms`. | #5 | 0.5 ngày |
| **#7** | Xây dựng Cart API (`/api/v1/cart`) cho Guest & User | `backend` | Xây dựng API quản lý giỏ hàng, thêm/sửa/xóa item, hỗ trợ giỏ vãng lai qua `cart_token` và đồng bộ khi đăng nhập. | Postman test CRUD giỏ hàng thành công cho cả khách vãng lai và người dùng đã đăng nhập. | #2, #4 | 0.5 ngày |
| **#8** | Xây dựng Order & Inventory Processing API (OCC) | `backend` | Xây dựng API `POST /api/v1/orders` chốt đơn hàng và trừ kho bằng Optimistic Concurrency Control (`xmin` / `RowVersion`). | Tạo đơn hàng thành công, trừ kho chính xác, trả về mã HTTP 409 Conflict khi xảy ra xung đột tranh chấp tồn kho. | #2, #7 | 1 ngày |
| **#9** | Tích hợp Payment API Ver 1 (COD & Simulated VNPay Callback) | `backend` | Xử lý phương thức thanh toán COD và tạo endpoint Callback giả lập cập nhật trạng thái thanh toán từ cổng VNPay. | API trả về thông tin thanh toán và tự động cập nhật `payment_status = 'Paid'` khi nhận callback giả lập. | #8 | 0.5 ngày |
| **#10** | Khởi tạo UI Design System với Tailwind CSS & `shadcn/ui` | `frontend` | Cấu hình Next.js với Tailwind CSS, `shadcn/ui`, Dark Mode gaming theme và các layout cơ bản (Header, Footer). | Component Button, Input, Card, Modal render đúng phong cách thiết kế Dark Gaming. | #1 | 0.5 ngày |
| **#11** | Xây dựng Storefront Header, Nav & WP Banner Carousel | `frontend` | Dựng Header chứa danh mục, thanh tìm kiếm, icon giỏ hàng và Carousel hiển thị banner ưu đãi từ WPGraphQL. | Banner lấy dữ liệu trực tiếp từ WPGraphQL hiển thị đúng hình ảnh, tiêu đề và mã giảm giá. | #3, #10 | 1 ngày |

---

# Milestone 2: Storefront Frontend, Tích hợp Giỏ hàng/Thanh toán, WP Blog & Hoàn thiện MVP (Tuần 2, ngày 8 - ngày 14)

## Mục tiêu milestone
- Xây dựng toàn bộ giao diện cửa hàng trực tuyến phía client (Danh sách sản phẩm với bộ lọc JSONB, Chi tiết sản phẩm & biến thể, Giỏ hàng, Thanh toán, Blog).
- Tích hợp kết nối Frontend ReactJS với Backend ASP.NET Core API và WordPress Headless CMS.
- Thiết lập cơ chế tự động xóa đệm (Webhook Revalidate) giữa WordPress và Next.js (ISR).
- Kiểm thử E2E luồng mua hàng, kiểm thử chịu tải tranh chấp tồn kho (OCC) và đóng gói Docker Compose hoàn chỉnh.

## Danh sách Issue
| # | Tên Issue | Label | Mô tả ngắn | Definition of Done | Phụ thuộc vào Issue # | Ước lượng |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **#12** | Xây dựng Trang danh sách sản phẩm & Bộ lọc JSONB (`ProductListPage`) | `frontend` | Dựng màn hình hiển thị sản phẩm, phân trang, bộ lọc đa tiêu chí (giá, hãng, switch, DPI) gọi API ASP.NET Core. | Bộ lọc tương tác mượt mà, cập nhật danh sách sản phẩm ngay lập tức không cần reload trang, chuẩn Responsive. | #6, #10 | 1 ngày |
| **#13** | Xây dựng Trang chi tiết sản phẩm & Chọn biến thể (`ProductDetailPage`) | `frontend` | Dựng màn hình chi tiết sản phẩm, gallery ảnh, chọn biến thể (màu sắc, switch), bảng thông số JSONB, nút Thêm giỏ hàng. | Chuyển đổi biến thể cập nhật đúng giá/tồn kho thực tế; thêm sản phẩm vào giỏ hàng thành công. | #6, #7, #10 | 1 ngày |
| **#14** | Xây dựng Màn hình Giỏ hàng & Đồng bộ State (`CartPage`) | `frontend` | Dựng giao diện giỏ hàng, thay đổi số lượng, xóa item, tính tổng tiền, lưu trữ state phía Client (Zustand/Redux). | Thay đổi số lượng cập nhật ngay UI và gửi API đồng bộ giỏ hàng với Backend. | #7, #13 | 0.5 ngày |
| **#15** | Xây dựng Màn hình Đăng ký / Đăng nhập & Auth Context | `frontend` | Dựng form đăng nhập/đăng ký, validate dữ liệu, lưu JWT token và tự động gắn Header `Authorization: Bearer` vào API client. | Đăng nhập thành công chuyển hướng đúng trang, duy trì Auth State khi reload và tự động làm mới Token. | #4, #10 | 0.5 ngày |
| **#16** | Xây dựng Màn hình Thanh toán & Đặt hàng (`CheckoutPage`) | `frontend` | Dựng form nhập địa chỉ giao hàng, chọn PTTT (COD / VNPay), gửi yêu cầu tạo đơn tới ASP.NET Core API. | Đặt hàng thành công hiển thị mã đơn hàng, tự động làm sạch giỏ hàng và chuyển sang trang xác nhận. | #8, #9, #14, #15 | 1 ngày |
| **#17** | Xây dựng Trang Blog Review Gear từ WPGraphQL | `frontend` | Dựng trang `/blog` và `/blog/[slug]` truy vấn danh sách và chi tiết bài viết đánh giá gear từ WordPress qua WPGraphQL. | Hiển thị danh sách bài viết review và nội dung chi tiết bài viết chuẩn đinh dạng HTML an toàn (Sanitized). | #3, #10 | 1 ngày |
| **#18** | Tích hợp Webhook Revalidate giữa WordPress và Next.js | `cms`, `frontend` | Viết hàm PHP hook `save_post` trên WordPress gửi HTTP POST sang endpoint `/api/revalidate` của Next.js để xóa đệm bài viết/banner. | Cập nhật/xuất bản bài viết trên WordPress -> Trang tĩnh Next.js tự động làm mới nội dung tức thì. | #3, #17 | 0.5 ngày |
| **#19** | Cấu hình SSO JWT giữa ReactJS và WordPress Comment (Ver 1 - đơn giản hóa) | `cms`, `backend`, `frontend` | Gửi JWT token do ASP.NET Core cấp phát trong Header khi ReactJS gọi API WordPress để gửi bình luận bài viết. | Khách hàng đã đăng nhập trên Storefront có thể gửi bình luận bài viết trên WordPress mà không cần đăng nhập lại WP. | #4, #15, #17 | 0.5 ngày |
| **#20** | Kiểm thử E2E luồng mua hàng, Stress test OCC & Dockerize Demo | `backend`, `frontend`, `cms` | Kiểm thử toàn trình (Xem SP -> Giỏ hàng -> Đặt hàng -> WP Blog); Giả lập 10 request đặt hàng đồng thời trên 1 biến thể còn 1 item kho. | Hệ thống vận hành trôi chảy, không xảy ra overselling (chỉ 1 order thành công, 9 order nhận lỗi 409); Docker Compose up 1 lệnh chạy full app. | Tất cả Issue trước | 1 ngày |

---

# Rủi ro tiến độ & lưu ý

### 1. Các điểm dễ phát sinh phình phạm vi (Scope Creep)
* **Sa lầy vào thiết kế quá nhiều bảng thuộc tính riêng lẻ**: Việc tạo quá nhiều bảng quan hệ cho từng thông số kỹ thuật (DPI, loại Switch, kích thước, tần số quét...) sẽ làm tăng thời gian viết SQL/Migration và làm chậm tiến độ Backend.
  * *Phòng tránh*: **Đóng đắng và chốt cố định cột `specifications` dạng `jsonb`** ngay ở Issue #2. Toàn bộ thuộc tính kỹ thuật động của Gaming Gear được gom trọn vào JSONB.
* **Thay đổi hợp đồng API (API Contract) khi đang làm Frontend**: Lập trình viên Frontend tự ý thêm/sửa trường dữ liệu dẫn đến việc Backend phải quay lại sửa Controller/DTO.
  * *Phòng tránh*: **Chốt cứng tài liệu Swagger/OpenAPI Spec ở Issue #6** trước khi triển khai các Issue Frontend ở Milestone 2. Frontend chỉ được phép tiêu thụ API theo đúng Schema đã thống nhất.
* **Sự phức tạp của tích hợp cổng thanh toán thực tế & SSO nâng cao**: Việc đăng ký Sandbox VNPay thật hoặc cấu hình SAML2 SSO đa chiều rất mất thời gian và dễ tắc nghẽn do thủ tục bên thứ 3.
  * *Phòng tránh*: **Áp dụng phạm vi MVP "Ver 1 - đơn giản hóa"**: Thanh toán chỉ cần COD và endpoint giả lập VNPay Webhook Callback (Issue #9); SSO chỉ cần chuyển tiếp JWT Access Token từ ASP.NET Core sang WordPress REST API (Issue #19).

### 2. Bảng quản lý phụ thuộc kỹ thuật (Dependency Bottlenecks)

```text
[Issue #1: Skeleton] ---> [Issue #2: DB Schema] ---> [Issue #5: Filter Engine] ---> [Issue #6: Product API] ---> [Issue #12: Frontend Product List]
       |                                                                                    |
       +-------------------> [Issue #4: Auth API] ------------------------------------------+---> [Issue #15: Frontend Auth]
       |                                                                                    |
       +-------------------> [Issue #3: WP CMS] --------------------------------------------+---> [Issue #11: Frontend Header/Banner]
                                                                                            |
                                                                                            v
                                                                                   [Issue #16: Checkout Page]
```

* **Điểm nghẽn #1 (Database Schema - Issue #2)**: Toàn bộ công việc Backend (#4, #5, #7, #8) đều dừng lại nếu Schema Database chưa chốt xong. **Cần ưu tiên hoàn thành Issue #2 ngay trong Tuần 1**.
* **Điểm nghẽn #2 (API Order & OCC - Issue #8)**: Màn hình Checkout của Frontend (#16) phụ thuộc trực tiếp vào API Đơn hàng (#8) và Giỏ hàng (#7). Backend phải bàn giao API đúng thời hạn Ngày 5 để Frontend hoàn thành tích hợp ở Ngày 11.
