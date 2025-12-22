---
title: "Hướng Dẫn Hoàn Chỉnh Claude Code + Supabase MCP Server: Từ Cài Đặt Đến Sử Dụng Cho Người Mới Bắt Đầu"
date: 2025-12-22T07:30:20+09:00
lastmod: 2025-12-22T07:45:22+09:00
draft: false
description: "Học cách kết nối Claude Code với Supabase làm MCP server để quản lý cơ sở dữ liệu bằng ngôn ngữ tự nhiên từ góc độ người mới bắt đầu. Hướng dẫn từng bước từ cài đặt đến sử dụng thực tế và các cân nhắc bảo mật."
tags: ["Claude Code", "Supabase", "MCP", "Model Context Protocol", "데이터베이스", "AI 개발도구", "자연어 쿼리", "개발 생산성"]
categories: ["DevOps"]
image: "https://urinfo24.com/cdn-cgi/image/width=1200,format=auto,quality=85/https://images.urinfo24.com/featured/claude-code-supabase-mcp-setup-featured.jpg"
lightgallery: true
---

<!--
Image Prompt: /Users/freein/Work/blog/images/image-prompt/claude-code-supabase-mcp-setup-prompt.txt
Featured Image: https://images.urinfo24.com/featured/claude-code-supabase-mcp-setup-featured.jpg
-->

Khi sử dụng Claude Code, có những lúc bạn muốn truy cập dữ liệu bên ngoài.
Đặc biệt các thao tác cơ sở dữ liệu có thể cồng kềnh vì bạn cần mở dashboard và viết SQL mỗi lần.
Trong những trường hợp như vậy, việc sử dụng MCP server cho phép bạn xử lý cơ sở dữ liệu bằng ngôn ngữ tự nhiên trong Claude Code.

Bài viết này sẽ hướng dẫn cách kết nối Claude Code với Supabase làm MCP server từ góc độ người mới bắt đầu.
Chúng ta sẽ tiến hành từng bước từ cài đặt đến sử dụng thực tế.

## 1. MCP là gì

### 1.1 Khái Niệm về MCP

MCP (Model Context Protocol) là một giao thức tiêu chuẩn cho phép các mô hình AI tương tác với các công cụ và dữ liệu bên ngoài.
Đơn giản hóa, hãy nghĩ về nó như một cây cầu kết nối AI với các hệ thống bên ngoài.

Trước đây, nếu AI muốn truy cập dữ liệu bên ngoài, bạn phải tạo API tùy chỉnh mỗi lần.
Điều này dẫn đến chi phí phát triển cao và khó bảo trì.
MCP là một cách tiếp cận chuẩn hóa được Anthropic tạo ra để giải quyết những vấn đề này.

### 1.2 Tại Sao Cần Thiết

Claude Code xuất sắc trong việc viết code nhưng không có cách nào để truy cập dữ liệu bên ngoài.
Đối với truy vấn cơ sở dữ liệu, truy cập hệ thống file, gọi API, v.v., bạn phải làm mọi thứ thủ công.

Sử dụng MCP server cho phép bạn thực hiện những tác vụ này bằng ngôn ngữ tự nhiên.
Ví dụ, nếu bạn yêu cầu "Hiển thị cho tôi 10 người dùng đăng ký gần đây nhất từ bảng users", Claude sẽ tự động viết và thực thi SQL.
Điều này cải thiện đáng kể năng suất phát triển.

## 2. Hướng Dẫn Cài Đặt Supabase MCP Server

### 2.1 Yêu Cầu Tiên Quyết

Đầu tiên, hãy kiểm tra những gì cần thiết.

**Yêu cầu thiết yếu**:
- Node.js (v16 trở lên)
- Claude Code đã cài đặt
- Tài khoản Supabase

Hãy kiểm tra phiên bản Node.js.

```bash
node --version
```

v16 trở lên là được.

### 2.2 Thiết Lập Dự Án Supabase

