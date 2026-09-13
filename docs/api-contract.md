# TÀI LIỆU API CONTRACT - HỆ THỐNG ASP.NET CORE BACKEND
**Dự án:** Website Bán Thiết Bị Gaming Gear (E-Commerce)
**Phiên bản API:** v1 (`/api/v1`)
**Định dạng dữ liệu:** JSON (`application/json`)

---

## 1. Quy chuẩn Response Error dùng chung toàn hệ thống

Toàn bộ các API khi gặp lỗi (Mã HTTP status 4xx, 5xx) đều phản hồi theo một cấu trúc chuẩn duy nhất như sau:

```json
{
  "error": {
    "code": "MA_LOI_NGHIEP_VU",
    "message": "Thông báo mô tả lỗi chi tiết dành cho người dùng/developer",
    "details": [
      {
        "field": "ten_truong_du_lieu",
        "issue": "Mô tả lỗi cụ thể của trường dữ liệu"
      }
    ],
    "timestamp": "2026-09-13T08:50:00Z"
  }
}
```

---

## 2. Danh sách Mã lỗi nghiệp vụ đặc thù (Business Error Codes)

| HTTP Status | Business Code | Mô tả & Nguyên nhân |
| :--- | :--- | :--- |
| `400 Bad Request` | `VALIDATION_ERROR` | Dữ liệu đầu vào không hợp lệ (thiếu trường bắt buộc, sai định dạng). |
| `400 Bad Request` | `INVALID_CREDENTIALS` | Sai email hoặc mật khẩu khi đăng nhập. |
| `400 Bad Request` | `EMAIL_ALREADY_EXISTS` | Email đã được sử dụng để đăng ký tài khoản khác. |
| `401 Unauthorized` | `UNAUTHORIZED` | Thiếu Header Authorization hoặc Bearer Token không hợp lệ. |
| `401 Unauthorized` | `TOKEN_EXPIRED` | Access Token JWT đã hết hạn sử dụng. |
| `403 Forbidden` | `ACCESS_DENIED` | Người dùng không có quyền truy cập tài nguyên (ví dụ: Customer gọi API Admin). |
| `404 Not Found` | `RESOURCE_NOT_FOUND` | Không tìm thấy sản phẩm, danh mục, giỏ hàng hoặc đơn hàng yêu cầu. |
| `409 Conflict` | `OUT_OF_STOCK_OCC` | Xung đột tranh chấp tồn kho khi đặt hàng (Optimistic Concurrency Control - biến thể đã hết hàng). |
| `409 Conflict` | `CART_ITEM_CONFLICT` | Biến thể sản phẩm bị thay đổi hoặc ngưng kinh doanh trong lúc chốt đơn. |
| `500 Internal Error`| `INTERNAL_SERVER_ERROR` | Lỗi máy chủ hoặc kết nối cơ sở dữ liệu thất bại. |

---

## 3. Chi tiết API Contract cho từng Endpoint

---

### 3.1 Nhóm Authentication & User

#### POST /api/v1/auth/register
**Mô tả:** Đăng ký tài khoản người dùng mới.
**Headers:** `Content-Type: application/json`
**Request Params/Query:** Không

**Request Body mẫu (JSON):**
```json
{
  "email": "gamer2026@gmail.com",
  "password": "Password123!",
  "full_name": "Nguyễn Văn Game",
  "phone_number": "0987654321"
}
```

**Response thành công (201 Created) mẫu (JSON):**
```json
{
  "id": "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11",
  "email": "gamer2026@gmail.com",
  "full_name": "Nguyễn Văn Game",
  "phone_number": "0987654321",
  "role": "Customer",
  "created_at": "2026-09-13T08:00:00Z"
}
```

**Response lỗi (400 Bad Request / Email đã tồn tại) mẫu (JSON):**
```json
{
  "error": {
    "code": "EMAIL_ALREADY_EXISTS",
    "message": "Email 'gamer2026@gmail.com' đã được sử dụng trong hệ thống.",
    "details": [
      {
        "field": "email",
        "issue": "Email đã tồn tại."
      }
    ],
    "timestamp": "2026-09-13T08:00:01Z"
  }
}
```

---

#### POST /api/v1/auth/login
**Mô tả:** Đăng nhập hệ thống, nhận JWT Access Token và thiết lập Refresh Token vào Cookie.
**Headers:** `Content-Type: application/json`
**Request Params/Query:** Không

**Request Body mẫu (JSON):**
```json
{
  "email": "gamer2026@gmail.com",
  "password": "Password123!"
}
```

