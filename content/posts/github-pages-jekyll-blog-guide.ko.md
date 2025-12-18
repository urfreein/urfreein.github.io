---
title: GitHub Pages와 Jekyll로 개발자 블로그 만들기
date: 2025-11-11T00:10:00+09:00
lastmod: 2025-11-11T00:10:00+09:00
draft: false
description: GitHub Pages와 Jekyll을 활용하여 무료로 개발자스러운 블로그를 만드는 완벽 가이드
tags: ["github-pages", "jekyll", "정적-사이트", "블로그", "개발자-블로그"]
categories: ["개발"]
image: "https://images.urinfo24.com/featured/github-pages-jekyll-blog-guide-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A modern, professional tech illustration for "GitHub Pages와 Jekyll로 개발자 블로그 만들기".
- Style: Clean, professional, flat design with technical elements
- Subject: Visual representation of github pages jekyll blog guide
- Elements: Technical icons, symbols, code snippets, terminal windows, relevant tech logos
- Colors: Blue and gray tech tones, white background, accent colors for highlights
- Mood: Professional, modern, educational, technical
- Composition: Centered layout with balanced elements, clean and organized

Technical keywords: github-pages,  "jekyll,  "정적-사이트,  "블로그,  "개발자-블로그

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/github-pages-jekyll-blog-guide-featured.jpg

NOTE: Hugo will serve this from /images/github-pages-jekyll-blog-guide-featured.jpg
-->

## GitHub Pages와 Jekyll을 선택해야 하는 이유

개발자라면 네이버 블로그나 티스토리 같은 일반 블로그 플랫폼보다 GitHub Pages를 활용한 블로그를 고려해볼 만합니다. GitHub Pages는 GitHub에서 제공하는 무료 정적 웹사이트 호스팅 서비스로, 개발자의 포트폴리오이자 기술 블로그로 활용하기에 최적화되어 있습니다. github.io라는 도메인으로 호스팅 되므로, 개발자들에게 친숙한 github에 익숙한 사용자라는 인상을 주는 것도 덤입니다.

### 개발자에게 GitHub Pages가 매력적인 이유

- **Git 버전 관리**: 글의 변경 이력을 추적하고 이전 버전으로 되돌릴 수 있고, 자연스럽게 git에 익숙해 집니다.
- **Markdown 지원**: 코드 블록과 기술 문서 작성에 최적화된 Markdown으로 글을 작성합니다.
- **완전 무료**: 호스팅 비용이 전혀 들지 않으며, 용량 제한도 넉넉합니다.
- **자유로운 커스터마이징**: HTML, CSS, JavaScript를 직접 수정하여 원하는 대로 꾸밀 수 있습니다.
- **개발자스러운 이미지**: 기술 블로그로서의 전문성을 보여줄 수 있습니다.

Jekyll은 Ruby 기반의 정적 사이트 생성기로, Markdown 형식으로 작성한 글을 자동으로 HTML로 변환해줍니다. GitHub Pages는 Jekyll을 기본적으로 지원하기 때문에 별도의 빌드 과정 없이 바로 배포할 수 있습니다.
Github Pages가 웹서비스를 위한 땅을 제공한다면, Jekyll은 집을 만드는 도구이고, Jekyll에 적용하는 테마는 집의 다양한 모양을 제공하는 것에 비유할 수 있습니다.

## GitHub Repository 생성하기

GitHub Pages 블로그를 시작하려면 특별한 이름 규칙을 따르는 저장소를 생성해야 합니다.

### 저장소 생성 단계

1. GitHub에 로그인 후 우측 상단의 **+** 버튼 클릭
2. **New repository** 선택
3. 저장소 이름을 `username.github.io` 형식으로 입력
   - 예: `freein.github.io`
   - `username`은 본인의 GitHub 사용자 이름으로 정확히 입력
4. **Public**으로 설정 (필수)
5. **Create repository** 클릭


### GitHub Pages 활성화

1. 생성한 저장소의 **Settings** 탭으로 이동
2. 왼쪽 메뉴에서 **Pages** 선택
3. **Source** 섹션에서 배포 브랜치 선택
   - Branch: `main`
   - Folder: `/ (root)`
4. **Save** 클릭

몇 분 후 `https://username.github.io` 주소로 접속할 수 있게 됩니다.

## Jekyll 설치 및 초기 설정

### Ruby 설치

Jekyll을 사용하려면 먼저 Ruby를 설치해야 합니다.

**Windows**
```bash
# RubyInstaller 다운로드 및 설치
# https://rubyinstaller.org/downloads/
# Ruby+Devkit 버전 선택 (3.0 이상 권장)
```

