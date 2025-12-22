---
title: "Panduan Lengkap Claude Code + Supabase MCP Server: Dari Instalasi hingga Pemanfaatan untuk Pemula"
date: 2025-12-22T07:30:20+09:00
lastmod: 2025-12-22T07:45:22+09:00
draft: false
description: "Pelajari cara menghubungkan Claude Code dengan Supabase sebagai MCP server untuk mengelola database menggunakan bahasa alami dari perspektif pemula. Penjelasan langkah demi langkah dari instalasi hingga penggunaan praktis dan pertimbangan keamanan."
tags: ["Claude Code", "Supabase", "MCP", "Model Context Protocol", "데이터베이스", "AI 개발도구", "자연어 쿼리", "개발 생산성"]
categories: ["DevOps"]
image: "https://urinfo24.com/cdn-cgi/image/width=1200,format=auto,quality=85/https://images.urinfo24.com/featured/claude-code-supabase-mcp-setup-featured.jpg"
lightgallery: true
---

<!--
Image Prompt: /Users/freein/Work/blog/images/image-prompt/claude-code-supabase-mcp-setup-prompt.txt
Featured Image: https://images.urinfo24.com/featured/claude-code-supabase-mcp-setup-featured.jpg
-->

Ketika menggunakan Claude Code, ada kalanya Anda ingin mengakses data eksternal.
Operasi database, khususnya, bisa merepotkan karena Anda perlu membuka dashboard dan menulis SQL setiap kali.
Dalam kasus seperti ini, menggunakan server MCP memungkinkan Anda menangani database menggunakan bahasa alami di Claude Code.

Artikel ini membahas cara menghubungkan Claude Code dengan Supabase sebagai server MCP dari perspektif pemula.
Mari kita lanjutkan langkah demi langkah dari instalasi hingga penggunaan praktis.

## 1. Apa itu MCP

### 1.1 Konsep MCP

MCP (Model Context Protocol) adalah protokol standar untuk model AI berinteraksi dengan alat dan data eksternal.
Sederhananya, bayangkan ini sebagai jembatan yang menghubungkan AI dengan sistem eksternal.

Sebelumnya, jika AI ingin mengakses data eksternal, Anda harus membuat API khusus setiap kali.
Ini mengakibatkan biaya pengembangan yang tinggi dan pemeliharaan yang sulit.
MCP adalah pendekatan standar yang dibuat oleh Anthropic untuk menyelesaikan masalah-masalah ini.

### 1.2 Mengapa Dibutuhkan

Claude Code unggul dalam menulis kode tetapi tidak memiliki cara untuk mengakses data eksternal.
Untuk query database, akses sistem file, pemanggilan API, dll., Anda harus melakukan semuanya secara manual.

Menggunakan server MCP memungkinkan Anda melakukan tugas-tugas ini dengan bahasa alami.
Misalnya, jika Anda meminta "Tampilkan 10 pengguna yang paling baru terdaftar dari tabel users," Claude secara otomatis menulis dan menjalankan SQL.
Ini secara signifikan meningkatkan produktivitas pengembangan.

## 2. Panduan Instalasi Supabase MCP Server

### 2.1 Prasyarat

Pertama, mari kita periksa apa yang dibutuhkan.

**Kebutuhan penting**:
- Node.js (v16 atau lebih tinggi)
- Claude Code terinstal
- Akun Supabase

Mari periksa versi Node.js.

```bash
node --version
```

v16 atau lebih tinggi sudah cukup.

### 2.2 Setup Proyek Supabase

