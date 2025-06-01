# Hust Book Store

**Hust Book Store** là một hệ thống quản lý cửa hàng trực tuyến, cung cấp các sản phẩm như sách, văn phòng phẩm và đồ chơi. Dự án được xây dựng với mục tiêu mô phỏng một cửa hàng thực tế, hỗ trợ người dùng duyệt sản phẩm và quản lý đơn hàng một cách dễ dàng.

##  Công nghệ sử dụng

### Backend:
- **Java**
- **Spring Boot** – Xây dựng API và xử lý nghiệp vụ
- **Maven** – Quản lý project và dependencies
- **PostgreSQL** - Quản lý dữ liệu
- **Spring Data JPA** – Tương tác với cơ sở dữ liệu (ORM)
- **Maven** – Quản lý project và dependencies
### Frontend:
- **HTML/CSS** – Giao diện người dùng đơn giản, dễ sử dụng


##  Tính năng chính

-  Hiển thị danh sách các sản phẩm: sách, văn phòng phẩm, đồ chơi
-  Tìm kiếm sản phẩm theo tên hoặc danh mục
-  Xem chi tiết sản phẩm
-  Thêm sản phẩm vào giỏ hàng
-  Hiển thỉ thông tin thanh toán
-  Hiển thị thông tin chi tiết sản phẩm
-  Tương tác dữ liệu bằng JPA và SQL
-  Đặt hàng và quản lý đơn hàng
-  Quản trị sản phẩm: thêm, xoá, cập nhật (cho admin)

## Cài đặt và chạy dự án

### Yêu cầu:
- Java 17 trở lên
- Maven 3.4.5
- IDE: VS Code
- Extensions trong VS Code: Spring Boot Extension Pack, Maven for java

### Các bước thực hiện:

```bash
# 1. Clone project
git clone https://github.com/deepdev-hub/ecommerce-website.git
cd hust-book-store

# 2. Cài đặt dependencies
mvn clean install

# 3. Chạy ứng dụng
mvn spring-boot:run

Truy cập vào http://localhost:8080 để sử dụng ứng dụng.
