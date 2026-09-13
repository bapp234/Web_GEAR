# TÀI LIỆU WIREFRAME & MÔ TẢ GIAO DIỆN FRONTEND (REACTJS / NEXT.JS)
**Dự án:** Website Bán Hàng Gaming Gear
**UI Stack:** Tailwind CSS + `shadcn/ui` (Dark Gaming Theme)

---

## 1. Hướng dẫn thiết kế chung & Design System
* **Theme**: Dark Mode mặc định (`bg-slate-950`, `text-slate-100`, màu điểm nhấn Accent: `cyan-500` / `emerald-400`).
* **Typography**: Inter / Sans-serif, font chữ rõ ràng, độ tương phản cao đạt chuẩn WCAG.
* **Iconography**: `lucide-react`.
* **Layout Container**: Max-width `1280px` (`container mx-auto px-4`), căn giữa.

---

## 2. Chi tiết Wireframe & Components từng trang

### 2.1 HomePage (Trang chủ)
**Mục đích trang:** Giới thiệu cửa hàng, hiển thị các chiến dịch khuyến mãi (Banner từ WordPress ACF), sản phẩm nổi bật/bán chạy (từ ASP.NET Core API) và các bài viết đánh giá gear mới nhất (từ WPGraphQL).

**Bố cục tổng thể (layout):**
```text
+-------------------------------------------------------------------+
|                        HEADER / NAVIGATION BAR                    |
+-------------------------------------------------------------------+
|                      HERO BANNER CAROUSEL                         |
+-------------------------------------------------------------------+
|                     FEATURED CATEGORIES GRID                      |
+-------------------------------------------------------------------+
|                  HOT PRODUCTS / FLASH SALE CAROUSEL               |
+-------------------------------------------------------------------+
|                   LATEST GEAR REVIEWS (BLOG GRID)                 |
+-------------------------------------------------------------------+
|                       TRUST BADGES & FOOTER                       |
+-------------------------------------------------------------------+
```

**Danh sách thành phần UI (components):**
| Tên component | Vị trí | Dữ liệu hiển thị | Hành động khi tương tác | Nguồn dữ liệu (API nào) |
| :--- | :--- | :--- | :--- | :--- |
| `HeaderNav` | Top sticky | Logo, Menu danh mục, Thanh tìm kiếm, Badge giỏ hàng, Nút Đăng nhập/Profile | Search, Hover menu, Click giỏ hàng/User | Frontend state, `/api/v1/categories`, `/api/v1/cart` |
| `HeroBanner` | Hero Section | Ảnh banner desktop/mobile, Tiêu đề campaign, Mã giảm giá, Nút CTA | Click slide chuyển banner, Click CTA chuyển trang khuyến mãi | WPGraphQL (`posts` / `acfBanners`) |
| `CategoryGrid` | Khối 1 | Icon & Tên danh mục (Chuột, Bàn phím, Màn hình, Tai nghe) | Click chọn danh mục -> chuyển `ProductListPage` với filter | ASP.NET Core `/api/v1/categories` |
| `ProductCarousel` | Khối 2 | Card sản phẩm: Ảnh, Tên, Brand, Giá gốc, Giá so sánh, Tag "Hot" | Click Card -> chuyển `ProductDetailPage`; Click "Thêm giỏ" | ASP.NET Core `/api/v1/products?page=1&pageSize=8` |
| `LatestBlogGrid` | Khối 3 | Card bài viết: Ảnh thumbnail, Tiêu đề, Excerpt, Ngày đăng | Click Card -> chuyển `BlogDetailPage` | WPGraphQL (`posts(first: 4)`) |
| `Footer` | Bottom | Thông tin công ty, chính sách bảo hành, phương thức thanh toán | Click link liên kết chính sách/mạng xã hội | Static Component |

