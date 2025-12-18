---
title: "Vultr Firewall 완벽 가이드: 클라우드 서버 보안 설정 방법"
date: 2025-12-16T16:00:00+09:00
lastmod: 2025-12-16T16:00:00+09:00
draft: false
description: "Vultr의 웹 기반 방화벽 기능을 활용한 클라우드 서버 보안 설정 방법. Firewall Group 생성부터 실전 활용까지 완벽 가이드."
tags: ["vultr", "firewall", "방화벽", "서버보안", "vps", "클라우드보안", "인프라"]
categories: ["클라우드"]
image: "https://images.urinfo24.com/featured/vultr-firewall-setup-guide-featured.jpg"
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

## 1. Vultr Firewall이란?

Vultr Firewall은 웹 기반 방화벽 서비스다.
클라우드 인스턴스에 트래픽이 도달하기 전에 패킷을 필터링한다.

### 1.1 왜 필요한가?

서버 보안은 다층 방어가 기본이다.
호스트 방화벽(UFW, firewalld)만으로는 부족하다.

Vultr Firewall은 네트워크 레벨에서 작동한다.
따라서 악의적인 트래픽이 서버에 도달하기 전에 차단된다.

### 1.2 호스트 방화벽과의 차이

**호스트 방화벽 (UFW, firewalld):**
- 서버 OS 내부에서 작동
- 트래픽이 서버에 도달한 후 필터링
- CPU/메모리 리소스 사용

**Vultr Firewall:**
- Vultr 네트워크 레벨에서 작동
- 트래픽이 서버에 도달하기 전 차단
- 서버 리소스 영향 없음

따라서 두 가지를 함께 사용하는 것이 가장 안전하다.

### 1.3 Firewall Group 개념

Vultr Firewall은 그룹 단위로 관리된다.
하나의 Firewall Group에 여러 규칙을 추가한다.
그리고 이 그룹을 여러 인스턴스에 적용할 수 있다.

예를 들어:
- 웹 서버용 그룹: HTTP/HTTPS 허용
- DB 서버용 그룹: 특정 IP에서만 DB 포트 허용
- 개발 서버용 그룹: SSH만 허용


## 2. Firewall Group 생성하기

### 2.1 포털에서 생성

Vultr Customer Portal에 로그인한다.

1. **Products → Network → Firewall** 메뉴로 이동
2. **Add Firewall** 버튼 클릭
3. **Description** 필드에 그룹 이름 입력
4. **Add Firewall Group** 버튼 클릭

그룹이 생성됐다.
하지만 아직 규칙이 없는 빈 그룹이다.

### 2.2 API로 생성

API를 사용하면 자동화가 가능하다.

```bash
curl "https://api.vultr.com/v2/firewalls" \
  -X POST \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "description": "web-server-firewall"
  }'
```

응답으로 Firewall Group ID를 받는다.
이 ID를 기억해두자.

### 2.3 Terraform으로 관리

인프라를 코드로 관리한다면 Terraform을 사용한다.

```hcl
resource "vultr_firewall_group" "web" {
  description = "Web Server Firewall"
}
```

코드로 관리하면 버전 관리가 가능하다.
팀원들과 협업할 때도 편리하다.

## 3. 방화벽 규칙 설정

### 3.1 기본 규칙 추가

Firewall Group을 클릭해서 규칙 관리 화면으로 들어간다.

**IPv4 Rule 추가:**
- Protocol: TCP
- Port: 80
- Source: Anywhere (0.0.0.0/0)

이렇게 하면 모든 곳에서 HTTP 접근이 가능하다.

### 3.2 SSH 접근 제한

SSH는 특정 IP에서만 접근 가능하게 한다.

**IPv4 Rule:**
- Protocol: TCP
- Port: 22
- Source: 123.45.67.89 (내 IP)

이제 내 IP에서만 SSH 접근이 가능하다.
다른 IP에서는 차단된다.

### 3.3 여러 포트 한번에 열기

웹 서버는 HTTP와 HTTPS를 모두 열어야 한다.

**규칙 1 - HTTP:**
```
Protocol: TCP
Port: 80
Source: 0.0.0.0/0
```

**규칙 2 - HTTPS:**
```
Protocol: TCP
Port: 443
Source: 0.0.0.0/0
```

### 3.4 API로 규칙 추가

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

자동화 스크립트에서 유용하다.

### 3.5 Terraform 규칙 정의

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

## 4. 인스턴스에 연결하기

### 4.1 포털에서 연결

