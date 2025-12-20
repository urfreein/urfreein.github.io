---
title: "Vultr linux VM 생성할 때, SSH 연결 설정, 신규 유저 생성하는 방법"
date: 2025-01-01T00:00:00+09:00
lastmod: 2025-01-01T00:00:00+09:00
draft: false
description: 
tags: ["vultr", "ssh", "server", "linux"]
categories: ["Tutorial"]
image: "https://urinfo24.com/cdn-cgi/image/width=800,format=auto,quality=75/https://images.urinfo24.com/featured/howto-vultr-ssh-connection-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A modern, professional tech illustration for "Vultr linux VM 생성할 때, SSH 연결 설정, 신규 유저 생성하는 방법".
- Style: Clean, professional, flat design with technical elements
- Subject: Visual representation of howto vultr ssh connection
- Elements: Technical icons, symbols, code snippets, terminal windows, relevant tech logos
- Colors: Blue and gray tech tones, white background, accent colors for highlights
- Mood: Professional, modern, educational, technical
- Composition: Centered layout with balanced elements, clean and organized

Technical keywords: vultr,  ""ssh,  ""server,  ""linux

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/howto-vultr-ssh-connection-featured.jpg

NOTE: Hugo will serve this from /images/howto-vultr-ssh-connection-featured.jpg
-->
<!-- 이미지를 assets/img/ 폴더에 넣고 경로를 지정하세요. 예: ![Vultr SSH Setup](/assets/img/your-image.png) -->
 
Vultr에서 SSH 키로 원하는 사용자 만들기 (Windows / macOS 공용 최종판)

이 문서는 Vultr에 새로운 서버를 배포하기 전, 필요한 SSH 키와 Startup Script를 미리 준비하고, 이를 적용하여 원하는 이름의 사용자로 안전하게 서버를 시작하고, ssh로 연결하는 전체 과정을 안내합니다.
<!--more-->

## 1단계: 사전 준비 (서버 배포 전)

서버를 만들기 전에 접속에 필요한 SSH 키와 사용자 생성 스크립트를 Vultr 계정에 미리 등록해야 합니다.

### 1. 내 PC에서 SSH 키 생성

먼저 내 PC에서 서버에 접속하기 위한 '열쇠'에 해당하는 SSH 키 쌍(공개키+비밀키)을 생성합니다.

* **Windows의 경우**  
  1. **PowerShell 실행**: Win 키 \+ X 키를 누른 후 '터미널' 또는 'Windows PowerShell'을 실행합니다.  
  2. **명령어 입력**: 아래 명령어를 입력하고 엔터를 누르세요.  
     ```powershell
     ssh-keygen -t ed25519 -C "your_email@example.com"
     ```

  3. **설정 완료**: 화면에 나타나는 질문에는 모두 엔터만 눌러 기본값으로 키 생성을 완료합니다.  
* **macOS의 경우**  
  1. **터미널 실행**: Spotlight(Cmd+Space)에서 Terminal을 검색하여 실행합니다.  
  2. **명령어 입력**: 아래 명령어를 입력하고 엔터를 누르세요.  
     ```bash
     ssh-keygen -t ed25519 -C "your_email@example.com"
     ```
   
  3. **설정 완료**: 화면에 나타나는 질문에는 모두 엔터만 눌러 기본값으로 키 생성을 완료합니다.

      > Ed25519는 기존 RSA방식보다 좀 더 보안성이 있는 키 생성 알고리즘입니다. **타원 곡선 디지털 서명 알고리즘(ECDSA)**의 한 형태입니다.
      {: .prompt-info }
   

### 2. Vultr에 SSH 공개키 등록

생성한 키 쌍 중, 서버에 등록할 **공개키(id_ed25519.pub)**의 내용을 Vultr에 추가합니다.

1. **공개키 내용 복사**   
   각 OS에 맞는 터미널에서 아래 명령어를 입력하여 공개키 내용을 화면에 출력한 뒤, `ssh-ed25519`로 시작하는 텍스트 전체를 복사합니다.  
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

