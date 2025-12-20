---
title: "2025년 정적 사이트 생성기(SSG) 완벽 가이드: Jekyll, Hugo, Astro 비교"
date: 2025-12-19T22:10:00+09:00
lastmod: 2025-12-19T22:47:44+09:00
draft: false
description: "Jekyll, Hugo, Astro 등 주요 SSG 도구들의 장단점을 상세 비교하고, 빌드 성능 벤치마크와 실전 예제를 통해 최적의 선택 가이드를 제공합니다."
tags: ["SSG", "Static Site Generator", "Jekyll", "Hugo", "Astro", "Next.js", "Eleventy", "웹개발", "블로그", "성능최적화"]
categories: ["Web Development"]
image: "https://urinfo24.com/cdn-cgi/image/width=800,format=auto,quality=75/https://images.urinfo24.com/featured/ssg-comparison-guide-2025-featured.jpg"
lightgallery: true
---

<!--
Image Prompt: /home/freein/blog/images/image-prompt/ssg-comparison-guide-2025-prompt.txt
Featured Image: https://images.urinfo24.com/featured/ssg-comparison-guide-2025-featured.jpg
-->

## 1. SSG란 무엇인가?

정적 사이트 생성기(Static Site Generator)는 말 그대로 정적 HTML 파일을 미리 생성해주는 도구다.
WordPress 같은 동적 CMS와는 완전히 다른 방식이다.

### 1.1 동적 사이트 vs 정적 사이트

**동적 사이트의 작동 방식**:
```
사용자 요청 → 서버 처리 → DB 쿼리 → HTML 생성 → 응답
```

매번 요청마다 서버가 HTML을 만들어낸다.
따라서 서버 부하가 크고, 응답 속도가 느리다.

**정적 사이트의 작동 방식**:
```
빌드 시점 → HTML 파일 생성 → CDN 배포 → 사용자 요청 시 즉시 응답
```

미리 만들어둔 HTML을 그냥 보여주기만 한다.
서버 처리가 없으니 엄청 빠르다.

### 1.2 SSG의 핵심 장점

**성능이 압도적이다**.
CDN에서 직접 HTML을 서빙하니 로딩 속도가 밀리초 단위다.

**보안이 탄탄하다**.
서버 사이드 로직이 없다.
따라서 SQL 인젝션이나 XSS 같은 공격에 안전하다.

**비용이 저렴하다**.
정적 파일만 호스팅하면 되니 서버 리소스가 거의 안 든다.
GitHub Pages나 Netlify에서 무료로 호스팅 가능하다.

**확장성이 좋다**.
트래픽이 10배 증가해도 문제없다.
CDN이 알아서 처리한다.

### 1.3 SSG가 적합한 경우

블로그, 포트폴리오, 문서 사이트가 대표적이다.
콘텐츠가 자주 바뀌지 않는 사이트에 최적이다.

마케팅 랜딩 페이지도 좋다.
SEO 최적화가 기본으로 되어있다.

## 2. 2025년 주요 SSG 도구 소개

### 2.1 Hugo - 속도의 제왕

**빌드 속도가 압도적이다**.
Go 언어로 만들어져서 1000개 페이지를 몇 초 만에 빌드한다.
특징:
- 단일 바이너리 파일로 배포 (설치 간편)
- Go 템플릿 엔진 사용
- 다국어 지원 기본 내장
- 풍부한 테마 생태계

**설치**:
```bash
# macOS
brew install hugo

# Windows (Chocolatey)
choco install hugo-extended

# Linux
snap install hugo
```

**장점**:
- 빌드 속도 최고 (1000 페이지 < 3초)
- 의존성 없음 (단일 바이너리)
- 대규모 사이트에 최적
- 이미지 최적화 내장

**단점**:
- Go 템플릿 언어 학습 곡선
- 템플릿 문법이 복잡할 수 있음
- 에러 메시지가 불친절

### 2.2 Jekyll - GitHub Pages의 표준

**가장 오래된 SSG다**.
GitHub Pages가 기본 지원한다.

특징:
- Ruby 기반
- Liquid 템플릿 엔진
- GitHub Pages 완벽 통합
- 풍부한 플러그인

**설치**:
```bash
gem install bundler jekyll
jekyll new my-blog
cd my-blog
bundle exec jekyll serve
```

**장점**:
- 학습 곡선이 완만함
- GitHub Pages 무료 호스팅
- 플러그인 생태계 풍부
- 문서화가 잘 되어있음

**단점**:
- 빌드 속도 느림 (1000 페이지 > 60초)
- Ruby 환경 설정 번거로움
- 대규모 사이트에 비효율적

### 2.3 Astro - 모던 프레임워크의 강자

**2021년 등장한 최신 SSG다**.
Zero JavaScript가 기본이다.

