---
layout: post
title: "터미널 설치 및 설정 가이드"
date: 2025-10-19
categories: [tutorial]
tags: [terminal, dev-environment, zsh, powershell, eza]
excerpt_separator: <!--more-->
---

# 터미널 설치 및 설정 가이드 (mac/Linux/Windows)

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

### 2.5 eza + colorls 스타일 Solarized Dark 설정
- 별도 파일 생성: `~/.config/eza_colors.sh`
```bash
mkdir -p ~/.config
nano ~/.config/eza_colors.sh
# (앞서 제공한 EXA_COLORS + alias 설정 붙여넣기)
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
```powershell
# scoop 설치 (권장)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

# 패키지 설치
scoop install git eza bat fzf ripgrep fd delta neovim
```

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
