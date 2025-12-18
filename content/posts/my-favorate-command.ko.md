---
title: "CLI 명령어 모음: 필수 쉘(Shell) 명령어 치트 시트 (1)"
date: 2025-10-27T08:14:48+09:00
lastmod: 2025-10-27T08:14:48+09:00
draft: false
description: "자주 사용하는 필수 CLI 명령어를 간결한 리스트 형태로 정리하여 빠르게 찾아볼 수 있도록 돕는 치트 시트입니다."
tags: ["CLI", "명령어", "Linux", "macOS", "Windows", "du", "find", "ls", "shutdown", "PowerShell"]
categories: ["기술"]
image: "https://images.urinfo24.com/featured/my-favorate-command-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A modern, professional tech illustration for "CLI 명령어 모음: 필수 쉘(Shell) 명령어 치트 시트 (1)".
- Style: Clean, professional, flat design with technical elements
- Subject: Visual representation of my favorate command
- Elements: Technical icons, symbols, code snippets, terminal windows, relevant tech logos
- Colors: Blue and gray tech tones, white background, accent colors for highlights
- Mood: Professional, modern, educational, technical
- Composition: Centered layout with balanced elements, clean and organized

Technical keywords: CLI,  "명령어,  "Linux,  "macOS,  "Windows

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/my-favorate-command-featured.jpg

NOTE: Hugo will serve this from /images/my-favorate-command-featured.jpg
-->

## Linux/macOS 명령어 (Bash & Zsh)

### 1. 디렉토리 용량 확인

**사용 예시**

```bash
du -sh .
````

**주요 옵션**

  - `-s`: 총합만 요약하여 표시 (summarize).
  - `-h`: 사람이 읽기 쉬운 형식(KB, MB, GB)으로 출력 (human-readable).
  - `-d 1`: 현재 디렉토리 바로 아래의 하위 디렉토리 크기만 개별적으로 표시.

### 2\. 특정 파일 찾기

**사용 예시 (확장자가 `.log`인 파일 찾기)**

```bash
find . -name "*.log"
```

**주요 옵션**

  - `path`: 탐색을 시작할 경로. (`.`은 현재 디렉토리)
  - `-name "pattern"`: 파일 이름 패턴으로 찾기 (`""` 안에 패턴 지정).
  - `-type f`: 파일만 찾기. (`-type d`는 디렉토리만 찾기).
  - `-maxdepth N`: 최대 N 레벨까지만 탐색.

### 3\. 디렉토리만 리스팅

**사용 예시(/bin/ls)**

```bash
ls -F | grep /
```

**주요 옵션 (ls/grep)**

  - `ls -F`: 파일 끝에 분류 표시자(`/` 등)를 추가.
  - `grep /`: 출력 결과에서 `/` 문자가 포함된 라인만 필터링.

**사용 예시 (eza 사용 시)**

```bash
eza --only-dirs
eza -D
alias ls='eza -F --icons --git --group-directories-first'
ls --only-dirs
ls -D
```

**주요 옵션 (eza 기준)**

  - `--only-dirs` 또는 `-D`: 파일은 제외하고 디렉토리만 출력.
  - `-a`: 숨김 디렉토리 포함.
  - `-l`: 상세 리스트 형식으로 출력 (파일 용량, 권한 등).

### 4\. 펌웨어(UEFI/BIOS)로 재부팅

**사용 예시 (macOS)**

```bash
sudo shutdown -r -p now --firmware
```

**주요 옵션**

  - `-r`: 재부팅(reboot)을 수행합니다.
  - `-p now`: 즉시 종료/재부팅을 시작합니다.
  - `--firmware`: 재부팅 시 펌웨어 인터페이스(시동 관리자)로 진입하도록 요청합니다.

-----

## Windows 명령어 (PowerShell)

### 1\. 디렉토리 용량 확인

**사용 예시**

```powershell
Get-ChildItem -Path . -Recurse | Measure-Object -Property Length -Sum
```

**주요 옵션 (GCI & MO)**

  - `-Recurse`: 하위 디렉토리를 재귀적으로 탐색 (Get-ChildItem 옵션).
  - `-Sum`: 지정된 속성(여기서는 Length)의 합계를 계산 (Measure-Object 옵션).

### 2\. 특정 문자열/확장자 파일 찾기

**사용 예시 (확장자가 `.txt`인 파일 찾기)**

```powershell
Get-ChildItem -Path . -Recurse -Filter "*.txt"
```

**주요 옵션**

  - `-Filter "pattern"`: 파일 이름이나 확장자를 필터링.
  - `-Include "pattern"`: 파일 이름 패턴으로 찾습니다.

### 3\. 디렉토리만 리스팅

**사용 예시**

```powershell
Get-ChildItem -Path . | Where-Object {$_.PSIsContainer -eq $true}
```

**주요 옵션 (GCI & WO)**

  - `Where-Object`: 객체의 특정 속성을 기준으로 필터링.
  - `$_.PSIsContainer`: 해당 항목이 컨테이너(디렉토리)인지 여부.

### 4\. 펌웨어(UEFI/BIOS)로 재부팅

**사용 예시**

```powershell
shutdown /r /fw /t 0
```

**주요 옵션**

  - `/r`: 시스템을 완전히 종료하고 재시작.
  - `/fw`: 다음 부팅 시 펌웨어 사용자 인터페이스로 이동.
  - `/t 0`: 지연 시간 없이 즉시 종료/재부팅 시작.

<!-- end list -->