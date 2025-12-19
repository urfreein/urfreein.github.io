---
title: "Vultr Minimal Windows 설치 Part 2"
date: 2025-10-26T17:25:30+09:00
lastmod: 2025-10-26T17:25:30+09:00
draft: false
description: "Vultr의 Windows 10 Pro 서버 설치 후, 24시간 자동 거래 프로그램을 안정적으로 운영하기 위해 시스템 리소스를 최소화하는 후속 설정 가이드입니다."
tags: ["Vultr Windows", "Minimal setup", "Windows 10", "최적화", "자동거래", "리소스 절약"]
categories: ["Cloud"]
image: "https://urinfo24.com/cdn-cgi/image/width=1200,format=auto,quality=85/https://images.urinfo24.com/featured/minimal-vultr-win-setup-part2-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A modern, professional tech illustration for "Vultr Minimal Windows 설치 Part 2".
- Style: Clean, professional, flat design with technical elements
- Subject: Visual representation of minimal vultr win setup part2
- Elements: Technical icons, symbols, code snippets, terminal windows, relevant tech logos
- Colors: Blue and gray tech tones, white background, accent colors for highlights
- Mood: Professional, modern, educational, technical
- Composition: Centered layout with balanced elements, clean and organized

Technical keywords: Vultr Windows,  "Minimal setup,  "Windows 10,  "최적화,  "자동거래

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/minimal-vultr-win-setup-part2-featured.jpg

NOTE: Hugo will serve this from /images/minimal-vultr-win-setup-part2-featured.jpg
-->

> 이 가이드는 [**이전 설치 가이드 링크**](https://urfreein.github.io/posts/minimal-vultr-win-setup-part1/)를 통해 Windows 10 Pro 설치를 완료한 후, 24시간 자동 거래 프로그램 운영 환경을 최적화하기 위한 후속 설정입니다.
{: .prompt-info }

-----

#### **Vultr 추천인 코드 사용하기**

서버 설치 및 운영을 시작하기 전에, 아래 추천인 링크를 통해 Vultr에 가입하시면 2주간 $100가 Deposit됩니다. 물론 2주가 지나면 남은 무료 Deposit은 사라집니다.

> **Vultr 추천인 링크:** 
> [**`https://www.vultr.com/?ref=9610163`**](https://www.vultr.com/?ref=9610163)
{: .prompt-info }

-----

### 1\. 시스템 성능 및 전원 관리 최적화

24시간 작동해야 하는 자동 거래 환경을 위해 Windows가 절대로 절전 모드로 진입하거나 불필요한 그래픽 리소스를 사용하지 않도록 설정합니다. 모든 작업은 **Vultr View Console**을 통해 진행합니다.

#### 1.1. 디스플레이 및 알림 최소화

Windows 리소스를 절약하고 VNC Console 환경에 최적화합니다.

1.  **`설정`** \> **`시스템`** \> \*\*`디스플레이`\*\*로 이동합니다.
      * **해상도:** **`1280 x 1024`** 또는 더 낮은 해상도를 선택하여 불필요한 그래픽 로드를 줄입니다.
2.  **`설정`** \> **`시스템`** \> \*\*`알림 및 작업`\*\*으로 이동합니다.
      * **알림:** 모든 알림을 \*\*`끔`\*\*으로 설정하여 시스템 자원 낭비를 방지합니다.

#### 1.2. 절전 기능 비활성화 및 고성능 모드 설정

서버가 24시간 구동되도록 절전 모드를 완전히 차단합니다.

1.  **`설정`** \> **`시스템`** \> \*\*`전원 및 절전`\*\*으로 이동합니다.
      * **화면 자동 꺼짐:** 모든 항목을 \*\*`안 함`\*\*으로 설정합니다.
2.  **`추가 전원 설정`** 링크를 클릭하여 제어판의 전원 옵션으로 이동합니다.
      * **전원 관리 옵션:** \*\*`고성능`\*\*으로 설정하여 CPU가 최대 속도를 유지하도록 합니다.

#### 1.3. 시각 효과 최소화 (최적 성능)

Windows의 화려한 시각 효과를 제거하여 CPU 및 메모리 사용량을 줄입니다.

1.  **`설정`** \> **`정보`** \> **`고급 시스템 설정`** (또는 Windows 검색에서 "고급 시스템 설정 보기" 검색)으로 이동합니다.
2.  **`고급`** 탭에서 **`성능`** 섹션의 **`설정`** 버튼을 클릭합니다.
3.  **`시각 효과`** 탭에서 \*\*`최적 성능으로 조정`\*\*을 선택하고 \*\*`확인`\*\*을 클릭합니다. (Windows UI가 매우 간소화됩니다.)

### 2\. 시간 동기화 및 자동 재부팅 설정

자동 거래 프로그램은 **정확한 시간**을 필요로 하며, 장기 운영을 위해 주기적인 재부팅은 필수입니다.

#### 2.1. Windows Time 서비스 활성화 및 동기화

정확한 시간 유지를 위해 Windows Time 서비스를 활성화하고, 현재 시간을 동기화합니다.

1.  Windows 검색에서 \*\*`서비스(Services.msc)`\*\*를 실행합니다.
2.  **`Windows Time`** 서비스를 찾아 마우스 오른쪽 버튼을 클릭하고 \*\*`속성`\*\*으로 이동합니다.
3.  **시작 유형**을 \*\*`자동`\*\*으로 변경하고 **`시작`** 버튼을 눌러 서비스를 활성화합니다.
4.  **`설정`** \> **`시간 및 언어`** \> \*\*`날짜 및 시간`\*\*으로 이동합니다.
      * **자동으로 시간 설정:** \*\*`켬`\*\*으로 설정합니다.
      * **`지금 동기화`** 버튼을 클릭하여 시간을 즉시 동기화합니다.

#### 2.2. 작업 스케줄러를 이용한 매일 자동 재부팅 설정

메모리 누수 방지 및 시스템 안정화를 위해 매일 서버를 재부팅하도록 스케줄을 설정합니다.

1.  Windows 검색에서 \*\*`작업 스케줄러(Task Scheduler)`\*\*를 실행합니다.
2.  \*\*`작업 만들기...`\*\*를 클릭합니다.
      * **일반 탭:** 이름 (예: `Daily_Reboot`)을 지정합니다.
      * **트리거 탭:** \*\*`새로 만들기`\*\*를 클릭하고, **`매일`**, 원하는 재부팅 시간(예: 새벽 4시)을 설정하고 확인합니다.
      * **동작 탭:** \*\*`새로 만들기`\*\*를 클릭합니다.
          * **프로그램/스크립트:** `shutdown`
          * **인수 추가:** `-r -f` (재부팅(-r)하고, 강제 종료(-f) 옵션)
3.  설정을 완료하고 작업을 활성화합니다.

### 3\. [선택 사항] 개인 맞춤형 키보드/입력기 설정

이 설정은 일반적인 사용자를 위한 것이 아니며, 특정 키보드 레이아웃이나 입력 방식을 사용하시는 분들을 위한 설정입니다.(`shift+space` 한영전환, 세벌식390 이용자)

1.  **`설정`** \> **`시간 및 언어`** \> \*\*`한국어`\*\*를 클릭하고 \*\*`옵션`\*\*으로 이동합니다.
2.  **키보드 레이아웃:** \*\*`레이아웃 변경`\*\*을 클릭하여 \*\*`종류 3`\*\*을 선택합니다.
3.  **Microsoft 입력기:** \*\*`옵션`\*\*으로 들어가서 \*\*`세벌식 390`\*\*으로 변경합니다.