#!/usr/bin/env bash
# ============================================================================
# Script tự động thiết lập GitHub repo cho dự án Gaming Gear E-Commerce
# Tạo: Labels + 2 Milestones + 20 Issues (đúng theo ke-hoach-lam-viec-chi-tiet.md)
#
# YÊU CẦU TRƯỚC KHI CHẠY:
#   1. Đã cài GitHub CLI: https://cli.github.com/
#   2. Đã đăng nhập: gh auth login
#   3. Đã tạo repo trên GitHub và đã "cd" vào thư mục repo local (đã git init + remote add)
#
# CÁCH CHẠY:
#   chmod +x setup-github-issues.sh
#   ./setup-github-issues.sh
# ============================================================================

set -e

echo "==> Kiểm tra đăng nhập GitHub CLI..."
gh auth status || { echo "Chưa đăng nhập. Chạy: gh auth login"; exit 1; }

REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
echo "==> Repo đang thao tác: $REPO"

# ----------------------------------------------------------------------------
# 1. TẠO LABELS
# ----------------------------------------------------------------------------
echo "==> Đang tạo Labels..."

create_label () {
  local name="$1" color="$2" desc="$3"
  gh label create "$name" --color "$color" --description "$desc" --force
}

create_label "backend"  "1D76DB" "Công việc ASP.NET Core Backend"
create_label "frontend" "0E8A16" "Công việc ReactJS/Next.js Frontend"
create_label "cms"      "F9A825" "Công việc WordPress Headless CMS"
create_label "priority: high" "D93F0B" "Ưu tiên cao, chặn tiến độ nếu chậm"
create_label "priority: medium" "FBCA04" "Ưu tiên trung bình"
create_label "mvp-v1"   "5319E7" "Phạm vi rút gọn cho MVP 2 tuần"

# ----------------------------------------------------------------------------
# 2. TẠO MILESTONES
# ----------------------------------------------------------------------------
echo "==> Đang tạo Milestones..."

DUE_M1=$(date -d "+7 days" +%Y-%m-%dT23:59:59Z 2>/dev/null || date -v+7d +%Y-%m-%dT23:59:59Z)
DUE_M2=$(date -d "+14 days" +%Y-%m-%dT23:59:59Z 2>/dev/null || date -v+14d +%Y-%m-%dT23:59:59Z)

M1_TITLE="Milestone 1: Hạ tầng, Database, WordPress Headless & Core API"
M2_TITLE="Milestone 2: Storefront Frontend, Checkout, WP Blog & Hoàn thiện MVP"

# GitHub CLI chưa có lệnh milestone tạo trực tiếp -> dùng API
gh api repos/$REPO/milestones -f title="$M1_TITLE" -f state="open" -f due_on="$DUE_M1" \
  -f description="Tuần 1 (ngày 1-7): Setup project, DB schema, WordPress headless, Core API" || true

gh api repos/$REPO/milestones -f title="$M2_TITLE" -f state="open" -f due_on="$DUE_M2" \
  -f description="Tuần 2 (ngày 8-14): Frontend storefront, tích hợp, kiểm thử E2E" || true

# ----------------------------------------------------------------------------
# 3. TẠO ISSUES (Milestone 1: #1 - #11)
# ----------------------------------------------------------------------------
echo "==> Đang tạo Issues cho Milestone 1..."

create_issue () {
  local title="$1" labels="$2" milestone="$3" body="$4"
  gh issue create --title "$title" --label "$labels" --milestone "$milestone" --body "$body"
}

create_issue "Khởi tạo Repository & Project Skeleton" \
  "backend,frontend,cms,priority: high" "$M1_TITLE" \
"**Mô tả:** Khởi tạo C# Solution (Clean Architecture 4 lớp), Next.js App (TypeScript, Tailwind), Docker Compose cho PostgreSQL & WordPress.