Login ke dashboard Supabase (https://supabase.com).
Buat proyek baru atau gunakan yang sudah ada.

Periksa informasi berikut dalam pengaturan proyek:
- Project URL (misalnya, `https://xxxxx.supabase.co`)
- API Keys → kunci publik `anon`

Informasi ini akan digunakan nanti dalam konfigurasi server MCP.

**Penting**: Kunci `service_role` memiliki izin penuh, jadi gunakan dengan hati-hati.
Gunakan hanya di lingkungan pengembangan dan jangan pernah upload ke repositori publik.

### 2.3 Menghasilkan URL Supabase MCP Server

Supabase menyediakan server MCP resmi.
Anda dapat menghasilkan URL MCP khusus di tab 'Connect' → 'MCP' di dashboard.

Format URL adalah sebagai berikut:

```
https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=true
```

**Penjelasan parameter query**:
- `project_ref`: Batasi ke proyek tertentu (disarankan)
- `read_only`: Aktifkan mode read-only (disarankan)

Mode read-only mencegah modifikasi data yang tidak disengaja.
Aman untuk mengaktifkan opsi ini selama pengembangan awal.

### 2.4 Konfigurasi Claude Code

Sekarang mari konfigurasi server MCP di Claude Code.

#### Konfigurasi macOS

Path file konfigurasi adalah sebagai berikut:

```
~/Library/Application Support/Claude/claude_desktop_config.json
```

Buat file jika belum ada.

```bash
mkdir -p ~/Library/Application\ Support/Claude
touch ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

#### Konfigurasi Windows

Di Windows, gunakan path berikut:

```
%APPDATA%\Claude\claude_desktop_config.json
```

Masukkan `%APPDATA%\Claude` di address bar Explorer.

## 3. Verifikasi Koneksi

### 3.1 Menulis File Konfigurasi

Buka file `claude_desktop_config.json` dan tambahkan konten berikut.

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

**Penjelasan parameter**:
- `command`: Gunakan `npx` (eksekusi paket npm langsung)
- `args`: Paket server MCP dan informasi autentikasi

**Atau gunakan hosted MCP server**:

```json
{
  "mcpServers": {
    "supabase": {
      "url": "https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=true"
    }
  }
}
```

Pendekatan hosting lebih sederhana.
Ini secara otomatis menangani autentikasi OAuth 2.1.

### 3.2 Tes Koneksi

Restart Claude Code.
Klik ikon Tools di menu untuk melihat daftar server MCP yang terhubung.

Jika Anda melihat server "supabase", berarti berhasil.

Mari lakukan tes sederhana.

```
Ke Claude: "Berapa anon key Supabase?"
```

Claude menquery informasi proyek dan memberitahu Anda.
Jika ini bekerja, server MCP sudah terhubung dengan benar.

## 4. Contoh Penggunaan Praktis

Sekarang mari kita benar-benar melakukan operasi database.

### 4.1 Query Tabel

Operasi paling dasar adalah query tabel.

```
Ke Claude: "Tampilkan semua data dari tabel users"
```

Claude secara otomatis menulis dan menjalankan query SELECT.
Ia mengatur hasil dalam tabel yang diformat dengan rapi.

**Permintaan yang lebih spesifik juga dimungkinkan**:

```
"Tampilkan hanya users dengan email Gmail dari tabel users"
```

```
"Beritahu berapa banyak users yang mendaftar dalam 7 hari terakhir"
```

Ketika Anda meminta dalam bahasa alami, Claude secara otomatis menghasilkan SQL yang sesuai.

### 4.2 Penyisipan Data

Penyisipan data juga dimungkinkan ketika mode read_only dinonaktifkan.

Pertama, ubah `read_only=false` di file konfigurasi.

```json
{
  "mcpServers": {
    "supabase": {
      "url": "https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=false"
    }
  }
}
```

Setelah restart Claude Code, buat permintaan seperti ini.

```
"Tambahkan user baru ke tabel users. 
Nama harus 'John', email harus 'john@example.com'"
```

Claude menghasilkan query INSERT dan meminta eksekusi.
Ketika user menyetujui, data ditambahkan.

### 4.3 Pembuatan Tabel

Anda juga bisa membuat tabel baru.

```
"Buat tabel comments. 
Kolom harus id, user_id, content, created_at"
```

Claude menghasilkan query CREATE TABLE.
Setelah meninjau schema dan menyetujui, tabel dibuat.

### 4.4 Query Kompleks

Query JOIN atau agregat juga bisa diminta dalam bahasa alami.

```
"Tampilkan jumlah komentar yang ditulis oleh setiap user"
```

```
"Berapa banyak users yang mendaftar bulan ini telah menulis setidaknya 1 komentar?"
```

Claude juga secara otomatis menulis SQL yang kompleks.
Ini membuat operasi database menjadi mungkin bahkan tanpa pengetahuan SQL yang sempurna.

## 5. Keamanan dan Tips

### 5.1 Pertimbangan Keamanan

Keamanan harus dipertimbangkan ketika menggunakan server MCP.

**Larang koneksi data produksi**:
- Gunakan MCP hanya di lingkungan pengembangan/test
- Jangan pernah terhubung ke database layanan aktual
- AI mungkin secara tidak sengaja menghapus data penting

**Manfaatkan mode read-only**:
- Set read_only=true secara default
- Nonaktifkan sementara hanya ketika operasi tulis diperlukan
- Aktifkan kembali setelah menyelesaikan pekerjaan

**Pembatasan proyek**:
- Batasi akses hanya ke proyek tertentu menggunakan parameter project_ref
- Jangan berikan izin akses ke multiple proyek

**Manajemen API key**:
- Jangan letakkan API key langsung di file konfigurasi
- Mengelola dengan environment variables lebih aman
- Jangan pernah upload ke repositori publik

### 5.2 Tips Penggunaan Efektif

**Buat permintaan spesifik**:
- "Tampilkan data" ❌
- "Tampilkan email dan tanggal registrasi dari 10 users terbaru dari tabel users" ✅

**Lanjutkan langkah demi langkah**:
- Jangan lakukan operasi kompleks sekaligus
- Query dulu untuk cek, baru kemudian modifikasi

**Review query**:
- Selalu periksa SQL yang dihasilkan Claude
- Minta modifikasi jika ada bagian yang mencurigakan

**Spesifikasi tools**:
- "Gunakan tool Supabase MCP untuk query tabel users"
- Menspesifikasikan seperti ini bisa menghemat token

## 6. Ringkasan

Kita telah mempelajari cara menghubungkan Claude Code dengan Supabase MCP server.

**Ringkasan konten utama**:
- MCP adalah protokol standar yang menghubungkan AI dengan sistem eksternal
- Supabase menyediakan server MCP resmi
- Tambahkan informasi server MCP ke file konfigurasi
- Operasi database dapat dilakukan menggunakan bahasa alami
- Gunakan mode read_only untuk keamanan

**Langkah selanjutnya**:
- Coba tambahkan server MCP lain (GitHub, Notion, dll.)
- Buat workflow kompleks dengan menggabungkan multiple server MCP
- Kembangkan server MCP khusus yang cocok untuk proyek Anda

Pemanfaatan server MCP yang baik secara signifikan meningkatkan produktivitas Claude Code.
Anda dapat berintegrasi dengan berbagai alat eksternal selain operasi database saja.
Ini membuat workflow pengembangan jauh lebih nyaman.