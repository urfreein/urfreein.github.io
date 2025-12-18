---
title: "Docker Image를 이용한 WordPress 환경 구축 가이드"
date: 2025-11-08T11:11:53+09:00
lastmod: 2025-11-08T11:11:53+09:00
draft: false
description: "WSL2 환경에서 docker-compose를 활용하여 WordPress와 MariaDB를 두 개의 컨테이너로 효율적으로 구축하고 실행하는 단계별 상세 가이드입니다."
tags: ["WSL2", "Docker", "Docker-Compose", "WordPress", "MariaDB", "개발환경"]
categories: ["DevOps"]
image: "https://images.urinfo24.com/featured/wordpress-setup-guide-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A modern, professional tech illustration for "Docker Image를 이용한 WordPress 환경 구축 가이드".
- Style: Clean, professional, flat design with technical elements
- Subject: Visual representation of wordpress setup guide
- Elements: Technical icons, symbols, code snippets, terminal windows, relevant tech logos
- Colors: Blue and gray tech tones, white background, accent colors for highlights
- Mood: Professional, modern, educational, technical
- Composition: Centered layout with balanced elements, clean and organized

Technical keywords: WSL2,  "Docker,  "Docker-Compose,  "WordPress,  "MariaDB

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/wordpress-setup-guide-featured.jpg

NOTE: Hugo will serve this from /images/wordpress-setup-guide-featured.jpg
-->

## 1단계: WSL2 환경 준비 및 도커 설치 확인

먼저 WSL2 내부에 도커를 사용할 수 있도록 환경을 준비해야 합니다.

### A. Docker Desktop 설정 확인 (권장)

Windows에 Docker Desktop이 설치되어 있다면, 다음 설정을 확인합니다.

1.  **설정(Settings)**으로 이동합니다.
2.  **Resources** -> **WSL INTEGRATION** 메뉴를 선택합니다.
3.  사용하려는 리눅스 배포판(예: Ubuntu)이 **활성화**되어 있는지 확인합니다.

### B. docker-compose 설치 확인

WSL2 셸을 열고 다음 명령어로 `docker-compose`가 설치되어 있는지 확인합니다.

```bash
docker-compose --version
````

> 만약 설치되어 있지 않다면, Docker Desktop을 사용하지 않는 경우이므로 수동으로 설치해야 합니다. (Docker Desktop 사용 시 대부분 자동 설치됩니다.)
{: .prompt-warning }

### C. 필요한 도커 이미지 미리 받기

`docker-compose up` 명령을 실행할 때 자동으로 이미지를 받지만, 미리 다운로드해 두면 더 안정적입니다. 워드프레스와 MariaDB 이미지를 받습니다.

```bash
docker pull wordpress:latest
docker pull mariadb
```

-----

## 2단계: 워드프레스 프로젝트 폴더 및 설정 파일 생성

워드프레스 관련 파일과 설정 파일(`docker-compose.yml`)을 담을 폴더를 만듭니다.

### 프로젝트 폴더 생성 및 이동

다음 명령어를 사용하여 프로젝트 폴더를 만들고 이동합니다.

```bash
mkdir wordpress-blog
cd wordpress-blog
```

### `docker-compose.yml` 파일 생성

다음 내용을 복사하여 `wordpress-blog` 폴더 안에 `docker-compose.yml` 파일을 만듭니다. (vi, nano 또는 VS Code 등을 사용하시면 됩니다.)

```yaml
version: '3.8'
services:
  db:
    # MariaDB 이미지를 사용합니다.
    image: mariadb
    command: '--default-authentication-plugin=mysql_native_password'
    restart: always
    environment:
      # 필요한 환경 변수 설정
      MYSQL_ROOT_PASSWORD: your_db_root_password # 루트 계정 비밀번호
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wpuser
      MYSQL_PASSWORD: your_db_password          # 워드프레스가 사용할 계정 비밀번호
    volumes:
      # 데이터베이스 데이터 영구 저장을 위한 볼륨 설정
      - db_data:/var/lib/mysql

  wordpress:
    image: wordpress:latest
    restart: always
    ports:
      # 호스트(WSL2/Windows)의 8080 포트를 컨테이너의 80 포트로 연결
      - "8080:80"
    environment:
      # 워드프레스가 DB에 접속하기 위한 설정
      WORDPRESS_DB_HOST: db:3306              # 서비스 이름(db)으로 통신
      WORDPRESS_DB_USER: wpuser
      WORDPRESS_DB_PASSWORD: your_db_password
      WORDPRESS_DB_NAME: wordpress
    volumes:
      # 워드프레스 설치 파일 및 플러그인, 업로드 파일 영구 저장을 위한 볼륨 설정
      - wp_files:/var/www/html