**Response thành công (200 OK) mẫu (JSON):**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 1800,
  "user": {
    "id": "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11",
    "email": "gamer2026@gmail.com",
    "full_name": "Nguyễn Văn Game",
    "role": "Customer"
  }
}
```

**Response lỗi (401 Unauthorized / Sai mật khẩu) mẫu (JSON):**
```json
{
  "error": {
    "code": "INVALID_CREDENTIALS",
    "message": "Email hoặc mật khẩu không chính xác.",
    "details": [],
    "timestamp": "2026-09-13T08:01:00Z"
  }
}
```

---

#### GET /api/v1/auth/me
**Mô tả:** Lấy thông tin tài khoản cá nhân người dùng đang xác thực.
**Headers:** 
* `Authorization: Bearer <JWT_ACCESS_TOKEN>`

**Request Params/Query:** Không

**Response thành công (200 OK) mẫu (JSON):**
```json
{
  "id": "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11",
  "email": "gamer2026@gmail.com",
  "full_name": "Nguyễn Văn Game",
  "phone_number": "0987654321",
  "role": "Customer",
  "created_at": "2026-09-13T08:00:00Z"
}
```

**Response lỗi (401 Unauthorized / Token hết hạn) mẫu (JSON):**
```json
{
  "error": {
    "code": "TOKEN_EXPIRED",
    "message": "Mã xác thực Access Token đã hết hạn. Vui lòng đăng nhập lại hoặc gia hạn token.",
    "details": [],
    "timestamp": "2026-09-13T08:02:00Z"
  }
}
```

---

### 3.2 Nhóm Products & Categories

#### GET /api/v1/categories
**Mô tả:** Lấy danh sách toàn bộ danh mục sản phẩm.
**Headers:** Không bắt buộc.
**Request Params/Query:** Không

**Response thành công (200 OK) mẫu (JSON):**
```json
[
  {
    "id": 1,
    "name": "Chuột Gaming",
    "slug": "chuot-gaming",
    "parent_id": null
  },
  {
    "id": 2,
    "name": "Bàn Phím Cơ",
    "slug": "ban-phim-co",
    "parent_id": null
  },
  {
    "id": 3,
    "name": "Chuột Không Dây",
    "slug": "chuot-khong-day",
    "parent_id": 1
  }
]
```

---

#### GET /api/v1/products
**Mô tả:** Lấy danh sách sản phẩm có phân trang, bộ lọc danh mục, thương hiệu, khoảng giá và thuộc tính JSONB.
**Headers:** Không bắt buộc.
**Request Params/Query:**

| Tên | Kiểu | Bắt buộc | Mô tả |
| :--- | :--- | :--- | :--- |
| `category` | string | Không | Slug danh mục (vd: `chuot-gaming`). |
| `brand_id` | number | Không | Mã ID thương hiệu (vd: `1`). |
| `min_price` | number | Không | Lọc giá tối thiểu (VND). |
| `max_price` | number | Không | Lọc giá tối đa (VND). |
| `page` | number | Không | Số trang (mặc định: `1`). |
| `pageSize` | number | Không | Số lượng item/trang (mặc định: `10`, tối đa `50`). |

**Response thành công (200 OK) mẫu (JSON):**
```json
{
  "items": [
    {
      "id": 101,
      "sku": "MOU-RAZER-001",
      "name": "Razer Viper V2 Pro",
      "slug": "razer-viper-v2-pro",
      "price": 3500000.00,
      "compare_at_price": 3900000.00,
      "specifications": {
        "sensor": "Focus Pro 30K Optical",
        "max_dpi": 30000,
        "polling_rate_hz": 4000,
        "switch_type": "Razer Optical Gen-3",
        "weight_grams": 63,
        "connectivity": ["2.4GHz Wireless", "USB-C Cable"]
      },
      "brand_id": 1,
      "category_id": 1,
      "created_at": "2026-09-10T10:00:00Z"
    }
  ],
  "total_count": 1,
  "page": 1,
  "page_size": 10
}
```

**Response lỗi (400 Bad Request / PageSize không hợp lệ) mẫu (JSON):**
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Tham số phân trang không hợp lệ.",
    "details": [
      {
        "field": "pageSize",
        "issue": "pageSize không được vượt quá 50."
      }
    ],
    "timestamp": "2026-09-13T08:03:00Z"
  }
}
```

---

