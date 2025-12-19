---
title: "Hướng Dẫn Hoàn Chỉnh Vultr Firewall: Thiết Lập Bảo Mật Máy Chủ Đám Mây"
date: 2025-12-16T16:00:00+09:00
lastmod: 2025-12-16T16:00:00+09:00
draft: false
description: "Hướng dẫn hoàn chỉnh để bảo mật máy chủ đám mây sử dụng firewall dựa trên web của Vultr. Từ tạo Firewall Groups đến triển khai thực tế."
tags: ["vultr", "firewall", "방화벽", "서버보안", "vps", "클라우드보안", "인프라"]
categories: ["클라우드"]
image: "https://urinfo24.com/cdn-cgi/image/width=1200,format=auto,quality=85/https://images.urinfo24.com/featured/vultr-firewall-setup-guide-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A professional, technical illustration depicting cloud firewall security concept.
- Style: Clean, modern technical diagram style with minimalist design
- Subject: Network firewall shield icon protecting cloud server instances
- Elements: Firewall shield in center, multiple server icons behind it, network traffic arrows (green for allowed, red for blocked), cloud infrastructure background
- Colors: Blue and white for security theme, green for allowed traffic, red for blocked traffic, gray for servers
- Mood: Professional, secure, trustworthy, technical
- Composition: Central firewall shield with bidirectional traffic flow visualization

Technical keywords: Vultr, firewall, cloud security, network protection, server infrastructure

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/vultr-firewall-setup-guide-featured.jpg

NOTE: Hugo will serve this from /images/vultr-firewall-setup-guide-featured.jpg
-->

## 1. Vultr Firewall Là Gì?

Vultr Firewall là dịch vụ tường lửa dựa trên web.
Nó lọc gói tin trước khi lưu lượng đến các instance đám mây của bạn.

### 1.1 Tại Sao Bạn Cần Nó?

Bảo mật máy chủ yêu cầu phòng thủ nhiều tầng.
Tường lửa host (UFW, firewalld) một mình không đủ.

Vultr Firewall hoạt động ở tầng mạng.
Do đó, lưu lượng độc hại bị chặn trước khi đến máy chủ của bạn.

### 1.2 Khác Biệt Với Tường Lửa Host

**Tường Lửa Host (UFW, firewalld):**
- Hoạt động trong hệ điều hành máy chủ
- Lọc lưu lượng sau khi đến máy chủ
- Sử dụng tài nguyên CPU/bộ nhớ

**Vultr Firewall:**
- Hoạt động ở tầng mạng của Vultr
- Chặn lưu lượng trước khi đến máy chủ
- Không ảnh hưởng đến tài nguyên máy chủ

Do đó, sử dụng cả hai cùng nhau là cách an toàn nhất.

### 1.3 Khái Niệm Firewall Group

Vultr Firewall được quản lý theo nhóm.
Bạn thêm nhiều quy tắc vào một Firewall Group.
Sau đó bạn có thể áp dụng nhóm này cho nhiều instance.

Ví dụ:
- Nhóm web server: Cho phép HTTP/HTTPS
- Nhóm DB server: Cho phép cổng DB chỉ từ IP cụ thể
- Nhóm development server: Chỉ cho phép SSH


## 2. Tạo Firewall Group

### 2.1 Tạo Qua Portal

Đăng nhập vào Vultr Customer Portal.

1. Điều hướng đến **Products → Network → Firewall**
2. Nhấp nút **Add Firewall**
3. Nhập tên nhóm vào trường **Description**
4. Nhấp nút **Add Firewall Group**

Nhóm đã được tạo.
Nhưng vẫn là nhóm trống không có quy tắc.

### 2.2 Tạo Qua API

Sử dụng API cho phép tự động hóa.

```bash
curl "https://api.vultr.com/v2/firewalls" \
  -X POST \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "description": "web-server-firewall"
  }'
```

Bạn sẽ nhận được Firewall Group ID trong phản hồi.
Nhớ ID này.

### 2.3 Quản Lý Với Terraform

Nếu bạn quản lý cơ sở hạ tầng dưới dạng mã, hãy sử dụng Terraform.

