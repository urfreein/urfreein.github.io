---
title: "คู่มือ Vultr Firewall ฉบับสมบูรณ์: การตั้งค่าความปลอดภัยเซิร์ฟเวอร์คลาวด์"
date: 2025-12-16T16:00:00+09:00
lastmod: 2025-12-16T16:00:00+09:00
draft: false
description: "คู่มือสมบูรณ์สำหรับการรักษาความปลอดภัยเซิร์ฟเวอร์คลาวด์โดยใช้ไฟร์วอลล์แบบเว็บของ Vultr ตั้งแต่การสร้าง Firewall Groups จนถึงการใช้งานจริง"
tags: ["vultr", "firewall", "방화벽", "서버보안", "vps", "클라우드보안", "인프라"]
categories: ["클라우드"]
image: "https://images.urinfo24.com/featured/vultr-firewall-setup-guide-featured.jpg"
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

## 1. Vultr Firewall คืออะไร?

Vultr Firewall เป็นบริการไฟร์วอลล์แบบเว็บ
มันกรองแพ็กเก็ตก่อนที่ทราฟฟิกจะมาถึงอินสแตนซ์คลาวด์ของคุณ

### 1.1 ทำไมคุณถึงต้องการมัน?

ความปลอดภัยของเซิร์ฟเวอร์ต้องการการป้องกันหลายชั้น
ไฟร์วอลล์โฮสต์ (UFW, firewalld) เพียงอย่างเดียวไม่เพียงพอ

Vultr Firewall ทำงานที่ระดับเครือข่าย
ดังนั้น ทราฟฟิกที่เป็นอันตรายจะถูกบล็อกก่อนถึงเซิร์ฟเวอร์ของคุณ

### 1.2 ความแตกต่างจากไฟร์วอลล์โฮสต์

**ไฟร์วอลล์โฮสต์ (UFW, firewalld):**
- ทำงานภายในระบบปฏิบัติการของเซิร์ฟเวอร์
- กรองทราฟฟิกหลังจากมาถึงเซิร์ฟเวอร์
- ใช้ทรัพยากร CPU/หน่วยความจำ

**Vultr Firewall:**
- ทำงานที่ระดับเครือข่ายของ Vultr
- บล็อกทราฟฟิกก่อนถึงเซิร์ฟเวอร์
- ไม่มีผลกระทบต่อทรัพยากรเซิร์ฟเวอร์

ดังนั้น การใช้ทั้งสองร่วมกันจึงเป็นวิธีที่ปลอดภัยที่สุด

### 1.3 แนวคิดของ Firewall Group

Vultr Firewall จัดการเป็นกลุ่ม
คุณเพิ่มกฎหลายข้อลงใน Firewall Group หนึ่งกลุ่ม
จากนั้นคุณสามารถนำกลุ่มนี้ไปใช้กับหลายอินสแตนซ์

ตัวอย่างเช่น:
- กลุ่มเว็บเซิร์ฟเวอร์: อนุญาต HTTP/HTTPS
- กลุ่มเซิร์ฟเวอร์ DB: อนุญาตพอร์ต DB เฉพาะจาก IP ที่ระบุ
- กลุ่มเซิร์ฟเวอร์พัฒนา: อนุญาตเฉพาะ SSH


## 2. การสร้าง Firewall Group

### 2.1 สร้างผ่านพอร์ทัล

เข้าสู่ระบบ Vultr Customer Portal

1. ไปที่ **Products → Network → Firewall**
2. คลิกปุ่ม **Add Firewall**
3. ใส่ชื่อกลุ่มในช่อง **Description**
4. คลิกปุ่ม **Add Firewall Group**

กลุ่มถูกสร้างแล้ว
แต่ยังเป็นกลุ่มว่างที่ไม่มีกฎ

### 2.2 สร้างผ่าน API

การใช้ API ช่วยให้อัตโนมัติได้

```bash
curl "https://api.vultr.com/v2/firewalls" \
  -X POST \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "description": "web-server-firewall"
  }'
```

คุณจะได้รับ Firewall Group ID ในการตอบกลับ
จำ ID นี้ไว้

### 2.3 จัดการด้วย Terraform

หากคุณจัดการโครงสร้างพื้นฐานเป็นโค้ด ให้ใช้ Terraform

```hcl
resource "vultr_firewall_group" "web" {
  description = "Web Server Firewall"
}
```

การจัดการด้วยโค้ดช่วยให้ควบคุมเวอร์ชันได้
สะดวกสำหรับการทำงานร่วมกันในทีมด้วย

## 3. การกำหนดค่ากฎไฟร์วอลล์

### 3.1 เพิ่มกฎพื้นฐาน