Đăng nhập vào dashboard Supabase (https://supabase.com).
Tạo dự án mới hoặc sử dụng dự án hiện có.

Kiểm tra thông tin sau trong cài đặt dự án:
- Project URL (ví dụ: `https://xxxxx.supabase.co`)
- API Keys → `anon` public key

Thông tin này sẽ được sử dụng sau trong cấu hình MCP server.

**Quan trọng**: `service_role` key có quyền đầy đủ, vì vậy hãy sử dụng cẩn thận.
Chỉ sử dụng trong môi trường phát triển và không bao giờ tải lên kho lưu trữ công khai.

### 2.3 Tạo URL Supabase MCP Server

Supabase cung cấp MCP server chính thức.
Bạn có thể tạo URL MCP tùy chỉnh trong tab 'Connect' → 'MCP' của dashboard.

Định dạng URL như sau:

```
https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=true
```

**Giải thích tham số query**:
- `project_ref`: Giới hạn cho dự án cụ thể (được khuyến nghị)
- `read_only`: Bật chế độ chỉ đọc (được khuyến nghị)

Chế độ chỉ đọc ngăn chặn việc sửa đổi dữ liệu vô tình.
An toàn khi bật tùy chọn này trong quá trình phát triển ban đầu.

### 2.4 Cấu Hình Claude Code

Bây giờ hãy cấu hình MCP server trong Claude Code.

#### Cấu Hình macOS

Đường dẫn file cấu hình như sau:

```
~/Library/Application Support/Claude/claude_desktop_config.json
```

Tạo file nếu nó chưa tồn tại.

```bash
mkdir -p ~/Library/Application\ Support/Claude
touch ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

#### Cấu Hình Windows

Trên Windows, sử dụng đường dẫn sau:

```
%APPDATA%\Claude\claude_desktop_config.json
```

Nhập `%APPDATA%\Claude` vào thanh địa chỉ Explorer.

## 3. Xác Minh Kết Nối

### 3.1 Viết File Cấu Hình

Mở file `claude_desktop_config.json` và thêm nội dung sau.

```json
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-supabase",
        "https://xxxxx.supabase.co",
        "your-anon-key-here"
      ]
    }
  }
}
```

**Giải thích tham số**:
- `command`: Sử dụng `npx` (thực thi gói npm trực tiếp)
- `args`: Gói MCP server và thông tin xác thực

**Hoặc sử dụng hosted MCP server**:

```json
{
  "mcpServers": {
    "supabase": {
      "url": "https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=true"
    }
  }
}
```

Cách tiếp cận hosting đơn giản hơn.
Nó tự động xử lý xác thực OAuth 2.1.

### 3.2 Kiểm Tra Kết Nối

Khởi động lại Claude Code.
Nhấp vào biểu tượng Tools trong menu để xem danh sách MCP server đã kết nối.

Nếu bạn thấy server "supabase", đó là thành công.

Hãy thực hiện một bài kiểm tra đơn giản.

```
Đến Claude: "Supabase anon key là gì?"
```

Claude truy vấn thông tin dự án và cho bạn biết.
Nếu điều này hoạt động, MCP server đã được kết nối đúng cách.

## 4. Ví Dụ Sử Dụng Thực Tế

Bây giờ hãy thực sự thực hiện các thao tác cơ sở dữ liệu.

### 4.1 Truy Vấn Bảng

Thao tác cơ bản nhất là truy vấn bảng.

```
Đến Claude: "Hiển thị tất cả dữ liệu từ bảng users"
```

Claude tự động viết và thực thi truy vấn SELECT.
Nó sắp xếp kết quả trong một bảng được định dạng đẹp mắt.

**Các yêu cầu cụ thể hơn cũng có thể**:

```
"Hiển thị chỉ những người dùng có email Gmail từ bảng users"
```

```
"Cho tôi biết có bao nhiều người dùng đăng ký trong 7 ngày qua"
```

Khi bạn yêu cầu bằng ngôn ngữ tự nhiên, Claude tự động tạo SQL phù hợp.

### 4.2 Chèn Dữ Liệu

Chèn dữ liệu cũng có thể khi chế độ read_only bị vô hiệu hóa.

Đầu tiên, thay đổi `read_only=false` trong file cấu hình.

```json
{
  "mcpServers": {
    "supabase": {
      "url": "https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=false"
    }
  }
}
```

Sau khi khởi động lại Claude Code, đưa ra yêu cầu như này.

```
"Thêm người dùng mới vào bảng users. 
Tên nên là 'John', email nên là 'john@example.com'"
```

Claude tạo truy vấn INSERT và yêu cầu thực thi.
Khi người dùng phê duyệt, dữ liệu được thêm vào.

### 4.3 Tạo Bảng

Bạn cũng có thể tạo bảng mới.

```
"Tạo bảng comments. 
Các cột nên là id, user_id, content, created_at"
```

Claude tạo truy vấn CREATE TABLE.
Sau khi xem xét schema và phê duyệt, bảng được tạo.

### 4.4 Truy Vấn Phức Tạp

JOIN hoặc truy vấn tổng hợp cũng có thể được yêu cầu bằng ngôn ngữ tự nhiên.

```
"Hiển thị số lượng bình luận được viết bởi mỗi người dùng"
```

```
"Có bao nhiều người dùng đăng ký tháng này đã viết ít nhất 1 bình luận?"
```

Claude cũng tự động viết SQL phức tạp.
Điều này làm cho các thao tác cơ sở dữ liệu có thể thực hiện được ngay cả khi không có kiến thức SQL hoàn hảo.

## 5. Bảo Mật và Mẹo

### 5.1 Cân Nhắc Bảo Mật

Bảo mật nên được xem xét khi sử dụng MCP server.

**Cấm kết nối dữ liệu production**:
- Chỉ sử dụng MCP trong môi trường phát triển/test
- Không bao giờ kết nối với cơ sở dữ liệu dịch vụ thực tế
- AI có thể vô tình xóa dữ liệu quan trọng

**Sử dụng chế độ chỉ đọc**:
- Đặt read_only=true theo mặc định
- Tạm thời vô hiệu hóa chỉ khi cần thao tác ghi
- Bật lại sau khi hoàn thành công việc

**Phạm vi dự án**:
- Chỉ giới hạn quyền truy cập cho các dự án cụ thể bằng tham số project_ref
- Không cấp quyền truy cập cho nhiều dự án

**Quản lý API key**:
- Không đặt API key trực tiếp trong file cấu hình
- Quản lý bằng biến môi trường an toàn hơn
- Không bao giờ tải lên kho lưu trữ công khai

### 5.2 Mẹo Sử Dụng Hiệu Quả

**Đưa ra yêu cầu cụ thể**:
- "Hiển thị dữ liệu" ❌
- "Hiển thị email và ngày đăng ký của 10 người dùng gần đây từ bảng users" ✅

**Tiến hành từng bước**:
- Không thực hiện các thao tác phức tạp cùng một lúc
- Trước tiên truy vấn để kiểm tra, sau đó sửa đổi

**Xem xét truy vấn**:
- Luôn kiểm tra SQL được tạo bởi Claude
- Yêu cầu sửa đổi nếu có phần đáng nghi

**Chỉ định công cụ**:
- "Sử dụng công cụ Supabase MCP để truy vấn bảng users"
- Chỉ định như này có thể tiết kiệm token

## 6. Tổng Kết

Chúng ta đã học cách kết nối Claude Code với Supabase MCP server.

**Tóm tắt nội dung chính**:
- MCP là giao thức tiêu chuẩn kết nối AI với các hệ thống bên ngoài
- Supabase cung cấp MCP server chính thức
- Thêm thông tin MCP server vào file cấu hình
- Các thao tác cơ sở dữ liệu có thể được thực hiện bằng ngôn ngữ tự nhiên
- Sử dụng chế độ read_only để an toàn

**Bước tiếp theo**:
- Thử thêm các MCP server khác (GitHub, Notion, v.v.)
- Tạo workflow phức tạp bằng cách kết hợp nhiều MCP server
- Phát triển MCP server tùy chỉnh phù hợp với dự án của bạn

Việc sử dụng tốt MCP server cải thiện đáng kể năng suất của Claude Code.
Bạn có thể tích hợp với nhiều công cụ bên ngoài khác ngoài chỉ thao tác cơ sở dữ liệu.
Điều này làm cho workflow phát triển thuận tiện hơn nhiều.