특징:
- 부분 하이드레이션 (Partial Hydration)
- 다중 프레임워크 지원 (React, Vue, Svelte)
- 컴포넌트 아일랜드 아키텍처
- Vite 기반 빠른 개발 서버

**설치**:
```bash
npm create astro@latest
cd my-astro-site
npm run dev
```

**장점**:
- 기본 JavaScript 제로 (최고 성능)
- 여러 프레임워크 혼용 가능
- 개발자 경험 우수
- 모던한 개발 환경

**단점**:
- 비교적 신생 (생태계 발전 중)
- Node.js 환경 필수
- 복잡한 인터랙션엔 제약

### 2.4 Next.js - 하이브리드의 정석

**React 기반 메타 프레임워크다**.
SSG, SSR, ISR을 모두 지원한다.

특징:
- Static Site Generation
- Server-Side Rendering
- Incremental Static Regeneration
- API Routes 내장

**설치**:
```bash
npx create-next-app@latest
cd my-next-app
npm run dev
```

**장점**:
- 정적/동적 혼합 가능
- React 생태계 활용
- 이미지 최적화 자동
- Vercel 배포 간편

**단점**:
- 순수 정적 사이트엔 과함
- 빌드 시간이 김
- 번들 크기가 큼

### 2.5 Eleventy - 미니멀리스트의 선택

**JavaScript 기반 경량 SSG다**.
프레임워크에 독립적이다.

특징:
- 프레임워크 비의존적
- 다양한 템플릿 언어 지원
- Zero Config 가능
- 빠른 빌드 속도

**설치**:
```bash
npm install -g @11ty/eleventy
echo '# Page header' > README.md
eleventy --serve
```

**장점**:
- 매우 유연함
- 학습 곡선 낮음
- 빌드 속도 빠름 (Hugo 다음)
- 플러그인 없이도 강력

**단점**:
- 큰 프로젝트엔 설정 복잡
- 이미지 처리 플러그인 필요
- 테마 생태계 작음

## 3. 각 SSG의 장단점 상세 비교

### 3.1 빌드 속도 비교

**1000 페이지 기준 상대적 빌드 속도**:

```
Hugo:     가장 빠름    ⚡⚡⚡⚡⚡
Eleventy: 매우 빠름    ⚡⚡⚡⚡
Astro:    빠름        ⚡⚡⚡
Next.js:  보통        ⚡⚡
Jekyll:   느림        ⚡
```

Hugo가 압도적으로 빠르다.
Eleventy도 상당히 빠른 편이다.
Jekyll은 대규모 사이트에선 버거워한다.


### 3.2 학습 곡선 비교

**초보자부터 고급까지**:

```
Jekyll:   ⭐⭐⭐⭐⭐ (가장 쉬움)
Eleventy: ⭐⭐⭐⭐
Next.js:  ⭐⭐⭐
Hugo:     ⭐⭐
Astro:    ⭐⭐
```

Jekyll은 Liquid 템플릿이 직관적이다.
Hugo는 Go 템플릿이 처음엔 어렵다.
하지만 익숙해지면 강력하다.

### 3.3 생태계 및 커뮤니티

**플러그인/테마 수 (GitHub stars 기준)**:

| SSG | Stars | 테마 수 | 활성도 |
|-----|-------|---------|--------|
| Next.js | 126k | 수백개 | 매우 활발 |
| Hugo | 75k | 500+ | 활발 |
| Gatsby | 55k | 1000+ | 보통 |
| Astro | 46k | 200+ | 활발 |
| Jekyll | 49k | 1000+ | 안정적 |

Next.js가 가장 인기다.
하지만 순수 SSG는 아니다.

Hugo와 Jekyll이 전통적 강자다.
Astro는 빠르게 성장 중이다.

### 3.4 사용 사례별 추천

**개인 블로그**:
- Jekyll (GitHub Pages 무료)
- Hugo (속도 중요 시)

**기술 문서**:
- Hugo (대규모 문서)
- Eleventy (유연성 필요 시)

**포트폴리오**:
- Astro (인터랙티브 요소)
- Next.js (복잡한 UI)

**마케팅 사이트**:
- Astro (성능 최우선)
- Next.js (동적 요소 필요 시)

**대규모 콘텐츠 사이트**:
- Hugo (빌드 속도 핵심)
- Eleventy (유연성 필요)

## 4. Hugo로 5분 만에 블로그 구축하기

이제 실습이다.
Hugo로 간단한 블로그를 만들어보자.

### 5.1 Hugo 설치

**macOS**:
```bash
brew install hugo
hugo version
```

**Windows**:
```bash
choco install hugo-extended -y
hugo version
```

**Linux**:
```bash
snap install hugo
hugo version
```

### 5.2 새 사이트 생성

```bash
# 프로젝트 생성
hugo new site my-blog
cd my-blog

# Git 초기화
git init
```

디렉토리 구조가 생성된다:
```
my-blog/
├── archetypes/
├── content/
├── data/
├── layouts/
├── static/
├── themes/
└── config.toml
```

