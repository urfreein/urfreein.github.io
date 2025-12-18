---
title: Next.js 웹사이트를 Vercel로 배포하는 완벽 가이드
date: 2025-11-14T12:30:18+09:00
lastmod: 2025-11-14T12:30:18+09:00
draft: false
description: Next.js 기반 웹 애플리케이션을 Vercel을 통해 빠르고 효율적으로 배포하는 방법을 단계별로 알아봅니다.
tags: ["nextjs", "vercel", "deployment", "frontend", "devops", "cicd"]
categories: ["DevOps"]
image: "https://images.urinfo24.com/featured/nextjs-vercel-deployment-guide-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A modern, professional tech illustration for "Next.js 웹사이트를 Vercel로 배포하는 완벽 가이드".
- Style: Clean, professional, flat design with technical elements
- Subject: Visual representation of Next.js deployment to Vercel platform
- Elements: Next.js logo, Vercel logo, deployment pipeline, cloud infrastructure, CI/CD symbols, rocket launch icon
- Colors: Next.js black, Vercel black/white, blue for deployment flow, white background
- Mood: Professional, modern, efficient, streamlined
- Composition: Centered layout showing deployment flow from code to production

Technical keywords: nextjs,  "vercel,  "deployment,  "frontend,  "devops

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/nextjs-vercel-deployment-guide-featured.jpg

NOTE: Hugo will serve this from /images/nextjs-vercel-deployment-guide-featured.jpg
-->

Next.js로 개발한 웹 애플리케이션을 배포할 때, Vercel은 가장 강력하고 편리한 선택지입니다. Cloudflare Pages와 같은 정적 사이트 호스팅 플랫폼도 훌륭하지만, Next.js의 서버 사이드 렌더링(SSR)과 API 라우트 같은 동적 기능을 완벽하게 지원하려면 Vercel이 최적의 솔루션입니다.

이 글에서는 Next.js 프로젝트를 Vercel에 배포하는 전체 과정을 실전 예제와 함께 살펴보겠습니다.

## 1. Vercel이 Next.js 배포에 적합한 이유

Vercel은 Next.js를 개발한 회사가 만든 플랫폼으로, Next.js와의 통합이 매우 긴밀합니다.

**주요 장점**

서버리스 함수 지원: API 라우트와 서버 컴포넌트가 자동으로 서버리스 함수로 배포됩니다. 별도의 백엔드 서버 없이도 동적 기능을 구현할 수 있습니다.

자동 최적화: 이미지 최적화, 코드 스플리팅, 프리페칭이 기본으로 활성화됩니다. 개발자가 별도로 설정하지 않아도 최상의 성능을 제공합니다.

즉시 배포: Git push만으로 자동 빌드 및 배포가 진행됩니다. CI/CD 파이프라인을 별도로 구축할 필요가 없습니다.

프리뷰 배포: 각 Pull Request마다 독립적인 프리뷰 환경이 생성됩니다. 팀원들과 변경사항을 미리 확인하고 피드백을 주고받을 수 있습니다.

글로벌 CDN: Edge Network를 통해 전 세계 어디서나 빠른 응답 속도를 제공합니다. 사용자의 위치와 가장 가까운 서버에서 콘텐츠가 제공됩니다.

## 2. Vercel vs Cloudflare Pages 비교

두 플랫폼 모두 훌륭한 서비스이지만, 사용 목적에 따라 적합한 선택이 다릅니다.

**Vercel이 유리한 경우**

Next.js 프로젝트: SSR, ISR(Incremental Static Regeneration), API Routes 등 Next.js의 모든 기능을 완벽하게 지원합니다. 서버 컴포넌트와 미들웨어도 문제없이 작동합니다.

서버리스 함수: API 엔드포인트를 쉽게 구축할 수 있습니다. Node.js 런타임을 사용하여 복잡한 백엔드 로직도 구현 가능합니다.

