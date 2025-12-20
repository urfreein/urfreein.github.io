---
title: "Panduan Lengkap Vultr Firewall: Pengaturan Keamanan Server Cloud"
date: 2025-12-16T16:00:00+09:00
lastmod: 2025-12-16T16:00:00+09:00
draft: false
description: "Panduan lengkap untuk mengamankan server cloud menggunakan firewall berbasis web Vultr. Dari membuat Firewall Groups hingga implementasi praktis."
tags: ["vultr", "firewall", "방화벽", "서버보안", "vps", "클라우드보안", "인프라"]
categories: ["클라우드"]
image: "https://urinfo24.com/cdn-cgi/image/width=800,format=auto,quality=75/https://images.urinfo24.com/featured/vultr-firewall-setup-guide-featured.jpg"
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

## 1. Apa Itu Vultr Firewall?

Vultr Firewall adalah layanan firewall berbasis web.
Ini memfilter paket sebelum traffic mencapai instance cloud Anda.

### 1.1 Mengapa Anda Membutuhkannya?

Keamanan server memerlukan pertahanan berlapis.
Firewall host (UFW, firewalld) saja tidak cukup.

Vultr Firewall beroperasi di tingkat jaringan.
Oleh karena itu, traffic berbahaya diblokir sebelum mencapai server Anda.

### 1.2 Perbedaan Dengan Firewall Host

**Firewall Host (UFW, firewalld):**
- Beroperasi di dalam sistem operasi server
- Memfilter traffic setelah mencapai server
- Menggunakan resource CPU/memori

**Vultr Firewall:**
- Beroperasi di tingkat jaringan Vultr
- Memblokir traffic sebelum mencapai server
- Tidak berdampak pada resource server

Oleh karena itu, menggunakan keduanya bersama adalah pendekatan paling aman.

### 1.3 Konsep Firewall Group

Vultr Firewall dikelola dalam grup.
Anda menambahkan beberapa aturan ke satu Firewall Group.
Kemudian Anda dapat menerapkan grup ini ke beberapa instance.

Misalnya:
- Grup web server: Izinkan HTTP/HTTPS
- Grup DB server: Izinkan port DB hanya dari IP tertentu
- Grup development server: Hanya izinkan SSH


## 2. Membuat Firewall Group

### 2.1 Membuat Melalui Portal

Login ke Vultr Customer Portal.

1. Navigasi ke **Products → Network → Firewall**
2. Klik tombol **Add Firewall**
3. Masukkan nama grup di field **Description**
4. Klik tombol **Add Firewall Group**

Grup telah dibuat.
Tapi masih grup kosong tanpa aturan.

### 2.2 Membuat Melalui API

Menggunakan API memungkinkan otomatisasi.

```bash
curl "https://api.vultr.com/v2/firewalls" \
  -X POST \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "description": "web-server-firewall"
  }'
```

Anda akan menerima Firewall Group ID dalam respons.
Ingat ID ini.

### 2.3 Mengelola Dengan Terraform

Jika Anda mengelola infrastruktur sebagai kode, gunakan Terraform.

```hcl
resource "vultr_firewall_group" "web" {
  description = "Web Server Firewall"
}
```

Manajemen kode memungkinkan kontrol versi.
Juga nyaman untuk kolaborasi tim.

## 3. Mengkonfigurasi Aturan Firewall

### 3.1 Menambahkan Aturan Dasar

Klik Firewall Group untuk masuk ke layar manajemen aturan.

**Tambahkan Aturan IPv4:**
- Protocol: TCP
- Port: 80
- Source: Anywhere (0.0.0.0/0)

Ini memungkinkan akses HTTP dari mana saja.

### 3.2 Membatasi Akses SSH

SSH hanya boleh diakses dari IP tertentu.

**Aturan IPv4:**
- Protocol: TCP
- Port: 22
- Source: 123.45.67.89 (IP Anda)

Sekarang akses SSH hanya mungkin dari IP Anda.
IP lain diblokir.

### 3.3 Membuka Beberapa Port Sekaligus

Web server memerlukan HTTP dan HTTPS terbuka.

**Aturan 1 - HTTP:**
```
Protocol: TCP
Port: 80
Source: 0.0.0.0/0
```

**Aturan 2 - HTTPS:**
```
Protocol: TCP
Port: 443
Source: 0.0.0.0/0
```

### 3.4 Menambahkan Aturan Melalui API

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

Berguna dalam script otomatisasi.

### 3.5 Mendefinisikan Aturan Di Terraform

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

## 4. Menghubungkan Ke Instance

### 4.1 Menghubungkan Melalui Portal