### 5.3 테마 설치

PaperMod 테마를 사용하자.
인기 있고 깔끔하다.

```bash
git submodule add --depth=1 \
  https://github.com/adityatelange/hugo-PaperMod.git \
  themes/PaperMod

echo "theme = 'PaperMod'" >> config.toml
```

### 5.4 설정 파일 작성

`config.toml` 수정:
```toml
baseURL = 'https://example.com/'
languageCode = 'ko-kr'
title = '내 블로그'
theme = 'PaperMod'

[params]
  description = "Hugo로 만든 기술 블로그"
  author = "홍길동"
  
[menu]
  [[menu.main]]
    name = "Home"
    url = "/"
    weight = 1
  [[menu.main]]
    name = "Posts"
    url = "/posts/"
    weight = 2
  [[menu.main]]
    name = "Tags"
    url = "/tags/"
    weight = 3
```


### 5.5 첫 포스트 작성

```bash
hugo new posts/my-first-post.md
```

`content/posts/my-first-post.md` 파일이 생성된다:
```markdown
---
title: "Hugo로 만든 첫 포스트"
date: 2025-12-19T22:00:00+09:00
draft: false
tags: ["hugo", "blog"]
---

## 안녕하세요!

Hugo로 블로그를 시작했습니다.

### 코드 블록도 잘 됩니다

```python
def hello():
    print("Hello, Hugo!")
```

앞으로 많은 글을 작성하겠습니다.
```

### 5.6 로컬 서버 실행

```bash
hugo server -D
```

`-D` 옵션은 draft 포스트도 보여준다.

브라우저에서 접속:
```
http://localhost:1313
```

변경사항이 실시간으로 반영된다.
Hot Reload가 기본이다.

### 5.7 빌드 및 배포

**프로덕션 빌드**:
```bash
hugo --minify
```

`public/` 디렉토리에 정적 파일이 생성된다.
이걸 그냥 웹 서버에 올리면 끝이다.

**Netlify 배포**:
```bash
# netlify.toml 생성
cat > netlify.toml << 'EOF'
[build]
  publish = "public"
  command = "hugo --gc --minify"

[context.production.environment]
  HUGO_VERSION = "0.121.0"
  HUGO_ENV = "production"
EOF

git add .
git commit -m "Initial commit"
git push origin main
```

Netlify에서 자동 배포된다.
무료로 사용 가능하다.

## 5. 정리

### 5.1 SSG 선택 가이드

**속도가 최우선이라면**:
→ Hugo 선택
- 대규모 사이트에 최적
- 빌드 시간 2-3초
- 메모리 효율 최고

**쉬운 시작을 원한다면**:
→ Jekyll 선택
- GitHub Pages 무료 호스팅
- 학습 곡선 낮음
- 소규모 블로그에 적합

**모던한 개발 경험을 원한다면**:
→ Astro 선택
- Zero JavaScript
- 다중 프레임워크 지원
- 최고 성능

**정적/동적 혼합이 필요하다면**:
→ Next.js 선택
- SSG + SSR
- React 생태계
- 복잡한 웹앱 가능

**유연성이 필요하다면**:
→ Eleventy 선택
- 프레임워크 독립적
- 빌드 속도 빠름
- 커스터마이징 자유

### 5.2 핵심 요약

**빌드 속도**:
Hugo > Eleventy > Astro > Next.js > Jekyll

**학습 난이도**:
Jekyll < Eleventy < Next.js < Astro < Hugo

**성능 (페이지 크기)**:
Astro < Hugo < Eleventy < Jekyll < Next.js

**커뮤니티 크기**:
Next.js > Jekyll > Hugo > Astro > Eleventy

**추천 용도**:
- 개인 블로그 → Jekyll, Hugo
- 기술 문서 → Hugo, Eleventy
- 포트폴리오 → Astro, Next.js
- 대규모 사이트 → Hugo

### 5.3 2025년 트렌드

**Astro가 빠르게 성장 중이다**.
Zero JavaScript 접근이 인기다.

**Hugo는 여전히 속도의 왕이다**.
대규모 사이트에선 대체 불가다.

**Jekyll은 안정적인 선택이다**.
새 기능은 적지만 검증됐다.

**Next.js는 웹앱 영역으로 확장 중이다**.
순수 SSG보다 메타 프레임워크에 가깝다.

### 5.4 마치며

SSG는 각자 장단점이 명확하다.
따라서 프로젝트 특성에 맞춰 선택해야 한다.

속도가 중요하다면 Hugo다.
GitHub Pages를 쓴다면 Jekyll이다.
최신 기술을 원한다면 Astro다.

어떤 선택을 하든 동적 CMS보다 빠르고 안전하다.
그게 SSG의 가장 큰 장점이다.

이제 직접 사용해보자.
5분이면 블로그를 만들 수 있다.