2. **Vultr에 SSH Key 추가**  
   * [Vultr 웹사이트](https://www.google.com/search?q=https://my.vultr.com/)에 로그인 후, 왼쪽 메뉴에서 **Products**를 클릭한 후 **Orchestration** 섹션의 **SSH Keys**를 선택합니다.  
   * 오른쪽 위의 **Add SSH Key** 버튼을 클릭합니다.  
   * **SSH Key Name**: `My-PC`처럼 알아보기 쉬운 이름을 입력합니다.  
   * **SSH Key**: 복사한 공개키 내용을 붙여넣습니다.  
   * **Add SSH Key** 버튼을 눌러 저장합니다.

### 3. Vultr에 Startup Script 등록

서버가 처음 부팅될 때 실행될 사용자 생성 스크립트를 미리 등록합니다.

1. **Startup Scripts 메뉴로 이동**  
   * 왼쪽 메뉴에서 **Products**를 클릭한 후 **Orchestration** 섹션의 **Startup Scripts**를 선택합니다.  
2. **새로운 Startup Script 추가**  
   * 오른쪽 위의 **Add Startup Script** 버튼을 클릭합니다.  
   * **Type**: **Boot**를 선택합니다.  
   * **Name**: `Create-My-User` 처럼 스크립트 역할을 알 수 있는 이름을 입력합니다.  
   * **Script**: 아래 스크립트를 붙여넣습니다. **myuser 부분만 원하는 사용자 이름으로 직접 수정하세요.**  
     ```bash
     #!/bin/bash

     # Change this to your desired username  
     NEW_USERNAME="myuser"

     # Create the new user and add to the sudo group  
     adduser $NEW_USERNAME --gecos "User" --disabled-password  
     usermod -aG sudo $NEW_USERNAME

     # Copy the SSH directory from the root user to the new user  
     rsync --archive --chown=$NEW_USERNAME:$NEW_USERNAME /root/.ssh /home/$NEW_USERNAME

     # Allow the new user to run sudo commands without a password  
     echo "$NEW_USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/010-$NEW_USERNAME-nopasswd

     echo "--- User '$NEW_USERNAME' created with passwordless sudo. ---"
     ```

   * **Add Script** 버튼을 눌러 저장합니다.

## 2단계: 서버 배포 및 설정 적용

사전 준비가 끝났습니다. 이제 새로운 서버를 만들면서 준비된 SSH 키와 스크립트를 선택합니다.

1. **서버 배포 페이지로 이동**하여 원하는 Linux 배포판, 위치, 플랜을 선택합니다.  
2. **SSH Keys** 섹션에서 키 선택  
   페이지 중간의 SSH Keys 섹션에서 1단계에서 등록한 내 PC의 SSH 키를 체크합니다.  
3. **Startup Script** 섹션에서 스크립트 선택  
   페이지를 더 내려 **Additional Features** 섹션에서 **Startup Script**를 찾고, 1단계에서 등록한 `Create-My-User` 스크립트를 선택합니다.  
4. 서버 배포  
   모든 설정을 확인하고 **Deploy Now** 버튼을 눌러 서버 생성을 시작합니다.

## 3단계: 접속 및 최종 보안 설정

서버가 생성되고 1\~2분 정도 지나면 스크립트가 실행되어 모든 설정이 완료됩니다.

### 1. 새로운 사용자로 서버 접속

각 OS에 맞는 터미널을 열고 **스크립트에서 설정한 사용자 이름**으로 SSH 접속을 시도합니다.

```bash
# 'myuser'는 스크립트에서 지정한 이름으로 변경하세요.
ssh myuser@서버IP주소
```

### 2. 관리자 권한(sudo) 확인

접속 후, `sudo` 명령이 잘 동작하는지 확인합니다. **Startup Script**가 비밀번호 없는 `sudo`를 설정했으므로, 아래 명령어를 실행했을 때 비밀번호를 묻지 않고 바로 실행되어야 합니다.

```bash
sudo apt update
```

### 3. (권장) Root 로그인 비활성화

새 사용자로 접속 및 `sudo` 사용이 완벽하게 동작하는 것을 확인했다면, 보안을 위해 `root` 계정의 직접적인 SSH 접속을 차단합니다.

1. **SSH 설정 파일 열기**  
   ```bash
   sudo nano /etc/ssh/sshd_config
   ```

2. 설정 변경  
   파일 내용 중 `PermitRootLogin`으로 시작하는 줄을 찾아 아래와 같이 `no`로 수정합니다.  
   ```ini
   PermitRootLogin no
   ```

3. 저장 및 서비스 재시작  
   Ctrl+X → Y → Enter 키를 눌러 저장하고, 아래 명령어로 SSH 서비스를 재시작하여 설정을 최종 적용합니다.  
   ```bash
   sudo systemctl restart sshd
   ```

> 서버는 내가 만든 사용자를 통해서만 안전하게 접속할 수 있습니다. Vultr의 **view console**을 통해, `root` 유저로 로그인 할 수 있습니다. 초기 비밀번호는 Vultr의 웹 콘솔 화면에 노출되어 있으므로, 바꾸시기 바랍니다.
{: .prompt-info }

> 무분별한 Port Scanning을 차단하기 위해, SSH Service Port를 변경해 놓는 것도 보안상 유리합니다.
{: .prompt-tip }