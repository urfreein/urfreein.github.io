---
title: "Tailscale을 이용한 안전한 SSH 접속 방법"
date: 2025-12-15T14:30:00+09:00
lastmod: 2025-12-15T14:30:00+09:00
draft: false
description: "방화벽을 우회하여 어디서든 안전하게 서버에 SSH 접속하는 방법. Tailscale 설치부터 설정까지 완벽 가이드."
tags: ["tailscale", "ssh", "vpn", "zero-trust", "remote-access"]
categories: ["DevOps"]
image: "https://urinfo24.com/cdn-cgi/image/width=1200,format=auto,quality=85/https://images.urinfo24.com/featured/tailscale-ssh-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A modern, professional tech illustration showing secure SSH connection through Tailscale VPN.
- Style: Clean, professional network diagram with flat design elements
- Subject: Two computers (laptop and server) connected through a secure VPN tunnel with Tailscale logo
- Elements: SSH terminal window, encrypted tunnel visualization, lock icons, network nodes, firewall shield being bypassed
- Colors: Tailscale purple/blue (#4B4DED), green for secure connections, dark gray for devices, white background
- Mood: Secure, professional, trustworthy, modern
- Composition: Devices on left and right, encrypted tunnel in center with flowing data packets, firewall in background showing blocked direct connection but allowed VPN path
- Additional: Small code snippets or terminal prompts, "SSH" text, padlock symbols

Technical keywords: Tailscale, SSH, VPN, zero-trust networking, secure remote access, WireGuard

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/tailscale-ssh-featured.jpg

NOTE: Hugo will serve this from /images/tailscale-ssh-featured.jpg
-->

## 1. Tailscale이란?

Tailscale은 WireGuard 기반의 제로 트러스트 네트워크 솔루션으로, 방화벽이나 NAT 환경에서도 안전한 원격 접속을 제공합니다.

### 1.1 왜 Tailscale인가?

기존의 SSH 접속 방식은 다음과 같은 문제점이 있습니다:

- 공개 포트 노출로 인한 무차별 공격 위험
- 복잡한 방화벽 규칙 설정 필요
- VPN 서버 구축 및 유지보수 부담
- NAT 환경에서의 접속 어려움

Tailscale은 이러한 문제를 다음과 같이 해결합니다:

- 제로 트러스트 아키텍처로 안전성 확보
- 자동 NAT 트래버설
- 중앙 집중식 관리
- 간편한 설치 및 설정

### 1.2 작동 원리

Tailscale은 각 장치에 가상 IP 주소를 할당하고, WireGuard 프로토콜을 사용하여 암호화된 터널을 생성합니다:

```
클라이언트 → Tailscale 네트워크 → 대상 서버
  (암호화)     (100.x.x.x 대역)     (SSH 접속)
```

## 2. Tailscale 설치

### 2.1 Linux 서버 설치

Ubuntu/Debian 기반:

```bash
# Tailscale GPG 키 및 저장소 추가
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

# 설치
sudo apt-get update
sudo apt-get install tailscale

# Tailscale 시작 및 인증
sudo tailscale up
```

CentOS/RHEL 기반:

```bash
# Tailscale 저장소 추가
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://pkgs.tailscale.com/stable/rhel/tailscale.repo

# 설치
sudo yum install tailscale

# Tailscale 시작 및 인증
sudo systemctl enable --now tailscaled
sudo tailscale up
```

### 2.2 Windows 클라이언트 설치

1. 공식 웹사이트에서 설치 파일 다운로드: [https://tailscale.com/download/windows](https://tailscale.com/download/windows)
2. 설치 프로그램 실행
3. Tailscale 계정으로 로그인
4. 시스템 트레이에서 Tailscale 아이콘 확인

### 2.3 macOS 클라이언트 설치


Homebrew 사용:

```bash
brew install tailscale
```

또는 공식 웹사이트에서 다운로드: [https://tailscale.com/download/mac](https://tailscale.com/download/mac)

## 3. SSH 접속 설정

### 3.1 서버에서 SSH 활성화

Tailscale이 설치된 후, SSH 접속을 위한 추가 설정을 진행합니다:

```bash
# SSH 서비스 상태 확인
sudo systemctl status sshd

# SSH 서비스가 비활성화되어 있다면 활성화
sudo systemctl enable --now sshd

# Tailscale IP 확인
tailscale ip -4
```

출력 예시:
```
100.101.102.103
```

### 3.2 방화벽 설정 (선택사항)

Tailscale 네트워크에서만 SSH 접속을 허용하려면:

Ubuntu/Debian:
```bash
# UFW 방화벽 설정
sudo ufw allow from 100.64.0.0/10 to any port 22
sudo ufw enable
```

CentOS/RHEL (firewalld):
```bash
# Tailscale 네트워크에서만 SSH 허용
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="100.64.0.0/10" port protocol="tcp" port="22" accept'
sudo firewall-cmd --reload
```

### 3.3 클라이언트에서 SSH 접속

Tailscale IP를 사용하여 접속:

```bash
# 기본 접속
ssh username@100.101.102.103

# 포트 지정 (기본값이 아닌 경우)
ssh -p 2222 username@100.101.102.103

# SSH 키 사용
ssh -i ~/.ssh/id_rsa username@100.101.102.103
```

### 3.4 SSH 설정 파일 구성

편리한 접속을 위해 `~/.ssh/config` 파일 설정:

```
Host my-server
    HostName 100.101.102.103
    User freein
    IdentityFile ~/.ssh/id_rsa
    Port 22

Host prod-server
    HostName 100.101.102.104
    User admin
    IdentityFile ~/.ssh/prod_key
    Port 22
```

이제 간단하게 접속 가능:

```bash
ssh my-server
```

## 4. 고급 설정 및 팁

### 4.1 Tailscale SSH 기능 활성화

Tailscale은 자체 SSH 기능을 제공합니다:

```bash
# Tailscale SSH 활성화 (서버에서)
sudo tailscale up --ssh

# 클라이언트에서 접속 (자동 인증)
ssh freein@my-server
```

장점:
- 비밀번호나 SSH 키 불필요
- Tailscale 계정으로 자동 인증
- ACL을 통한 세밀한 접근 제어

### 4.2 MagicDNS 활성화

IP 주소 대신 호스트명으로 접속:

1. Tailscale Admin Console 접속: [https://login.tailscale.com/admin/dns](https://login.tailscale.com/admin/dns)
2. MagicDNS 활성화
3. 호스트명으로 접속:

```bash
# IP 대신 호스트명 사용
ssh username@my-server-name

# 예시
ssh freein@prod-webserver
```

### 4.3 ACL(접근 제어 목록) 설정

Tailscale Admin Console에서 세밀한 접근 제어:

```json
{
  "acls": [
    {
      "action": "accept",
      "src": ["group:developers"],
      "dst": ["tag:production:22"]
    },
    {
      "action": "accept",
      "src": ["user@example.com"],
      "dst": ["*:*"]
    }
  ]
}
```

### 4.4 멀티플랫폼 접속

Windows에서 Linux 서버 접속:

```powershell
# PowerShell에서
ssh username@100.101.102.103

# PuTTY 사용
# Host Name: 100.101.102.103
# Port: 22
# Connection Type: SSH
```

## 5. 보안 강화 방법

### 5.1 SSH 키 기반 인증

비밀번호 인증 비활성화:

```bash
# SSH 키 생성 (클라이언트에서)
ssh-keygen -t ed25519 -C "your-email@example.com"

# 공개 키를 서버에 복사
ssh-copy-id username@100.101.102.103

# 서버에서 비밀번호 인증 비활성화
sudo vi /etc/ssh/sshd_config
```

`/etc/ssh/sshd_config` 파일 수정:

```
PasswordAuthentication no
PubkeyAuthentication yes
```

SSH 서비스 재시작:

```bash
sudo systemctl restart sshd
```

### 5.2 Fail2ban 설정

무차별 대입 공격 방지:

```bash
# Fail2ban 설치
sudo apt-get install fail2ban

# 설정 파일 생성
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# SSH 보호 활성화
sudo vi /etc/fail2ban/jail.local
```

설정 내용:

```ini
[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
```

Fail2ban 시작:

```bash
sudo systemctl enable --now fail2ban
sudo fail2ban-client status sshd
```

### 5.3 Tailscale 키 만료 설정

자동 키 만료로 보안 강화:

1. Tailscale Admin Console 접속
2. Machines 메뉴에서 장치 선택
3. Key expiry 설정 (기본 180일)
4. 필요시 키 갱신:

```bash
sudo tailscale up --force-reauth
```

## 6. 실전 시나리오

### 6.1 시나리오 1: 회사 서버 원격 관리

상황:
- 회사 방화벽이 인바운드 SSH 차단
- 집에서 서버에 접속 필요

해결책:

```bash
# 회사 서버에 Tailscale 설치
sudo apt-get install tailscale
sudo tailscale up

# 집 컴퓨터에서 Tailscale 설치 및 접속
tailscale ip -4  # 서버 IP 확인
ssh admin@100.101.102.103
```

### 6.2 시나리오 2: 여러 서버 관리

상황:
- 개발, 스테이징, 프로덕션 서버 관리
- 각 서버마다 다른 접근 권한 필요

해결책:

`~/.ssh/config` 설정:

```
Host dev-server
    HostName 100.101.102.103
    User developer
    IdentityFile ~/.ssh/dev_key

Host staging-server
    HostName 100.101.102.104
    User deployer
    IdentityFile ~/.ssh/staging_key

Host prod-server
    HostName 100.101.102.105
    User admin
    IdentityFile ~/.ssh/prod_key
    Port 2222
```


접속:

```bash
ssh dev-server      # 개발 서버
ssh staging-server  # 스테이징 서버
ssh prod-server     # 프로덕션 서버
```

### 6.3 시나리오 3: 모바일에서 서버 접속

상황:
- 긴급 상황 발생
- 스마트폰으로 서버 접속 필요

해결책:

1. 모바일에 Tailscale 앱 설치 (iOS/Android)
2. SSH 클라이언트 앱 설치 (Termius, JuiceSSH 등)
3. Tailscale IP로 SSH 접속

## 7. 문제 해결

### 7.1 연결이 안 될 때

연결 상태 확인:

```bash
# Tailscale 상태 확인
sudo tailscale status

# 연결 테스트
ping 100.101.102.103

# Tailscale 로그 확인
sudo journalctl -u tailscaled -f
```

### 7.2 인증 문제

Tailscale 재인증:

```bash
# 로그아웃
sudo tailscale logout

# 다시 로그인
sudo tailscale up
```

### 7.3 방화벽 문제

방화벽 규칙 확인:

Ubuntu/Debian:
```bash
sudo ufw status verbose
```

CentOS/RHEL:
```bash
sudo firewall-cmd --list-all
```

### 7.4 SSH 키 권한 문제

올바른 권한 설정:

```bash
# 개인 키 권한 (클라이언트)
chmod 600 ~/.ssh/id_rsa

# 공개 키 권한 (서버)
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

## 8. 정리

Tailscale을 사용하면 방화벽 환경에서도 안전하고 편리하게 SSH 접속이 가능합니다.

핵심 포인트:
- 제로 트러스트 아키텍처로 안전한 원격 접속
- 간단한 설치 및 설정으로 빠른 도입 가능
- NAT 트래버설 자동 처리로 복잡한 네트워크 설정 불필요
- MagicDNS와 ACL로 편리하고 세밀한 관리
- 멀티플랫폼 지원으로 어디서든 접속 가능

추가 리소스:
- Tailscale 공식 문서: [https://tailscale.com/kb/](https://tailscale.com/kb/)
- WireGuard 프로토콜: [https://www.wireguard.com/](https://www.wireguard.com/)
- SSH 보안 가이드: [https://www.ssh.com/academy/ssh](https://www.ssh.com/academy/ssh)