개발 경험: Vercel CLI와 대시보드가 매우 직관적이며, Next.js 개발자라면 학습 곡선이 거의 없습니다.

**Cloudflare Pages가 유리한 경우**

정적 사이트: Jekyll, Hugo, Gatsby 등 정적 사이트 생성기로 만든 사이트는 Cloudflare Pages가 탁월합니다. 무료 플랜에서도 무제한 대역폭을 제공합니다.

Workers 통합: Cloudflare Workers와의 긴밀한 통합이 필요한 경우 유리합니다. Edge Computing 기능을 최대한 활용할 수 있습니다.

비용: 트래픽이 매우 많은 경우 Cloudflare의 무료 대역폭이 비용 절감에 도움이 됩니다.

## 3. Next.js 프로젝트 준비하기

Vercel 배포를 위한 Next.js 프로젝트를 생성해보겠습니다.

### 3.1 새 프로젝트 생성

터미널에서 다음 명령어로 Next.js 프로젝트를 생성합니다.

```bash
npx create-next-app@latest my-vercel-app
```

설치 중 나타나는 옵션들을 선택합니다.

```
✔ Would you like to use TypeScript? … Yes
✔ Would you like to use ESLint? … Yes
✔ Would you like to use Tailwind CSS? … Yes
✔ Would you like to use `src/` directory? … Yes
✔ Would you like to use App Router? … Yes
✔ Would you like to customize the default import alias? … No
```

프로젝트 폴더로 이동합니다.

```bash
cd my-vercel-app
```

### 3.2 로컬 개발 서버 실행

다음 명령어로 개발 서버를 시작합니다.

```bash
npm run dev
```

브라우저에서 `http://localhost:3000`에 접속하면 Next.js 시작 페이지를 확인할 수 있습니다.

### 3.3 간단한 페이지 추가

`src/app/about/page.tsx` 파일을 생성합니다.

```typescript
export default function About() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <h1 className="text-4xl font-bold mb-4">About Page</h1>
      <p className="text-lg">
        This is a Next.js app deployed on Vercel
      </p>
    </main>
  );
}
```

### 3.4 API 라우트 추가

`src/app/api/hello/route.ts` 파일을 생성합니다.

```typescript
import { NextResponse } from 'next/server';

export async function GET() {
  return NextResponse.json({
    message: 'Hello from Vercel!',
    timestamp: new Date().toISOString(),
  });
}
```

`http://localhost:3000/api/hello`에 접속하면 JSON 응답을 확인할 수 있습니다.

## 4. Git 저장소 설정

Vercel은 Git 기반 배포를 지원합니다. GitHub, GitLab, Bitbucket 중 하나와 연동할 수 있습니다. 저는 Github을 주로 쓰기 때문에 Github과 연결했기 때문에, 주로 Github과 연결을 설명하겠습니다.

### 4.1 Git 초기화 및 커밋

프로젝트가 이미 Git 저장소로 초기화되어 있지만, 변경사항을 커밋합니다.

```bash
git add .
git commit -m "Initial Next.js project for Vercel deployment"
```

### 4.2 GitHub 저장소 생성 및 푸시

GitHub에서 새 저장소를 생성한 후, 로컬 프로젝트와 연결합니다.

```bash
git remote add origin https://github.com/your-username/my-vercel-app.git
git branch -M main
git push -u origin main
```

GitLab이나 Bitbucket을 사용하는 경우에도 동일한 방식으로 진행합니다.

## 5. Vercel 계정 설정 및 프로젝트 배포

### 5.1 Vercel 계정 생성

vercel.com에 접속하여 GitHub 계정으로 로그인합니다. 별도의 회원가입 없이 GitHub OAuth를 통해 바로 시작할 수 있습니다.
저는 Google계정으로 로그인해서, Github 저장소 연결할 때, 한번 더 OAuth인증 절차를 거쳤습니다. 혹시 이 글을 먼저 보시는 분들은 편리한 연동을 위해 Github 계정으로 Vercel에 가입하면 좋습니다.