**Trạng thái đặc biệt cần xử lý:**
* **Loading**: Skeleton loaders cho Hero Banner, Category Icons và Product Cards (`animate-pulse`).
* **Error state**: Lỗi gọi WPGraphQL/API hiển thị Toast notification "Không thể tải dữ liệu mới nhất" và sử dụng fallback banner tĩnh.

**Responsive (<768px):**
* `HeaderNav`: Chuyển menu danh mục thành Hamburger Drawer (Slide-over).
* `CategoryGrid`: Chuyển dạng lưới 4 cột sang Carousel vuốt ngang (`overflow-x-auto`).
* `ProductCarousel`: Hiển thị 1.5 - 2 card/màn hình hỗ trợ vuốt cảm ứng (Touch slider).

---

### 2.2 ProductListPage (Trang danh sách & Bộ lọc sản phẩm)
**Mục đích trang:** Cho phép người dùng tìm kiếm, duyệt sản phẩm theo danh mục và lọc đa tiêu chí linh hoạt dựa trên giá, thương hiệu và thông số kỹ thuật động (DPI, switch, panel) từ cột JSONB.

**Bố cục tổng thể (layout):**
```text
+-------------------------------------------------------------------+
|                        HEADER / NAVIGATION BAR                    |
+-------------------------------------------------------------------+
| BREADCRUMB: Trang chủ / Chuột Gaming                              |
+----------------------------------+--------------------------------+
| SIDEBAR FILTER (25%)             | MAIN CONTENT AREA (75%)        |
| - Khoảng giá (Slider)            | - Header Danh mục & Tổng số SP |
| - Thương hiệu (Checkbox)         | - Sắp xếp (Sort dropdown)      |
| - Lọc Specs JSONB (Checkbox)     | - Active Filter Badges         |
|   + Cảm biến (Sensor)            | - Grid Sản phẩm (3x4)          |
|   + Loại Switch                  |                                |
|   + Mức DPI tối đa               | - Phân trang (Pagination)      |
| - Nút "Áp dụng" & "Xóa bộ lọc"  |                                |
+----------------------------------+--------------------------------+
|                                FOOTER                             |
+-------------------------------------------------------------------+
```

**Danh sách thành phần UI (components):**
| Tên component | Vị trí | Dữ liệu hiển thị | Hành động khi tương tác | Nguồn dữ liệu (API nào) |
| :--- | :--- | :--- | :--- | :--- |
| `FilterSidebar` | Trái (25%) | Range slider giá, Checkbox Brands, Checkbox Specs dynamic (Sensor, Switch, DPI...) | onChange cập nhật URL query string; Nút "Xóa bộ lọc" reset state | Hardcoded options + API `/api/v1/categories` |
| `SortDropdown` | Nội dung - Top | Các tùy chọn: Mới nhất, Giá tăng dần, Giá giảm dần | onChange reload danh sách SP | Update URL params `sort` |
| `FilterBadges` | Nội dung - Top | Các thẻ tag bộ lọc đang chọn (vd: "Razer", "< 2.000.000đ") | Click "x" trên Badge để hủy tiêu chí lọc tương ứng | URL state |
| `ProductGrid` | Nội dung - Mid | Lưới các `ProductCard` (Ảnh, Tên, Brand, Giá, Badge giảm giá) | Click sản phẩm -> chuyển `ProductDetailPage`; Hover hiệu ứng zoom ảnh | ASP.NET Core `/api/v1/products?category=...&brand=...` |
| `Pagination` | Nội dung - Bottom | Trang hiện tại, Tổng số trang, nút Previous/Next | onClick chuyển trang, cuộn mượt lên đầu danh sách | API Response metadata (`page`, `pageSize`, `totalCount`) |

**Trạng thái đặc biệt cần xử lý:**
* **Loading**: Hiển thị Lưới 12 Skeleton cards.
* **Empty state**: Khi không có sản phẩm nào khớp bộ lọc -> Hiển thị Illustration "Không tìm thấy sản phẩm phù hợp" + Nút "Xóa toàn bộ bộ lọc" (Reset Filters).
* **Error state**: Lỗi API 500/Network -> Hiển thị alert error + Nút "Thử lại".

