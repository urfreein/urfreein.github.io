---
title: "zsh, Oh My Zsh, Powerlevel10k 설치, 설정하는 방법"
date: 2025-01-01T00:00:00+09:00
lastmod: 2025-01-01T00:00:00+09:00
draft: false
description: 
tags: ["linux", "terminal", "zsh", "oh-my-zsh", "powerlevel10k"]
categories: ["Tutorial"]
image: "https://urinfo24.com/cdn-cgi/image/width=1200,format=auto,quality=85/https://images.urinfo24.com/featured/howto-vultr-startup-script-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A modern, professional tech illustration for "zsh, Oh My Zsh, Powerlevel10k 설치, 설정하는 방법".
- Style: Clean, professional, flat design with technical elements
- Subject: Visual representation of howto vultr startup script
- Elements: Technical icons, symbols, code snippets, terminal windows, relevant tech logos
- Colors: Blue and gray tech tones, white background, accent colors for highlights
- Mood: Professional, modern, educational, technical
- Composition: Centered layout with balanced elements, clean and organized

Technical keywords: linux,  "terminal,  "zsh,  "oh-my-zsh,  "powerlevel10k

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/howto-vultr-startup-script-featured.jpg

NOTE: Hugo will serve this from /images/howto-vultr-startup-script-featured.jpg
-->

이 문서는 Debian/Ubuntu 기반의 리눅스 서버에서 기본 쉘인 bash를 zsh으로 변경하고, Oh My Zsh와 Powerlevel10k 테마를 설치하여 Mac과 같이 강력하고 멋진 터미널 환경을 구축하는 방법을 안내합니다.
<!--more-->

## 1단계: Zsh 설치 및 기본 쉘 변경

먼저 서버에 zsh을 설치하고, 현재 사용자의 기본 쉘을 bash에서 zsh으로 변경합니다.

1. Zsh 설치  
   패키지 관리자를 이용해 zsh을 설치합니다.  
   ```bash
   sudo apt update
   sudo apt install zsh
   ```

2. 기본 쉘 변경  
   `sudo`를 사용하여 현재 사용자의 기본 쉘을 zsh으로 변경합니다. `myuser` 부분은 본인의 사용자 이름으로 바꿔주세요.  
   ```bash
   sudo chsh -s $(which zsh) myuser
   ```

3. 변경 사항 적용  
   쉘 변경 사항은 다음 로그인 시점부터 적용됩니다. 서버에서 로그아웃한 뒤, 다시 접속해주세요.  
   ```bash
   exit
   ```

   다시 접속하면 zsh이 처음 실행되면서 기본 설정을 어떻게 할지 물어봅니다. 키보드에서 **2**를 눌러 추천 설정으로 시작하는 것이 가장 편리합니다.

## 2단계: Oh My Zsh 설치하기

zsh을 더욱 강력하게 만들어주는 프레임워크인 Oh My Zsh를 설치합니다.

1. 필수 도구 설치  
   Oh My Zsh 설치에 필요한 `git`과 `curl`을 설치합니다. 이미 설치되어 있다면 건너뛰세요.  
   ```bash
   sudo apt install git curl
   ```

2. Oh My Zsh 설치 명령어 실행  
   아래 공식 설치 명령어를 터미널에 붙여넣으면 자동으로 설치가 진행됩니다.  
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

   설치 과정에서 기본 쉘을 변경할지 물으면 Y를 누르고 엔터를 치세요.  
3. 터미널 재시작  
   설치가 완료되면 `exit`로 나갔다가 다시 서버에 접속하여 변경 사항을 적용합니다. 깔끔한 기본 테마가 적용된 것을 확인할 수 있습니다.

## 3단계: Powerlevel10k 테마 설치 및 설정

가장 인기 있는 테마인 Powerlevel10k를 설치하여 터미널을 완성합니다.

### 1. 서버에 Powerlevel10k 테마 설치

Oh My Zsh의 테마 폴더에 Powerlevel10k를 `git`으로 내려받습니다.

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### 2. 서버에서 테마 활성화

`~/.zshrc` 파일을 열어 `ZSH_THEME` 설정을 Powerlevel10k로 변경합니다.

1. **.zshrc 파일 열기**  
   ```bash
   nano ~/.zshrc
   ```

2. `ZSH_THEME` 설정 변경  
   파일 상단에 있는 `ZSH_THEME="..."` 부분을 아래와 같이 수정합니다.  
   ```bash
   ZSH_THEME="powerlevel10k/powerlevel10k"
   ```

3. 저장하고 나오기  
   Ctrl+X → Y → Enter 키를 눌러 저장합니다.

### 3. (매우 중요) 내 PC에 권장 폰트 설치

Powerlevel10k의 아이콘이 깨지지 않고 보이려면 **서버가 아닌, 지금 사용 중인 내 PC(Windows 또는 Mac)에** 특별한 폰트를 설치해야 합니다.

1. 아래 링크를 클릭하여 권장 폰트 4개를 다운로드합니다.  
   * [MesloLGS NF Regular.ttf](https://www.google.com/search?q=https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%2520NF%2520Regular.ttf)  
   * [MesloLGS NF Bold.ttf](https://www.google.com/search?q=https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%2520NF%2520Bold.ttf)  
   * [MesloLGS NF Italic.ttf](https://www.google.com/search?q=https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%2520NF%2520Italic.ttf)  
   * [MesloLGS NF Bold Italic.ttf](https://www.google.com/search?q=https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%2520NF%2520Bold%2520Italic.ttf)  
2. 다운로드한 4개의 `.ttf` 파일을 모두 열어 **'서체 설치'** 또는 **'설치'** 버튼을 눌러 PC에 폰트를 설치합니다.

### 4. 내 PC 터미널에 새 폰트 적용

사용 중인 터미널 프로그램(Windows Terminal, iTerm2, macOS 기본 터미널 등)의 **설정**으로 들어가, **글꼴(Font)을 방금 설치한 MesloLGS NF로 변경**합니다.

### 5. Powerlevel10k 설정 마법사 실행

모든 준비가 끝났습니다. **새 폰트가 적용된 터미널을 다시 시작**한 후 서버로 접속하면, Powerlevel10k가 자동으로 설정 마법사를 시작합니다.

```bash
ssh myuser@서버IP주소
```

화면에 나타나는 아이콘들이 깨지지 않고 잘 보이는지 확인하며 y를 누르고, 이후에는 취향에 맞게 프롬프트 스타일을 선택하면 모든 과정이 완료됩니다. 
> 설정 마법사는 언제든지 `p10k configure` 명령어로 다시 실행할 수 있습니다.
{: .prompt-tip }