규칙을 만들었으면 인스턴스에 적용해야 한다.

1. **Products → Compute** 메뉴로 이동
2. 대상 인스턴스 클릭
3. **Settings → Firewall** 메뉴
4. Firewall 드롭다운에서 그룹 선택
5. **Update Firewall Group** 버튼 클릭

즉시 적용된다.

### 4.2 여러 인스턴스에 적용

같은 역할의 서버가 여러 대라면?
각 인스턴스에 같은 Firewall Group을 적용하면 된다.

예를 들어:
- 웹 서버 3대
- 모두 같은 방화벽 규칙 필요

따라서 하나의 Firewall Group을 3대 모두에 적용한다.
규칙을 수정하면 3대 모두에 즉시 반영된다.

### 4.3 API로 연결

```bash
curl "https://api.vultr.com/v2/instances/{instance-id}" \
  -X PATCH \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "firewall_group_id": "{firewall-id}"
  }'
```

자동 배포 스크립트에서 사용한다.

### 4.4 Terraform으로 관리

```hcl
resource "vultr_instance" "web" {
  region             = "sea"
  plan               = "vc2-1c-1gb"
  os_id              = 1743  # Ubuntu 22.04
  label              = "web-server-01"
  firewall_group_id  = vultr_firewall_group.web.id
}
```

인스턴스 생성과 동시에 방화벽을 적용한다.

## 5. 실전 사용 예시

### 5.1 웹 서버 보호

웹 서버는 HTTP, HTTPS, SSH만 열면 된다.

```hcl
resource "vultr_firewall_group" "web" {
  description = "Web Server Firewall"
}

resource "vultr_firewall_rule" "web_ssh" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  port              = "22"
  ip_type           = "v4"
  subnet            = "123.45.67.89"  # 내 IP만
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

다른 모든 포트는 자동으로 차단된다.

### 5.2 데이터베이스 서버

DB 서버는 웹 서버에서만 접근 가능해야 한다.

```hcl
resource "vultr_firewall_rule" "db_from_web" {
  firewall_group_id = vultr_firewall_group.db.id
  protocol          = "tcp"
  port              = "5432"  # PostgreSQL
  ip_type           = "v4"
  subnet            = "192.168.1.10"  # 웹 서버 private IP
  subnet_size       = 32
}
```

Public IP로는 DB에 접근할 수 없다.
Private Network를 통해서만 가능하다.

### 5.3 Load Balancer와 연계

Load Balancer를 사용한다면?
웹 서버는 Load Balancer에서만 트래픽을 받아야 한다.

**규칙 설정:**
- Protocol: TCP
- Port: 80
- Source: Load Balancer (LB ID 입력)

이렇게 하면 Load Balancer를 우회한 직접 접근이 차단된다.

## 6. 보안 모범 사례

### 6.1 기본 정책: Deny All

Vultr Firewall의 기본 정책은 "모두 차단"이다.
따라서 명시적으로 허용한 트래픽만 통과한다.

이것이 올바른 방식이다.
필요한 것만 열어야 한다.

### 6.2 최소 권한 원칙

SSH는 모든 IP에서 열면 안 된다.
브루트포스 공격의 표적이 된다.

따라서 특정 IP만 허용한다:
- 사무실 IP
- VPN IP
- 집 IP

### 6.3 이중 방어

Vultr Firewall만으로 충분할까?
아니다. 호스트 방화벽도 함께 사용해야 한다.

**방어 계층:**
1. Vultr Firewall (네트워크 레벨)
2. 호스트 방화벽 (OS 레벨)
3. 애플리케이션 방화벽 (앱 레벨)

따라서 UFW나 firewalld도 설정한다.

### 6.4 프로덕션 적용 전 테스트

방화벽 설정을 잘못하면?
서비스가 중단된다. ㅠ.ㅠ

따라서 반드시:
1. 개발 환경에서 테스트
2. 스테이징 환경에서 검증
3. 프로덕션에 적용

### 6.5 정기적인 규칙 검토

한번 설정하고 끝이 아니다.
정기적으로 규칙을 검토한다:

- 불필요한 규칙 삭제
- 더 이상 사용하지 않는 IP 제거
- 새로운 보안 요구사항 반영

## 7. 트러블슈팅

### 7.1 연결이 안 될 때

SSH나 웹 접속이 안 된다면?

**체크리스트:**
1. Firewall Group이 인스턴스에 연결됐는가?
2. 해당 포트를 허용하는 규칙이 있는가?
3. Source IP가 올바른가?
4. 호스트 방화벽도 확인

### 7.2 규칙 적용 시간

Firewall Group 변경은 즉시 적용된다.
하지만 네트워크 전파에 몇 초 걸릴 수 있다.

연결 테스트는 10-20초 후에 해보자.

### 7.3 로그 확인

Vultr Firewall 자체는 로그를 제공하지 않는다.
따라서 호스트 방화벽 로그를 확인해야 한다.

**UFW 로그:**
```bash
sudo tail -f /var/log/ufw.log
```

**Firewalld 로그:**
```bash
sudo journalctl -u firewalld -f
```

### 7.4 규칙 우선순위

Vultr Firewall은 규칙 순서가 없다.
모든 규칙이 OR 조건으로 작동한다.

즉, 하나라도 매칭되면 허용된다.

## 8. CLI와 자동화

### 8.1 Vultr CLI 설치

```bash
# macOS
brew install vultr/vultr-cli/vultr-cli

