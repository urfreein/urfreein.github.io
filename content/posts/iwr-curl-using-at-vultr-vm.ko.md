---
title: "curl과 iwr 스크립트 활용 가이드"
date: 2025-10-31T22:48:04+09:00
lastmod: 2025-10-31T22:48:04+09:00
draft: false
description: "저사양 VM 환경에서 구글 드라이브 대신 Private Repository의 파일을 효율적으로 다운로드하는 방법을 찾고 계신가요? 이 가이드는 Linux/macOS의 `curl`과 Windows PowerShell의 `iwr`을 사용한 자동화 스크립트 작성 방법을 상세히 알려드립니다."
tags: ["curl", "iwr", "powershell", "linux", "private-repo", "automation", "vultr-vm"]
categories: ["Tech"]
image: "https://urinfo24.com/cdn-cgi/image/width=800,format=auto,quality=75/https://images.urinfo24.com/featured/iwr-curl-using-at-vultr-vm-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A modern, professional tech illustration for "curl과 iwr 스크립트 활용 가이드".
- Style: Clean, professional, flat design with technical elements
- Subject: Visual representation of iwr curl using at vultr vm
- Elements: Technical icons, symbols, code snippets, terminal windows, relevant tech logos
- Colors: Blue and gray tech tones, white background, accent colors for highlights
- Mood: Professional, modern, educational, technical
- Composition: Centered layout with balanced elements, clean and organized

Technical keywords: curl,  "iwr,  "powershell,  "linux,  "private-repo

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/iwr-curl-using-at-vultr-vm-featured.jpg

NOTE: Hugo will serve this from /images/iwr-curl-using-at-vultr-vm-featured.jpg
-->

## 저사양 VM을 위한 효율적인 파일 전송 전략

Vultr와 같은 클라우드 서비스에서 **최소 사양의 VM(Virtual Machine)**을 운영하는 경우, 웹 브라우저를 통한 파일 다운로드(특히 용량이 크거나 구글 드라이브처럼 스크립트 로딩이 많은 페이지)는 상상 이상으로 느리고 비효율적일 수 있습니다. 웹 UI 로딩 자체가 VM 리소스를 과도하게 소모하기 때문입니다.

이러한 환경에서 가장 빠르고 안정적인 파일 전송 방법은 **Private Git Repository** 또는 자체 파일 서버에 올려둔 파일을 **터미널 명령어**를 통해 직접 다운로드하는 것입니다. 본 글에서는 대표적인 두 가지 툴, **`curl`** (Linux/macOS)과 **`Invoke-WebRequest` (`iwr` - Windows PowerShell)**을 사용하여 Private Repository에서 파일을 안전하게 다운로드하는 스크립트 작성법을 안내합니다.

---

## 1. Private Repository 파일 다운로드 기본 원리

Private Repository (예: GitHub Private Repo)에서 파일을 다운로드하려면 **인증(Authentication)**이 필수입니다. 일반적으로 **개인 액세스 토큰(Personal Access Token, PAT)**을 사용하여 인증 정보를 URL에 포함하거나 HTTP 헤더로 전달합니다.

### 개인 액세스 토큰 (PAT) 발급

**GitHub** 기준: `Settings` → `Developer settings` → `Personal access tokens` 에서 'repo' 스코프를 가진 토큰을 발급받아야 합니다. **이 토큰은 절대 외부에 노출되어서는 안 됩니다.**

### Raw 파일 URL 획득

다운로드할 파일의 **Raw** URL을 사용해야 합니다. 예를 들어, GitHub의 경우 `https://raw.githubusercontent.com/<user>/<repo>/<branch>/<file_path>` 형태가 됩니다.

---

## 2. Linux/macOS: `curl`을 사용한 다운로드

`curl`은 가장 널리 사용되는 CLI(Command Line Interface) HTTP 클라이언트입니다.

### 스크립트 예제

Private Repository에서 특정 파일을 다운로드하여 로컬에 저장하는 기본 형식은 다음과 같습니다.