```hcl
resource "vultr_firewall_group" "web" {
  description = "Web Server Firewall"
}
```

Quản lý bằng mã cho phép kiểm soát phiên bản.
Cũng thuận tiện cho cộng tác nhóm.

## 3. Cấu Hình Quy Tắc Tường Lửa

### 3.1 Thêm Quy Tắc Cơ Bản

Nhấp vào Firewall Group để vào màn hình quản lý quy tắc.

**Thêm Quy Tắc IPv4:**
- Protocol: TCP
- Port: 80
- Source: Anywhere (0.0.0.0/0)

Điều này cho phép truy cập HTTP từ bất kỳ đâu.

### 3.2 Hạn Chế Truy Cập SSH

SSH chỉ nên truy cập được từ IP cụ thể.

**Quy Tắc IPv4:**
- Protocol: TCP
- Port: 22
- Source: 123.45.67.89 (IP của bạn)

Bây giờ truy cập SSH chỉ có thể từ IP của bạn.
Các IP khác bị chặn.

### 3.3 Mở Nhiều Cổng Cùng Lúc

Web server cần mở cả HTTP và HTTPS.

**Quy Tắc 1 - HTTP:**
```
Protocol: TCP
Port: 80
Source: 0.0.0.0/0
```

**Quy Tắc 2 - HTTPS:**
```
Protocol: TCP
Port: 443
Source: 0.0.0.0/0
```

### 3.4 Thêm Quy Tắc Qua API

```bash
curl "https://api.vultr.com/v2/firewalls/{firewall-id}/rules" \
  -X POST \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "ip_type": "v4",
    "protocol": "tcp",
    "subnet": "0.0.0.0",
    "subnet_size": 0,
    "port": "80",
    "notes": "Allow HTTP"
  }'
```

Hữu ích trong các script tự động hóa.

### 3.5 Định Nghĩa Quy Tắc Trong Terraform

```hcl
resource "vultr_firewall_rule" "allow_http" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "80"
  notes             = "Allow HTTP traffic"
}

resource "vultr_firewall_rule" "allow_https" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "443"
  notes             = "Allow HTTPS traffic"
}

resource "vultr_firewall_rule" "allow_ssh" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "123.45.67.89"
  subnet_size       = 32
  port              = "22"
  notes             = "Allow SSH from my IP"
}
```

## 4. Kết Nối Với Instances

### 4.1 Kết Nối Qua Portal

Sau khi bạn đã tạo quy tắc, áp dụng chúng cho instances.

1. Điều hướng đến **Products → Compute**
2. Nhấp vào instance mục tiêu
3. Vào **Settings → Firewall**
4. Chọn nhóm từ menu thả xuống Firewall
5. Nhấp nút **Update Firewall Group**

Áp dụng ngay lập tức.

### 4.2 Áp Dụng Cho Nhiều Instances

Nếu bạn có nhiều server cùng vai trò?
Áp dụng cùng Firewall Group cho mỗi instance.

Ví dụ:
- 3 web server
- Tất cả cần cùng quy tắc tường lửa

Do đó, áp dụng một Firewall Group cho cả 3.
Thay đổi quy tắc được phản ánh ngay lập tức trên cả 3.

### 4.3 Kết Nối Qua API

```bash
curl "https://api.vultr.com/v2/instances/{instance-id}" \
  -X PATCH \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "firewall_group_id": "{firewall-id}"
  }'
```

Sử dụng trong script triển khai tự động.

### 4.4 Quản Lý Với Terraform

```hcl
resource "vultr_instance" "web" {
  region             = "sea"
  plan               = "vc2-1c-1gb"
  os_id              = 1743  # Ubuntu 22.04
  label              = "web-server-01"
  firewall_group_id  = vultr_firewall_group.web.id
}
```

Áp dụng tường lửa đồng thời với tạo instance.

## 5. Ví Dụ Sử Dụng Thực Tế

### 5.1 Bảo Vệ Web Servers

Web server chỉ cần mở HTTP, HTTPS và SSH.

