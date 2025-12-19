---
title: "터미널 설정 가이드"
date: 2025-01-01T00:00:00+09:00
lastmod: 2025-01-01T00:00:00+09:00
draft: false
description: 
tags: ["terminal", "dev-environment", "zsh", "powershell", "eza"]
categories: ["Tutorial"]
image: "https://urinfo24.com/cdn-cgi/image/width=1200,format=auto,quality=85/https://images.urinfo24.com/featured/terminal-setup-guide-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A modern, professional tech illustration for "터미널 설정 가이드".
- Style: Clean, professional, flat design with technical elements
- Subject: Visual representation of terminal setup guide
- Elements: Technical icons, symbols, code snippets, terminal windows, relevant tech logos
- Colors: Blue and gray tech tones, white background, accent colors for highlights
- Mood: Professional, modern, educational, technical
- Composition: Centered layout with balanced elements, clean and organized

Technical keywords: terminal,  "dev-environment,  "zsh,  "powershell,  "eza

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/terminal-setup-guide-featured.jpg

NOTE: Hugo will serve this from /images/terminal-setup-guide-featured.jpg
-->

## 1. 개요
이 가이드는 zsh(mac/Linux)와 PowerShell(Windows) 환경에서
컬러풀한 ls(eza), Git 상태 표시, 자동완성, 터미널 테마 등
생산성을 높이고 시각적으로 보기 좋은 터미널 환경을 구성하기 위한 단계별 설치 및 설정 방법입니다.
<!--more-->

---

## 2. mac / Linux (zsh 기준)

### 2.1 필수 패키지 설치
```bash
# Homebrew 설치 (mac)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 기본 패키지 설치
brew install zsh eza bat fzf ripgrep delta fd git tmux neovim
```

### 2.2 Oh My Zsh 설치
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 2.3 Powerlevel10k 테마 설치
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# .zshrc에서 ZSH_THEME="powerlevel10k/powerlevel10k" 설정
```

### 2.4 zsh 플러그인 설치
```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```
- `.zshrc` 플러그인 섹션에 `plugins=(git zsh-autosuggestions zsh-syntax-highlighting)` 추가
> 플러그인 설정에서 `zsh-syntax-highlighting`이 항상 마지막에 오도록 설정한다.
{: .prompt-warning }

### 2.5 eza + colorls 스타일 Solarized Dark 설정
- 별도 파일 생성: `~/.config/eza_colors.sh`
```bash
mkdir -p ~/.config
nano ~/.config/eza_colors.sh
# (아래 제공한 EXA_COLORS + alias 설정 붙여넣기)
```

```bash
#!/bin/bash
# =================================================
# eza colorls-style Solarized Dark complete config
# =================================================

# Solarized Dark 톤 EXA_COLORS
export EXA_COLORS="\
di=38;2;38;139;210:\
ln=38;2;211;54;130:\
ex=38;2;133;153;0:\
so=38;2;203;75;22:\
pi=38;2;203;75;22:\
bd=38;2;108;113;196:\
cd=38;2;108;113;196:\
fi=38;2;131;148;150:\
da=38;2;101;123;131:\
uu=38;2;108;113;196:\
gu=38;2;108;113;196:\
*.rb=38;2;220;50;47:\
*.py=38;2;38;139;210:\
*.js=38;2;211;54;130:\
*.ts=38;2;211;54;130:\
*.json=38;2;181;137;0:\
*.yml=38;2;133;153;0:\
*.yaml=38;2;133;153;0:\
*.md=38;2;133;153;0:\
*.txt=38;2;131;148;150:\
*.html=38;2;38;139;210:\
*.css=38;2;42;161;152:\
*.scss=38;2;211;54;130:\
*.sh=38;2;133;153;0:\
*.zsh=38;2;133;153;0:\
*.c=38;2;38;139;210:\
*.cpp=38;2;38;139;210:\
*.h=38;2;38;139;210:\
*.hpp=38;2;38;139;210:\
*.rs=38;2;211;54;130:\
*.go=38;2;133;153;0:\
*.php=38;2;38;139;210:\
*.java=38;2;38;139;210:\
*.kt=38;2;38;139;210:\
*.sql=38;2;38;139;210:\
*.xml=38;2;38;139;210:\
*.toml=38;2;133;153;0:\
*.ini=38;2;133;153;0:\
*.log=38;2;131;148;150:\
*.cfg=38;2;133;153;0:\
*.zip=38;2;203;75;22:\
*.tar=38;2;203;75;22:\
*.gz=38;2;203;75;22:\
*.bz2=38;2;203;75;22:\
*.xz=38;2;203;75;22:\
*.dmg=38;2;203;75;22:\
*.iso=38;2;203;75;22:\
*.pdf=38;2;211;54;130:\
*.mp3=38;2;133;153;0:\
*.wav=38;2;133;153;0:\
*.mp4=38;2;133;153;0:\
*.mkv=38;2;133;153;0:\
*.mov=38;2;133;153;0:\
*.png=38;2;42;161;152:\
*.jpg=38;2;42;161;152:\
*.jpeg=38;2;42;161;152:\
*.gif=38;2;42;161;152"