**macOS**
```bash
# Homebrew로 설치
brew install ruby
```

**Linux (Ubuntu/Debian)**
```bash
sudo apt-get update
sudo apt-get install ruby-full build-essential zlib1g-dev
```

### Jekyll과 Bundler 설치

터미널을 열고 다음 명령어를 실행합니다.

```bash
gem install jekyll bundler
```

설치 확인:
```bash
jekyll -v
# Jekyll 4.x.x 같은 버전 정보가 출력되면 성공
```

### Jekyll 사이트 생성

위에서 만든 Github 저장소를 로컬에 클론하고 Jekyll 사이트를 생성합니다.

```bash
# 저장소 클론
git clone https://github.com/username/username.github.io.git
cd username.github.io

# Jekyll 사이트 생성
jekyll new . --force

# 의존성 설치
bundle install

# 로컬 서버 실행
bundle exec jekyll serve
```

브라우저에서 `http://localhost:4000`으로 접속하면 생성된 사이트를 확인할 수 있습니다.

### 기본 구조 이해하기

Jekyll 사이트의 주요 디렉토리와 파일 구조는 다음과 같습니다.

```
username.github.io/
├── _config.yml       # 사이트 전체 설정 파일
├── _posts/           # 블로그 글을 저장하는 디렉토리
├── _layouts/         # 페이지 레이아웃 템플릿
├── _includes/        # 재사용 가능한 컴포넌트
├── _sass/            # CSS 스타일 파일
├── assets/           # 이미지, CSS, JS 등 정적 파일
├── Gemfile           # Ruby 의존성 관리 파일
└── index.md          # 홈페이지 파일
```

### 사이트 기본 설정

`_config.yml` 파일을 열어 기본 정보를 수정합니다.

```yaml
# 사이트 기본 정보
title: 내 기술 블로그
description: 개발하며 배운 것들을 기록합니다
author: 홍길동
email: your-email@example.com

# URL 설정
url: "https://username.github.io"
baseurl: ""

# 빌드 설정
markdown: kramdown
theme: minima
```

설정을 변경한 후에는 Jekyll 서버를 재시작해야 반영됩니다.

## 테마 선택과 적용

기본 Jekyll 테마는 단순하기 때문에 대부분의 사용자는 더 세련된 테마를 적용합니다.

### 인기 있는 Jekyll 테마

- **Minimal Mistakes**: 깔끔하고 기능이 풍부한 테마
- **Chirpy**: 다크 모드를 지원하는 모던한 테마
- **Beautiful Jekyll**: 심플하면서도 아름다운 디자인
- **Type Theme**: 타이포그래피에 중점을 둔 테마

