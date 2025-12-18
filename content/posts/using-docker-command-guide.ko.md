---
title: "Docker & Docker Compose 자주 사용하는 명령어"
date: 2025-01-01T00:00:00+09:00
lastmod: 2025-01-01T00:00:00+09:00
draft: false
description: 
tags: ["docker", "docker-compose", "cli", "cheatsheet", "devops"]
categories: ["Tutorial"]
image: "https://images.urinfo24.com/featured/using-docker-command-guide-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A modern, professional tech illustration for "Docker & Docker Compose 자주 사용하는 명령어".
- Style: Clean, professional, flat design with technical elements
- Subject: Visual representation of using docker command guide
- Elements: Technical icons, symbols, code snippets, terminal windows, relevant tech logos
- Colors: Blue and gray tech tones, white background, accent colors for highlights
- Mood: Professional, modern, educational, technical
- Composition: Centered layout with balanced elements, clean and organized

Technical keywords: docker,  "docker-compose,  "cli,  "cheatsheet,  "devops

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/using-docker-command-guide-featured.jpg

NOTE: Hugo will serve this from /images/using-docker-command-guide-featured.jpg
-->

Docker와 Docker Compose 사용 시 자주 필요한 명령어와 설정 파일(Dockerfile, docker-compose.yml) 작성법을 정리한 치트 시트입니다.
<!--more-->

## 1\. Docker CLI (Container Management)

| 명령어 | 설명 |
| :--- | :--- |
| `docker pull <image>:<tag>` | Docker Hub와 같은 레지스트리에서 이미지를 로컬로 다운로드합니다. |
| `docker images` | 로컬에 저장된 모든 이미지를 나열합니다. |
| `docker build -t <tag> .` | 현재 디렉터리(`.`)의 `Dockerfile`을 사용하여 이미지를 빌드하고 `<tag>` 이름으로 저장합니다. |
| `docker ps` | **실행 중인** 컨테이너 목록을 표시합니다. `-a` 옵션을 추가하면 중지된 컨테이너까지 모두 표시합니다. |
| `docker run -d -p <host>:<container> <image>` | 이미지를 사용하여 새 컨테이너를 실행합니다. `-d`는 백그라운드(`detach`)로 실행하고, `-p`는 포트를 매핑합니다. |
| `docker stop <container>` | 실행 중인 컨테이너를 부드럽게(`gracefully`) 중지합니다. |
| `docker rm <container>` | 중지된 컨테이너를 시스템에서 제거합니다. |
| `docker rmi <image>` | 로컬 이미지를 제거합니다. |
| `docker logs -f <container>` | 컨테이너의 표준 출력/오류 로그를 실시간(`follow`)으로 확인합니다. |
| `docker exec -it <container> /bin/bash` | 실행 중인 컨테이너 내부에 접속하여(`execute`) 새로운 셸 세션을 시작합니다. |

---
## 2\. Docker Compose CLI (Multi-Container Management)

| 명령어 | 설명 |
| :--- | :--- |
| `docker compose up -d` | `docker-compose.yml` 파일에 정의된 모든 서비스를 읽어와 컨테이너를 생성하고 시작합니다. `-d`는 백그라운드로 실행합니다. |
| `docker compose down` | `docker-compose.yml` 파일에 의해 생성된 컨테이너, 네트워크 및 볼륨을 중지하고 제거합니다. |
| `docker compose ps` | Compose 파일에 정의된 서비스들의 현재 상태를 표시합니다. |
| `docker compose logs -f` | Compose 파일에 정의된 모든 서비스의 로그를 실시간으로 확인합니다. |
| `docker compose stop <service>` | 특정 서비스만 중지합니다. |
| `docker compose build` | 서비스에 정의된 `Dockerfile`을 사용하여 이미지를 재빌드합니다. |

-----
---
## Docker 설정 파일 예시 및 규칙
 
## 1\. Dockerfile 예시 (파이썬 웹 앱)

이 `Dockerfile`은 파이썬 프로젝트를 빌드하고 실행하는 표준적인 예시입니다.

```dockerfile
# --------------------------------------------------------------------
# Dockerfile: Python 웹 애플리케이션 빌드 예시
# --------------------------------------------------------------------

# 1. Base Image: 애플리케이션을 위한 경량 Python 런타임 이미지 사용
FROM python:3.11-slim

# 2. Environment Variables: 컨테이너 내부 환경 변수 설정
ENV PYTHONUNBUFFERED 1
ENV APP_HOME /app

# 3. Working Directory: 컨테이너 내 작업 디렉터리 설정 (이후 모든 명령의 기준 경로)
WORKDIR $APP_HOME

# 4. Dependency Copy & Install: 종속성 파일 복사 및 설치
# requirements.txt 파일만 먼저 복사하여 캐시 효율을 높임
COPY requirements.txt .

# 종속성 설치 (이 단계는 requirements.txt가 변경될 때만 재실행됨)
RUN pip install --no-cache-dir -r requirements.txt

# 5. Application Code Copy: 나머지 모든 소스 코드 복사
COPY . $APP_HOME

# 6. Port Exposure: 컨테이너가 8000번 포트를 사용한다고 선언
EXPOSE 8000

# 7. Command: 컨테이너가 시작될 때 실행할 기본 명령어
# (Gunicorn을 사용하여 WSGI 서버를 구동하는 예시)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "my_app.wsgi:application"]
```

