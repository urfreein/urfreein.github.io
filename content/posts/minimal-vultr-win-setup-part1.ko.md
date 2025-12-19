---
title: "Vultr Minimal Windows 설치 Part 1"
date: 2025-10-26T16:20:10+09:00
lastmod: 2025-10-26T16:20:10+09:00
draft: false
description: "클라우드 초보자를 위한 Vultr Windows 설치 가이드입니다. 설치 후 Vultr의 View Console을 통해 모든 설정을 마무리하는 방법을 안내합니다."
tags: ["Vultr Windows", "Minimal setup", "Windows 10", "VirtIO", "Custom ISO", "VNC 콘솔"]
categories: ["Cloud"]
image: "https://urinfo24.com/cdn-cgi/image/width=1200,format=auto,quality=85/https://images.urinfo24.com/featured/minimal-vultr-win-setup-part1-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A modern, professional tech illustration for "Vultr Minimal Windows 설치 Part 1".
- Style: Clean, professional, flat design with technical elements
- Subject: Visual representation of minimal vultr win setup part1
- Elements: Technical icons, symbols, code snippets, terminal windows, relevant tech logos
- Colors: Blue and gray tech tones, white background, accent colors for highlights
- Mood: Professional, modern, educational, technical
- Composition: Centered layout with balanced elements, clean and organized

Technical keywords: Vultr Windows,  "Minimal setup,  "Windows 10,  "VirtIO,  "Custom ISO

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/minimal-vultr-win-setup-part1-featured.jpg

NOTE: Hugo will serve this from /images/minimal-vultr-win-setup-part1-featured.jpg
-->

-----

#### **[필수] Vultr 추천인 코드 사용하기**

서버 설치를 시작하기 전에, 아래 추천인 링크를 통해 Vultr에 가입하시면 **2주간 $100가 Deposit**됩니다. Vultr에서 **$100면 왠만한 모든 것은 다 테스트** 해볼 수 있습니다. 특히, Custom ISO를 Upload하기 위해 AWS의 S3와 같은 스토리지 서비스를 이용하면 편리한데, 추천인 코드 사용하여 회원 가입후 편하게 이런 서비스 이용해서 서버 설치하면 비용을 많이 절약할 수 있습니다. 꼭, 아래의 추천인 코드가 아니어도 웹상에 수없이 널려있고, 혹은 먼저 가입한 지인의 추천인 코드를 사용해서라도 **반드시 추천인 코드를 사용하여 가입**하시기 바랍니다.

