---
layout: post
title: "WSL2 설치하기"
categories: WSL2 installation
---

1. Windows Version 확인하기
* `$ winver` 명령으로 현재 윈도우즈의 버전 확인하기
* 윈도우즈 버전이 2004 이상이거나, Windows 11이 설치되어 있어야 한다.
* 윈도우즈를 업데이트하거나 11로 업그레이드하여 조건을 만족시킨다.
* 윈도우즈 11로 업그레이드 할 경우에는 TPM 2.0이 활성화 되어 있어야 한다.
* TPM 2.0은 BIOS에서 Security 관련 옵션에서 설정해준다.
* Intel CPU의 경우 dTPM 같은 Hardware TPM보다 PTT 라는 Software TPM을 선택해준다.