Setelah Anda membuat aturan, terapkan ke instance.

1. Navigasi ke **Products → Compute**
2. Klik instance target
3. Pergi ke **Settings → Firewall**
4. Pilih grup dari dropdown Firewall
5. Klik tombol **Update Firewall Group**

Diterapkan segera.

### 4.2 Menerapkan Ke Beberapa Instance

Bagaimana jika Anda memiliki beberapa server dengan peran sama?
Terapkan Firewall Group yang sama ke setiap instance.

Misalnya:
- 3 web server
- Semua memerlukan aturan firewall yang sama

Oleh karena itu, terapkan satu Firewall Group ke ketiga-tiganya.
Perubahan aturan segera tercermin di ketiga-tiganya.

### 4.3 Menghubungkan Melalui API

```bash
curl "https://api.vultr.com/v2/instances/{instance-id}" \
  -X PATCH \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "firewall_group_id": "{firewall-id}"
  }'
```

Gunakan dalam script deployment otomatis.

### 4.4 Mengelola Dengan Terraform

```hcl
resource "vultr_instance" "web" {
  region             = "sea"
  plan               = "vc2-1c-1gb"
  os_id              = 1743  # Ubuntu 22.04
  label              = "web-server-01"
  firewall_group_id  = vultr_firewall_group.web.id
}
```

Terapkan firewall bersamaan dengan pembuatan instance.

## 5. Contoh Penggunaan Praktis

### 5.1 Melindungi Web Server

Web server hanya memerlukan HTTP, HTTPS, dan SSH terbuka.

```hcl
resource "vultr_firewall_group" "web" {
  description = "Web Server Firewall"
}

resource "vultr_firewall_rule" "web_ssh" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  port              = "22"
  ip_type           = "v4"
  subnet            = "123.45.67.89"  # Hanya IP Anda
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

Semua port lain secara otomatis diblokir.

### 5.2 Database Server

DB server hanya boleh diakses dari web server.

```hcl
resource "vultr_firewall_rule" "db_from_web" {
  firewall_group_id = vultr_firewall_group.db.id
  protocol          = "tcp"
  port              = "5432"  # PostgreSQL
  ip_type           = "v4"
  subnet            = "192.168.1.10"  # IP privat web server
  subnet_size       = 32
}
```

DB tidak dapat diakses melalui IP publik.
Hanya mungkin melalui Private Network.

### 5.3 Integrasi Dengan Load Balancer

Jika menggunakan Load Balancer?
Web server hanya boleh menerima traffic dari Load Balancer.

**Pengaturan aturan:**
- Protocol: TCP
- Port: 80
- Source: Load Balancer (masukkan ID LB)

Ini memblokir akses langsung yang melewati Load Balancer.

## 6. Praktik Terbaik Keamanan

### 6.1 Kebijakan Default: Tolak Semua

Kebijakan default Vultr Firewall adalah "blokir semua".
Oleh karena itu, hanya traffic yang diizinkan secara eksplisit yang lewat.

Ini adalah pendekatan yang benar.
Hanya buka yang diperlukan.

### 6.2 Prinsip Hak Istimewa Minimum

Jangan buka SSH ke semua IP.
Menjadi target serangan brute force.

Oleh karena itu, hanya izinkan IP tertentu:
- IP kantor
- IP VPN
- IP rumah

### 6.3 Pertahanan Berlapis

Apakah Vultr Firewall saja cukup?
Tidak. Gunakan firewall host juga.

**Lapisan pertahanan:**
1. Vultr Firewall (tingkat jaringan)
2. Firewall host (tingkat OS)
3. Firewall aplikasi (tingkat app)

Oleh karena itu, konfigurasikan UFW atau firewalld juga.

### 6.4 Tes Sebelum Production

Bagaimana jika Anda salah mengonfigurasi firewall?
Gangguan layanan.

Oleh karena itu, selalu:
1. Tes di lingkungan pengembangan
2. Verifikasi di lingkungan staging
3. Terapkan ke production

### 6.5 Tinjau Aturan Secara Berkala

Bukan pengaturan satu kali.
Tinjau aturan secara berkala:

- Hapus aturan yang tidak perlu
- Hapus IP yang tidak lagi digunakan
- Cerminkan persyaratan keamanan baru

## 7. Pemecahan Masalah

### 7.1 Ketika Koneksi Gagal

Tidak bisa mengakses SSH atau web?

**Checklist:**
1. Apakah Firewall Group terhubung ke instance?
2. Apakah ada aturan yang mengizinkan port?
3. Apakah IP sumber benar?
4. Periksa firewall host juga

### 7.2 Waktu Penerapan Aturan

Perubahan Firewall Group diterapkan segera.
Tapi propagasi jaringan mungkin memakan waktu beberapa detik.

Coba tes koneksi setelah 10-20 detik.

### 7.3 Memeriksa Log

Vultr Firewall sendiri tidak menyediakan log.
Oleh karena itu, periksa log firewall host.

**Log UFW:**
```bash
sudo tail -f /var/log/ufw.log
```

**Log Firewalld:**
```bash
sudo journalctl -u firewalld -f
```

### 7.4 Prioritas Aturan

Vultr Firewall tidak memiliki urutan aturan.
Semua aturan bekerja dengan kondisi OR.

Artinya, jika ada aturan yang cocok, diizinkan.

## 8. CLI Dan Otomatisasi

### 8.1 Menginstal Vultr CLI

```bash
# macOS
brew install vultr/vultr-cli/vultr-cli