**Definition of Done:** Code compile 0 lỗi; \`docker compose up\` khởi chạy thành công PostgreSQL và WordPress Local.

**Phụ thuộc:** Không
**Ước lượng:** 1 ngày"

create_issue "Định nghĩa Schema PostgreSQL & EF Core Migrations" \
  "backend,priority: high" "$M1_TITLE" \
"**Mô tả:** Viết Entities, Fluent API Configurations cho 11 bảng (Product, Variant, Category, Brand, Cart, Order, User, Payment, Inventory...) với cột \`specifications\` dạng \`jsonb\`.

**Definition of Done:** \`dotnet ef database update\` chạy thành công, DB tạo đủ 11 bảng chuẩn ràng buộc + GIN Index trên cột JSONB.

**Phụ thuộc:** #1
**Ước lượng:** 1 ngày"

create_issue "Cấu hình WordPress Local Headless CMS & Plugins" \
  "cms,priority: high" "$M1_TITLE" \
"**Mô tả:** Cài WPGraphQL, ACF PRO, WPGraphQL for ACF, JWT Auth plugin, cấu hình CORS.

**Definition of Done:** WPGraphQL Playground truy vấn thành công danh sách bài viết blog và các trường ACF Banner.

**Phụ thuộc:** #1
**Ước lượng:** 0.5 ngày"

create_issue "Xây dựng Auth API & Identity Service (Ver 1 - đơn giản hóa)" \
  "backend,mvp-v1,priority: high" "$M1_TITLE" \
"**Mô tả:** Viết API /api/v1/auth/register và /login, phát hành JWT Access Token (15-30m) + Refresh Token (HttpOnly Cookie).

**Definition of Done:** Postman test đăng ký/đăng nhập trả 200 kèm JWT hợp lệ (HMAC-SHA256).

**Phụ thuộc:** #2
**Ước lượng:** 0.5 ngày"

create_issue "Xây dựng Product Repository & Engine lọc thuộc tính JSONB" \
  "backend,priority: high" "$M1_TITLE" \
"**Mô tả:** Lập trình ProductRepository/ProductService: phân trang, lọc theo danh mục, hãng, khoảng giá, thuộc tính động JSONB.

**Definition of Done:** Unit/Integration test lọc JSONB trả dữ liệu chính xác, phân trang chuẩn.

**Phụ thuộc:** #2
**Ước lượng:** 1 ngày"

create_issue "Implement REST API Product Catalog (/api/v1/products)" \
  "backend,priority: high" "$M1_TITLE" \
"**Mô tả:** Viết ProductsController và CategoriesController expose endpoint REST công khai, khớp api-contract.md.

**Definition of Done:** Swagger UI gọi API danh sách/chi tiết sản phẩm kèm JSONB specs, phản hồi < 50ms.

**Phụ thuộc:** #5
**Ước lượng:** 0.5 ngày"

create_issue "Xây dựng Cart API (/api/v1/cart) cho Guest & User" \
  "backend,priority: high" "$M1_TITLE" \
"**Mô tả:** API quản lý giỏ hàng: thêm/sửa/xóa item, hỗ trợ giỏ vãng lai qua cart_token, đồng bộ khi đăng nhập.

**Definition of Done:** Postman test CRUD giỏ hàng thành công cho cả khách vãng lai và user đã đăng nhập.

**Phụ thuộc:** #2, #4
**Ước lượng:** 0.5 ngày"

create_issue "Xây dựng Order & Inventory Processing API (OCC)" \
  "backend,priority: high" "$M1_TITLE" \
"**Mô tả:** API POST /api/v1/orders chốt đơn và trừ kho bằng Optimistic Concurrency Control (xmin/RowVersion).

**Definition of Done:** Tạo đơn thành công, trừ kho chính xác, trả 409 Conflict khi xung đột tồn kho.

**Phụ thuộc:** #2, #7
**Ước lượng:** 1 ngày"

create_issue "Tích hợp Payment API Ver 1 (COD & Simulated VNPay Callback)" \
  "backend,mvp-v1,priority: medium" "$M1_TITLE" \
"**Mô tả:** Xử lý COD và endpoint Callback giả lập cập nhật trạng thái thanh toán từ VNPay.

**Definition of Done:** API trả thông tin thanh toán, tự cập nhật payment_status='Paid' khi nhận callback giả lập.

**Phụ thuộc:** #8
**Ước lượng:** 0.5 ngày"

create_issue "Khởi tạo UI Design System với Tailwind CSS & shadcn/ui" \
  "frontend,priority: high" "$M1_TITLE" \
"**Mô tả:** Cấu hình Next.js với Tailwind, shadcn/ui, Dark Mode gaming theme, layout cơ bản (Header, Footer).

**Definition of Done:** Component Button, Input, Card, Modal render đúng phong cách Dark Gaming.

**Phụ thuộc:** #1
**Ước lượng:** 0.5 ngày"

create_issue "Xây dựng Storefront Header, Nav & WP Banner Carousel" \
  "frontend,priority: high" "$M1_TITLE" \
"**Mô tả:** Dựng Header (danh mục, tìm kiếm, giỏ hàng) + Carousel banner ưu đãi từ WPGraphQL.

**Definition of Done:** Banner lấy dữ liệu trực tiếp từ WPGraphQL, hiển thị đúng ảnh/tiêu đề/mã giảm giá.

**Phụ thuộc:** #3, #10
**Ước lượng:** 1 ngày"

# ----------------------------------------------------------------------------
# 4. TẠO ISSUES (Milestone 2: #12 - #20)
# ----------------------------------------------------------------------------
echo "==> Đang tạo Issues cho Milestone 2..."

create_issue "Xây dựng Trang danh sách sản phẩm & Bộ lọc JSONB (ProductListPage)" \
  "frontend,priority: high" "$M2_TITLE" \
"**Mô tả:** Màn hình hiển thị sản phẩm, phân trang, bộ lọc đa tiêu chí (giá, hãng, switch, DPI) gọi API ASP.NET Core.

**Definition of Done:** Bộ lọc tương tác mượt, cập nhật danh sách ngay không reload, chuẩn Responsive. Khớp wireframe-ui-mockup.md.

**Phụ thuộc:** #6, #10
**Ước lượng:** 1 ngày"

create_issue "Xây dựng Trang chi tiết sản phẩm & Chọn biến thể (ProductDetailPage)" \
  "frontend,priority: high" "$M2_TITLE" \
"**Mô tả:** Chi tiết sản phẩm, gallery ảnh, chọn biến thể, bảng thông số JSONB, nút thêm giỏ hàng.

**Definition of Done:** Đổi biến thể cập nhật đúng giá/tồn kho thực tế; thêm giỏ hàng thành công.

**Phụ thuộc:** #6, #7, #10
**Ước lượng:** 1 ngày"

create_issue "Xây dựng Màn hình Giỏ hàng & Đồng bộ State (CartPage)" \
  "frontend,priority: medium" "$M2_TITLE" \
"**Mô tả:** Giao diện giỏ hàng: đổi số lượng, xóa item, tính tổng tiền, state phía client (Zustand/Redux).

**Definition of Done:** Đổi số lượng cập nhật UI ngay và gửi API đồng bộ với Backend.

**Phụ thuộc:** #7, #13
**Ước lượng:** 0.5 ngày"

create_issue "Xây dựng Màn hình Đăng ký/Đăng nhập & Auth Context" \
  "frontend,priority: high" "$M2_TITLE" \
"**Mô tả:** Form đăng nhập/đăng ký, validate, lưu JWT, tự gắn Header Authorization: Bearer vào API client.

**Definition of Done:** Đăng nhập chuyển hướng đúng trang, duy trì Auth State khi reload, tự refresh Token.

**Phụ thuộc:** #4, #10
**Ước lượng:** 0.5 ngày"

create_issue "Xây dựng Màn hình Thanh toán & Đặt hàng (CheckoutPage)" \
  "frontend,priority: high" "$M2_TITLE" \
"**Mô tả:** Form địa chỉ giao hàng, chọn PTTT (COD/VNPay), gửi tạo đơn tới ASP.NET Core API.

**Definition of Done:** Đặt hàng thành công hiện mã đơn, tự dọn giỏ hàng, chuyển trang xác nhận.

**Phụ thuộc:** #8, #9, #14, #15
**Ước lượng:** 1 ngày"

create_issue "Xây dựng Trang Blog Review Gear từ WPGraphQL" \
  "frontend,cms,priority: medium" "$M2_TITLE" \
"**Mô tả:** Trang /blog và /blog/[slug] truy vấn danh sách/chi tiết bài viết từ WordPress qua WPGraphQL.

**Definition of Done:** Hiển thị danh sách + nội dung chi tiết chuẩn HTML an toàn (sanitized).

**Phụ thuộc:** #3, #10
**Ước lượng:** 1 ngày"

create_issue "Tích hợp Webhook Revalidate giữa WordPress và Next.js" \
  "cms,frontend,priority: medium" "$M2_TITLE" \
"**Mô tả:** Hook save_post trên WordPress gửi HTTP POST sang /api/revalidate của Next.js để xóa đệm ISR.

**Definition of Done:** Cập nhật bài viết trên WP -> trang tĩnh Next.js tự làm mới nội dung tức thì.

**Phụ thuộc:** #3, #17
**Ước lượng:** 0.5 ngày"

create_issue "Cấu hình SSO JWT giữa ReactJS và WordPress Comment (Ver 1 - đơn giản hóa)" \
  "cms,backend,frontend,mvp-v1,priority: medium" "$M2_TITLE" \
"**Mô tả:** Gửi JWT do ASP.NET Core cấp trong Header khi ReactJS gọi API WordPress để gửi bình luận.

**Definition of Done:** Khách đã đăng nhập trên Storefront có thể bình luận bài viết mà không cần đăng nhập lại WP.

**Phụ thuộc:** #4, #15, #17
**Ước lượng:** 0.5 ngày"

create_issue "Kiểm thử E2E luồng mua hàng, Stress test OCC & Dockerize Demo" \
  "backend,frontend,cms,priority: high" "$M2_TITLE" \
"**Mô tả:** Kiểm thử toàn trình (Xem SP -> Giỏ hàng -> Đặt hàng -> WP Blog); giả lập 10 request đặt hàng đồng thời trên 1 biến thể còn 1 item kho.

**Definition of Done:** Không overselling (chỉ 1 order thành công, 9 order lỗi 409); \`docker compose up\` chạy full app bằng 1 lệnh.

**Phụ thuộc:** Tất cả Issue trước
**Ước lượng:** 1 ngày"

echo ""
echo "✅ Hoàn tất! Đã tạo Labels + 2 Milestones + 20 Issues trên $REPO"
echo "==> Kiểm tra tại: https://github.com/$REPO/issues"
echo "==> Milestones tại: https://github.com/$REPO/milestones"