### 5.2 새 프로젝트 임포트

Vercel 대시보드에서 다음 단계를 진행합니다.

1단계: "Add New..." 버튼을 클릭하고 "Project"를 선택합니다.

2단계: GitHub 저장소 목록에서 방금 생성한 `my-vercel-app` 저장소를 찾습니다. 저장소가 보이지 않는다면 "Adjust GitHub App Permissions"를 클릭하여 Vercel이 접근할 수 있도록 권한을 부여합니다.

3단계: "Import" 버튼을 클릭합니다.

### 5.3 프로젝트 설정

Vercel이 Next.js 프로젝트를 자동으로 감지하고 최적의 설정을 제안합니다.

**기본 설정 확인**

Framework Preset: Next.js가 자동으로 선택됩니다.

Build Command: `next build`가 기본값입니다. 대부분의 경우 변경할 필요가 없습니다.

Output Directory: `.next`가 자동으로 설정됩니다.

Install Command: `npm install` 또는 `yarn install`이 자동으로 감지됩니다.

**환경 변수 설정 (선택사항)**

API 키나 데이터베이스 연결 정보가 필요한 경우, "Environment Variables" 섹션에서 추가할 수 있습니다.

```
DATABASE_URL=postgresql://user:password@host:port/dbname
API_KEY=your_api_key_here
NEXT_PUBLIC_SITE_URL=https://your-domain.com
```

환경 변수 이름이 `NEXT_PUBLIC_`로 시작하면 클라이언트 사이드에서도 접근할 수 있습니다.
환경 변수는 Vercel 내부에 암호화되어 저장됩니다. 따라서, 외부로 노출이 안되야 하는 것들을 안전하게 환경변수로 지정하여 프로그램이 이용할 수 있도록 합니다.
코드안에 하드코딩하여 API Key같은 것을 쓰는 경우가 있는데, 그러지 마세요.

### 5.4 배포 시작

"Deploy" 버튼을 클릭하면 배포가 시작됩니다. 빌드 로그를 실시간으로 확인할 수 있습니다.

**배포 프로세스**

1단계: 코드 체크아웃 - GitHub에서 최신 코드를 가져옵니다.

2단계: 의존성 설치 - package.json에 명시된 패키지들을 설치합니다.

3단계: 빌드 실행 - Next.js 프로젝트를 프로덕션용으로 빌드합니다.

4단계: 배포 - 빌드된 파일들을 Vercel의 Edge Network에 배포합니다.

보통 2-3분 정도면 배포가 완료됩니다. 완료되면 프로젝트 URL이 생성됩니다.
프로젝트 URL은 보통 projectname.vercel.app 형태입니다. 그닥 멋지지 않으므로, 여유가 있다면 custom domain을 이용하면 좋습니다.
저는 CloudFlare에서 관리하는 domain이 있어서 그걸 이용했는데, Vercel의 Project Settings에서 설정할 수 있는데요. Vercel에서 직접 구매한 domain을 써도 되고, 저처럼 다른 사이트에서 구매한 경우에는 해당 Domain관리 사이트에서 DNS에 등록할 CNAME을 친절하게 알려줍니다.
저는 CloudFlare에서 관리하는데, Vercel에서 CloudFlare는 자동등록 해줍니다. 자동 등록 버튼을 누르면, Vercel이 자동으로 Cloudflare에 접속하여 DNS를 올바르게 변경해 줍니다.

## 6. 배포 확인 및 테스트

### 6.1 프로덕션 URL 확인

배포가 완료되면 `https://your-project-name.vercel.app` 형태의 URL이 생성됩니다. 대시보드에서 "Visit" 버튼을 클릭하여 사이트를 확인할 수 있습니다.

### 6.2 기능 테스트

다음 항목들을 확인합니다.

