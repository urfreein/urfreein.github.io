# GEMINI.md: urfreein.github.io 프로젝트 분석 보고서

## 1. 프로젝트 개요

이 프로젝트는 GitHub Pages와 Jekyll을 기반으로 구축된 개인 기술 블로그입니다. **Chirpy** 테마를 사용하여 깔끔하고 기능이 풍부한 디자인을 갖추고 있으며, 모든 콘텐츠는 마크다운(`.md`) 파일로 관리됩니다.

- **블로그 URL**: `https://urfreein.github.io`
- **GitHub 저장소**: `https://github.com/urfreein/urfreein.github.io`
- **테마**: Jekyll Chirpy Theme

## 2. 기술 스택

- **정적 사이트 생성**: Jekyll
- **테마**: Chirpy
- **콘텐츠 작성**: Markdown
- **호스팅**: GitHub Pages
- **CI/CD**: GitHub Actions
- **언어**: Ruby

## 3. 프로젝트 구조

프로젝트의 주요 디렉토리와 파일은 다음과 같습니다. 각 파일과 디렉토리는 블로그의 설정, 콘텐츠, 디자인을 구성하는 데 중요한 역할을 합니다.

- `_config.yml`: 사이트의 전반적인 설정을 담고 있는 핵심 파일. (사이트 제목, 저자, URL 등)
- `_posts/`: 블로그 게시물이 저장되는 디렉토리. `YYYY-MM-DD-title.md` 형식의 파일명 규칙을 따릅니다.
- `_data/authors.yml`: 포스트별 저자 정보를 관리하는 파일.
- `_tabs/`: 'About', 'Categories' 등 상단 탭 페이지의 콘텐츠를 관리하는 디렉토리.
- `_site/`: Jekyll이 빌드한 후 생성되는 정적 웹사이트 파일들이 위치하는 곳. (직접 수정하지 않음)
- `assets/`: 이미지, CSS, JS 등 정적 자산을 관리하는 디렉토리.
- `.github/workflows/pages-deploy.yml`: GitHub Actions를 이용한 자동 배포 워크플로우 정의 파일.
- `GEMINI.md`: (현재 파일) 프로젝트 분석 및 가이드 문서.

## 4. 주요 페이지 안내

Chirpy 테마는 블로그 탐색을 돕는 여러 기본 페이지를 제공합니다. 각 페이지는 사이드바를 통해 접근할 수 있습니다.

- **Home (`/`)**: 최신 글 목록이 표시되는 메인 페이지입니다. `pin: true`로 설정된 글을 상단에 고정할 수 있습니다.
- **Categories (`/categories/`)**: 계층적인 구조로 글을 분류합니다. 상위 카테고리와 하위 카테고리를 만들어 체계적으로 콘텐츠를 정리할 수 있습니다.
- **Tags (`/tags/`)**: 비계층적인 키워드로 글을 분류합니다. 특정 주제와 관련된 글들을 쉽게 찾아볼 수 있도록 돕습니다.
- **Archives (`/archives/`)**: 모든 글을 작성 연도 및 날짜순으로 보여주는 페이지입니다. 블로그의 전체 기록을 시간순으로 확인할 수 있습니다.
- **About (`/about/`)**: 블로그와 운영자에 대한 소개를 담는 정적 페이지입니다. `_tabs/about.md` 파일을 수정하여 내용을 채울 수 있습니다.

## 5. 콘텐츠 관리

### 새 글 작성 방법

1.  **파일 생성**: `_posts` 디렉토리 안에 `YYYY-MM-DD-post-title.md` 형식으로 새 마크다운 파일을 생성합니다. 파일명은 URL의 일부가 됩니다.
2.  **머리말(Front Matter) 작성**: 파일 상단에 다음과 같은 형식의 YAML 머리말을 작성하여 포스트의 속성을 정의합니다.

   ```yaml
   ---
   layout: post
   title: "포스트 제목"
   date: YYYY-MM-DD HH:MM:SS +/-TTTT
   last_modified_at: YYYY-MM-DD
   author: freein # _data/authors.yml에 정의된 저자 ID
   categories: [카테고리1, 카테고리2]
   tags: [태그1, 태그2]
   excerpt_separator: <!--more-->
   pin: true # true로 설정 시 홈 화면 상단에 고정
   toc: true # false로 설정 시 목차(TOC) 비활성화
   comments: true # false로 설정 시 댓글 기능 비활성화
   ---
   ```

3.  **요약(Excerpt) 구분**: 목록 페이지에 표시될 요약문과 전체 내용의 경계를 `<!--more-->` 태그로 지정합니다. 이 태그 이전의 내용이 요약으로 표시됩니다.
4.  **본문 작성**: 머리말과 요약 구분자 아래에 마크다운 문법을 사용하여 본문을 작성합니다.
5.  **배포**: 작성된 파일을 `main` 브랜치에 푸시하면 GitHub Actions가 자동으로 블로그를 빌드하고 배포합니다.

### Front Matter 주요 옵션