คลิก Firewall Group เพื่อเข้าสู่หน้าจัดการกฎ

**เพิ่มกฎ IPv4:**
- Protocol: TCP
- Port: 80
- Source: Anywhere (0.0.0.0/0)

นี่จะอนุญาตการเข้าถึง HTTP จากทุกที่

### 3.2 จำกัดการเข้าถึง SSH

SSH ควรเข้าถึงได้เฉพาะจาก IP ที่ระบุเท่านั้น

**กฎ IPv4:**
- Protocol: TCP
- Port: 22
- Source: 123.45.67.89 (IP ของคุณ)

ตอนนี้การเข้าถึง SSH เป็นไปได้เฉพาะจาก IP ของคุณเท่านั้น
IP อื่น ๆ ถูกบล็อก

### 3.3 เปิดหลายพอร์ตพร้อมกัน

เว็บเซิร์ฟเวอร์ต้องเปิดทั้ง HTTP และ HTTPS

**กฎ 1 - HTTP:**
```
Protocol: TCP
Port: 80
Source: 0.0.0.0/0
```

**กฎ 2 - HTTPS:**
```
Protocol: TCP
Port: 443
Source: 0.0.0.0/0
```

### 3.4 เพิ่มกฎผ่าน API

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

มีประโยชน์ในสคริปต์อัตโนมัติ

### 3.5 กำหนดกฎใน Terraform

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

## 4. เชื่อมต่อกับอินสแตนซ์

### 4.1 เชื่อมต่อผ่านพอร์ทัล

เมื่อคุณสร้างกฎแล้ว นำไปใช้กับอินสแตนซ์

1. ไปที่ **Products → Compute**
2. คลิกอินสแตนซ์เป้าหมาย
3. ไปที่ **Settings → Firewall**
4. เลือกกลุ่มจากเมนูแบบเลื่อนลง Firewall
5. คลิกปุ่ม **Update Firewall Group**

นำไปใช้ทันที

### 4.2 นำไปใช้กับหลายอินสแตนซ์

จะเป็นอย่างไรถ้าคุณมีหลายเซิร์ฟเวอร์ที่มีบทบาทเดียวกัน?
นำ Firewall Group เดียวกันไปใช้กับแต่ละอินสแตนซ์

ตัวอย่างเช่น:
- เว็บเซิร์ฟเวอร์ 3 เครื่อง
- ทั้งหมดต้องการกฎไฟร์วอลล์เดียวกัน

ดังนั้น นำ Firewall Group หนึ่งกลุ่มไปใช้กับทั้ง 3 เครื่อง
การเปลี่ยนแปลงกฎจะสะท้อนทันทีกับทั้ง 3 เครื่อง

### 4.3 เชื่อมต่อผ่าน API

```bash
curl "https://api.vultr.com/v2/instances/{instance-id}" \
  -X PATCH \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "firewall_group_id": "{firewall-id}"
  }'
```

ใช้ในสคริปต์การปรับใช้อัตโนมัติ

### 4.4 จัดการด้วย Terraform

```hcl
resource "vultr_instance" "web" {
  region             = "sea"
  plan               = "vc2-1c-1gb"
  os_id              = 1743  # Ubuntu 22.04
  label              = "web-server-01"
  firewall_group_id  = vultr_firewall_group.web.id
}
```

นำไฟร์วอลล์ไปใช้พร้อมกับการสร้างอินสแตนซ์

## 5. ตัวอย่างการใช้งานจริง

### 5.1 ปกป้องเว็บเซิร์ฟเวอร์

เว็บเซิร์ฟเวอร์ต้องการเฉพาะ HTTP, HTTPS และ SSH เท่านั้น

