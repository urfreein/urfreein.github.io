---
title: "Google Sheets API 연동을 위한 서비스 계정 생성 및 키 발급 가이드"
date: 2025-11-01T00:38:40+09:00
lastmod: 2025-11-01T00:38:40+09:00
draft: false
description: "외부 애플리케이션이 Google 스프레드시트 데이터에 안전하게 접근하고 읽기/쓰기 작업을 수행할 수 있도록, Google Cloud Platform에서 서비스 계정을 생성하고 키를 발급받는 실용적인 방법을 안내합니다."
tags: ["GCP", "서비스계정", "GoogleSheetsAPI", "IAM", "자동화"]
categories: ["Google Cloud"]
image: "https://urinfo24.com/cdn-cgi/image/width=1200,format=auto,quality=85/https://images.urinfo24.com/featured/gcp-service-account-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A modern, professional tech illustration for "Google Sheets API 연동을 위한 서비스 계정 생성 및 키 발급 가이드".
- Style: Clean, professional, flat design with technical elements
- Subject: Visual representation of gcp service account
- Elements: Technical icons, symbols, code snippets, terminal windows, relevant tech logos
- Colors: Blue and gray tech tones, white background, accent colors for highlights
- Mood: Professional, modern, educational, technical
- Composition: Centered layout with balanced elements, clean and organized

Technical keywords: GCP,  "서비스계정,  "GoogleSheetsAPI,  "IAM,  "자동화

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/gcp-service-account-featured.jpg

NOTE: Hugo will serve this from /images/gcp-service-account-featured.jpg
-->

Google Cloud Platform(GCP)의 **서비스 계정(Service Account)**은 외부 시스템이나 자동화 스크립트가 Google 스프레드시트(Google Sheets)와 같은 Google 서비스에 접근하도록 인증하는 핵심 요소입니다. 이 가이드에서는 스프레드시트 데이터 연동을 목적으로 서비스 계정을 설정하는 과정을 상세히 다룹니다.

---

## 0. 시작 전 준비 사항: GCP 프로젝트 및 API 활성화

서비스 계정을 생성하고 사용하려면 해당 계정이 속할 **GCP 프로젝트**가 필요하며, 목표 서비스인 **Google Sheets API**를 활성화해야 합니다.

### 0.1. GCP 프로젝트 생성 (필수)

Google Cloud에서 모든 리소스와 설정은 **프로젝트**를 단위로 관리됩니다. 만약 기존 프로젝트가 없다면, 다음 단계를 통해 프로젝트를 먼저 생성해야 합니다.

1.  Google Cloud Console 상단에서 현재 프로젝트 이름 옆의 드롭다운을 클릭합니다.
2.  **"새 프로젝트"**를 클릭하여 프로젝트 이름과 위치를 설정하고 생성합니다.

### 0.2. Google Sheets API 활성화 (필수)

서비스 계정이 스프레드시트에 접근하려면 해당 프로젝트에서 **Google Sheets API**가 활성화되어 있어야 합니다.

1.  Google Cloud Console 탐색 메뉴(☰)에서 **"API 및 서비스"** > **"대시보드"**로 이동합니다.
2.  상단의 **"+ API 및 서비스 사용 설정"** 버튼을 클릭합니다.
3.  검색창에 **"Google Sheets API"**를 검색하여 선택하고 **"사용 설정"** 버튼을 클릭합니다.

---

## 1. Google Cloud Console 접속 및 서비스 계정 화면 이동

프로젝트와 API 준비가 완료되었다면, 서비스 계정을 관리하는 화면으로 이동합니다.

### 1.1. Google Cloud Console 접속

선택된 프로젝트가 Sheets API 연동을 진행할 프로젝트인지 확인합니다.

### 1.2. IAM 및 관리자 페이지로 이동

1.  좌측 상단의 **탐색 메뉴(☰)**를 클릭합니다.
2.  **IAM 및 관리자** 메뉴를 찾아서 클릭합니다.
3.  하위 메뉴 중 **서비스 계정**을 선택하여 서비스 계정 관리 화면으로 이동합니다.

---

## 2. 새로운 서비스 계정 생성

### 2.1. 서비스 계정 만들기 시작

**"+ 서비스 계정 만들기"** 버튼을 클릭합니다.

### 2.2. 계정 기본 정보 입력