-   `title`: 포스트 제목
-   `date`: 포스트 작성일. 시간까지 지정할 수 있습니다. (예: `2024-10-20 14:30:00 +0900`)
-   `last_modified_at`: 최종 수정일. 이 값을 지정하면 포스트 상단에 "Updated" 날짜가 표시됩니다.
-   `categories`: 계층적인 카테고리. `[상위, 하위]` 순서로 지정할 수 있습니다.
-   `tags`: 비계층적인 태그.
-   `pin`: `true`로 설정하면 해당 글을 홈 페이지의 최상단에 고정시킬 수 있습니다.
-   `toc`: `false`로 설정하면 해당 포스트의 목차(Table of Contents)를 표시하지 않습니다.
-   `comments`: `false`로 설정하면 해당 포스트의 댓글 기능을 비활성화합니다.

## 6. 콘텐츠 스타일링 가이드

Chirpy 테마는 마크다운 콘텐츠를 더 풍부하게 표현할 수 있는 다양한 스타일링 기능을 제공합니다.

### 알림/정보 패널 (Prompt Panels)

독자의 주의를 끌어야 하는 팁, 정보, 경고 등을 효과적으로 전달할 수 있습니다. 마크다운 인용문(`>`) 바로 아래에 클래스를 지정하여 사용합니다.

```markdown
> Tip: 유용한 정보를 전달합니다.
{: .prompt-tip }

> Info: 일반적인 정보를 안내합니다.
{: .prompt-info }

> Warning: 주의가 필요한 내용을 강조합니다.
{: .prompt-warning }

> Danger: 위험하거나 꼭 확인해야 할 내용을 전달합니다.
{: .prompt-danger }
```

### 이미지 스타일링

- **이미지 정렬**: 이미지를 감싸는 `<a>` 또는 `<img>` 태그에 클래스를 추가하여 정렬할 수 있습니다.
  - `.left`: 왼쪽 정렬 (텍스트가 오른쪽으로 흐름)
  - `.right`: 오른쪽 정렬 (텍스트가 왼쪽으로 흐름)
  - `.normal`: 가운데 정렬 (기본값)
- **그림자 효과**: `.shadow` 클래스를 추가하여 이미지에 그림자 효과를 줄 수 있습니다.
- **캡션**: 이미지를 `<figure>` 태그로 감싸고 내부에 `<figcaption>`을 사용하면 이미지 아래에 캡션을 추가할 수 있습니다.

### 수식 표현

`$$`로 블록을 감싸거나 `$`로 인라인 수식을 감싸 LaTeX 문법을 사용하여 수학 공식을 표현할 수 있습니다.

```markdown
$$
\sum_{i=1}^n i = \frac{n(n+1)}{2}
$$
```

## 7. 배포 프로세스

이 프로젝트는 `.github/workflows/pages-deploy.yml`에 정의된 GitHub Actions 워크플로우를 통해 자동 배포됩니다.

- **트리거**: `main` 또는 `master` 브랜치에 `push` 이벤트가 발생할 때 실행됩니다.
- **프로세스**:
  1. Ubuntu 환경에서 코드를 체크아웃합니다.
  2. Ruby와 Bundler를 설정하고 의존성을 설치합니다.
  3. `bundle exec jekyll b` 명령어로 사이트를 빌드합니다.
  4. `htmlproofer`를 사용해 빌드된 사이트의 링크 등을 테스트합니다.
  5. 빌드 결과물(`_site` 폴더)을 GitHub Pages에 배포합니다.

## 8. 다음 단계 제안

블로그의 기본 설정은 대부분 완료되었습니다. 다음 단계로 아래 기능들을 추가하여 블로그를 더욱 풍성하게 만들 수 있습니다.

- **댓글 기능 활성화**: `_config.yml` 파일의 `comments` 섹션에 `giscus`나 `utterances` 같은 댓글 서비스를 연동하여 독자들과 소통할 수 있습니다.
- **방문자 분석 도구 연동**: `analytics` 섹션에 Google Analytics ID 등을 추가하여 블로그 방문자 통계를 확인할 수 있습니다.
- **검색 엔진 최적화(SEO)**: `webmaster_verifications`에 Google, Naver 등의 사이트 소유 확인 코드를 추가하여 검색 결과에 블로그가 더 잘 노출되도록 설정할 수 있습니다.
- **이미지 관리**: 포스트에 사용될 이미지는 `assets/img/` 폴더에 저장하고, 마크다운에서 `!이미지 설명`와 같이 상대 경로로 참조하는 방식을 권장합니다. 이렇게 하면 관리가 용이하고 페이지 로딩 속도도 개선됩니다.

---

## 9. 블로그 커스터마이징 할 일 목록 (To-Do List)

앞으로 블로그를 꾸미기 위한 작업 목록입니다. 완료된 항목은 `[x]`로 표시하여 진행 상황을 관리할 수 있습니다.

- [x] **`_config.yml` 상세 설정**
    - [x] 댓글 기능 활성화 (giscus 등)
    - [x] 웹 분석 도구 연동 (GoatCounter 등)
    - [x] 아바타(프로필 이미지) 변경

- [ ] **나만의 스타일(CSS) 적용**
    - [ ] `_sass/custom/custom.scss` 파일을 만들어 폰트, 색상 등 디자인 수정

- [x] **파비콘(Favicon) 변경**
    - [x] `assets/img/favicons/` 디렉토리의 아이콘들을 개인 로고로 교체

- [ ] **새로운 탭(페이지) 추가**
    - [ ] `_tabs` 디렉토리에 '포트폴리오'나 '프로젝트' 같은 새 페이지 추가