메인 페이지: `https://your-project-name.vercel.app`에 접속하여 홈페이지가 정상적으로 로드되는지 확인합니다.

About 페이지: `/about` 경로로 이동하여 추가한 페이지가 작동하는지 확인합니다.

API 엔드포인트: `/api/hello`에 접속하여 서버리스 함수가 정상적으로 응답하는지 확인합니다.

### 6.3 성능 확인

Vercel은 자동으로 성능 메트릭을 수집합니다. 대시보드의 "Analytics" 탭에서 다음 정보를 확인할 수 있습니다.

페이지 로딩 속도: Core Web Vitals 지표를 통해 사용자 경험을 측정합니다.

트래픽 분석: 방문자 수, 페이지뷰, 지역별 분포를 확인할 수 있습니다.

함수 실행 시간: API 라우트의 응답 시간과 성능을 모니터링합니다.

## 7. 자동 배포 설정

Vercel의 가장 큰 장점 중 하나는 Git 기반 자동 배포입니다.

### 7.1 프로덕션 배포

`main` 브랜치에 푸시하면 자동으로 프로덕션 환경에 배포됩니다.

```bash
git add .
git commit -m "Update homepage content"
git push origin main
```

몇 분 후 변경사항이 자동으로 프로덕션 사이트에 반영됩니다. 브랜치는 Vercel의 project 설정에서 변경할 수 있습니다.

### 7.2 프리뷰 배포

새로운 브랜치를 생성하고 Pull Request를 만들면 독립적인 프리뷰 환경이 자동으로 생성됩니다.

```bash
git checkout -b feature/new-landing-page
# 파일 수정 후
git add .
git commit -m "Add new landing page design"
git push origin feature/new-landing-page
```

GitHub에서 Pull Request를 생성하면, Vercel 봇이 자동으로 프리뷰 URL을 댓글로 추가합니다. 팀원들은 이 URL을 통해 변경사항을 미리 확인할 수 있습니다.

## 8. 커스텀 도메인 설정

### 8.1 도메인 추가

Vercel 대시보드의 프로젝트 설정에서 "Domains" 탭으로 이동합니다.

"Add" 버튼을 클릭하고 소유한 도메인을 입력합니다. 예: `example.com` 또는 `www.example.com`

### 8.2 DNS 설정

도메인 등록 업체의 DNS 관리 페이지에서 다음 레코드를 추가합니다.

**A 레코드 방식**

```
Type: A
Name: @
Value: 76.76.21.21
```

**CNAME 레코드 방식**

```
Type: CNAME
Name: www
Value: cname.vercel-dns.com
```

DNS 전파에는 보통 몇 분에서 최대 48시간이 걸릴 수 있습니다.
> CloudFlare를 이용한다면, 자동등록 버튼을 누르면 Vercel이 등록해줍니다.
{: .prompt-tip }

### 8.3 SSL 인증서

Vercel은 Let's Encrypt를 통해 무료 SSL 인증서를 자동으로 발급하고 갱신합니다. DNS 설정이 완료되면 자동으로 HTTPS가 활성화됩니다.

## 9. 고급 설정 및 최적화

### 9.1 빌드 설정 커스터마이징

프로젝트 루트에 `vercel.json` 파일을 생성하여 빌드 설정을 커스터마이즈할 수 있습니다.

```json
{
  "buildCommand": "npm run build",
  "devCommand": "npm run dev",
  "installCommand": "npm install",
  "framework": "nextjs",
  "outputDirectory": ".next"
}
```

### 9.2 헤더 및 리다이렉트 설정

`next.config.js`에서 커스텀 헤더와 리다이렉트를 설정할 수 있습니다.

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
        ],
      },
    ];
  },
  async redirects() {
    return [
      {
        source: '/old-page',
        destination: '/new-page',
        permanent: true,
      },
    ];
  },
};