alias ls='eza --icons -F --git --group-directories-first'          # ls를 eza로 대체 (아이콘, git 상태 표시)
alias l='eza -l --icons --git --group-directories-first'        # 자세히 보기 (한 줄에 하나씩)
alias ll='eza -lh --icons --git --group-directories-first'      # 자세히 보기 + 파일 크기 보기 좋게
alias la='eza -lha --icons --git --group-directories-first'     # 숨김 파일 포함
alias tree='eza --tree'               # 트리 형태로 보기
```
- `.zshrc`에서 불러오기
```bash
[ -f ~/.config/eza_colors.sh ] && source ~/.config/eza_colors.sh
```

### 2.6 fzf 설정
```bash
$(brew --prefix)/opt/fzf/install
```
- 기본 키 바인딩과 자동 완성 활성화

### 2.7 tmux 기본 설정 (선택)
- `~/.tmux.conf` 생성, 패널 분할, 색상, statusline 등 설정 가능

### 2.8 bat alias 설정
```bash
alias cat='bat'
```
- `bat`은 `cat`을 대체하면서 syntax highlighting 기능이 있다.

### 2.9 Git diff 도구 설정
```bash
git config --global core.pager "delta"
```

### 2.10 적용
```bash
source ~/.zshrc
```
- eza, bat, delta, fzf 등 정상 동작 확인

---

## 3. Windows (PowerShell 기준)

### 3.1 Windows Terminal 설치
- Microsoft Store에서 Windows Terminal 설치

### 3.2 PowerShell 모듈 설치
```powershell
# posh-git
Install-Module posh-git -Scope CurrentUser

# Oh My Posh
Install-Module oh-my-posh -Scope CurrentUser
```

### 3.3 프로필 설정
```powershell
# 프로필 확인
$PROFILE
if (!(Test-Path -Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force }

# $PROFILE 열기
notepad $PROFILE
```
- 다음 내용 추가
```powershell
Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme Paradox  # 또는 원하는 테마
```

### 3.4 필수 CLI 설치
- scoop 또는 winget 이용 가능  
{% raw %}
```powershell
# scoop 설치 (권장)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

# 패키지 설치
scoop install git eza bat fzf ripgrep fd delta neovim
```
{% endraw %}

### 3.5 alias 설정
- `~\Documents\PowerShell\profile.ps1`에 eza alias 추가
```powershell
Set-Alias ls eza
```

### 3.6 적용
```powershell
. $PROFILE
```
- eza, posh-git, Oh My Posh, bat 등 정상 동작 확인

---

## 4. 추천 조합 및 활용
- mac/Linux: Oh My Zsh + Powerlevel10k + eza + bat + fzf + delta + tmux
- Windows: Windows Terminal + Oh My Posh + posh-git + eza + bat + fzf
- 공통 유틸: ripgrep, fd, neovim, tmux (mac/Linux)

---

## 5. 추가 팁
- iTerm2, Windows Terminal 등에서 Nerd Font 적용 시 아이콘과 프롬프트 더 예쁘게 표시
- Solarized Dark 테마 적용 시 eza, Powerlevel10k, Oh My Posh 모두 색감 통일 가능
- 필요 시 eza_colors.sh 파일에서 파일 확장자별 색상 추가 조정 가능
