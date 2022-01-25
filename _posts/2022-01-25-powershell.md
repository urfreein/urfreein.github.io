---
title: Powershell 7.x 를 써보자.
categories: [Windows, Powershell]
tags: [powershell pwsh oh-my-posh]     # TAG names should always be lowercase
---

## 1. Powershell 7.x 설치하기

#### 1. MSI 패키지 다운로드하여 설치하기

* MS의 [PowerShell 설명서](https://docs.microsoft.com/ko-kr/powershell/)페이지에서 "Windows에 Powershell설치"에 들어가 MSI 패키지를 내려받아 설치한다.
* 이전 버전은 5.x인데, Windows PowerShell이라 불리고, 이후 개방형으로 바뀌면서 7.x버전부터는 그냥 PowerShell이라 불린다.
* 보통 Windows 10, 11에 Windows PowerShell이 이미 존재하는데, 이것은 5.x버전이다.
* 새로운 버전이 나오고 그만큼 좋아졌을테니 이제부터는 7.x버전을 설치하여 쓰도록 하자.

#### 2. 유저 프로필 파일 만들기

* `$PROFILE`을 CLI에서 실행보면 `C:\Users\<UserID>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`{: .filepath} 와 같은 파일명이 나오는데, 초기엔 없으니 만들어주자.
* `notepad $PROFILE` 과 같은 명령을 내려 만들면 된다. 빈 파일이라도 만들어 둔다.
* PowerShell의 Script 파일은 확장자가 `*.ps1`{: .filepath}인데, 실행에 제한이 걸려 있을 수 있다. 만일 그렇다면 아래와 같이 정책을 변경한다.
```powershell
PS> Set-ExecutionPolicy RemoteSigned
```

## 2. Custom Prompt 설정하기

#### 1. Oh my posh 설치하기

* 맨 먼저 Font를 설치한다. 기본 폰트로는 몇가지가 없어서 표시가 되지 않는게 있다. [Nerd Font 설치](https://www.nerdfonts.com/font-downloads) 사이트에서 적당한 것을 받아 설치한다. 보통은 BitStream이나 Caskaydia, Hack 을 받으면 된다.

* [사용자 지정 프롬프트 설정](https://docs.microsoft.com/ko-kr/windows/terminal/tutorials/custom-prompt-setup)페이지에 잘 설명이 되어 있다. 천천히 읽어 보고 설치한다.
```powershell
PS> Install-Module oh-my-posh -Scope CurrentUser
```

* 적당한 테마도 골라보자.
```powershell
PS> Get-PoshThemes
```

* `$PROFILE`{: .filepath}에 아래와 같은 내용을 추가한다.

```
Import-Module oh-my-posh
Set-PoshPrompt -Theme <theme_name>
```
{: .nolineno file="$PROFILE" }

#### 2. Posh-git 설치하기

* oh-my-posh에서 git 상태를 표시할 수 있게 해준다.(고 하는데 난 안된다.)
```powershell
PS> Install-Module posh-git -Scope CurrentUser
```

* `$PROFILE`{: .filepath}에 다음과 같은 내용을 추가한다.

```
Import-Module posh-git
```
{: .nolineno file="$PROFILE"}

#### 3. Terminal Icon 설치하기

* 폴더나 파일을 좀 더 멋지게 표시한다.
```powershell
PS> Install-Module -Name Terminal-Icons -Repository PSGallery
```
* `$PROFILE`{: .filepath}에 다음과 같은 내용을 추가한다.

```
Import-Module -Name Terminal-Icons
```
{: .nolineno file="$PROFILE"}
