---
layout: post
title: "WSL2 설치하기"
categories: [WSL2, installation]
tags: [WSL, WSL2]
---

### 1. Windows Version 확인하기
* `winver` 명령으로 현재 윈도우즈의 버전 확인하기
* 윈도우즈 버전이 2004 이상이거나, Windows 11이 설치되어 있어야 한다.
* 윈도우즈를 업데이트하거나 Windows 11로 업그레이드하여 조건을 만족시킨다.
* 윈도우즈 11로 업그레이드 할 경우에는 TPM 2.0이 활성화 되어 있어야 한다.
* TPM 2.0은 BIOS에서 Security 관련 옵션에서 설정해준다.
* Intel CPU의 경우 dTPM 같은 Hardware TPM보다 PTT 라는 Software TPM을 선택해준다.

### 2. WSL 설치전 준비
* Windows Terminal 을 설치하여, 관리자 모드의 PowerShell등에서 작업한다.
* DISM을 이용하여 WSL설치전 WSL, VM 기능 활성화하기
```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```
* [WSL2 Linux Kernel Update](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)를 설치해준다.

### 3. WSL을 통해 Linux 설치하기
* [Windows WSL 설치 문서](https://docs.microsoft.com/ko-kr/windows/wsl/install)를 참고하여 설치
```powershell
wsl --install -d Ubuntu
```

### 4. 설치후 할일
* VS Code에 WSL extension 설치
* git 설치
* Bash를 zsh로 변경하고, oh-my-zsh 설치하여 프롬프트 변경하기 
* ruby, jekyll 등 설치하기 