```hcl
resource "vultr_firewall_group" "web" {
  description = "Web Server Firewall"
}

resource "vultr_firewall_rule" "web_ssh" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  port              = "22"
  ip_type           = "v4"
  subnet            = "123.45.67.89"  # เฉพาะ IP ของคุณ
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

พอร์ตอื่น ๆ ทั้งหมดจะถูกบล็อกโดยอัตโนมัติ

### 5.2 เซิร์ฟเวอร์ฐานข้อมูล

เซิร์ฟเวอร์ DB ควรเข้าถึงได้เฉพาะจากเว็บเซิร์ฟเวอร์เท่านั้น

```hcl
resource "vultr_firewall_rule" "db_from_web" {
  firewall_group_id = vultr_firewall_group.db.id
  protocol          = "tcp"
  port              = "5432"  # PostgreSQL
  ip_type           = "v4"
  subnet            = "192.168.1.10"  # IP ส่วนตัวของเว็บเซิร์ฟเวอร์
  subnet_size       = 32
}
```

ไม่สามารถเข้าถึง DB ผ่าน IP สาธารณะได้
เป็นไปได้เฉพาะผ่านเครือข่ายส่วนตัวเท่านั้น

### 5.3 การผสานรวมกับ Load Balancer

หากใช้ Load Balancer?
เว็บเซิร์ฟเวอร์ควรรับทราฟฟิกเฉพาะจาก Load Balancer เท่านั้น

**การตั้งค่ากฎ:**
- Protocol: TCP
- Port: 80
- Source: Load Balancer (ใส่ ID ของ LB)

นี่จะบล็อกการเข้าถึงโดยตรงที่ข้าม Load Balancer

## 6. แนวปฏิบัติที่ดีที่สุดด้านความปลอดภัย

### 6.1 นโยบายเริ่มต้น: ปฏิเสธทั้งหมด

นโยบายเริ่มต้นของ Vultr Firewall คือ "บล็อกทั้งหมด"
ดังนั้น เฉพาะทราฟฟิกที่อนุญาตอย่างชัดเจนเท่านั้นที่ผ่านได้

นี่คือวิธีที่ถูกต้อง
เปิดเฉพาะสิ่งที่จำเป็น

### 6.2 หลักการของสิทธิ์น้อยที่สุด

อย่าเปิด SSH ให้กับ IP ทั้งหมด
จะกลายเป็นเป้าหมายของการโจมตีแบบ brute force

ดังนั้น อนุญาตเฉพาะ IP ที่ระบุ:
- IP สำนักงาน
- IP VPN
- IP บ้าน

### 6.3 การป้องกันหลายชั้น

Vultr Firewall เพียงอย่างเดียวเพียงพอหรือไม่?
ไม่ ใช้ไฟร์วอลล์โฮสต์ร่วมกันด้วย

**ชั้นการป้องกัน:**
1. Vultr Firewall (ระดับเครือข่าย)
2. ไฟร์วอลล์โฮสต์ (ระดับ OS)
3. ไฟร์วอลล์แอปพลิเคชัน (ระดับแอป)

ดังนั้น กำหนดค่า UFW หรือ firewalld ด้วย

### 6.4 ทดสอบก่อนใช้งานจริง

จะเป็นอย่างไรถ้าคุณกำหนดค่าไฟร์วอลล์ผิด?
บริการจะหยุดชะงัก

ดังนั้น ต้อง:
1. ทดสอบในสภาพแวดล้อมพัฒนา
2. ตรวจสอบในสภาพแวดล้อม staging
3. นำไปใช้ในโปรดักชัน

### 6.5 ตรวจสอบกฎเป็นประจำ

ไม่ใช่การตั้งค่าครั้งเดียว
ตรวจสอบกฎเป็นประจำ:

- ลบกฎที่ไม่จำเป็น
- ลบ IP ที่ไม่ได้ใช้แล้ว
- สะท้อนข้อกำหนดความปลอดภัยใหม่

## 7. การแก้ไขปัญหา

### 7.1 เมื่อการเชื่อมต่อล้มเหลว

ไม่สามารถเข้าถึง SSH หรือเว็บ?

**รายการตรวจสอบ:**
1. Firewall Group เชื่อมต่อกับอินสแตนซ์หรือไม่?
2. มีกฎที่อนุญาตพอร์ตหรือไม่?
3. IP ต้นทางถูกต้องหรือไม่?
4. ตรวจสอบไฟร์วอลล์โฮสต์ด้วย

### 7.2 เวลาการนำกฎไปใช้

การเปลี่ยนแปลง Firewall Group จะนำไปใช้ทันที
แต่การแพร่กระจายเครือข่ายอาจใช้เวลาสองสามวินาที

ลองทดสอบการเชื่อมต่อหลังจาก 10-20 วินาที

### 7.3 ตรวจสอบล็อก

Vultr Firewall เองไม่ให้ล็อก
ดังนั้น ตรวจสอบล็อกไฟร์วอลล์โฮสต์

**ล็อก UFW:**
```bash
sudo tail -f /var/log/ufw.log
```

**ล็อก Firewalld:**
```bash
sudo journalctl -u firewalld -f
```

### 7.4 ลำดับความสำคัญของกฎ

Vultr Firewall ไม่มีลำดับกฎ
กฎทั้งหมดทำงานด้วยเงื่อนไข OR

นั่นคือ หากกฎใดกฎหนึ่งตรงกัน จะได้รับอนุญาต

## 8. CLI และระบบอัตโนมัติ

### 8.1 ติดตั้ง Vultr CLI

```bash
# macOS
brew install vultr/vultr-cli/vultr-cli