```hcl
resource "vultr_firewall_group" "web" {
  description = "Web Server Firewall"
}

resource "vultr_firewall_rule" "web_ssh" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  port              = "22"
  ip_type           = "v4"
  subnet            = "123.45.67.89"  # Chỉ IP của bạn
  subnet_size       = 32
}

resource "vultr_firewall_rule" "web_http" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  port              = "80"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
}

resource "vultr_firewall_rule" "web_https" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  port              = "443"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
}
```

Tất cả cổng khác tự động bị chặn.

### 5.2 Database Servers

DB server chỉ nên truy cập được từ web server.

```hcl
resource "vultr_firewall_rule" "db_from_web" {
  firewall_group_id = vultr_firewall_group.db.id
  protocol          = "tcp"
  port              = "5432"  # PostgreSQL
  ip_type           = "v4"
  subnet            = "192.168.1.10"  # IP riêng của web server
  subnet_size       = 32
}
```

Không thể truy cập DB qua IP công khai.
Chỉ có thể qua Mạng Riêng.

### 5.3 Tích Hợp Với Load Balancer

Nếu sử dụng Load Balancer?
Web server chỉ nên nhận lưu lượng từ Load Balancer.

**Cài đặt quy tắc:**
- Protocol: TCP
- Port: 80
- Source: Load Balancer (nhập ID LB)

Điều này chặn truy cập trực tiếp bỏ qua Load Balancer.

## 6. Thực Hành Tốt Nhất Về Bảo Mật

### 6.1 Chính Sách Mặc Định: Từ Chối Tất Cả

Chính sách mặc định của Vultr Firewall là "chặn tất cả".
Do đó, chỉ lưu lượng được cho phép rõ ràng mới đi qua.

Đây là cách tiếp cận đúng.
Chỉ mở những gì cần thiết.

### 6.2 Nguyên Tắc Đặc Quyền Tối Thiểu

Đừng mở SSH cho tất cả IP.
Nó trở thành mục tiêu của tấn công brute force.

Do đó, chỉ cho phép IP cụ thể:
- IP văn phòng
- IP VPN
- IP nhà

### 6.3 Phòng Thủ Nhiều Tầng

Chỉ Vultr Firewall là đủ?
Không. Sử dụng tường lửa host cùng nhau.

**Tầng phòng thủ:**
1. Vultr Firewall (tầng mạng)
2. Tường lửa host (tầng OS)
3. Tường lửa ứng dụng (tầng app)

Do đó, cấu hình UFW hoặc firewalld cũng vậy.

### 6.4 Kiểm Tra Trước Khi Production

Nếu bạn cấu hình sai tường lửa?
Gián đoạn dịch vụ.

Do đó, luôn:
1. Kiểm tra trong môi trường phát triển
2. Xác minh trong môi trường staging
3. Áp dụng vào production

### 6.5 Xem Xét Quy Tắc Thường Xuyên

Không phải là thiết lập một lần.
Xem xét quy tắc thường xuyên:

- Xóa quy tắc không cần thiết
- Xóa IP không còn sử dụng
- Phản ánh yêu cầu bảo mật mới

## 7. Khắc Phục Sự Cố

### 7.1 Khi Kết Nối Thất Bại

Không thể truy cập SSH hoặc web?

**Danh sách kiểm tra:**
1. Firewall Group có kết nối với instance không?
2. Có quy tắc cho phép cổng không?
3. IP nguồn có đúng không?
4. Kiểm tra tường lửa host cũng vậy

### 7.2 Thời Gian Áp Dụng Quy Tắc

Thay đổi Firewall Group áp dụng ngay lập tức.
Nhưng lan truyền mạng có thể mất vài giây.

Thử kiểm tra kết nối sau 10-20 giây.

### 7.3 Kiểm Tra Logs

Vultr Firewall tự nó không cung cấp logs.
Do đó, kiểm tra logs tường lửa host.

**Logs UFW:**
```bash
sudo tail -f /var/log/ufw.log
```

**Logs Firewalld:**
```bash
sudo journalctl -u firewalld -f
```

### 7.4 Ưu Tiên Quy Tắc

Vultr Firewall không có thứ tự quy tắc.
Tất cả quy tắc hoạt động với điều kiện OR.

Tức là, nếu bất kỳ quy tắc nào khớp, nó được cho phép.