### Dockerfile 작성 규칙 및 포맷

  * **대문자 명령:** 모든 명령어(`FROM`, `RUN`, `CMD` 등)는 대문자로 작성합니다.
  * **레이어 최소화:** Docker 이미지는 각 명령어가 하나의 \*\*레이어(Layer)\*\*를 생성합니다. `RUN` 명령을 하나로 묶어(`&&` 사용) 레이어 수를 줄이는 것이 이미지 크기와 빌드 속도에 유리합니다.
  * **캐시 활용 극대화:** 변경이 잦은 코드 파일(`COPY . $APP_HOME`)보다 변경이 적은 의존성 파일(`COPY requirements.txt .`)을 **먼저 복사**하고 설치(`RUN`)해야, 코드 변경 시마다 의존성 설치 레이어를 재빌드하는 낭비를 막을 수 있습니다.
  * **CMD/ENTRYPOINT:** 컨테이너가 시작될 때 실행되는 주 프로세스를 정의합니다. `CMD`는 실행될 기본 명령을 설정하며, `docker run` 시 덮어쓸 수 있습니다.

---

## 2\. docker-compose.yml 예시 (웹 서버 + 데이터베이스)

이 파일은 **웹 애플리케이션 컨테이너**와 **PostgreSQL 데이터베이스 컨테이너** 두 개를 하나의 서비스로 정의하는 예시입니다.

```yaml
# --------------------------------------------------------------------
# docker-compose.yml: 웹 앱 + DB 구성 예시
# --------------------------------------------------------------------
version: '3.8' # 사용하려는 Docker Compose 파일 형식 버전 지정

services:
  # 1. 웹 애플리케이션 서비스 정의
  web:
    build: .                           # 현재 디렉터리의 Dockerfile을 사용하여 이미지 빌드
    image: my-python-app:latest        # 빌드된 이미지에 이름 할당
    container_name: my_app_container   # 컨테이너에 고정 이름 할당 (선택 사항)
    
    ports:
      - "8000:8000"                    # 호스트 포트 8000을 컨테이너 포트 8000으로 매핑
    
    environment:
      # 컨테이너 내 환경 변수 설정 (예: Django 설정)
      DATABASE_URL: postgres://user:pass@db:5432/mydb
      DEBUG: "True"
    
    volumes:
      - .:/app                         # 호스트 코드 변경을 컨테이너에 실시간 반영 (개발용)
    
    depends_on:
      - db                             # 'db' 서비스가 먼저 시작되기를 기다림

  # 2. 데이터베이스 서비스 정의
  db:
    image: postgres:14-alpine          # Docker Hub에서 공식 PostgreSQL 이미지 사용
    container_name: postgres_db
    
    volumes:
      - postgres_data:/var/lib/postgresql/data/ # 데이터 영속성을 위한 볼륨 마운트
      
    environment:
      # DB 접속 정보 설정 (보안을 위해 실제 운영 환경에서는 .env 파일 사용 권장)
      POSTGRES_DB: mydb
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    
    # DB 포트 5432는 외부에 노출하지 않음 (web 서비스만 내부적으로 접근)

# 데이터 영속성을 위한 볼륨 정의
volumes:
  postgres_data:
```

### `docker-compose.yml` 작성 규칙 및 포맷

  * **YAML 형식:** 파일은 YAML(Yet Another Markup Language) 형식으로 작성되며, \*\*들여쓰기(Indentation)\*\*가 문법적으로 중요합니다. 공백 2칸 또는 4칸을 일관되게 사용해야 합니다.
  * **`version`:** Compose 파일의 버전을 명시하며, 사용할 수 있는 기능 세트를 결정합니다. `3.x` 버전을 권장합니다.
  * **`services`:** 실행하려는 개별 컨테이너를 정의하는 최상위 키입니다. 각 서비스는 독립적인 컨테이너입니다.
  * **`build` vs. `image`:**
      * `build: .` : 로컬 `Dockerfile`을 사용하여 이미지를 빌드하라는 의미입니다.
      * `image: <name>` : 이미 빌드된 이미지나 Docker Hub의 이미지를 사용하라는 의미입니다.
  * **`ports`:** 호스트 포트와 컨테이너 포트를 `HOST_PORT:CONTAINER_PORT` 형식으로 연결합니다.
  * **`volumes`:** 컨테이너가 중지/제거되어도 데이터를 유지하기 위해 영구 저장소(볼륨)를 연결하거나, 개발 중 호스트의 코드를 동기화하기 위해 현재 디렉터리를 마운트(`.:/app`)합니다.
  * **`depends_on`:** 서비스 간의 **시작 순서**를 정의합니다. (예: `web`은 `db`가 시작될 때까지 기다립니다.)