**Responsive (<768px):**
* `FilterSidebar` ẩn khỏi màn hình chính, thay bằng Nút "Bộ lọc" cố định góc dưới. Khi click mở Bottom Sheet / Modal phủ full màn hình.
* `ProductGrid` chuyển từ 3-4 cột thành 2 cột sản phẩm.

---

### 2.3 ProductDetailPage (Trang chi tiết sản phẩm)
**Mục đích trang:** Hiển thị toàn bộ thông tin chi tiết của một sản phẩm: bộ sưu tập hình ảnh, bộ chọn biến thể (màu sắc, switch), giá thực tế, tồn kho, bảng thông số kỹ thuật (từ JSONB) và bài viết review liên quan từ WordPress.

**Bố cục tổng thể (layout):**
```text
+-------------------------------------------------------------------+
|                        HEADER / NAVIGATION BAR                    |
+-------------------------------------------------------------------+
| BREADCRUMB: Trang chủ / Bàn phím cơ / Razer BlackWidow V4         |
+----------------------------------+--------------------------------+
| IMAGE GALLERY (50%)              | PRODUCT INFO & VARIANTS (50%)  |
| - Ảnh chính phóng to             | - Tên SP & Brand               |
| - Dải ảnh Thumbnail bên dưới     | - Giá niêm yết & Giá gạch      |
|                                  | - Bộ chọn biến thể (Switch/Màu)|
|                                  | - Bộ chọn số lượng (+ / -)     |
|                                  | - Tình trạng kho (In Stock)    |
|                                  | - Nút "THÊM VÀO GIỎ HÀNG"      |
|                                  | - Nút "MUA NGAY"               |
+----------------------------------+--------------------------------+
| TAB SECTION:                                                      |
| [ Thông số kỹ thuật ] [ Mô tả chi tiết ] [ Bài viết Review Gear ] |
| - Bảng Thông số kỹ thuật động parse từ JSONB                      |
| - Bài viết Review nhúng từ WPGraphQL                              |
+-------------------------------------------------------------------+
|                    RELATED PRODUCTS CAROUSEL                      |
+-------------------------------------------------------------------+
|                                FOOTER                             |
+-------------------------------------------------------------------+
```

**Danh sách thành phần UI (components):**
| Tên component | Vị trí | Dữ liệu hiển thị | Hành động khi tương tác | Nguồn dữ liệu (API nào) |
| :--- | :--- | :--- | :--- | :--- |
| `ImageGallery` | Trái (50%) | Ảnh chính kích thước lớn + danh sách Thumbnail | Click Thumbnail đổi ảnh chính, Hover phóng to kính lúp | ASP.NET Core `/api/v1/products/{slug}` |
| `VariantSelector` | Phải - Top | Danh sách các `product_variants` (vd: Switch Red/Blue/Brown, Màu Đen/Trắng) | Click chọn biến thể -> Cập nhật `variant_id`, giá `price_override` và tồn kho `stock_quantity` | ASP.NET Core `/api/v1/products/{slug}` (`variants`) |
| `QuantityInput` | Phải - Mid | Số lượng chọn mua (mặc định 1) | Click `+` / `-` kiểm tra không vượt quá `stock_quantity` | Client state |
| `AddToCartGroup` | Phải - Mid | Nút "Thêm vào giỏ" và "Mua ngay" | onClick gửi `POST /api/v1/cart/items`, hiển thị Toast "Đã thêm vào giỏ thành công" | ASP.NET Core `/api/v1/cart/items` |
| `SpecTable` | Tab 1 | Bảng 2 cột parse từ `specifications` (JSONB): Sensor, DPI, Switch, Trọng lượng... | Hiển thị dạng bảng kẻ sọc (Zebra striped) | `product.specifications` (JSONB) |
| `WPReviewEmbed` | Tab 3 | Bài viết đánh giá gear nhúng từ WordPress | Click đọc bài viết đầy đủ | WPGraphQL (`posts`) |