* **서비스 계정 이름:** (예: `sheets-api-connector`)
* **서비스 계정 설명:** 스프레드시트 연동 목적으로 사용됨을 명시합니다.

정보를 입력한 후 **"만들고 계속하기"** 버튼을 클릭합니다.

---

## 3. 서비스 계정에 역할(Role) 부여 (Sheets 연동 목적)

Google Sheets API 연동을 위한 서비스 계정에는 일반적으로 **특정 GCP 리소스에 대한 역할은 필요하지 않습니다.** Sheets API 접근 권한은 **JSON 키를 다운로드한 후 스프레드시트 자체에서 부여**하게 됩니다.

### 3.1. 역할 부여 단계는 건너뛰기

Google Sheets API를 통한 연동의 경우, 서비스 계정의 주 목적이 GCP 내부 리소스 관리가 아니므로, 이 단계에서는 **별도의 역할을 부여하지 않고** 진행하는 것이 일반적이며 권장됩니다.

1.  역할 선택 단계에서 **별도로 역할을 선택하지 않습니다.**
2.  **"계속"** 버튼을 클릭하여 다음 단계로 넘어갑s니다.

### 3.2. (선택 사항) 사용자에게 서비스 계정 액세스 권한 부여

이 단계도 건너뛰고 **"완료"** 버튼을 클릭하여 서비스 계정 생성을 마무리합니다.

---

## 4. 서비스 계정 키 생성 및 JSON 파일 다운로드

외부 애플리케이션이 스프레드시트에 접근하기 위해 필요한 **JSON 키**를 발급받습니다.

### 4.1. 서비스 계정 목록에서 키 관리로 이동

1.  방금 생성한 서비스 계정의 오른쪽 끝에 있는 **"더 보기(⋮)"** 아이콘을 클릭합니다.
2.  **"키 관리"**를 선택합니다.

### 4.2. 키 만들기 및 JSON 다운로드

1.  **"키 추가"** > **"새 키 만들기"**를 선택합니다.
2.  **JSON** 키 유형을 선택하고 **"만들기"** 버튼을 클릭합니다.
3.  **JSON 키 파일이 자동으로 다운로드**되며, 이 파일을 사용하여 외부 스크립트에서 인증을 진행하게 됩니다.

다운로드한 JSON 키 파일은 다음과 같은 구조를 가집니다.

```json
{
  "type": "service_account",
  "project_id": "your-gcp-project-id",
  "private_key_id": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAw... [매우 긴 암호화된 키 값] ...CgYIKoZIzdj0DAQE=\n-----END PRIVATE KEY-----\n",
  "client_email": "sheets-api-connector@your-gcp-project-id.iam.gserviceaccount.com",
  "client_id": "123456789012345678901",
  "auth_uri": "[https://accounts.google.com/o/oauth2/auth](https://accounts.google.com/o/oauth2/auth)",
  "token_uri": "[https://oauth2.googleapis.com/token](https://oauth2.googleapis.com/token)",
  "auth_provider_x509_cert_url": "[https://www.googleapis.com/oauth2/v1/certs](https://www.googleapis.com/oauth2/v1/certs)",
  "client_x509_cert_url": "[https://www.googleapis.com/robot/v1/metadata/x509/sheets-api-connector%40your-gcp-project-id.iam.gserviceaccount.com](https://www.googleapis.com/robot/v1/metadata/x509/sheets-api-connector%40your-gcp-project-id.iam.gserviceaccount.com)",
  "universe_domain": "googleapis.com"
}
```
> **다음 단계 (필수):** 다운로드한 JSON 키 파일 내의 `client_email` 값을 복사하여, 접근하려는 **Google 스프레드시트의 공유 설정**에 `편집자` 또는 `뷰어`로 추가해야만 실제 데이터에 접근할 수 있습니다. 이것이 Sheets 연동의 핵심 보안 설정입니다.
{: .prompt-info }

---

## 결론

Google Sheets API를 사용하기 위한 서비스 계정 생성을 완료했습니다. 생성된 JSON 키를 안전하게 보관하고, **키 파일 내의 이메일 주소를 원하는 스프레드시트의 '공유 대상'에 추가**하는 것을 잊지 마십시오. 이제 외부 환경에서 Sheets API를 활용한 데이터 자동화 작업을 시작할 수 있습니다.