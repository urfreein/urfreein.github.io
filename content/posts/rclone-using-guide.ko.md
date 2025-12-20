---
title: "윈도우 10에서 rclone CLI로 구글 드라이브 사용 가이드"
date: 2025-11-07T11:44:00+09:00
lastmod: 2025-11-07T11:44:00+09:00
draft: false
description: 저사양 VM 환경에서도 웹 인터페이스 없이 빠르고 간편하게 rclone을 사용하여 구글 드라이브 파일을 관리하는 방법을 다운로드부터 업로드/다운로드까지 단계별로 안내합니다.
tags: ["rclone", "Windows10", "GoogleDrive", "CLI", "Vultr", "CloudStorage", "DataTransfer"]
categories: ["Tech"]
image: "https://urinfo24.com/cdn-cgi/image/width=800,format=auto,quality=75/https://images.urinfo24.com/featured/rclone-using-guide-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A modern, professional tech illustration for "윈도우 10에서 rclone CLI로 구글 드라이브 사용 가이드".
- Style: Clean, professional, flat design with technical elements
- Subject: Visual representation of rclone using guide
- Elements: Technical icons, symbols, code snippets, terminal windows, relevant tech logos
- Colors: Blue and gray tech tones, white background, accent colors for highlights
- Mood: Professional, modern, educational, technical
- Composition: Centered layout with balanced elements, clean and organized

Technical keywords: rclone,  "Windows10,  "GoogleDrive,  "CLI,  "Vultr

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/rclone-using-guide-featured.jpg

NOTE: Hugo will serve this from /images/rclone-using-guide-featured.jpg
-->

클라우드 스토리지 서비스, 특히 구글 드라이브는 편리하지만, 저사양의 가상 머신(VM) 환경, 예를 들어 Vultr VM에서 웹 브라우저를 통해 파일을 관리하려고 하면 웹페이지 로딩으로 인해 비효율적인 경우가 많습니다.

이러한 상황에서 **rclone**은 구세주와 같습니다. rclone은 50가지 이상의 클라우드 스토리지 서비스에 접근할 수 있게 해주는 명령줄 인터페이스(CLI) 프로그램으로, 웹 인터페이스 없이도 빠르고 간편하게 파일을 관리할 수 있도록 돕습니다. 본 가이드에서는 Windows 10 환경을 기준으로 rclone을 처음 설치하고 구글 드라이브를 설정한 후 파일을 전송하는 모든 과정을 안내합니다.

-----

## **1. rclone 다운로드 및 설치 (Windows 10 기준)**

rclone을 사용하기 위한 첫 번째 단계는 공식 배포판을 다운로드하고 시스템 환경 변수에 등록하는 것입니다.

### **rclone 최신 버전 다운로드**