> **Vultr 추천인 링크:**
> [**`https://www.vultr.com/?ref=9610163`**](https://www.vultr.com/?ref=9610163)
{: .prompt-info }

-----

### 1\. Vultr Windows 10 Pro 서버 설치 준비

Vultr 서버에 Windows를 설치할 때, 하드웨어(디스크, 네트워크)를 인식시키려면 **VirtIO 드라이버**가 필수입니다. 이 드라이버가 Windows ISO에 이미 포함되어 있으므로, 하나의 ISO만 업로드하면 됩니다.

#### 1.1. Windows 10 Pro ISO 준비 및 업로드

1.  **Windows 10 Pro ISO:** 확보하신 **`Windows 10 Pro Optimize Service Max SSD`** ISO 파일의 **직접 다운로드 URL**을 준비합니다.  
ISO 파일은 웹 검색을 하여 찾아보아요~
2. **직접 다운로드 URL**: Vultr의 Object Storage 서비스 이용하면 편합니다. 무료 Deposit으로 쓰거나, Upload를 위해 잠시만 사용하는데는 몇 센트면 충분합니다.(Upload완료후 바로 삭제)  
그렇지않으면, Dropbox나 AWS의 S3를 이용합니다. google drive 지원하지 않습니다.
3.  Vultr 계정에 로그인 후, **`Orchestration/ISOs`**로 이동합니다.
4.  **`Create ISO`** 버튼을 클릭하여 **Windows 10 Pro ISO** URL을 입력하고 업로드합니다.
5.  ISO 파일이 **`Available`** 상태가 될 때까지 기다립니다.

### 2\. Vultr 서버 (Instance) 생성 단계

업로드한 ISO를 사용하여 가상 서버를 만들고 설치를 준비합니다.

#### 2.1. `Step 1` 서버 타입 및 위치 선택

1. Vultr 대시보드에서 **`Products`** \> **`Compute`**로 이동 후, **`Deploy`**를 클릭합니다.
2. **Choose Type:** **`Shared CPU`**를 선택합니다.
3. **Server Location:** 서버를 운영할 가장 가까운 리전(예: Asia/Seoul)을 선택합니다.
4. **Server Size:** list에서 가장 위쪽 저렴한 $5.00/mo 를 선택합니다.
5. **Backup Service Disable:*** 우측, Deploy Summary에서 **Automatic Backups**를 `Disable`버튼을 눌러 경고 무시하고 확인합니다.

#### 2.2. `Step 2` ISO 이미지 선택 및 추가 설정

1. **Server Image:** **`ISO/iPXE`** 탭에서 업로드했던 **Windows 10 Pro ISO**를 선택합니다.
2. **Server Settings:** 빈칸으로 남겨 둡니다.
3. **Server Hostname and Label:** 서버의 호스트네임을 입력합니다. Label은 보통 호스트네임과 동일하게 설정됩니다.
4. **Additional Features**: 기본 설정으로 둡니다. 여기서 **Automatic Backups**를 `Disable`인지 꼭 확인하세요.

#### 2.3. 배포

1. 우측 **Deploy Summary**를 다시 확인하여, 수정이 필요하면 앞단계로 다시 가서 수정하면 됩니다. Total Price가 **$5.00/mo** 인지 확인합니다.
2.  **`Deploy`** 버튼을 클릭하여 서버 생성을 시작합니다.

### 3\. VNC를 통한 Windows 10 Pro 설치 진행 및 드라이버 로드 (핵심)

서버 배포 후, VNC 콘솔을 통해 Windows 설치를 시작하고 **VirtIO 드라이버를 수동으로 로드**합니다.
경험상 설치 화면이 꾀 늦게 나타날 수 있습니다.
저의 경우 처음에 대략 20여분만에 설치 화면이 나왔습니다.
최근에 다시 해보면 몇 분만 잠깐 기다리면 됩니다. 그러니, 좀 늦더라도 기다려 주세요.

1.  배포된 서버 인스턴스 상세 페이지로 이동하여 **`View Console`** 버튼을 클릭합니다.
2.  Windows 설치 화면에서 언어, 키보드 등을 선택 후 **`지금 설치`**를 클릭합니다.
3.  설치 유형 선택 화면에서 \*\*`사용자 지정: Windows만 설치(고급)`\*\*을 선택합니다.

> 언어, 키보드 변경해도 적용안됩니다. 변경이 필요하면 설치후에 하세요.
{: .prompt-warning }

#### 3.1. 스토리지와 네트워크 드라이버 로드

1.  **`드라이버 로드`**를 클릭합니다.
2.  **`찾아보기`**를 클릭하여 **Windows ISO 드라이브** 내부에 있는 드라이버 폴더로 이동합니다.
3.  **디스크 드라이버 경로:**
      * `[Windows ISO 드라이브]:\virtio-win-0.1.208\viostor\w10\amd64` 경로를 선택합니다.
      * **`다음`**을 클릭하여 드라이버를 로드합니다.
4.  **네트워크 드라이버 경로:**
      * `[Windows ISO 드라이브]:\virtio-win-0.1.208\NetKVM\w10\amd64` 경로를 선택합니다.
      * **`다음`**을 클릭하여 드라이버를 로드합니다.      
5.  드라이브를 선택하고 설치를 시작합니다.

### 4\. 설치 후 마무리 설정 (Vultr View Console 활용)

#### 4.1. 설치된 Windows에서 가상 CD/DVD 드라이브 '꺼내기'

설치 완료 후 재부팅 시 ISO로 다시 부팅되는 것을 막고, 다음 재설치를 위해 ISO를 유지하려면 이 과정이 필수입니다.

1.  **`View Console`**을 통해 생성한 서버에 접속합니다.
2.  **`내 PC`** 또는 \*\*`파일 탐색기`\*\*를 엽니다.
3.  Windows ISO가 마운트된 **CD/DVD 드라이브** 아이콘을 마우스 오른쪽 버튼으로 클릭합니다.
4.  드롭다운 메뉴에서 \*\*`꺼내기(Eject)`\*\*를 선택하여 가상 드라이브에서 ISO를 분리합니다.

#### 4.2. Vultr View Console을 통한 서버 활용 시작

이후 모든 서버 관리 및 활용은 **Vultr 인스턴스 상세 페이지의 `View Console` 기능**을 통해 웹 브라우저에서 진행할 수 있습니다.

> Windows의 필요한 초기 설정(업데이트, 시간대 등)을 Console을 통해 완료합니다.
{: .prompt-info }

#### **추가 팁 :** 같은 설정의 윈도우 여러개를 배포할 경우
- Windows 설치후 필요한 설정을 합니다. 필요한 Application도 모두 설치합니다.
- 그리고, **Snapshot**을 이용하도록 합니다.
- 배포한 VM의 Overview 화면이나, **Orchestration**메뉴에서 **Snapshot**을 선택합니다.
- `Take a snapshot`을 누릅니다.
- 몇 분후에 Snapshot이 만들어지면, 배포할 때, ISO 탭이 아닌 Snapshot 탭으로 가서 만들어진 Snapshot을 선택합니다.
- 이제 귀찮고 시간걸리는 윈도우즈 설치 과정없이, 바로 똑같은 윈도우즈가 배포됩니다.
- Snapshot Image는 $0.05/GB/month입니다. 위와 같은 Lite버전의 Windows의 Snapshot은 약 7GB이므로, 월 $0.35 내외입니다.
- 월 유지 비용이 저렴하므로, 혹여 재설치나 추가 배포를 위해 남겨 놓는 것도 좋습니다.
- 또는 삭제후 필요할 때, 언제든 Snapshot을 만들어 배포하면 됩니다.
- 참고로, Snapshot이 만들어지는 동안은 VM을 쓸 수 없으니 주의하시기 바랍니다.
- Snapshot은 똑같은 상태의 이미지가 만들어지는 것이므로, Static IP를 지정한 경우에는 주의하시기 바랍니다. 꼭, DHCP Client Service를 이용하시기 바랍니다. 그렇지않으면, 배포후 기존 VM과 IP 충돌이 일어날 수 있습니다.

이제 가장 저렴한 비용으로 Vultr 클라우드에 Windows 10 Pro 서버 구축을 완료했으며, **View Console**을 통해 편리하게 서버를 운영할 수 있습니다\!  
이후, 리소스를 더욱 최소화하여 자동 프로그램을 운영하기 위한 설정은 다음 게시물에서 설명합니다. 필요하신 분만 보세요.