```bash
#!/bin/bash

# 사용자 정의 변수
REPO_OWNER="your_username"
REPO_NAME="your_private_repo"
FILE_PATH="path/to/your/release.zip"
BRANCH="main" # 또는 master, release 등
PAT="YOUR_PERSONAL_ACCESS_TOKEN" # **주의: 실제 스크립트에서는 환경 변수 사용을 권장합니다.**
OUTPUT_FILENAME="downloaded_file.zip"

DOWNLOAD_URL="[https://raw.githubusercontent.com/$](https://raw.githubusercontent.com/$){REPO_OWNER}/${REPO_NAME}/${BRANCH}/${FILE_PATH}"

echo "Downloading $OUTPUT_FILENAME from private repo..."

curl -L \
     -H "Authorization: token $PAT" \
     -o "$OUTPUT_FILENAME" \
     "$DOWNLOAD_URL"

if [ $? -eq 0 ]; then
    echo "Download successful: $OUTPUT_FILENAME"
else
    echo "Download failed. Check PAT and URL."
fi
```

  * **`-L`**: 리다이렉트를 따라갑니다 (Follow redirects).
  * **`-H "Authorization: token $PAT"`**: HTTP 헤더에 PAT를 포함하여 인증합니다.
  * **`-o "$OUTPUT_FILENAME"`**: 다운로드한 파일을 지정된 파일명으로 저장합니다.

-----

## 3. Windows PowerShell: `iwr` (Invoke-WebRequest)을 사용한 다운로드

Windows 환경, 특히 PowerShell에서는 `Invoke-WebRequest` cmdlet (별칭: **`iwr`**)을 사용합니다.

### 스크립트 예제

`iwr`은 기본적으로 파일 다운로드를 지원하며, 헤더를 쉽게 추가할 수 있습니다.

```powershell
# 사용자 정의 변수
$REPO_OWNER="your_username"
$REPO_NAME="your_private_repo"
$FILE_PATH="path/to/your/release.zip"
$BRANCH="main" 
$PAT="YOUR_PERSONAL_ACCESS_TOKEN" 
$OUTPUT_FILENAME="downloaded_file.zip"

$DOWNLOAD_URL="[https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/$BRANCH/$FILE_PATH](https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/$BRANCH/$FILE_PATH)"

# HTTP 헤더 생성 (PAT 포함)
$Headers = @{
    "Authorization" = "token $PAT"
}

Write-Host "Downloading $OUTPUT_FILENAME from private repo..."

# iwr을 사용하여 다운로드
Invoke-WebRequest -Uri $DOWNLOAD_URL `
                  -Headers $Headers `
                  -OutFile $OUTPUT_FILENAME

Write-Host "Download successful: $OUTPUT_FILENAME"
```

### `iwr` 성능 최적화: `ProgressPreference` 활용 (저사양 VM 필수\!)

저사양 VM 환경에서 `iwr` 사용 시 **다운로드 속도가 현저히 느려지는 현상**을 겪을 수 있습니다. 이는 PowerShell의 **진행률 표시(Progress Bar)** 기능이 많은 리소스를 소모하기 때문입니다.

이를 해결하기 위해 스크립트 시작 시 `$ProgressPreference` 변수를 변경하면 됩니다.

```powershell
# **핵심 최적화 코드**
$ProgressPreference = "SilentlyContinue" 

# 이후 iwr 코드를 실행하면, 진행률 표시 없이 다운로드 속도가 크게 향상됩니다.
Invoke-WebRequest -Uri $DOWNLOAD_URL -Headers $Headers -OutFile $OUTPUT_FILENAME

# 이후 원래 상태로 되돌립니다.
$ProgressPreference = "Continue"
```

> **주의:** `$ProgressPreference`를 `SilentlyContinue`로 설정하면 진행률 표시가 아예 나타나지 않아 다운로드 과정을 시각적으로 확인할 수 없지만, 저사양 장비에서는 **다운로드 성능을 극적으로 높일 수 있습니다.**
{: .prompt-warning }

-----

## 결론: VM 환경에서의 자동화된 다운로드

`curl`과 `iwr`을 활용한 자동화된 다운로드 스크립트는 **저사양 VM의 리소스 제약**을 우회하고, **안정적이고 빠른** 파일 전송 경로를 제공합니다. Google Drive 페이지 로딩을 기다리는 대신, 위 스크립트들을 초기 설정 스크립트에 통합하여 VM 배포 직후 필요한 파일을 즉시 다운로드함으로써 **작업 효율성을 극대화**할 수 있습니다.

-----