1.  **공식 사이트 접속:** [rclone 공식 다운로드 페이지](https://rclone.org/downloads/)로 이동합니다.
2.  **Windows 버전 다운로드:** 64-bit 또는 32-bit Windows 버전을 다운로드합니다.

### **시스템 경로(Path) 설정**

다운로드한 rclone을 어느 위치에서든 명령어 하나로 실행하기 위해서는 압축을 풀고 실행 파일 경로를 시스템 환경 변수에 추가해야 합니다.

1.  **압축 해제:** 다운로드한 ZIP 파일의 압축을 풀고, 예를 들어 `C:\rclone`과 같이 관리하기 쉬운 경로에 폴더 전체를 옮깁니다. `rclone.exe` 파일이 이 폴더 안에 있어야 합니다.
2.  **환경 변수 추가:**
      * Windows 검색 창에 "환경 변수"를 검색하여 \*\*'시스템 환경 변수 편집'\*\*을 엽니다.
      * **'환경 변수'** 버튼을 클릭합니다.
      * **'시스템 변수'** 목록에서 `Path`를 선택하고 \*\*'편집'\*\*을 누릅니다.
      * \*\*'새로 만들기'\*\*를 클릭하여 rclone 실행 파일이 있는 폴더 경로(예: `C:\rclone`)를 추가하고 확인을 눌러 저장합니다.
3.  **설치 확인:** 명령 프롬프트(CMD)나 PowerShell을 열고 다음 명령어를 입력하여 rclone이 정상적으로 설치되었는지 확인합니다.

```powershell
rclone version
```

-----

## **2. rclone 설정 (Config) – 구글 드라이브 연결**

rclone을 사용하여 구글 드라이브에 접근하려면, `rclone config` 명령어를 통해 구글 드라이브 API 인증 정보를 설정해야 합니다.

### **설정 프로세스 시작**

명령 프롬프트에서 다음 명령어를 입력하여 설정 마법사를 시작합니다.

```powershell
rclone config
```

### **새로운 리모트 생성 및 유형 선택**

1.  **새 리모트 생성:** `n` (New remote)를 입력하고 Enter를 누릅니다.
2.  **리모트 이름 지정:** 원격 연결에 사용할 이름을 지정합니다. 이 이름은 나중에 명령어에서 구글 드라이브를 지칭할 때 사용되므로, 예를 들어 `gdrive`와 같이 간단하게 설정하는 것이 좋습니다.
3.  **스토리지 유형 선택:** 클라우드 서비스 목록이 나타나면, 구글 드라이브에 해당하는 번호(예: `22` 또는 최신 번호)를 입력하고 Enter를 누릅니다.

### **구글 드라이브 인증 (OAuth)**

설정 과정에서 가장 중요한 단계입니다. rclone은 웹 브라우저를 통해 구글 계정에 접근 권한을 요청합니다.

1.  **Client ID 및 Secret 설정:** 기본적으로 rclone의 공용 ID/Secret을 사용해도 무방합니다. 프롬프트에서 아무것도 입력하지 않고 Enter를 누릅니다.
2.  **Scope 설정:** 접근 범위(`scope`)를 묻는 질문이 나오면, 보통 `1` (Full access)을 선택합니다.
3.  **Root Folder ID:** 특정 폴더를 루트로 사용하고 싶지 않다면, 비워두고 Enter를 누릅니다.
4.  **고급 설정:** `y/n` 질문에 `n`을 입력하고 기본 설정을 유지합니다.
5.  **자동 구성:** `y`를 입력하여 rclone이 로컬 웹 브라우저를 열어 인증을 시도하게 합니다.
      * **인증 창:** 잠시 후 기본 웹 브라우저가 열리고 구글 로그인 페이지가 나타납니다. 연결할 구글 계정을 선택하고 rclone에 대한 접근 권한을 허용합니다.
      * **토큰 수신:** 인증이 완료되면 rclone CLI 창으로 돌아와 토큰을 성공적으로 받았다는 메시지가 표시됩니다.
6.  **Remote 설정 완료:** 이어서 Team Drive 사용 여부 등을 묻는 질문이 나오는데, 사용자 환경에 맞게 선택하고 최종적으로 `y`를 입력하여 설정을 저장합니다.


```bash
# rclone config 출력 예시 (설정이 완료된 후)
Current remotes:

Name                 Type
====                 ====
gdrive               drive

q/n/d/r/c/s/p/m/t/o> q
```

-----

## **3. rclone을 사용한 파일 업로드 및 다운로드**

설정이 완료되면, 웹 브라우저를 열 필요 없이 명령 한 줄로 파일을 전송할 수 있습니다. rclone의 핵심 명령어는 `copy`와 `sync`입니다.

### **기본 명령어 구조**

rclone 명령어는 **`rclone [명령어] [소스 경로] [목표 경로]`** 구조를 따릅니다.

  * **로컬 경로:** 일반적인 Windows 경로를 사용합니다. (예: `C:\data\local_file.txt`)
  * **리모트 경로:** 설정 시 지정한 리모트 이름과 클라우드 내 경로를 콜론(`:`)으로 구분하여 사용합니다. (예: `gdrive:backup/2025_data`)

### **파일 업로드 (Local -\> Google Drive)**

로컬 PC의 파일을 구글 드라이브로 복사(업로드)합니다. `gdrive`는 Section 2에서 설정한 리모트 이름입니다.

#### **단일 파일 업로드 예시**

```powershell
# C:\Data\report.docx 파일을 구글 드라이브의 "Document" 폴더로 업로드
rclone copy "C:\Data\report.docx" gdrive:Document
```

#### **폴더 전체 업로드 예시**

`sync` 명령어는 소스와 목표를 일치시키는(동기화) 명령어이므로, 백업 시 자주 사용됩니다. **목표 경로의 파일은 소스 경로에 없는 경우 삭제될 수 있으므로 주의해야 합니다.**

```powershell
# C:\Backup 폴더의 모든 내용을 구글 드라이브의 "Archive" 폴더에 동기화
rclone sync "C:\Backup" gdrive:Archive
```

### **파일 다운로드 (Google Drive -\> Local)**

구글 드라이브의 파일을 로컬 PC로 복사(다운로드)합니다.

#### **단일 파일 다운로드 예시**

```powershell
# 구글 드라이브 "Config" 폴더의 settings.ini 파일을 C:\Temp로 다운로드
rclone copy gdrive:Config/settings.ini "C:\Temp"
```

#### **폴더 전체 다운로드 예시**

```powershell
# 구글 드라이브의 "Project" 폴더 전체를 C:\Download\Projects 폴더에 동기화
rclone sync gdrive:Project "C:\Download\Projects"
```

### **기타 유용한 명령어**

| 명령어 | 설명 | 예시 |
| :--- | :--- | :--- |
| **`ls`** | 원격 저장소의 파일 목록 확인 | `rclone ls gdrive:Document` |
| **`mkdir`** | 원격 저장소에 폴더 생성 | `rclone mkdir gdrive:NewFolder` |
| **`delete`** | 원격 저장소의 파일 삭제 | `rclone delete gdrive:Trash/old.log` |
| **`move`** | 원격 저장소 내에서 파일 이동 | `rclone move gdrive:temp/file.txt gdrive:archive/` |

-----

## **마치며**

rclone을 사용하면 저사양 Vultr VM이든, 일반 Windows PC든, Linux/macOS든, 상관없이 웹 브라우저의 제약 없이 빠른 클라우드 스토리지 이용이 가능해집니다. 특히 CLI에 익숙한 사용자에게는 매우 편리한 도구입니다.