**Trạng thái đặc biệt cần xử lý:**
* **Out of Stock**: Khi biến thể chọn có `stock_quantity == 0` -> Nút "THÊM VÀO GIỎ" đổi thành "HẾT HÀNG" (Disabled), ẩn nút "Mua ngay".
* **Loading**: Skeleton loader cho Gallery và Khối thông tin giá.
* **404 Not Found**: Nhập sai slug -> Hiển thị màn hình 404 "Sản phẩm không tồn tại" + Nút "Về trang chủ".

**Responsive (<768px):**
* Layout chuyển thành 1 cột dọc: Gallery -> Info & Variants -> Tab Section.
* Thanh mua hàng cố định (Sticky Bottom Bar) chứa Nút "Thêm vào giỏ" luôn nổi ở đáy màn hình di động.

---

### 2.4 CartPage (Trang giỏ hàng)
**Mục đích trang:** Cho phép người dùng xem lại danh sách sản phẩm đã chọn, điều chỉnh số lượng, xóa sản phẩm, kiểm tra tổng tiền và chuyển hướng sang trang Thanh toán.

**Bố cục tổng thể (layout):**
```text
+-------------------------------------------------------------------+
|                        HEADER / NAVIGATION BAR                    |
+-------------------------------------------------------------------+
| H1: GIỎ HÀNG CỦA BẠN (3 sản phẩm)                                 |
+----------------------------------+--------------------------------+
| CART ITEMS LIST (70%)            | ORDER SUMMARY (30%)            |
| - Header Bảng (SP, Đơn giá, SL,  | - Tạm tính giá                 |
|   Thành tiền, Xóa)               | - Phí vận chuyển (Tính sau)    |
| - Item 1: Ảnh, Tên, Variant, SL  | - Tổng tiền thanh toán         |
| - Item 2: ...                    | - Nút "TIẾN HÀNH THANH TOÁN"   |
| - Nút "Xóa toàn bộ giỏ"          | - Khung nhập Mã giảm giá       |
+----------------------------------+--------------------------------+
|                                FOOTER                             |
+-------------------------------------------------------------------+
```

**Danh sách thành phần UI (components):**
| Tên component | Vị trí | Dữ liệu hiển thị | Hành động khi tương tác | Nguồn dữ liệu (API nào) |
| :--- | :--- | :--- | :--- | :--- |
| `CartItemList` | Trái (70%) | Danh sách các item trong giỏ: Ảnh, Tên SP, Biến thể chọn, Đơn giá, Tăng/Giảm SL, Nút Xóa | Click `+`/`-` gọi API `PUT /api/v1/cart/items/{id}`; Click "Xóa" gọi `DELETE` | ASP.NET Core `/api/v1/cart` |
| `CouponBox` | Phải - Top | Input nhập mã ưu đãi + Nút "Áp dụng" | onClick gửi kiểm tra voucher | Client Validation / API |
| `CartSummaryCard` | Phải - Mid | Tạm tính, Giảm giá, Tổng tiền thanh toán | Click "TIẾN HÀNH THANH TOÁN" -> Chuyển sang `CheckoutPage` | ASP.NET Core `/api/v1/cart` |

**Trạng thái đặc biệt cần xử lý:**
* **Empty Cart**: Giỏ hàng trống (`items.length == 0`) -> Hiển thị Illustration Giỏ hàng trống + Thông báo "Giỏ hàng của bạn đang trống" + Nút "Khám phá sản phẩm ngay" dẫn về `ProductListPage`.
* **Quantity limit**: Tăng số lượng vượt quá tồn kho `stock_quantity` -> Hiển thị Toast cảnh báo "Số lượng trong kho chỉ còn X sản phẩm".