## 8. CLI Và Tự Động Hóa

### 8.1 Cài Đặt Vultr CLI

```bash
# macOS
brew install vultr/vultr-cli/vultr-cli

# Linux
curl -L https://github.com/vultr/vultr-cli/releases/latest/download/vultr-cli-linux-amd64.tar.gz | tar xz
sudo mv vultr-cli /usr/local/bin/
```

Cấu hình API Key:
```bash
export VULTR_API_KEY="your-api-key"
```

### 8.2 Quản Lý Firewall Groups

**Liệt kê nhóm:**
```bash
vultr-cli firewall group list
```

**Tạo nhóm:**
```bash
vultr-cli firewall group create --description "Web Server"
```

**Thêm quy tắc:**
```bash
vultr-cli firewall rule create \
  --firewall-group-id <id> \
  --protocol tcp \
  --port 80 \
  --ip-type v4 \
  --subnet 0.0.0.0 \
  --subnet-size 0
```

### 8.3 Tự Động Hóa Triển Khai

Tự động áp dụng tường lửa khi triển khai instances mới:

```bash
#!/bin/bash

# Tạo instance
INSTANCE_ID=$(vultr-cli instance create \
  --region sea \
  --plan vc2-1c-1gb \
  --os 1743 \
  --label web-server \
  --output json | jq -r '.id')

# Áp dụng tường lửa
vultr-cli instance update-firewall-group \
  --instance-id $INSTANCE_ID \
  --firewall-group-id $FIREWALL_ID

echo "Instance $INSTANCE_ID deployed with firewall"
```

## 9. Chi Phí Và Giới Hạn

### 9.1 Chi Phí

Vultr Firewall **hoàn toàn miễn phí**.
Không có phí bổ sung nào cả.

Do đó, được khuyến nghị cho tất cả instances.

### 9.2 Giới Hạn

**Firewall Groups:**
- Tối đa 50 mỗi tài khoản

**Quy tắc:**
- Tối đa 50 quy tắc mỗi nhóm

Đủ cho hầu hết các trường hợp.
Liên hệ hỗ trợ nếu cần thêm.

### 9.3 Khác Biệt Với Load Balancer Firewall

Vultr Load Balancer có tường lửa riêng biệt.
Hai cái khác nhau:

**Vultr Firewall:**
- Bảo vệ instances
- Lọc tầng mạng

**Load Balancer Firewall:**
- Bảo vệ Load Balancer
- Lọc lưu lượng vào LB

Do đó, cấu hình cả hai khi sử dụng Load Balancer.

## 10. Tóm Tắt

### 10.1 Ưu Điểm Của Vultr Firewall

- Miễn phí
- Bảo vệ tầng mạng
- Dễ áp dụng cho nhiều instances
- Hỗ trợ API/CLI/Terraform
- Không sử dụng tài nguyên máy chủ

### 10.2 Khi Nào Sử Dụng?

**Phải sử dụng:**
- Server production
- Dịch vụ công khai
- Xử lý dữ liệu nhạy cảm

**Tùy chọn:**
- Môi trường phát triển/kiểm tra
- Server chỉ sử dụng Mạng Riêng

Nhưng áp dụng cho tất cả instances nếu có thể.

### 10.3 Cải Thiện Bảo Mật Bổ Sung

Ngoài Vultr Firewall:
- Cài đặt Fail2ban (chặn brute force)
- Sử dụng xác thực khóa SSH
- Cập nhật bảo mật thường xuyên
- Kích hoạt Bảo Vệ DDoS

Cần nhiều tầng bảo mật.

### 10.4 Tài Liệu Tham Khảo

- [Tài liệu Chính thức Vultr Firewall](https://docs.vultr.com/products/network/firewall)
- [Tài liệu Vultr API](https://www.vultr.com/api/)
- [Vultr CLI GitHub](https://github.com/vultr/vultr-cli)
- [Terraform Vultr Provider](https://registry.terraform.io/providers/vultr/vultr/latest/docs)

Sử dụng Vultr Firewall bảo vệ server đám mây một cách an toàn.
Miễn phí và dễ sử dụng.
Do đó, thiết lập ngay bây giờ.
