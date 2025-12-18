---
title: "GitHub Pages에서 Cloudflare Pages로 Jekyll 블로그 마이그레이션하기"
date: 2025-11-10T16:30:00+09:00
lastmod: 2025-11-10T16:30:00+09:00
draft: false
description: "GitHub Pages에서 운영하던 Jekyll 블로그를 Cloudflare Pages로 안전하게 옮기는 단계별 가이드입니다."
tags: ["github-pages", "cloudflare-pages", "jekyll", "migration", "blog"]
categories: ["Blogging"]
image: "https://images.urinfo24.com/featured/migrate-github-pages-to-cloudflare-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A modern, professional tech illustration for "GitHub Pages에서 Cloudflare Pages로 Jekyll 블로그 마이그레이션하기".
- Style: Clean, professional, flat design with technical elements
- Subject: Visual representation of migrate github pages to cloudflare
- Elements: Technical icons, symbols, code snippets, terminal windows, relevant tech logos
- Colors: Blue and gray tech tones, white background, accent colors for highlights
- Mood: Professional, modern, educational, technical
- Composition: Centered layout with balanced elements, clean and organized

Technical keywords: github-pages,  "cloudflare-pages,  "jekyll,  "migration,  "blog

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/migrate-github-pages-to-cloudflare-featured.jpg

NOTE: Hugo will serve this from /images/migrate-github-pages-to-cloudflare-featured.jpg
-->

## 개요

GitHub Pages는 많은 개발자들이 선택하는 무료 호스팅 서비스입니다. 하지만 더 나은 성능과 보안을 위해 Cloudflare Pages로 이전을 고려하게 되었습니다. 이 글에서는 기존 GitHub Pages 블로그를 Cloudflare Pages로 옮기는 과정을 제 경험으로 설명합니다.

## 마이그레이션이 필요한 이유

GitHub Pages에서 Cloudflare Pages로 이전하면 다음과 같은 이점이 있습니다:

- 전 세계적으로 분산된 CDN을 통한 빠른 로딩 속도
- 강력한 보안 기능과 DDoS 방어
- 더 유연한 빌드 설정과 환경 변수 관리
- 무료 플랜에서도 제공되는 다양한 기능

## 마이그레이션 준비 사항

마이그레이션을 시작하기 전에 다음 사항을 확인하세요:

- GitHub 저장소에 Jekyll 블로그 소스 코드가 있어야 합니다
- Cloudflare 계정이 필요합니다 (무료 가입 가능)
- 기존 블로그의 설정 파일과 콘텐츠를 백업하세요

## 단계별 마이그레이션 과정

### 1단계: Cloudflare Pages 프로젝트 생성

Cloudflare 대시보드에 로그인한 후 다음 절차를 따릅니다:

1. Workers & Pages 메뉴로 이동합니다.
2. Create application 버튼을 클릭합니다. 처음이라면, `Get Started`를 누르세요.
3. Pages 탭을 선택합니다. Github pages와 같은 역할을 합니다.
4. Connect to Git를 선택하여 GitHub 저장소를 연결합니다.

### 2단계: GitHub 저장소 연결

GitHub 계정 인증 후 블로그 저장소를 선택합니다:

1. 저장소 목록에서 Jekyll 블로그 저장소를 찾습니다. `username.github.io` 와 같은 이름으로 되어 있습니다.
2. 배포할 브랜치를 선택합니다 (일반적으로 main 또는 master)
3. Begin setup을 클릭합니다
4. Project 명을 정합니다. 기본은 github 저장소 이름 형태입니다. `username-github-io` 형태인데, 바꾸지 않으면, `username-github-io.pages.dev`와 같이 되어 보기에 좋지 않습니다. github pages를 더 이상 이용하지 않으므로, 반드시 `github.io`를 안붙여도 됩니다. `username`만 쓰면, `username.pages.dev`와 같은 형태가 됩니다. 혹은, 다른 이름을 자유롭게 정해도 됩니다. 추후 Settings에서 project 이름을 바꿀 수 있지만, URL은 바뀌지 않습니다.

### 3단계: 빌드 설정 구성

Jekyll 프로젝트에 맞는 빌드 설정을 입력합니다:

- Framework preset: Jekyll 선택
- Build command: `jekyll build`
- Build output directory: `_site`
- Environment variables: 필요한 경우 JEKYLL_ENV=production 추가

### 4단계: 배포 및 확인

Save and Deploy 버튼을 클릭하여 첫 배포를 시작합니다. 빌드 과정은 실시간으로 모니터링할 수 있으며, 성공적으로 완료되면 Cloudflare가 제공하는 임시 URL을 통해 사이트에 접근할 수 있습니다.
> Build command에 default값으로는 저는 에러가 발생해서 `bundle install && bundle exec jekyll build`와 같이 했습니다. 우선 default로 해보시고, deploy에 실패한다면 저처럼 해보세요.
{: .prompt-warning }

## URL 변경 사항 주의

마이그레이션 후 중요한 변경 사항이 있습니다:

- 기존 URL: `username.github.io`
- 새로운 URL: `your-project.pages.dev`

> 위의 Project명을 정하는 순서에 주의 사항을 언급했지만, 한번 정해지면 새로 만들기전에는 변경이 안되므로 꼭 신경쓰기 바랍니다.
{: .prompt-warning }

이 URL 변경은 검색 엔진 인덱싱과 기존 링크에 영향을 줄 수 있습니다. 따라서 다음 조치를 권장합니다:

- GitHub Pages 저장소에 리다이렉트 설정 추가
- Google Search Console에 새 URL 등록
- 소셜 미디어 프로필의 블로그 링크 업데이트

## 커스텀 도메인 설정

자신의 도메인이 있다면 Cloudflare Pages에서 쉽게 설정할 수 있습니다. 커스텀 도메인을 사용하면 URL 변경 문제를 완전히 해결할 수 있습니다. 자세한 도메인 설정 방법은 별도 글에서 다루겠습니다.

## 마이그레이션 후 확인 사항

배포가 완료되면 다음 항목을 확인하세요:

- 모든 페이지가 정상적으로 표시되는지 확인
- 이미지와 CSS 파일이 올바르게 로드되는지 점검
- 내부 링크가 정상 작동하는지 테스트
- RSS 피드와 사이트맵이 접근 가능한지 확인

## 문제 해결 팁

마이그레이션 과정에서 자주 발생하는 문제와 해결 방법입니다:

빌드 실패가 발생하면 Gemfile과 _config.yml 설정을 확인하세요. Cloudflare Pages는 최신 Ruby 버전을 사용하므로, 필요한 경우 로컬에서 호환성을 먼저 테스트하는 것이 좋습니다.

혹은, 빌명 명령을 바꿔 보세요. 저도 default 명령은 실패해서, `bundle install && bundle exec jekyll build`와 같이 바꾸었습니다.

경로 문제가 발생하면 _config.yml의 baseurl과 url 설정을 확인하세요. Cloudflare Pages에서는 baseurl을 빈 문자열로 설정해야 하는 경우가 많습니다.

## 마무리

GitHub Pages에서 Cloudflare Pages로의 마이그레이션은 복잡해 보일 수 있지만, 단계별로 진행하면 어렵지 않습니다. github pages로 이미 잘 작동되었다면, cloudflare pages로도 잘 될겁니다. 저도 default 빌드 명령 바꾼거 말고는 특별한 변경없이 한번에 잘 되었습니다.

마이그레이션 후에는 프로젝트 설정에서 여러가지 설정도 변경해 보고, 보안과 성능 관련 설정도 점검해 보시기 바랍니다.