# Linux
curl -L https://github.com/vultr/vultr-cli/releases/latest/download/vultr-cli-linux-amd64.tar.gz | tar xz
sudo mv vultr-cli /usr/local/bin/
```

Konfigurasikan API Key:
```bash
export VULTR_API_KEY="your-api-key"
```

### 8.2 Mengelola Firewall Groups

**Daftar grup:**
```bash
vultr-cli firewall group list
```

**Buat grup:**
```bash
vultr-cli firewall group create --description "Web Server"
```

**Tambah aturan:**
```bash
vultr-cli firewall rule create \
  --firewall-group-id <id> \
  --protocol tcp \
  --port 80 \
  --ip-type v4 \
  --subnet 0.0.0.0 \
  --subnet-size 0
```

### 8.3 Otomatisasi Deployment

Terapkan firewall secara otomatis saat men-deploy instance baru:

```bash
#!/bin/bash

# Buat instance
INSTANCE_ID=$(vultr-cli instance create \
  --region sea \
  --plan vc2-1c-1gb \
  --os 1743 \
  --label web-server \
  --output json | jq -r '.id')

# Terapkan firewall
vultr-cli instance update-firewall-group \
  --instance-id $INSTANCE_ID \
  --firewall-group-id $FIREWALL_ID

echo "Instance $INSTANCE_ID deployed with firewall"
```

## 9. Biaya Dan Batasan

### 9.1 Biaya

Vultr Firewall **sepenuhnya gratis**.
Tidak ada biaya tambahan sama sekali.

Oleh karena itu, direkomendasikan untuk semua instance.

### 9.2 Batasan

**Firewall Groups:**
- Maksimal 50 per akun

**Aturan:**
- Maksimal 50 aturan per grup

Cukup untuk sebagian besar kasus.
Hubungi dukungan jika memerlukan lebih banyak.

### 9.3 Perbedaan Dengan Load Balancer Firewall

Vultr Load Balancer memiliki firewall terpisah.
Keduanya berbeda:

**Vultr Firewall:**
- Melindungi instance
- Filtering tingkat jaringan

**Load Balancer Firewall:**
- Melindungi Load Balancer
- Filter traffic yang masuk ke LB

Oleh karena itu, konfigurasikan keduanya saat menggunakan Load Balancer.

## 10. Ringkasan

### 10.1 Keuntungan Vultr Firewall

- Gratis
- Perlindungan tingkat jaringan
- Mudah diterapkan ke beberapa instance
- Dukungan API/CLI/Terraform
- Tidak menggunakan resource server

### 10.2 Kapan Menggunakan?

**Harus digunakan:**
- Server production
- Layanan publik
- Pemrosesan data sensitif

**Opsional:**
- Lingkungan development/test
- Server yang hanya menggunakan Private Network

Tapi terapkan ke semua instance jika memungkinkan.

### 10.3 Peningkatan Keamanan Tambahan

Selain Vultr Firewall:
- Instal Fail2ban (blokir brute force)
- Gunakan autentikasi kunci SSH
- Update keamanan rutin
- Aktifkan Perlindungan DDoS

Diperlukan beberapa lapisan keamanan.

### 10.4 Referensi

- [Dokumentasi Resmi Vultr Firewall](https://docs.vultr.com/products/network/firewall)
- [Dokumentasi API Vultr](https://www.vultr.com/api/)
- [Vultr CLI GitHub](https://github.com/vultr/vultr-cli)
- [Terraform Vultr Provider](https://registry.terraform.io/providers/vultr/vultr/latest/docs)

Menggunakan Vultr Firewall melindungi server cloud dengan aman.
Gratis dan mudah digunakan.
Oleh karena itu, atur sekarang juga.