module.exports = nextConfig;
```

### 9.3 이미지 최적화

Next.js의 Image 컴포넌트를 사용하면 Vercel이 자동으로 이미지를 최적화합니다.

```typescript
import Image from 'next/image';

export default function MyComponent() {
  return (
    <Image
      src="/hero.jpg"
      alt="Hero image"
      width={1200}
      height={600}
      priority
    />
  );
}
```

Vercel은 다양한 포맷(WebP, AVIF)과 디바이스별 최적화된 이미지를 자동으로 제공합니다.

### 9.4 캐싱 전략

Next.js의 데이터 페칭 방식에 따라 캐싱이 자동으로 처리됩니다.

**정적 생성 (SSG)**

```typescript
export default async function Page() {
  const data = await fetch('https://api.example.com/data', {
    cache: 'force-cache', // 빌드 시점에 캐시
  });
  
  return <div>{/* 렌더링 */}</div>;
}
```

**증분 정적 재생성 (ISR)**

```typescript
export default async function Page() {
  const data = await fetch('https://api.example.com/data', {
    next: { revalidate: 3600 }, // 1시간마다 재생성
  });
  
  return <div>{/* 렌더링 */}</div>;
}
```

**서버 사이드 렌더링 (SSR)**

```typescript
export default async function Page() {
  const data = await fetch('https://api.example.com/data', {
    cache: 'no-store', // 매 요청마다 새로 가져옴
  });
  
  return <div>{/* 렌더링 */}</div>;
}
```

## 10. 문제 해결 및 디버깅

### 10.1 빌드 실패 해결

**의존성 문제**

로컬에서는 작동하지만 Vercel에서 빌드 실패하는 경우, package-lock.json을 삭제하고 다시 생성합니다.

```bash
rm package-lock.json
npm install
git add package-lock.json
git commit -m "Update package-lock.json"
git push
```

**타입스크립트 오류**

타입 에러로 빌드가 실패하는 경우, next.config.js에서 일시적으로 타입 체크를 비활성화할 수 있습니다.

```javascript
const nextConfig = {
  typescript: {
    ignoreBuildErrors: true, // 권장하지 않음, 임시 방편
  },
};
```

하지만 이는 임시 방편이며, 근본적인 타입 오류를 해결하는 것이 좋습니다.

### 10.2 로그 확인

Vercel 대시보드의 "Deployments" 탭에서 각 배포의 상세 로그를 확인할 수 있습니다. 빌드 로그, 함수 로그, 에러 추적 정보가 모두 제공됩니다.

### 10.3 로컬 환경에서 프로덕션 빌드 테스트

배포 전에 로컬에서 프로덕션 빌드를 테스트할 수 있습니다.

```bash
npm run build
npm start
```

이렇게 하면 프로덕션 환경과 동일한 조건에서 애플리케이션을 실행할 수 있습니다.

## 11. 실전 예제: 블로그 플랫폼 배포

간단한 블로그 플랫폼을 만들어 Vercel에 배포하는 전체 과정을 살펴보겠습니다.

### 11.1 프로젝트 구조

```
my-blog/
├── src/
│   ├── app/
│   │   ├── page.tsx          # 홈페이지
│   │   ├── blog/
│   │   │   ├── page.tsx      # 블로그 목록
│   │   │   └── [slug]/
│   │   │       └── page.tsx  # 개별 포스트
│   │   └── api/
│   │       └── posts/
│   │           └── route.ts  # API 엔드포인트
│   ├── lib/
│   │   └── posts.ts          # 포스트 데이터 관리
│   └── types/
│       └── post.ts           # 타입 정의
└── posts/
    ├── first-post.md
    └── second-post.md
```

### 11.2 포스트 데이터 관리

`src/lib/posts.ts` 파일을 생성합니다.

```typescript
import fs from 'fs';
import path from 'path';
import matter from 'gray-matter';

const postsDirectory = path.join(process.cwd(), 'posts');

