---
title: "Cloudflare Tunnel 설치 및 SSH 접속 완벽 가이드"
date: 2025-12-15T15:00:00+09:00
lastmod: 2025-12-15T15:00:00+09:00
draft: false
description: "Cloudflare Tunnel을 서비스 및 컨테이너로 설치하고, SSH 접속을 위한 완벽한 설정 방법을 알아봅니다."
tags: ["cloudflare", "cloudflared", "tunnel", "ssh", "zero-trust"]
categories: ["DevOps"]
image: "https://urinfo24.com/cdn-cgi/image/width=1200,format=auto,quality=85/https://images.urinfo24.com/featured/cloudflare-tunnel-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A modern, professional tech illustration showing Cloudflare Tunnel architecture.
- Style: Clean, professional network diagram with flat design elements
- Subject: Server connected to Cloudflare cloud network, with secure tunnel visualization
- Elements: Server icon, Cloudflare logo and cloud, encrypted tunnel with data flow, client devices (laptop, mobile), dashboard interface mockup
- Colors: Cloudflare orange (#F38020), blue (#3B82F6) for secure connections, white/gray for infrastructure, subtle gradients
- Mood: Secure, enterprise-grade, reliable, modern cloud architecture
- Composition: Server on left, Cloudflare cloud in center with tunnel flowing through it, multiple client devices on right side
- Additional: Lock icons for security, "cloudflared" daemon symbol, SSH terminal window in corner

Technical keywords: Cloudflare Tunnel, Zero Trust, cloudflared, secure access, reverse proxy, edge network

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/cloudflare-tunnel-featured.jpg

NOTE: Hugo will serve this from /images/cloudflare-tunnel-featured.jpg
-->

## 1. Cloudflare Tunnel이란?

Cloudflare Tunnel(이전 명칭: Argo Tunnel)은 서버에서 Cloudflare 네트워크로 아웃바운드 연결을 생성하여, 인바운드 포트를 열지 않고도 안전하게 서비스를 노출할 수 있는 솔루션입니다.

### 1.1 주요 특징

Cloudflare Tunnel의 핵심 장점:

- 인바운드 방화벽 포트 개방 불필요
- DDoS 보호 자동 적용
- Cloudflare의 글로벌 네트워크 활용
- Zero Trust 보안 모델 적용
- 무료 플랜 제공 (합리적인 사용량 내)

### 1.2 작동 원리

```
서버(cloudflared) → Cloudflare Edge → 클라이언트
     (아웃바운드)      (글로벌 네트워크)    (접속)
```

주요 구성 요소:
- **cloudflared**: 서버에서 실행되는 경량 데몬
- **Tunnel**: Cloudflare Edge와 서버 간의 안전한 연결
- **DNS**: Cloudflare DNS를 통한 라우팅

### 1.3 사용 시나리오

Cloudflare Tunnel이 유용한 경우:

- 홈 서버나 개발 서버를 외부에 안전하게 노출
- 공용 IP 없이 웹 서비스 제공
- SSH, RDP 등 관리 서비스 보안 접속
- 마이크로서비스 간 안전한 통신

## 2. Cloudflare 계정 및 준비

### 2.1 Cloudflare 계정 생성

1. [Cloudflare](https://www.cloudflare.com/) 접속
2. 무료 계정 생성
3. 도메인 추가 (선택사항, Tunnel만 사용 시 불필요)

### 2.2 Zero Trust 대시보드 접근

1. Cloudflare Dashboard 로그인
2. 좌측 메뉴에서 **Zero Trust** 선택
3. **Access** → **Tunnels** 메뉴로 이동

### 2.3 필수 정보 확인

Tunnel 생성에 필요한 정보:
- Cloudflare 계정 이메일
- Zone ID (도메인 사용 시)
- Tunnel Token (설치 시 자동 생성)

## 3. cloudflared 설치 방법

### 3.1 Linux 서비스로 설치

Ubuntu/Debian:

```bash
# cloudflared 다운로드 및 설치
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb

# 설치 확인
cloudflared --version
```

CentOS/RHEL:

```bash
# cloudflared 다운로드 및 설치
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.rpm
sudo rpm -i cloudflared-linux-amd64.rpm

# 설치 확인
cloudflared --version
```

Binary 직접 설치 (모든 Linux):

```bash
# 바이너리 다운로드
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
sudo mv cloudflared-linux-amd64 /usr/local/bin/cloudflared
sudo chmod +x /usr/local/bin/cloudflared

# 설치 확인
cloudflared --version
```

### 3.2 Docker 컨테이너로 설치

Docker Compose를 사용한 설치:

`docker-compose.yml` 파일 생성:

```yaml
version: '3.8'

services:
  cloudflared:
    image: cloudflare/cloudflared:latest
    container_name: cloudflared-tunnel
    restart: unless-stopped
    command: tunnel --no-autoupdate run --token ${TUNNEL_TOKEN}
    environment:
      - TUNNEL_TOKEN=${TUNNEL_TOKEN}
    network_mode: host
```

`.env` 파일 생성:

```bash
TUNNEL_TOKEN=your-tunnel-token-here
```

컨테이너 실행:

```bash
docker-compose up -d
```


Docker CLI 사용:

```bash
docker run -d \
  --name cloudflared-tunnel \
  --restart unless-stopped \
  cloudflare/cloudflared:latest \
  tunnel --no-autoupdate run --token YOUR_TUNNEL_TOKEN
```

### 3.3 설치 방법 비교

| 방법 | 장점 | 단점 | 추천 |
|------|------|------|------|
| 서비스 | 시스템 통합, 쉬운 관리 | 시스템 권한 필요 | 프로덕션 |
| 컨테이너 | 격리, 이식성, 쉬운 업데이트 | Docker 필요 | 개발/컨테이너 환경 |

## 4. Cloudflare Dashboard 설정

### 4.1 Tunnel 생성

1. Zero Trust Dashboard 접속
2. **Access** → **Tunnels** → **Create a tunnel**
3. Tunnel 이름 입력 (예: `my-server-tunnel`)
4. **Next** 클릭

### 4.2 Connector 설치

Dashboard에서 제공하는 설치 명령어 확인:

서비스 설치:
```bash
sudo cloudflared service install YOUR_TUNNEL_TOKEN
```

Docker 설치:
```bash
docker run cloudflare/cloudflared:latest tunnel --no-autoupdate run --token YOUR_TUNNEL_TOKEN
```

### 4.3 Public Hostname 설정

웹 서비스 노출을 위한 설정:

1. Tunnel 생성 후 **Public Hostname** 탭 선택
2. **Add a public hostname** 클릭
3. 설정 입력:
   - Subdomain: `app` (예시)
   - Domain: `example.com`
   - Service: `http://localhost:3000`
4. **Save hostname** 클릭

예시 설정:
```
Hostname: app.example.com
Service: http://localhost:3000
```

## 5. SSH 접속 설정

### 5.1 서버 측 SSH 설정

SSH를 Tunnel을 통해 노출:

Dashboard에서 Private Network 설정:

1. Tunnel 페이지에서 **Private Networks** 탭
2. **Add a private network** 클릭
3. CIDR 입력: `10.0.0.0/24` (서버의 내부 네트워크)
4. **Save** 클릭

또는 CLI로 직접 설정:

`config.yml` 파일 생성 (`~/.cloudflared/config.yml`):

```yaml
tunnel: YOUR_TUNNEL_ID
credentials-file: /home/user/.cloudflared/YOUR_TUNNEL_ID.json

ingress:
  - hostname: ssh.example.com
    service: ssh://localhost:22
  - service: http_status:404
```

Tunnel 실행:

```bash
cloudflared tunnel run
```

### 5.2 클라이언트 측 cloudflared 설치

클라이언트(접속하는 컴퓨터)에도 cloudflared 설치:

Ubuntu/Debian:
```bash
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb
```

Windows:
```powershell
# Chocolatey 사용
choco install cloudflared

# 또는 직접 다운로드
# https://github.com/cloudflare/cloudflared/releases
```

macOS:
```bash
brew install cloudflare/cloudflare/cloudflared
```

### 5.3 SSH ProxyCommand 설정

`~/.ssh/config` 파일 설정:

```
Host my-server
    HostName ssh.example.com
    User freein
    ProxyCommand cloudflared access ssh --hostname %h
```

또는 Tunnel ID 직접 사용:

```
Host my-server
    HostName YOUR_TUNNEL_ID.cfargotunnel.com
    User freein
    ProxyCommand cloudflared access ssh --hostname %h
```

### 5.4 SSH 접속

설정 완료 후 접속:

```bash
ssh my-server
```

첫 접속 시 Cloudflare 로그인 브라우저 창이 열립니다:
1. Cloudflare 계정으로 로그인
2. 접근 허가
3. SSH 세션 자동 연결

## 6. Zero Trust Access 정책

### 6.1 Access Application 생성

보안 강화를 위한 접근 정책:

1. Zero Trust Dashboard → **Access** → **Applications**
2. **Add an application** → **Self-hosted**
3. 설정:
   - Application name: `SSH Access`
   - Session Duration: `24 hours`
   - Application domain: `ssh.example.com`

### 6.2 Access Policy 설정

누가 접속할 수 있는지 정의:

```
Policy name: Allow Admins
Action: Allow
Include:
  - Emails: admin@example.com, user@example.com
```

또는 그룹 기반:

```
Policy name: Allow DevOps Team
Action: Allow
Include:
  - Email domain: @company.com
  - Groups: DevOps
```

### 6.3 추가 보안 설정

다중 인증 요구:

```
Policy name: Require MFA
Action: Allow
Include:
  - Everyone
Require:
  - Authentication method: Multi-factor authentication
```

## 7. 고급 활용

### 7.1 Multiple Services 설정

여러 서비스를 하나의 Tunnel로 제공:

```yaml
tunnel: YOUR_TUNNEL_ID
credentials-file: /home/user/.cloudflared/YOUR_TUNNEL_ID.json

ingress:
  - hostname: ssh.example.com
    service: ssh://localhost:22
  - hostname: web.example.com
    service: http://localhost:3000
  - hostname: api.example.com
    service: http://localhost:8080
  - service: http_status:404
```

### 7.2 로드 밸런싱

여러 서버로 트래픽 분산:

```yaml
ingress:
  - hostname: app.example.com
    service: hello-world
    originRequest:
      connectTimeout: 30s
      noTLSVerify: true
  - hostname: api.example.com
    service: http://backend-pool
    originRequest:
      loadBalancer:
        pool:
          - http://server1:8080
          - http://server2:8080
  - service: http_status:404
```

### 7.3 헬스체크 설정

서비스 상태 모니터링:

```yaml
ingress:
  - hostname: app.example.com
    service: http://localhost:3000
    originRequest:
      httpHostHeader: app.example.com
      connectTimeout: 30s
      keepAliveTimeout: 90s
      proxyType: ""
  - service: http_status:404
```

### 7.4 자동 재시작 설정

systemd 서비스로 등록 (Linux):

```bash
# 서비스 파일 생성
sudo cloudflared service install

# 서비스 시작
sudo systemctl start cloudflared

# 부팅 시 자동 시작
sudo systemctl enable cloudflared

# 상태 확인
sudo systemctl status cloudflared
```

Docker 자동 재시작:

```yaml
services:
  cloudflared:
    image: cloudflare/cloudflared:latest
    restart: always  # 또는 unless-stopped
    command: tunnel --no-autoupdate run --token ${TUNNEL_TOKEN}
```

## 8. 모니터링 및 문제 해결

### 8.1 Tunnel 상태 확인

현재 실행 중인 Tunnel 확인:

```bash
# Tunnel 목록
cloudflared tunnel list

# 특정 Tunnel 정보
cloudflared tunnel info YOUR_TUNNEL_NAME

# Tunnel 연결 상태
cloudflared tunnel route ip show
```

### 8.2 로그 확인

서비스 로그:

```bash
# systemd 서비스 로그
sudo journalctl -u cloudflared -f

# Docker 컨테이너 로그
docker logs -f cloudflared-tunnel
```

### 8.3 일반적인 문제 해결

**문제 1: Tunnel이 연결되지 않음**

확인 사항:
- Token이 올바른지 확인
- 방화벽에서 아웃바운드 443 포트 허용 확인
- cloudflared 서비스 상태 확인

```bash
# 서비스 재시작
sudo systemctl restart cloudflared

# 로그 확인
sudo journalctl -u cloudflared -n 50
```

**문제 2: SSH 접속 시 인증 실패**


해결 방법:
- 브라우저에서 Cloudflare 로그인 확인
- Access Policy 설정 확인
- 클라이언트 cloudflared 버전 확인

```bash
# cloudflared 업데이트
sudo cloudflared update

# SSH 디버그 모드
ssh -v my-server
```

**문제 3: 느린 연결 속도**

최적화:
- 가장 가까운 Cloudflare 데이터센터 활용 (자동)
- HTTP/2 사용 (기본 활성화)
- 압축 활성화

```yaml
ingress:
  - hostname: app.example.com
    service: http://localhost:3000
    originRequest:
      noTLSVerify: false
      http2Origin: true
      disableChunkedEncoding: false
```

**문제 4: 컨테이너가 자주 재시작됨**

확인 사항:
- Docker 로그 확인
- 메모리/CPU 리소스 확인
- Tunnel Token 유효성 확인

```bash
# 컨테이너 리소스 사용량
docker stats cloudflared-tunnel

# 상세 로그
docker logs cloudflared-tunnel --tail 100
```

### 8.4 성능 최적화

네트워크 설정 최적화:

```yaml
ingress:
  - hostname: app.example.com
    service: http://localhost:3000
    originRequest:
      connectTimeout: 30s
      tcpKeepAlive: 30s
      keepAliveTimeout: 90s
      keepAliveConnections: 100
```

## 9. 보안 모범 사례

### 9.1 최소 권한 원칙

필요한 서비스만 노출:

```yaml
ingress:
  # SSH는 특정 IP만 허용
  - hostname: ssh.example.com
    service: ssh://localhost:22
  # 웹은 공개
  - hostname: web.example.com
    service: http://localhost:3000
  - service: http_status:404
```

### 9.2 정기적인 Tunnel Token 갱신

보안을 위한 Token 재생성:

```bash
# 새 Tunnel 생성
cloudflared tunnel create new-tunnel

# 기존 Tunnel 삭제
cloudflared tunnel delete old-tunnel
```

### 9.3 액세스 로그 모니터링

Cloudflare Dashboard에서 접근 로그 확인:
- Zero Trust → Logs → Access
- 비정상 접근 패턴 감지
- 알림 설정

### 9.4 네트워크 분리

중요 서비스는 별도 Tunnel 사용:

```bash
# 프로덕션 Tunnel
cloudflared tunnel create prod-tunnel

# 개발 Tunnel
cloudflared tunnel create dev-tunnel

# 관리 Tunnel (SSH)
cloudflared tunnel create admin-tunnel
```

## 10. 실전 활용 예제

### 10.1 홈랩 서버 노출

시나리오:
- 집에 있는 NAS와 홈 서버
- 외부에서 안전하게 접속 필요

설정:

```yaml
tunnel: home-lab
credentials-file: /root/.cloudflared/home-lab.json

ingress:
  - hostname: nas.mydomain.com
    service: http://192.168.1.100:5000
  - hostname: homeassistant.mydomain.com
    service: http://192.168.1.101:8123
  - hostname: ssh.mydomain.com
    service: ssh://localhost:22
  - service: http_status:404
```

### 10.2 개발 환경 공유

시나리오:
- 로컬 개발 서버를 팀원과 공유
- 임시로 외부 접속 필요

빠른 설정:

```bash
# 퀵 Tunnel (임시)
cloudflared tunnel --url http://localhost:3000
```

결과: `https://random-name.trycloudflare.com` 자동 생성

### 10.3 마이크로서비스 아키텍처

시나리오:
- 여러 마이크로서비스 운영
- 단일 진입점으로 접근

설정:

```yaml
ingress:
  - hostname: api.example.com
    service: http://api-gateway:8080
    originRequest:
      httpHostHeader: api.example.com
  - hostname: auth.example.com
    service: http://auth-service:3000
  - hostname: users.example.com
    service: http://user-service:4000
  - hostname: orders.example.com
    service: http://order-service:5000
  - service: http_status:404
```

## 11. 정리

Cloudflare Tunnel을 활용하면 인바운드 포트 개방 없이 안전하게 서비스와 SSH 접속을 제공할 수 있습니다.

핵심 포인트:
- 인바운드 방화벽 규칙 불필요 (아웃바운드만 사용)
- Cloudflare의 글로벌 네트워크와 DDoS 보호 자동 적용
- Zero Trust 모델로 세밀한 접근 제어 가능
- 서비스 및 컨테이너 두 가지 설치 방식 지원
- SSH, HTTP, TCP 등 다양한 프로토콜 지원

비교 정리:

| 항목 | Cloudflare Tunnel | 전통적 VPN |
|------|-------------------|-----------|
| 포트 개방 | 불필요 | 필요 |
| DDoS 보호 | 자동 제공 | 별도 설정 |
| 설정 난이도 | 쉬움 | 중간~어려움 |
| 확장성 | 우수 | 제한적 |
| 비용 | 무료~저렴 | 서버 비용 |

추가 리소스:
- Cloudflare Tunnel 공식 문서: [https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)
- Zero Trust 가이드: [https://www.cloudflare.com/zero-trust/](https://www.cloudflare.com/zero-trust/)
- Community Forum: [https://community.cloudflare.com/](https://community.cloudflare.com/)