# Linux
curl -L https://github.com/vultr/vultr-cli/releases/latest/download/vultr-cli-linux-amd64.tar.gz | tar xz
sudo mv vultr-cli /usr/local/bin/
```

กำหนดค่า API Key:
```bash
export VULTR_API_KEY="your-api-key"
```

### 8.2 จัดการ Firewall Groups

**แสดงรายการกลุ่ม:**
```bash
vultr-cli firewall group list
```

**สร้างกลุ่ม:**
```bash
vultr-cli firewall group create --description "Web Server"
```

**เพิ่มกฎ:**
```bash
vultr-cli firewall rule create \
  --firewall-group-id <id> \
  --protocol tcp \
  --port 80 \
  --ip-type v4 \
  --subnet 0.0.0.0 \
  --subnet-size 0
```

### 8.3 ระบบอัตโนมัติในการปรับใช้

นำไฟร์วอลล์ไปใช้โดยอัตโนมัติเมื่อปรับใช้อินสแตนซ์ใหม่:

```bash
#!/bin/bash

# สร้างอินสแตนซ์
INSTANCE_ID=$(vultr-cli instance create \
  --region sea \
  --plan vc2-1c-1gb \
  --os 1743 \
  --label web-server \
  --output json | jq -r '.id')

# นำไฟร์วอลล์ไปใช้
vultr-cli instance update-firewall-group \
  --instance-id $INSTANCE_ID \
  --firewall-group-id $FIREWALL_ID

echo "Instance $INSTANCE_ID deployed with firewall"
```

## 9. ต้นทุนและข้อจำกัด

### 9.1 ต้นทุน

Vultr Firewall **ฟรีโดยสมบูรณ์**
ไม่มีค่าใช้จ่ายเพิ่มเติมเลย

ดังนั้น แนะนำสำหรับอินสแตนซ์ทั้งหมด

### 9.2 ข้อจำกัด

**Firewall Groups:**
- สูงสุด 50 กลุ่มต่อบัญชี

**กฎ:**
- สูงสุด 50 กฎต่อกลุ่ม

เพียงพอสำหรับกรณีส่วนใหญ่
ติดต่อฝ่ายสนับสนุนหากต้องการเพิ่ม

### 9.3 ความแตกต่างจาก Load Balancer Firewall

Vultr Load Balancer มีไฟร์วอลล์แยกต่างหาก
ทั้งสองแตกต่างกัน:

**Vultr Firewall:**
- ปกป้องอินสแตนซ์
- การกรองระดับเครือข่าย

**Load Balancer Firewall:**
- ปกป้อง Load Balancer
- กรองทราฟฟิกที่เข้าสู่ LB

ดังนั้น กำหนดค่าทั้งสองเมื่อใช้ Load Balancer

## 10. สรุป

### 10.1 ข้อดีของ Vultr Firewall

- ฟรี
- การปกป้องระดับเครือข่าย
- ใช้งานง่ายกับหลายอินสแตนซ์
- รองรับ API/CLI/Terraform
- ไม่ใช้ทรัพยากรเซิร์ฟเวอร์

### 10.2 เมื่อใดควรใช้?

**ต้องใช้:**
- เซิร์ฟเวอร์โปรดักชัน
- บริการสาธารณะ
- การประมวลผลข้อมูลที่ละเอียดอ่อน

**ตัวเลือก:**
- สภาพแวดล้อมพัฒนา/ทดสอบ
- เซิร์ฟเวอร์ที่ใช้เฉพาะเครือข่ายส่วนตัว

แต่ใช้กับอินสแตนซ์ทั้งหมดถ้าเป็นไปได้

### 10.3 การเพิ่มประสิทธิภาพความปลอดภัยเพิ่มเติม

นอกจาก Vultr Firewall:
- ติดตั้ง Fail2ban (บล็อก brute force)
- ใช้การยืนยันตัวตนด้วยคีย์ SSH
- อัปเดตความปลอดภัยเป็นประจำ
- เปิดใช้งานการป้องกัน DDoS

ต้องการหลายชั้นของความปลอดภัย

### 10.4 เอกสารอ้างอิง

- [เอกสาร Vultr Firewall อย่างเป็นทางการ](https://docs.vultr.com/products/network/firewall)
- [เอกสาร Vultr API](https://www.vultr.com/api/)
- [Vultr CLI GitHub](https://github.com/vultr/vultr-cli)
- [Terraform Vultr Provider](https://registry.terraform.io/providers/vultr/vultr/latest/docs)

การใช้ Vultr Firewall ปกป้องเซิร์ฟเวอร์คลาวด์อย่างปลอดภัย
ฟรีและใช้งานง่าย
ดังนั้น ตั้งค่าเดี๋ยวนี้เลย