export interface Post {
  slug: string;
  title: string;
  date: string;
  content: string;
}

export function getAllPosts(): Post[] {
  const fileNames = fs.readdirSync(postsDirectory);
  const allPosts = fileNames.map((fileName) => {
    const slug = fileName.replace(/\.md$/, '');
    const fullPath = path.join(postsDirectory, fileName);
    const fileContents = fs.readFileSync(fullPath, 'utf8');
    const { data, content } = matter(fileContents);

    return {
      slug,
      title: data.title,
      date: data.date,
      content,
    };
  });

  return allPosts.sort((a, b) => (a.date < b.date ? 1 : -1));
}
```

필요한 패키지를 설치합니다.

```bash
npm install gray-matter
```

### 11.3 블로그 목록 페이지

`src/app/blog/page.tsx` 파일을 생성합니다.

```typescript
import Link from 'next/link';
import { getAllPosts } from '@/lib/posts';

export default function BlogPage() {
  const posts = getAllPosts();

  return (
    <main className="max-w-4xl mx-auto p-8">
      <h1 className="text-4xl font-bold mb-8">Blog Posts</h1>
      <div className="space-y-6">
        {posts.map((post) => (
          <article key={post.slug} className="border-b pb-6">
            <Link href={`/blog/${post.slug}`}>
              <h2 className="text-2xl font-semibold hover:text-blue-600">
                {post.title}
              </h2>
            </Link>
            <time className="text-gray-600">{post.date}</time>
          </article>
        ))}
      </div>
    </main>
  );
}
```

### 11.4 개별 포스트 페이지

`src/app/blog/[slug]/page.tsx` 파일을 생성합니다.

```typescript
import { getAllPosts } from '@/lib/posts';
import { notFound } from 'next/navigation';

export async function generateStaticParams() {
  const posts = getAllPosts();
  return posts.map((post) => ({
    slug: post.slug,
  }));
}

export default function PostPage({ params }: { params: { slug: string } }) {
  const posts = getAllPosts();
  const post = posts.find((p) => p.slug === params.slug);

  if (!post) {
    notFound();
  }

  return (
    <main className="max-w-4xl mx-auto p-8">
      <article>
        <h1 className="text-4xl font-bold mb-4">{post.title}</h1>
        <time className="text-gray-600 mb-8 block">{post.date}</time>
        <div className="prose lg:prose-xl">{post.content}</div>
      </article>
    </main>
  );
}
```

### 11.5 샘플 포스트 작성

`posts/first-post.md` 파일을 생성합니다.

```markdown
---
title: "Next.js와 Vercel로 블로그 만들기"
date: "2025-11-14"
---

Next.js와 Vercel을 활용하면 빠르고 효율적인 블로그 플랫폼을 구축할 수 있습니다.

이 포스트에서는 기본적인 설정 방법과 배포 과정을 다룹니다.
```

### 11.6 배포

모든 파일을 커밋하고 푸시합니다.

```bash
git add .
git commit -m "Add blog functionality"
git push origin main
```

Vercel이 자동으로 빌드하고 배포합니다. 잠시후 블로그가 온라인 상태가 됩니다. 저의 빌드에 대략 1분 내외 걸렸습니다.

## 12. 마치며

Next.js와 Vercel의 조합은 웹 애플리케이션 개발과 배포에 있어 좋은 선택입니다. 특히 다음과 같은 프로젝트에 적합합니다.

- 서버 사이드 렌더링이 필요한 동적 웹사이트

- API 엔드포인트가 포함된 풀스택 애플리케이션

- 빠른 프로토타입과 MVP 개발

- 팀 협업이 필요한 프로젝트

Vercel의 자동 배포, 프리뷰 환경, 그리고 글로벌 CDN은 개발 생산성을 크게 올려줍니다.
다음엔 Supabase같은 Backend에 대해서도 알아보고, next.js같은 Frontend와 함께 테스트 해보도록 하겠습니다.