**Responsive (<768px):**
* Danh sách sản phẩm chuyển từ dạng Bảng nhiều cột sang dạng Thẻ danh sách dọc (Card view).
* Khối `CartSummaryCard` chuyển xuống dưới cùng hoặc ghim cố định ở đáy màn hình.

---

### 2.5 CheckoutPage (Trang thanh toán & Đặt hàng)
**Mục đích trang:** Cho phép người dùng điền thông tin giao hàng, chọn phương thức thanh toán (COD / VNPay), xem tóm tắt đơn hàng và xác nhận chốt đơn gửi về ASP.NET Core API.

**Bố cục tổng thể (layout):**
```text
+-------------------------------------------------------------------+
|                        HEADER (COMPACT / LOGO ONLY)               |
+-------------------------------------------------------------------+
| BREADCRUMB: Giỏ hàng / Thông tin giao hàng / Thanh toán           |
+----------------------------------+--------------------------------+
| CHECKOUT FORM (60%)              | ORDER REVIEW SIDEBAR (40%)     |
| 1. Thông tin người nhận          | - Danh sách tóm tắt SP (Ảnh,   |
|    - Họ tên, Email, Số điện thoại|   Tên, Variant, SL, Giá)       |
|    - Địa chỉ giao hàng           | - Tạm tính                      |
| 2. Phương thức thanh toán        | - Phí giao hàng                 |
|    (*) Thanh toán khi nhận (COD) | - TỔNG CỘNG                     |
|    ( ) Thanh toán VNPay (QR)     | - Nút "ĐẶT HÀNG NGAY"           |
| 3. Ghi chú đơn hàng              |                                |
+----------------------------------+--------------------------------+
|                                FOOTER                             |
+-------------------------------------------------------------------+
```

**Danh sách thành phần UI (components):**
| Tên component | Vị trí | Dữ liệu hiển thị | Hành động khi tương tác | Nguồn dữ liệu (API nào) |
| :--- | :--- | :--- | :--- | :--- |
| `ShippingForm` | Trái - Top | Các trường: Họ tên, Email, SĐT, Địa chỉ chi tiết | Form validation (react-hook-form + zod) | User input / Auto-fill từ `/api/v1/auth/me` |
| `PaymentMethodRadio` | Trái - Mid | Radio button: COD (Thanh toán khi nhận) / VNPay | onChange thay đổi phương thức thanh toán chọn | State chọn phương thức |
| `OrderSummarySidebar` | Phải | Danh sách rút gọn các item, Tạm tính, Phí ship, Tổng cộng | Nút "ĐẶT HÀNG NGAY" -> Submit form gửi `POST /api/v1/orders` | ASP.NET Core `/api/v1/cart` & `/api/v1/orders` |

**Trạng thái đặc biệt cần xử lý:**
* **OCC Stock Conflict (Lỗi 409 Conflict)**: Khi bị hết hàng do tranh chấp tồn kho Flash Sale -> Hiển thị Alert Dialog: "Một số sản phẩm trong giỏ đã hết hàng hoặc thay đổi số lượng" + Nút "Cập nhật lại giỏ hàng".
* **Submitting State**: Nút "ĐẶT HÀNG NGAY" hiển thị Spinner và Disabled để ngăn click đúp (Double Submit).

**Responsive (<768px):**
* Khối `OrderReviewSidebar` thu gọn dạng Accordion lên trên cùng (có thể nhấn "Xem tóm tắt đơn hàng").
* Form giao hàng trải dài 100% chiều rộng màn hình.

---

### 2.6 BlogListPage (Trang tin tức & Review Gear từ WordPress)
**Mục đích trang:** Hiển thị danh sách các bài viết đánh giá gear, cẩm nang hướng dẫn và tin tức khuyến mãi được truy vấn trực tiếp từ Headless WordPress qua WPGraphQL.