테마 찾기: [jekyllthemes.org](https://jekyllthemes.org), [jekyllthemes.io](https://jekyllthemes.io)


### Remote Theme 방식으로 테마 적용하기

Remote Theme 방식은 테마 업데이트를 쉽게 받을 수 있어 권장됩니다.

**1단계: Gemfile 수정**

```ruby
# Gemfile
source "https://rubygems.org"

gem "jekyll", "~> 4.3"
gem "jekyll-remote-theme"

group :jekyll_plugins do
  gem "jekyll-feed"
  gem "jekyll-seo-tag"
end
```

**2단계: _config.yml에 테마 추가**

```yaml
# Remote Theme 설정 (예: Chirpy 테마)
remote_theme: cotes2020/jekyll-theme-chirpy

# 플러그인 활성화
plugins:
  - jekyll-remote-theme
  - jekyll-feed
  - jekyll-seo-tag
```

**3단계: 의존성 설치 및 실행**

```bash
bundle install
bundle exec jekyll serve
```

### 테마 커스터마이징

각 테마는 고유한 설정 옵션을 제공합니다. 테마의 GitHub 저장소에서 README를 확인하여 사용 가능한 옵션을 파악할 수 있습니다.

```yaml
# Chirpy 테마 커스터마이징 예시
theme_mode: dual  # light, dark, dual

# 소셜 링크
social:
  name: 홍길동
  email: your-email@example.com
  links:
    - https://github.com/username
    - https://twitter.com/username

# 구글 애널리틱스
google_analytics:
  id: 'G-XXXXXXXXXX'
```


## 첫 글 작성하기

Jekyll에서 블로그 글은 `_posts` 디렉토리에 Markdown 파일로 작성됩니다.

### 파일명 규칙

파일명은 반드시 다음 형식을 따라야 합니다.

```
YYYY-MM-DD-title.md
```

예시:
```
2025-11-10-my-first-post.md
2025-11-10-github-pages-tutorial.md
```

### Front Matter 작성

각 포스트 파일은 Front Matter라는 메타데이터로 시작합니다.

```markdown
---
title: 내 첫 블로그 글
date: 2025-11-10 14:30:00 +0900
categories: [개발, 튜토리얼]
tags: [jekyll, github-pages, 블로그]
excerpt: GitHub Pages로 만든 첫 번째 블로그 글입니다
---

## 첫 번째 섹션

여기에 본문 내용을 작성합니다.
```

### Front Matter 주요 항목

- `title`: 글 제목
- `date`: 작성 날짜 (YYYY-MM-DD HH:MM:SS +0900 형식)
- `categories`: 카테고리 (대괄호 안에 배열 형태로 작성)
- `tags`: 태그 (여러 개 지정 가능)
- `excerpt`: 글 요약 (선택사항)
- `layout`: 레이아웃 지정 (기본값: post)

### Markdown 본문 작성 예시

```markdown
## 제목 2

일반 텍스트 단락입니다. **굵은 글씨**와 *기울임*을 사용할 수 있습니다.

### 코드 블록

파이썬 코드 예시:

```python
def hello_world():
    print("Hello, GitHub Pages!")
    
hello_world()
\```

### 목록

- 항목 1
- 항목 2
- 항목 3

### 링크와 이미지

[GitHub Pages 공식 문서](https://pages.github.com)

![대체 텍스트](/assets/images/sample.jpg)
```

### 이미지 관리

이미지는 `assets/images` 디렉토리에 저장하는 것이 일반적입니다.

```bash
# 디렉토리 생성
mkdir -p assets/images

# 이미지 파일 복사
cp ~/Downloads/screenshot.png assets/images/
```

Markdown에서 이미지 사용:
```markdown
![스크린샷 설명](/assets/images/screenshot.png)
```

## 사이트 배포하기

작성한 내용을 GitHub에 푸시하면 자동으로 사이트가 빌드되고 배포됩니다.

### Git 명령어로 배포하기

```bash
# 변경된 파일 스테이징
git add .

# 커밋 메시지 작성
git commit -m "첫 번째 블로그 글 추가"

# GitHub에 푸시
git push origin main
```

### 배포 상태 확인

1. GitHub 저장소의 **Actions** 탭 클릭
2. 최근 워크플로우 실행 상태 확인
3. 녹색 체크 표시가 나타나면 배포 완료

보통 푸시 후 1-2분이면 사이트가 업데이트됩니다.

### 배포 후 확인

브라우저에서 `https://username.github.io`로 접속하여 변경 사항을 확인합니다.

캐시 문제로 변경이 안 보일 경우:
- **Ctrl + F5** (Windows/Linux)
- **Cmd + Shift + R** (macOS)


## 커스터마이징과 고급 기능

### 디렉토리 구조 이해

Jekyll의 핵심 디렉토리를 커스터마이징할 수 있습니다.

```
_layouts/        # 페이지 레이아웃 템플릿
  ├── default.html
  ├── post.html
  └── page.html

_includes/       # 재사용 가능한 컴포넌트
  ├── header.html
  ├── footer.html
  └── sidebar.html

_sass/           # SCSS 스타일 파일
  └── custom.scss

assets/
  ├── css/
  ├── js/
  └── images/
```

### CSS 커스터마이징

`assets/css/custom.css` 파일을 만들어 스타일을 추가할 수 있습니다.

```css
/* 커스텀 스타일 예시 */
body {
    font-family: 'Noto Sans KR', sans-serif;
}

.post-title {
    color: #2c3e50;
    font-weight: 700;
}

code {
    background-color: #f8f9fa;
    padding: 2px 6px;
    border-radius: 3px;
}
```

`_config.yml`에서 폰트 추가:
```yaml
# Google Fonts 추가
google_fonts:
  - Noto+Sans+KR:400,700
```

### 플러그인 활용

GitHub Pages에서 지원하는 주요 플러그인:

```yaml
# _config.yml
plugins:
  - jekyll-feed          # RSS 피드 생성
  - jekyll-seo-tag       # SEO 메타 태그
  - jekyll-sitemap       # 사이트맵 자동 생성
  - jekyll-paginate      # 페이지네이션
```


### Google Analytics 연동

방문자 통계를 추적하려면 Google Analytics를 연동합니다.

**1단계: Google Analytics 계정 생성**
- [Google Analytics](https://analytics.google.com) 접속
- 속성 만들기
- 측정 ID 복사 (예: G-XXXXXXXXXX)

**2단계: _config.yml 설정**
```yaml
google_analytics:
  id: 'G-XXXXXXXXXX'
```

### 댓글 기능 추가

**Utterances (GitHub Issues 기반)**

```yaml
# _config.yml
comments:
  provider: utterances
  utterances:
    repo: username/username.github.io
    issue_term: pathname
    theme: github-light
```

Utterances는 GitHub 계정으로 로그인하여 댓글을 작성하므로 개발자 블로그에 적합합니다.

**Disqus (전통적인 댓글 시스템)**

```yaml
comments:
  provider: disqus
  disqus:
    shortname: your-disqus-shortname
```

### SEO 최적화

**sitemap.xml 자동 생성**

`jekyll-sitemap` 플러그인이 자동으로 생성해줍니다.

```yaml
# _config.yml
plugins:
  - jekyll-sitemap

url: "https://username.github.io"
```

**robots.txt 추가**

루트 디렉토리에 `robots.txt` 파일 생성:

```
User-agent: *
Allow: /

Sitemap: https://username.github.io/sitemap.xml
```


## 블로그 운영 팁

### 꾸준한 글 작성 전략

성공적인 블로그 운영을 위한 실용적인 팁들입니다.

**주제 선정**
- 학습한 내용 정리 (TIL - Today I Learned)
- 프로젝트 진행 과정 기록
- 문제 해결 과정 공유
- 개발 도구 사용법 정리
- Code Review 및 Best Practice

**작성 습관 만들기**
- 처음부터 완벽한 글을 쓰려고 하지 말기
- 짧은 글이라도 자주 작성하기
- 초안 작성 후 하루 뒤 다시 읽고 수정하기
- 메모 습관화하기 (아이디어가 떠오를 때마다 기록)

### 코드 예제 작성 요령

독자가 이해하기 쉬운 코드 예제를 작성합니다.

```python
# 나쁜 예: 설명 없는 코드
def f(x): return x*2

# 좋은 예: 명확한 설명이 있는 코드
def double_number(number):
    """
    주어진 숫자를 2배로 만들어 반환합니다.
    
    Args:
        number (int): 2배로 만들 숫자
    
    Returns:
        int: 입력값의 2배
    """
    return number * 2

# 사용 예시
result = double_number(5)
print(f"결과: {result}")  # 출력: 결과: 10
```

### SEO 최적화 체크리스트

검색 엔진에 노출되기 위한 필수 사항들입니다.

- [ ] 제목에 핵심 Keyword 포함
- [ ] 메타 설명(excerpt) 작성
- [ ] 적절한 단락 구조 (H2, H3) 사용
- [ ] 이미지에 alt 텍스트 추가
- [ ] 내부 링크 활용 (다른 포스트 연결)
- [ ] 외부 참조 사이트 링크
- [ ] sitemap.xml 생성 확인
- [ ] Google Search Console 등록


### 자주 발생하는 문제 해결

**빌드 실패**

```bash
# 로컬에서 빌드 에러 확인
bundle exec jekyll build --verbose

# Gemfile.lock 삭제 후 재설치
rm Gemfile.lock
bundle install
```

**한글 인코딩 문제**

파일을 UTF-8 인코딩으로 저장했는지 확인합니다. VS Code에서는 우측 하단에서 인코딩을 확인하고 변경할 수 있습니다.

**캐시 문제**

로컬 서버 실행 시 캐시를 비우려면:

```bash
bundle exec jekyll serve --no-watch --force_polling
```

### 추천 작업 환경

**에디터**
- Visual Studio Code (Markdown 미리보기 지원)
- Jekyll 관련 VS Code 확장 프로그램 설치

**유용한 VS Code 확장**
- Markdown All in One
- Code Spell Checker
- GitLens

**로컬 테스트 워크플로우**

```bash
# 1. 로컬 서버 실행
bundle exec jekyll serve --livereload

# 2. 브라우저에서 확인 (http://localhost:4000)

# 3. 파일 저장 시 자동 새로고침

# 4. 만족하면 Git에 commit & push
git add .
git commit -m "새 글 추가: 제목"
git push
```

## 마치며

GitHub Pages와 Jekyll을 활용한 블로그는 개발자로서의 정체성을 드러내고 기술적 역량을 보여주는 효과적인 도구입니다. 초기 설정에 약간의 시간이 필요하지만, 한 번 구축해두면 장기적으로 유지보수가 쉽고 확장 가능한 플랫폼을 갖게 됩니다.

무엇보다 중요한 것은 꾸준히 글을 작성하는 것입니다. 완벽한 글을 쓰려고 하기보다는 작은 주제부터 시작하여 습관을 만들어가세요. 시간이 지나면서 본인만의 글쓰기 스타일과 블로그 운영 노하우가 생길 것입니다.
