---
layout: post
title: "VS Code 기준 Markdown(.md) 최소 설치 및 추천 확장 가이드"
date: 2025-10-19
categories: [tutorial]
tags: [vscode, markdown, editor]
excerpt_separator: <!--more-->
---

# VS Code 기준 Markdown(.md) 최소 설치 및 추천 확장 가이드

## 1️. 최소 설치
VS Code 기본 기능만으로도 Markdown 파일 열기, 편집, 코드 블록 미리보기 가능.
<!--more-->

### 기능
- `.md` 파일 열기
- 편집 가능
- 기본 미리보기
  - 단축키: `Ctrl+Shift+V` (Windows/Linux), `Cmd+Shift+V` (Mac)
  - 편집과 미리보기 동시에 보기: `Ctrl+K V` / `Cmd+K V`
- 코드 블록 기본 하이라이팅 지원

> 최소 설치만으로 Markdown 읽기/편집과 코드 블록 시각화 가능
{: .prompt-info }

---

## 2️. 권장 확장 (선택)
필요한 기능에 따라 설치

### 2.1 Markdown All in One
- 자동 목차 생성
- 단축키, 편집 편의 기능
- 설치 방법: VS Code 확장 검색 후 Install

### 2.2 Markdown Preview Enhanced
- PDF/HTML 내보내기
- 수식, 그래프, 차트 렌더링 지원
- 설치 후 Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`) → `Markdown Preview Enhanced: Export (PDF)`

### 2.3 Prettier - Code Formatter
- 코드 블록 포맷 깔끔하게 정리
- 설치 후 `Format Document` 사용 가능

---

## 3️. 사용 팁
- 기본 미리보기만으로 GitHub 스타일 Markdown 확인 가능
- 필요 시 Markdown Preview Enhanced에서 CSS 커스터마이징 가능
- 코드 블록은 Fenced code block(````bash`) 그대로 하이라이팅 가능

---

## 4️. 추천 설정 조합
| 목적 | 설치/설정 |
|------|------------|
| 최소 편집/보기 | VS Code 기본 기능만 사용 |
| 편집 편의 + 목차 자동 생성 | Markdown All in One |
| PDF 변환/수식/그래프 렌더링 | Markdown Preview Enhanced |
| 코드 블록 포맷 정리 | Prettier |

> ⚡ 요약: 최소 설치로도 충분히 Markdown 편집과 코드 블록 확인 가능하며, 필요 기능에 따라 선택적으로 확장 설치