**Bố cục tổng thể (layout):**
```text
+-------------------------------------------------------------------+
|                        HEADER / NAVIGATION BAR                    |
+-------------------------------------------------------------------+
| HERO SECTION: TIN TỨC & REVIEW GAMING GEAR                        |
+-------------------------------------------------------------------+
| FEATURED POST (Bài viết nổi bật nhất - Full width)                |
+-------------------------------------------------------------------+
| POSTS GRID (3 Cột)                                                |
| [ Card Bài viết 1 ] [ Card Bài viết 2 ] [ Card Bài viết 3 ]       |
| [ Card Bài viết 4 ] [ Card Bài viết 5 ] [ Card Bài viết 6 ]       |
+-------------------------------------------------------------------+
|                       LOAD MORE / PAGINATION                      |
+-------------------------------------------------------------------+
|                                FOOTER                             |
+-------------------------------------------------------------------+
```

**Danh sách thành phần UI (components):**
| Tên component | Vị trí | Dữ liệu hiển thị | Hành động khi tương tác | Nguồn dữ liệu (API nào) |
| :--- | :--- | :--- | :--- | :--- |
| `FeaturedPostCard` | Top | Bài viết mới nhất: Ảnh đại diện lớn, Tiêu đề, Excerpt, Ngày đăng, Tác giả | Click -> Chuyển sang `BlogDetailPage` | WPGraphQL (`posts(first: 1)`) |
| `BlogPostGrid` | Main Grid | Lưới 3 cột: Ảnh thumbnail, Chuyên mục, Tiêu đề, Excerpt ngắn | Click Card -> Chuyển sang `BlogDetailPage` | WPGraphQL (`posts(first: 9, after: cursor)`) |
| `LoadMoreButton` | Bottom | Nút "Xem thêm bài viết" | onClick nạp tiếp danh sách bài viết trang sau | WPGraphQL (`pageInfo.hasNextPage`) |

**Trạng thái đặc biệt cần xử lý:**
* **Loading**: Skeleton loaders dạng hình chữ nhật cho bài viết.
* **Empty State**: Không có bài viết nào -> Hiển thị "Chưa có bài viết nào trong chuyên mục này".

**Responsive (<768px):**
* Lưới bài viết chuyển từ 3 cột thành 1 cột dọc.

---

### 2.7 BlogDetailPage (Trang chi tiết bài viết Blog)
**Mục đích trang:** Hiển thị toàn bộ nội dung chi tiết của bài viết đánh giá gear, hỗ trợ mục lục tự động (TOC), nhúng sản phẩm liên quan và khung bình luận kết nối SSO JWT với WordPress.

**Bố cục tổng thể (layout):**
```text
+-------------------------------------------------------------------+
|                        HEADER / NAVIGATION BAR                    |
+-------------------------------------------------------------------+
| BREADCRUMB: Trang chủ / Blog / Review Razer Viper V2 Pro          |
+-----------------------------------+-------------------------------+
| ARTICLE CONTENT MAIN (70%)        | SIDEBAR (30%)                 |
| - Tiêu đề H1, Ngày đăng, Tác giả  | - Mục lục bài viết (TOC)      |
| - Ảnh đại diện bài viết           | - Sản phẩm nhắc đến trong     |
| - Nội dung HTML (Rich text)       |   bài viết (Widget Card)      |
| - Khung Bình luận (Comments)      | - Bài viết liên quan          |
+-----------------------------------+-------------------------------+
|                                FOOTER                             |
+-------------------------------------------------------------------+
```