# 볼륨 정의 (컨테이너가 삭제되어도 데이터는 보존됨)
volumes:
  db_data:
  wp_files:
```

> 위 설정 파일에서 `your_db_root_password`와 `your_db_password`는 반드시 **안전한 비밀번호로 변경**해야 합니다.
{: .prompt-danger }
-----

## 3단계: 도커 컨테이너 실행

`docker-compose.yml` 파일이 있는 폴더(`wordpress-blog`)에서 다음 명령어를 실행합니다.

```bash
docker-compose up -d
```

  * `up`: `docker-compose.yml`에 정의된 서비스를 시작합니다.
  * `-d`: **detached 모드**로, 백그라운드에서 컨테이너를 실행하고 셸을 종료하지 않습니다.

이 명령어를 실행하면, 필요한 이미지를 다운로드(로컬에 없는 경우)하고 두 개의 컨테이너(`db`와 `wordpress`)를 동시에 실행합니다.

-----

## 4단계: 컨테이너 실행 확인 및 초기 접속

### 컨테이너 상태 확인

컨테이너가 정상적으로 실행되었는지 확인합니다. **상태(STATUS)가 `Up`으로 표시**되어야 합니다.

```bash
docker-compose ps
```

### 워드프레스 초기 설치 접속

Windows 웹 브라우저를 열고 다음 주소로 접속합니다.

```
http://localhost:8080
```

> `docker-compose.yml`에서 `ports: - "8080:80"`을 설정했기 때문에 8080 포트를 사용합니다. 다른 포트를 사용하고 싶으면 해당 숫자를 변경하면 됩니다.
{: .prompt-info }

-----

## 5단계: 워드프레스 초기 설정

웹 브라우저로 접속하면 워드프레스 설치 마법사(Wizard)가 시작됩니다.

1.  **언어 선택:** 원하는 언어(예: 한국어)를 선택하고 **계속**을 클릭합니다.
2.  **정보 입력:**
      * **사이트 제목:** 블로그의 이름을 입력합니다.
      * **사용자명:** 워드프레스 관리자로 사용할 사용자명을 입력합니다.
      * **비밀번호:** 강력한 비밀번호를 설정하고 메모해 둡니다.
      * **이메일:** 관리자 이메일을 입력합니다.
3.  **설치 완료:** **워드프레스 설치** 버튼을 클릭하여 마무리합니다.

이제 관리자 계정으로 로그인하여 블로그 사용을 시작할 수 있습니다.

-----

## 6단계: 컨테이너 종료 (선택 사항)

테스트를 완료하고 컨테이너를 중지하고 싶다면, 다시 `wordpress-blog` 폴더로 이동하여 다음 명령어를 실행합니다.

```bash
docker-compose down
```

이 명령어는 컨테이너를 중지하고 제거하지만, 2단계에서 정의한 `db_data`와 `wp_files` 볼륨 덕분에 데이터(DB 내용과 WP 파일)는 보존됩니다. 나중에 다시 `docker-compose up -d`를 실행하면 이전에 작업했던 상태 그대로 다시 시작됩니다.