#### GET /api/v1/products/{slug}
**Mô tả:** Lấy thông tin chi tiết một sản phẩm kèm danh sách biến thể kho (ProductVariants) và thông số JSONB kỹ thuật.
**Headers:** Không bắt buộc.
**Request Params/Query:**
* `slug` (Path Parameter, string, bắt buộc): Chuỗi SEO slug của sản phẩm (vd: `razer-viper-v2-pro`).

**Response thành công (200 OK) mẫu (JSON):**
```json
{
  "id": 101,
  "sku": "MOU-RAZER-001",
  "name": "Razer Viper V2 Pro",
  "slug": "razer-viper-v2-pro",
  "price": 3500000.00,
  "compare_at_price": 3900000.00,
  "specifications": {
    "sensor": "Focus Pro 30K Optical",
    "max_dpi": 30000,
    "polling_rate_hz": 4000,
    "switch_type": "Razer Optical Gen-3",
    "weight_grams": 63,
    "connectivity": ["2.4GHz Wireless", "USB-C Cable"]
  },
  "brand_id": 1,
  "category_id": 1,
  "created_at": "2026-09-10T10:00:00Z",
  "variants": [
    {
      "id": 501,
      "product_id": 101,
      "sku_variant": "MOU-RAZER-001-BLK",
      "name": "Màu Đen (Black)",
      "price_override": null,
      "stock_quantity": 15,
      "is_active": true
    },
    {
      "id": 502,
      "product_id": 101,
      "sku_variant": "MOU-RAZER-001-WHT",
      "name": "Màu Trắng (White)",
      "price_override": 3600000.00,
      "stock_quantity": 8,
      "is_active": true
    }
  ]
}
```

**Response lỗi (404 Not Found) mẫu (JSON):**
```json
{
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "Không tìm thấy sản phẩm với slug 'razer-viper-v2-pro-invalid'.",
    "details": [],
    "timestamp": "2026-09-13T08:04:00Z"
  }
}
```

---

### 3.3 Nhóm Shopping Cart

#### GET /api/v1/cart
**Mô tả:** Lấy thông tin giỏ hàng hiện tại của khách vãng lai (qua `cart_token`) hoặc người dùng đã đăng nhập (qua JWT).
**Headers:** 
* `Authorization: Bearer <JWT_ACCESS_TOKEN>` (Nếu đã đăng nhập)
* `X-Cart-Token: <CART_TOKEN_UUID>` (Nếu là khách vãng lai)

**Request Params/Query:** Không

**Response thành công (200 OK) mẫu (JSON):**
```json
{
  "id": 201,
  "user_id": "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11",
  "cart_token": "cart_tok_9876543210_abc",
  "created_at": "2026-09-13T08:10:00Z",
  "items": [
    {
      "id": 1001,
      "cart_id": 201,
      "variant_id": 501,
      "quantity": 2,
      "variant_name": "Màu Đen (Black)",
      "product_name": "Razer Viper V2 Pro",
      "unit_price": 3500000.00,
      "subtotal": 7000000.00
    }
  ],
  "total_price": 7000000.00
}
```

---

#### POST /api/v1/cart/items
**Mô tả:** Thêm một biến thể sản phẩm (`variant_id`) vào giỏ hàng.
**Headers:** 
* `Content-Type: application/json`
* `X-Cart-Token: <CART_TOKEN_UUID>` (Bắt buộc nếu vãng lai)

**Request Params/Query:** Không

**Request Body mẫu (JSON):**
```json
{
  "variant_id": 501,
  "quantity": 1
}
```

**Response thành công (200 OK) mẫu (JSON):**
```json
{
  "id": 201,
  "cart_token": "cart_tok_9876543210_abc",
  "items_count": 1,
  "total_price": 3500000.00
}
```