**Danh sách thành phần UI (components):**
| Tên component | Vị trí | Dữ liệu hiển thị | Hành động khi tương tác | Nguồn dữ liệu (API nào) |
| :--- | :--- | :--- | :--- | :--- |
| `ArticleMain` | Trái (70%) | Tiêu đề bài viết, Tác giả, Ngày đăng, Nội dung HTML Sanitized | Cuộn đọc bài viết, Click link sản phẩm | WPGraphQL (`post(id: $slug)`) |
| `TableOfContents` | Phải - Sticky | Danh sách các thẻ H2, H3 trong bài | Click tiêu đề -> Cuộn mượt (Smooth scroll) tới đoạn tương ứng | Generated từ HTML content |
| `RelatedProductWidget` | Phải - Mid | Card sản phẩm bán chạy được giới thiệu trong bài | Click -> Chuyển sang `ProductDetailPage` | ASP.NET Core `/api/v1/products/{slug}` |
| `CommentSection` | Trái - Bottom | Danh sách bình luận + Form gửi bình luận (Tích hợp SSO JWT) | Gửi bình luận mới qua API WP (gắn JWT Header) | WordPress REST API / WPGraphQL |

**Trạng thái đặc biệt cần xử lý:**
* **Unauthenticated Comment**: Nếu chưa đăng nhập -> Hiển thị yêu cầu "Vui lòng Đăng nhập để viết bình luận" + Nút "Đăng nhập ngay".

**Responsive (<768px):**
* `TableOfContents` chuyển thành dạng Accordion có thể thu gọn ở đầu bài viết.
* Sidebar chuyển xuống dưới cùng nội dung bài viết.

---

### 2.8 UserProfilePage (Trang quản lý tài khoản & Đơn hàng)
**Mục đích trang:** Cho phép người dùng xem thông tin cá nhân, cập nhật địa chỉ và tra cứu lịch sử các đơn hàng đã đặt cùng trạng thái xử lý đơn.

**Bố cục tổng thể (layout):**
```text
+-------------------------------------------------------------------+
|                        HEADER / NAVIGATION BAR                    |
+-------------------------------------------------------------------+
| ACCOUNT DASHBOARD HEADER: Xin chào, [Tên Khách Hàng]             |
+----------------------------------+--------------------------------+
| PROFILE NAVIGATION TABS (20%)    | TAB CONTENT AREA (80%)         |
| - Thông tin cá nhân              | [ LỊCH SỬ ĐƠN HÀNG ]           |
| - Lịch sử đơn hàng               | - Đơn hàng #ORD-20260913-001   |
| - Địa chỉ giao hàng              |   + Ngày đặt: 13/09/2026       |
| - Đăng xuất                      |   + Trạng thái: [Đang giao]    |
|                                  |   + Tổng tiền: 3.500.000đ      |
|                                  |   + Chi tiết danh sách SP      |
+----------------------------------+--------------------------------+
|                                FOOTER                             |
+-------------------------------------------------------------------+
```

**Danh sách thành phần UI (components):**
| Tên component | Vị trí | Dữ liệu hiển thị | Hành động khi tương tác | Nguồn dữ liệu (API nào) |
| :--- | :--- | :--- | :--- | :--- |
| `ProfileSidebarNav` | Trái (20%) | Menu các Tab: Thông tin, Đơn hàng, Đăng xuất | Click chuyển Tab hiển thị | Client State / React Router |
| `UserInfoTab` | Trái (80%) | Form Họ tên, Email, Số điện thoại | Click "Lưu thay đổi" | API `/api/v1/auth/me` |
| `OrderHistoryTab` | Trái (80%) | Danh sách đơn hàng: Mã đơn, Ngày đặt, Trạng thái (`Pending`, `Processing`, `Shipped`), Tổng tiền | Click "Xem chi tiết" mở Modal danh sách SP trong đơn | ASP.NET Core `/api/v1/orders/user` |

**Trạng thái đặc biệt cần xử lý:**
* **No Order History**: Chưa từng mua hàng -> Hiển thị "Bạn chưa có đơn hàng nào" + Nút "Mua sắm ngay".
* **Unauthorized**: Chưa đăng nhập truy cập `/profile` -> Tự động chuyển hướng về `/login`.

**Responsive (<768px):**
* `ProfileSidebarNav` chuyển thành dải Tab ngang vuốt (Horizontal scroll tabs) ở trên cùng.
