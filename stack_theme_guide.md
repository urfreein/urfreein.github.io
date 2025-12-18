# Hugo Stack Theme Configuration Guide

## 📚 목차
1. [Stack 테마 개요](#stack-테마-개요)
2. [설정 파일 구조](#설정-파일-구조)
3. [전체 설정 옵션](#전체-설정-옵션)
4. [현재 적용된 설정](#현재-적용된-설정)
5. [커스터마이징 가이드](#커스터마이징-가이드)
6. [트러블슈팅](#트러블슈팅)

---

## Stack 테마 개요

**GitHub**: https://github.com/CaiJimmy/hugo-theme-stack  
**문서**: https://stack.jimmycai.com  
**데모**: https://demo.stack.jimmycai.com

### 주요 특징
- 카드 스타일 레이아웃 (Jekyll Chirpy와 유사)
- 반응형 이미지 지원
- Lazy loading
- Dark 모드
- 로컬 검색
- PhotoSwipe 통합
- 아카이브 페이지
- 네이티브 JavaScript (jQuery 없음)
- 목차(TOC) 지원
- 서브섹션 지원

### 시스템 요구사항
- Hugo Extended 버전 필수 (SCSS와 TypeScript 사용)
- Go 설치 필요 (Hugo Modules 사용 시)

---

## 설정 파일 구조

```
config/
└── _default/
    ├── config.yaml    # 사이트 기본 설정 및 다국어
    ├── params.yaml    # 테마 파라미터
    └── menu.yaml      # 메뉴 설정
```

---

## 전체 설정 옵션 상세 가이드

### 1. Site-wide Settings (params.yaml)

#### mainSections
```yaml
mainSections:
  - posts
```
- Type: `[string]`
- Default: `["post"]`
- 홈페이지와 아카이브 페이지에 표시될 섹션
- 여러 섹션 지정 가능

#### featuredImageField
```yaml
featuredImageField: image
```
- Type: `string`
- Default: `image`
- Featured image를 가져올 Front Matter 필드명
- Stack 테마는 `image` 사용 (DoIt의 `featuredImage`와 다름)

#### rssFullContent
```yaml
rssFullContent: true
```
- Type: `bool`
- Default: `true`
- RSS 피드에 전체 콘텐츠 출력 여부

#### favicon
```yaml
favicon: /favicon.ico
```
- Type: `string`
- 사이트 favicon 경로 (static 폴더 기준)

---

### 2. Sidebar Configuration

```yaml
sidebar:
  emoji: 🍥
  subtitle: Tech & Development Blog
  compact: false
  avatar:
    enabled: true
    local: true
    src: img/avatar.png
```

#### emoji
- Type: `string`
- 아바타 위에 표시될 이모지

#### subtitle
- Type: `string`
- 사이트 타이틀 아래 표시될 부제목

#### compact
- Type: `bool`
- Default: `false`
- 컴팩트 버전 사이드바 활성화

#### avatar.enabled
- Type: `bool`
- Default: `true`
- 아바타 표시 여부

#### avatar.src
- Type: `string`
- Default: `img/avatar.png`
- 아바타 이미지 경로

#### avatar.local
- Type: `bool`
- Default: `true`
- `true`: `assets/${avatar.src}`에서 로드 (자동 리사이징)
- `false`: URL에서 직접 로드

---

### 3. Article Settings

```yaml
article:
  math: true
  toc: true
  readingTime: true
  headingAnchor: false
  license:
    enabled: false
    default: Licensed under CC BY-NC-SA 4.0
```

#### math
- Type: `bool`
- KaTeX 수학 지원 활성화
- Front Matter에서 개별 포스트별로 설정 가능

#### toc
- Type: `bool`
- 목차 기본 활성화
- ⚠️ **중요**: `widgets.page`에 toc 위젯도 추가해야 실제로 표시됨
- Front Matter에서 개별 포스트별로 설정 가능

#### readingTime
- Type: `bool`
- Default: `true`
- 예상 읽기 시간 표시

#### headingAnchor
- Type: `bool`
- Default: `false`
- 헤딩 옆에 # 앵커 링크 표시 (호버 시에만 표시)

#### license.enabled
- Type: `bool`
- Default: `false`
- 글 하단에 라이선스 정보 표시

#### license.default
- Type: `string`
- Default: `Licensed under CC BY-NC-SA 4.0`
- 기본 라이선스 텍스트
- Front Matter에서 개별 포스트별로 변경 가능

---

### 4. Date Format

```yaml
dateFormat:
  published: 2006-01-02
  lastUpdated: 2006-01-02 15:04 MST
```

#### published
- Type: `string`
- Default: `Jan 02, 2006`
- 게시일 포맷 (Go의 날짜 형식 사용)

#### lastUpdated
- Type: `string`
- Default: `Jan 02, 2006 15:04 MST`
- 최종 수정일 포맷

**날짜 형식 참고**:
- Go는 `2006-01-02 15:04:05` 형식 사용
- `2006` = 연도, `01` = 월, `02` = 일
- `15` = 시, `04` = 분, `05` = 초

---

### 5. Widgets Configuration

```yaml
widgets:
  homepage:
    - type: search
    - type: archives
      params:
        limit: 5
    - type: categories
      params:
        limit: 10
    - type: tag-cloud
      params:
        limit: 10
  page:
    - type: toc
```

#### 사용 가능한 위젯

**archives**
- 연도별 포스트 수 표시
- `limit`: 표시할 연도 수 (기본: 10)
- ⚠️ `layout: archives` 페이지 미리 생성 필요

**search**
- 검색 박스 표시
- ⚠️ `layout: search` 페이지 미리 생성 필요

**categories**
- 카테고리 목록 표시
- `limit`: 표시할 카테고리 수 (기본: 10)

**toc**
- 페이지 목차 표시
- ⚠️ 최소 1개 이상의 헤딩이 있어야 표시됨

**tag-cloud**
- 태그 클라우드 표시
- `limit`: 표시할 태그 수 (기본: 10)

---

### 6. Menu Configuration

```yaml
main:
  - identifier: home
    name: Home
    url: /
    weight: 1
    params:
      icon: home
      newTab: false

social:
  - identifier: github
    name: GitHub
    url: https://github.com/username
    params:
      icon: brand-github
```

#### 필드 설명
- `identifier`: 메뉴 아이템 ID (고유값)
- `name`: 표시될 텍스트
- `url`: 링크 URL
- `weight`: 우선순위 (낮을수록 먼저 표시)
- `params.icon`: SVG 아이콘 이름
- `params.newTab`: 새 탭에서 열기

#### 아이콘 추가 방법
1. [Tabler Icons](https://tabler-icons.io)에서 SVG 다운로드
2. `assets/icons/` 폴더에 저장
3. 파일명(확장자 제외)을 icon 값으로 사용

---

### 7. Footer Configuration

```yaml
footer:
  since: 2020
  customText: ""
```

#### since
- Type: `int`
- 사이트 생성 연도
- 푸터에 "© 2020 - 2025" 형식으로 표시

#### customText
- Type: `string`
- 푸터에 표시될 커스텀 텍스트
- HTML 지원

---

### 8. Color Scheme

```yaml
colorScheme:
  toggle: true
  default: auto
```

#### toggle
- Type: `bool`
- Default: `true`
- 색상 테마 전환 버튼 표시
- `false`로 설정 시 `default` 옵션으로 고정

#### default
- Type: `string` (`light`|`dark`|`auto`)
- Default: `auto`
- 기본 색상 테마
- `auto`: 시스템 설정 따름 (`prefers-color-scheme`)

---

### 9. Image Processing

```yaml
imageProcessing:
  cover:
    enabled: true
  content:
    enabled: true
```

#### cover.enabled
- Type: `bool`
- Default: `true`
- Featured (커버) 이미지 자동 최적화

#### content.enabled
- Type: `bool`
- Default: `true`
- 콘텐츠 내 이미지 자동 최적화

**주의사항**:
- Hugo의 내장 이미지 처리 기능 사용
- 이미지가 많으면 빌드 시간 증가
- Page Bundle 방식 이미지에만 적용

---

### 10. Open Graph

```yaml
opengraph:
  twitter:
    site: username
    card: summary_large_image
```

#### twitter.site
- Type: `string`
- Twitter 계정명 (@ 기호 없이)

#### twitter.card
- Type: `string`
- Twitter 카드 타입
- 옵션: `summary`, `summary_large_image`

---

### 11. Default Image

```yaml
defaultImage:
  opengraph:
    enabled: false
    local: false
    src: ""
```

Featured image가 없을 때 Open Graph와 Twitter 카드에 사용될 기본 이미지

#### opengraph.enabled
- Type: `bool`
- Default: `false`
- 기본 이미지 사용 여부

#### opengraph.local
- Type: `bool`
- Default: `false`
- `true`: `assets` 폴더의 로컬 파일
- `false`: 원격 URL

#### opengraph.src
- Type: `string`
- 이미지 경로 또는 URL

---

### 12. Comments

```yaml
comments:
  enabled: false
  provider: ""
```

#### 지원하는 댓글 시스템
- Cactus
- Cusdis
- Disqus
- DisqusJS
- Giscus
- Gitalk
- Remark42
- Twikoo
- utterances
- Vssue
- Waline

#### 설정 예시 (utterances)
```yaml
comments:
  enabled: true
  provider: utterances
  utterances:
    repo: username/repo
    issueTerm: pathname
    theme: github-light
```

---

### 13. Custom Header/Footer

커스텀 HTML/CSS/JS 추가를 위한 예약 파일:
- `layouts/partials/head/custom.html` - HEAD 섹션에 추가
- `layouts/partials/footer/custom.html` - BODY 끝에 추가

#### 예시: 커스텀 폰트 변경

```html
<!-- layouts/partials/head/custom.html -->
<style>
    :root {
        --article-font-family: "Merriweather", var(--base-font-family);
    }
</style>

<script>
    (function () {
        const customFont = document.createElement('link');
        customFont.href = "https://fonts.googleapis.com/css2?family=Merriweather:wght@400;700&display=swap";
        customFont.type = "text/css";
        customFont.rel = "stylesheet";
        document.head.appendChild(customFont);
    }());
</script>
```

---

## 현재 urinfo24.com 적용 설정

### config/_default/config.yaml
```yaml
baseURL: https://urinfo24.com/
languageCode: ko-kr
title: Urinfo24

module:
  imports:
    - path: github.com/CaiJimmy/hugo-theme-stack/v3

defaultContentLanguage: ko
languages:
  ko:
    languageName: 한국어
    title: Urinfo24
    weight: 1
  en:
    languageName: English
    title: Urinfo24
    weight: 2
  ja:
    languageName: 日本語
    title: Urinfo24
    weight: 3
  de:
    languageName: Deutsch
    title: Urinfo24
    weight: 4
  fr:
    languageName: Français
    title: Urinfo24
    weight: 5
  es:
    languageName: Español
    title: Urinfo24
    weight: 6
  vi:
    languageName: Tiếng Việt
    title: Urinfo24
    weight: 7
  th:
    languageName: ไทย
    title: Urinfo24
    weight: 8
  hi:
    languageName: हिन्दी
    title: Urinfo24
    weight: 9
  id:
    languageName: Bahasa Indonesia
    title: Urinfo24
    weight: 10

pagination:
  pagerSize: 10
hasCJKLanguage: true
enableRobotsTXT: true
```

### config/_default/params.yaml
```yaml
mainSections:
  - posts

featuredImageField: image
rssFullContent: true

sidebar:
  emoji: 🍥
  subtitle: Tech & Development Blog
  avatar:
    enabled: true
    local: true
    src: img/avatar.png

article:
  math: true
  readingTime: true
  toc: true
  headingAnchor: true
  license:
    enabled: true
    default: Licensed under CC BY-NC-SA 4.0

dateFormat:
  published: 2006-01-02
  lastUpdated: 2006-01-02 15:04 MST

widgets:
  homepage:
    - type: search
    - type: archives
      params:
        limit: 5
    - type: categories
      params:
        limit: 10
    - type: tag-cloud
      params:
        limit: 10
  page:
    - type: toc

comments:
  enabled: false

footer:
  since: 2020
  customText: ''

opengraph:
  twitter:
    site: ''
    card: summary_large_image

defaultImage:
  opengraph:
    enabled: false
    local: false
    src: ''

colorScheme:
  toggle: true
  default: auto

imageProcessing:
  cover:
    enabled: true
  content:
    enabled: true
```

### config/_default/menu.yaml
```yaml
main:
  - identifier: home
    name: Home
    url: /
    weight: 1
    params:
      icon: home
    
  - identifier: archives
    name: Archives
    url: /archives/
    weight: 2
    params:
      icon: archives
    
  - identifier: search
    name: Search
    url: /search/
    weight: 3
    params:
      icon: search

social:
  - identifier: github
    name: GitHub
    url: https://github.com/urfreein
    params:
      icon: brand-github
```

---

## 커스터마이징 가이드

### 1. Archives 페이지 생성

```markdown
<!-- content/page/archives/index.ko.md -->
---
title: 아카이브
description: 모든 포스트 아카이브
menu:
    main: 
        weight: 2
        params:
            icon: archives
layout: archives
slug: archives
---
```

```markdown
<!-- content/page/archives/index.en.md -->
---
title: Archives
description: All posts archive
menu:
    main: 
        weight: 2
        params:
            icon: archives
layout: archives
slug: archives
---
```

### 2. Search 페이지 생성

```markdown
<!-- content/page/search/index.ko.md -->
---
title: 검색
description: 포스트 검색
menu:
    main:
        weight: 3
        params:
            icon: search
layout: search
slug: search
---
```

```markdown
<!-- content/page/search/index.en.md -->
---
title: Search
description: Search posts
menu:
    main:
        weight: 3
        params:
            icon: search
layout: search
slug: search
---
```

### 3. 다국어 포스트 작성

#### 파일명 규칙
- `post-title.ko.md` - 한국어
- `post-title.en.md` - 영어
- `post-title.ja.md` - 일본어

#### Front Matter 예시

```yaml
---
title: Hugo Stack 테마 가이드
date: 2025-01-01T00:00:00+09:00
lastmod: 2025-01-01T00:00:00+09:00
draft: false
description: Stack 테마 완벽 가이드
tags: ["hugo", "stack", "theme"]
categories: ["웹개발"]
image: https://images.urinfo24.com/featured/stack-guide.jpg

# 선택적 설정
math: true              # KaTeX 수학 지원
toc: true               # 목차 표시
readingTime: true       # 읽기 시간 표시
comments: true          # 댓글 활성화
license: CC BY-NC-SA    # 라이선스 (false로 숨김 가능)

# 스타일 커스터마이징 (카테고리/태그 뱃지)
style:
  background: "#2a9d8f"
  color: "#fff"
---

## 콘텐츠 시작

여기에 포스트 내용 작성...
```

### 4. 카테고리 페이지 커스터마이징

```markdown
<!-- content/categories/web-development/_index.md -->
---
title: "웹 개발"
description: "웹 개발 관련 포스트"
image: "web-dev-banner.jpg"

style:
  background: "#2a9d8f"
  color: "#fff"
---

웹 개발 카테고리 설명...
```

### 5. Shortcodes 사용

Stack 테마 기본 제공 shortcodes:

#### Bilibili
```markdown
{{< bilibili BV1d4411e7mN >}}
```

#### YouTube
```markdown
{{< youtube dQw4w9WgXcQ >}}
```

#### Quote
```markdown
{{< quote author="Author Name" source="Source Title" url="https://source.url" >}}
인용문 내용
{{< /quote >}}
```

---

## 트러블슈팅

### 1. TOC(목차)가 보이지 않을 때

**체크리스트:**
1. ✅ `params.yaml`에 `article.toc: true` 설정
2. ✅ `widgets.page`에 `- type: toc` 추가
3. ✅ 포스트에 헤딩(##, ###)이 최소 1개 이상 있는지 확인
4. ✅ Front Matter에 `toc: false`로 설정되어 있지 않은지 확인

**해결 방법:**
```yaml
# params.yaml
article:
  toc: true

widgets:
  page:
    - type: toc
```

### 2. 다국어 포스트가 모두 보일 때

**원인:** Hugo는 언어별로 URL을 자동 분리
- `/ko/` → 한국어 사이트 (한국어 포스트만)
- `/en/` → 영어 사이트 (영어 포스트만)
- `/` → 기본 언어 (defaultContentLanguage 설정)

**해결 방법:**
1. 브라우저 캐시 클리어
2. `/ko/` 또는 `/en/` 명시적으로 접속
3. 언어 선택기로 전환 확인

### 3. Hugo Module 에러

```
Error: failed to download modules: binary with name "go" not found
```

**원인:** Go가 PATH에 없거나 설치되지 않음

**로컬 해결:**
```bash
# Go 설치 확인
which go

# PATH에 Go 추가
export PATH=/usr/local/go/bin:$PATH
```

**Cloudflare Pages 해결:**
환경변수 설정
```
GO_VERSION=1.21
HUGO_VERSION=0.152.2
```

### 4. 이미지가 표시되지 않을 때

**Page Bundle 방식 사용:**
```
content/
└── posts/
    └── my-post/
        ├── index.md
        ├── image1.jpg
        └── image2.jpg
```

**마크다운에서 참조:**
```markdown
![이미지 설명](image1.jpg)
```

**외부 URL 사용:**
```markdown
![이미지 설명](https://images.urinfo24.com/image.jpg)
```

### 5. 빌드 에러: SCSS 관련

```
Error: TOCSS: failed to transform "scss/style.scss"
```

**원인:** Hugo Extended 버전이 아님

**해결:**
```bash
# Hugo Extended 설치 확인
hugo version | grep extended
```

### 6. Search 또는 Archives 페이지 경고

```
WARN Search page not found
WARN Archives page not found
```

**해결:** 해당 레이아웃을 가진 페이지 생성
```bash
# Archives
hugo new page/archives/index.md

# Search
hugo new page/search/index.md
```

---

## 유용한 링크

### 공식 문서
- Stack 테마: https://stack.jimmycai.com
- Stack GitHub: https://github.com/CaiJimmy/hugo-theme-stack
- Hugo 공식 문서: https://gohugo.io/documentation

### 리소스
- Tabler Icons: https://tabler-icons.io
- KaTeX: https://katex.org
- PhotoSwipe: https://photoswipe.com

### 커뮤니티
- Hugo Discourse: https://discourse.gohugo.io
- Stack Issues: https://github.com/CaiJimmy/hugo-theme-stack/issues

---

## 프로젝트 정보

- **블로그**: https://urinfo24.com
- **Repository**: github.com/urfreein/urinfo24-blog
- **테마**: Hugo Stack v3 (v3.32.0)
- **배포**: Cloudflare Pages
- **Hugo 버전**: 0.152.2 (Extended)
- **Go 버전**: 1.21

---

## 변경 이력

- **2025-12-18**: Stack 테마로 마이그레이션
  - Astro morethan-log에서 Hugo Stack으로 전환
  - 10개 언어 지원 설정
  - 완전한 테마 커스터마이징 적용
  - Archives 및 Search 페이지 생성

---

**문서 작성일**: 2025-12-18  
**최종 수정일**: 2025-12-18  
**작성자**: Claude (with freein)