**Response lỗi (400 Bad Request / Số lượng vượt tồn kho) mẫu (JSON):**
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Số lượng yêu cầu (100) vượt quá số lượng tồn kho khả dụng (15).",
    "details": [
      {
        "field": "quantity",
        "issue": "Vượt quá tồn kho."
      }
    ],
    "timestamp": "2026-09-13T08:11:00Z"
  }
}
```

---

#### PUT /api/v1/cart/items/{id}
**Mô tả:** Cập nhật số lượng của một mục sản phẩm trong giỏ hàng.
**Headers:** `Content-Type: application/json`
**Request Params/Query:**
* `id` (Path Parameter, number, bắt buộc): Mã ID mục giỏ hàng (`cart_items.id`).

**Request Body mẫu (JSON):**
```json
{
  "quantity": 3
}
```

**Response thành công (200 OK) mẫu (JSON):**
```json
{
  "id": 201,
  "cart_token": "cart_tok_9876543210_abc",
  "items_count": 1,
  "total_price": 10500000.00
}
```

---

#### DELETE /api/v1/cart/items/{id}
**Mô tả:** Xóa một mục sản phẩm khỏi giỏ hàng.
**Headers:** Không bắt buộc.
**Request Params/Query:**
* `id` (Path Parameter, number, bắt buộc): Mã ID mục giỏ hàng (`cart_items.id`).

**Response thành công (200 OK) mẫu (JSON):**
```json
{
  "message": "Đã xóa sản phẩm khỏi giỏ hàng thành công.",
  "cart_id": 201,
  "remaining_items": 0
}
```

---

### 3.4 Nhóm Orders & OCC Processing

#### POST /api/v1/orders
**Mô tả:** Tạo đơn hàng mới từ giỏ hàng. Kiểm tra và trừ kho bằng cơ chế Optimistic Concurrency Control (OCC) để chống over-selling.
**Headers:** 
* `Authorization: Bearer <JWT_ACCESS_TOKEN>` (Nếu người dùng đã đăng nhập)
* `Content-Type: application/json`

**Request Body mẫu (JSON):**
```json
{
  "cart_id": 201,
  "shipping_address": "Số 123 Đường Cầu Giấy, Phường Dịch Vọng, Quận Cầu Giấy, Hà Nội",
  "payment_method": "VNPAY"
}
```

**Response thành công (201 Created) mẫu (JSON):**
```json
{
  "id": 3001,
  "user_id": "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11",
  "order_number": "ORD-20260913-001",
  "total_amount": 7000000.00,
  "status": "Pending",
  "shipping_address": "Số 123 Đường Cầu Giấy, Phường Dịch Vọng, Quận Cầu Giấy, Hà Nội",
  "payment_status": "Unpaid",
  "created_at": "2026-09-13T08:15:00Z",
  "order_items": [
    {
      "id": 7001,
      "order_id": 3001,
      "variant_id": 501,
      "quantity": 2,
      "unit_price": 3500000.00
    }
  ]
}
```

**Response lỗi (409 Conflict / Hết hàng do xung đột OCC) mẫu (JSON):**
```json
{
  "error": {
    "code": "OUT_OF_STOCK_OCC",
    "message": "Sản phẩm 'Màu Đen (Black)' vừa bị người mua khác chốt đơn trước. Số lượng tồn kho không đủ.",
    "details": [
      {
        "field": "variant_id_501",
        "issue": "Xung đột tranh chấp phiên bản tồn kho (RowVersion mismatch)."
      }
    ],
    "timestamp": "2026-09-13T08:15:05Z"
  }
}
```

---

#### GET /api/v1/orders/user
**Mô tả:** Lấy danh sách lịch sử đơn hàng của người dùng đang đăng nhập.
**Headers:** 
* `Authorization: Bearer <JWT_ACCESS_TOKEN>`

**Request Params/Query:** Không

**Response thành công (200 OK) mẫu (JSON):**
```json
[
  {
    "id": 3001,
    "user_id": "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11",
    "order_number": "ORD-20260913-001",
    "total_amount": 7000000.00,
    "status": "Pending",
    "shipping_address": "Số 123 Đường Cầu Giấy, Hà Nội",
    "payment_status": "Unpaid",
    "created_at": "2026-09-13T08:15:00Z"
  }
]
```

---

### 3.5 Nhóm Payments

#### POST /api/v1/payments/process
**Mô tả:** Khởi tạo giao dịch thanh toán hoặc tiếp nhận Webhook Callback cập nhật kết quả thanh toán từ cổng thanh toán.
**Headers:** `Content-Type: application/json`

**Request Body mẫu (JSON):**
```json
{
  "order_id": 3001,
  "payment_method": "VNPAY",
  "amount": 7000000.00,
  "transaction_id": "VNPAY_TX_20260913_998877"
}
```

**Response thành công (200 OK) mẫu (JSON):**
```json
{
  "id": 8001,
  "order_id": 3001,
  "payment_method": "VNPAY",
  "transaction_id": "VNPAY_TX_20260913_998877",
  "amount": 7000000.00,
  "status": "Completed",
  "created_at": "2026-09-13T08:16:00Z"
}
```

**Response lỗi (400 Bad Request / Số tiền không khớp) mẫu (JSON):**
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Số tiền thanh toán (5000000.00) không khớp với giá trị đơn hàng (7000000.00).",
    "details": [],
    "timestamp": "2026-09-13T08:16:02Z"
  }
}
```