# Linux
curl -L https://github.com/vultr/vultr-cli/releases/latest/download/vultr-cli-linux-amd64.tar.gz | tar xz
sudo mv vultr-cli /usr/local/bin/
```

API Key를 설정한다:
```bash
export VULTR_API_KEY="your-api-key"
```

### 8.2 Firewall Group 관리

**그룹 목록:**
```bash
vultr-cli firewall group list
```

**그룹 생성:**
```bash
vultr-cli firewall group create --description "Web Server"
```

**규칙 추가:**
```bash
vultr-cli firewall rule create \
  --firewall-group-id <id> \
  --protocol tcp \
  --port 80 \
  --ip-type v4 \
  --subnet 0.0.0.0 \
  --subnet-size 0
```

### 8.3 배포 자동화

새 인스턴스를 배포할 때 자동으로 방화벽을 적용한다:

```bash
#!/bin/bash

# 인스턴스 생성
INSTANCE_ID=$(vultr-cli instance create \
  --region sea \
  --plan vc2-1c-1gb \
  --os 1743 \
  --label web-server \
  --output json | jq -r '.id')

# Firewall 적용
vultr-cli instance update-firewall-group \
  --instance-id $INSTANCE_ID \
  --firewall-group-id $FIREWALL_ID

echo "Instance $INSTANCE_ID deployed with firewall"
```

## 9. 비용 및 제한사항

### 9.1 비용

Vultr Firewall은 **완전 무료**다.
추가 비용이 전혀 없다.

따라서 모든 인스턴스에 적용하는 것을 권장한다.

### 9.2 제한사항

**Firewall Group:**
- 계정당 최대 50개

**규칙:**
- 그룹당 최대 50개 규칙

대부분의 경우 충분하다.
더 필요하면 서포트에 문의한다.

### 9.3 Load Balancer Firewall과의 차이

Vultr Load Balancer에는 별도의 방화벽이 있다.
두 가지는 다르다:

**Vultr Firewall:**
- 인스턴스 보호
- 네트워크 레벨 필터링

**Load Balancer Firewall:**
- Load Balancer 보호
- LB로 들어오는 트래픽 필터링

따라서 Load Balancer를 사용한다면 두 가지 모두 설정한다.

## 10. 정리

### 10.1 Vultr Firewall의 장점

- 무료
- 네트워크 레벨 보호
- 여러 인스턴스에 쉽게 적용
- API/CLI/Terraform 지원
- 서버 리소스 사용 없음

### 10.2 언제 사용하는가?

**반드시 사용:**
- 프로덕션 서버
- 공개 서비스
- 민감한 데이터 처리

**선택적 사용:**
- 개발/테스트 환경
- Private Network만 사용하는 서버

하지만 가능하면 모든 인스턴스에 적용하자.

### 10.3 추가 보안 강화

Vultr Firewall 외에도:
- Fail2ban 설치 (브루트포스 차단)
- SSH Key 인증 사용
- 정기적인 보안 업데이트
- DDoS Protection 활성화

여러 계층의 보안이 필요하다.

### 10.4 참고 자료

- [Vultr Firewall 공식 문서](https://docs.vultr.com/products/network/firewall)
- [Vultr API 문서](https://www.vultr.com/api/)
- [Vultr CLI GitHub](https://github.com/vultr/vultr-cli)
- [Terraform Vultr Provider](https://registry.terraform.io/providers/vultr/vultr/latest/docs)

Vultr Firewall을 활용하면 클라우드 서버를 안전하게 보호할 수 있다.
무료이고 사용하기 쉽다.
따라서 지금 바로 설정해보자.
