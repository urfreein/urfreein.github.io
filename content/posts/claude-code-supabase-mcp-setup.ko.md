---
title: "Claude Code + Supabase MCP 서버 완벽 가이드: 초보자를 위한 설치부터 활용까지"
date: 2025-12-22T07:30:20+09:00
lastmod: 2025-12-22T07:45:22+09:00
draft: false
description: "Claude Code와 Supabase를 MCP 서버로 연결하여 자연어로 데이터베이스를 관리하는 방법을 초보자 관점에서 상세히 알아봅니다. 설치부터 실전 활용, 보안 고려사항까지 단계별로 설명합니다."
tags: ["Claude Code", "Supabase", "MCP", "Model Context Protocol", "데이터베이스", "AI 개발도구", "자연어 쿼리", "개발 생산성"]
categories: ["DevOps"]
image: "https://urinfo24.com/cdn-cgi/image/width=1200,format=auto,quality=85/https://images.urinfo24.com/featured/claude-code-supabase-mcp-setup-featured.jpg"
lightgallery: true
---

<!--
Image Prompt: /Users/freein/Work/blog/images/image-prompt/claude-code-supabase-mcp-setup-prompt.txt
Featured Image: https://images.urinfo24.com/featured/claude-code-supabase-mcp-setup-featured.jpg
-->

Claude Code를 사용하다보면 외부 데이터에 접근하고 싶을 때가 있다.
특히 데이터베이스 작업은 매번 대시보드를 열어 SQL을 작성하기 번거롭다.
이럴 때 MCP 서버를 활용하면 Claude Code에서 자연어로 데이터베이스를 다룰 수 있다.

이 글에서는 Claude Code와 Supabase를 MCP 서버로 연결하는 방법을 초보자 관점에서 상세히 다룬다.
설치부터 실제 활용까지 단계별로 진행해보자.

## 1. MCP란 무엇인가

### 1.1 MCP의 개념

MCP(Model Context Protocol)는 AI 모델이 외부 도구나 데이터와 상호작용하기 위한 표준 프로토콜이다.
쉽게 말해 AI와 외부 시스템을 연결하는 다리라고 생각하면 된다.

기존에는 AI가 외부 데이터에 접근하려면 매번 커스텀 API를 만들어야 했다.
따라서 개발 비용이 많이 들고, 유지보수도 어려웠다.
MCP는 이런 문제를 해결하기 위해 Anthropic이 만든 표준 방식이다.

### 1.2 왜 필요한가

Claude Code는 코드 작성에는 뛰어나지만, 외부 데이터에 접근할 방법이 없었다.
데이터베이스 조회, 파일 시스템 접근, API 호출 등을 하려면 매번 수동으로 해야 했다.

MCP 서버를 사용하면 이런 작업을 자연어로 할 수 있다.
예를 들어 "users 테이블에서 최근 가입한 사용자 10명을 보여줘"라고 요청하면 Claude가 알아서 SQL을 작성하고 실행한다.
따라서 개발 생산성이 크게 향상된다.

## 2. Supabase MCP 서버 설치 가이드

### 2.1 사전 준비

먼저 필요한 것들을 확인하자.

**필수 요구사항**:
- Node.js (v16 이상)
- Claude Code 설치
- Supabase 계정

Node.js 버전을 확인해보자.

```bash
node --version
```

v16 이상이면 문제없다.

### 2.2 Supabase 프로젝트 설정

Supabase 대시보드(https://supabase.com)에 로그인하자.
새 프로젝트를 만들거나 기존 프로젝트를 사용하면 된다.

프로젝트 설정에서 다음 정보를 확인하자:
- Project URL (예: `https://xxxxx.supabase.co`)
- API Keys → `anon` public key

이 정보는 나중에 MCP 서버 설정에서 사용한다.

**중요**: `service_role` 키는 모든 권한을 가지므로 주의해서 사용해야 한다.
개발 환경에서만 사용하고, 절대 공개 저장소에 올리면 안 된다.

### 2.3 Supabase MCP 서버 URL 생성

Supabase는 공식 MCP 서버를 제공한다.
대시보드의 'Connect' → 'MCP' 탭에서 커스텀 MCP URL을 생성할 수 있다.

URL 형식은 다음과 같다:

```
https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=true
```

**쿼리 파라미터 설명**:
- `project_ref`: 특정 프로젝트로 제한 (권장)
- `read_only`: 읽기 전용 모드 활성화 (권장)

read_only 모드는 실수로 데이터를 변경하는 것을 방지한다.
개발 초기에는 이 옵션을 켜두는 게 안전하다.

### 2.4 Claude Code 설정

이제 Claude Code에서 MCP 서버를 설정하자.

#### macOS 설정

설정 파일 경로는 다음과 같다:

```
~/Library/Application Support/Claude/claude_desktop_config.json
```

파일이 없으면 새로 만들자.

```bash
mkdir -p ~/Library/Application\ Support/Claude
touch ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

#### Windows 설정

Windows에서는 다음 경로를 사용한다:

```
%APPDATA%\Claude\claude_desktop_config.json
```

탐색기 주소창에 `%APPDATA%\Claude`를 입력하면 된다.

## 3. 연결 확인

### 3.1 설정 파일 작성

`claude_desktop_config.json` 파일을 열어 다음 내용을 추가하자.

```json
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-supabase",
        "https://xxxxx.supabase.co",
        "your-anon-key-here"
      ]
    }
  }
}
```

**파라미터 설명**:
- `command`: `npx` 사용 (npm 패키지 직접 실행)
- `args`: MCP 서버 패키지와 인증 정보

**또는 호스팅된 MCP 서버 사용**:

```json
{
  "mcpServers": {
    "supabase": {
      "url": "https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=true"
    }
  }
}
```

호스팅 방식이 더 간단하다.
OAuth 2.1 인증을 자동으로 처리해주기 때문이다.

### 3.2 연결 테스트

Claude Code를 재시작하자.
메뉴에서 Tools 아이콘을 클릭하면 연결된 MCP 서버 목록이 보인다.

"supabase" 서버가 보이면 성공이다.

간단한 테스트를 해보자.

```
Claude에게: "Supabase의 anon key가 뭐야?"
```

Claude가 프로젝트 정보를 조회해서 알려준다.
이게 작동하면 MCP 서버가 제대로 연결된 것이다.

## 4. 실전 활용 예시

이제 실제로 데이터베이스 작업을 해보자.

### 4.1 테이블 조회

가장 기본적인 작업은 테이블 조회다.

```
Claude에게: "users 테이블의 모든 데이터를 보여줘"
```

Claude가 자동으로 SELECT 쿼리를 작성하고 실행한다.
결과를 표 형식으로 보기 좋게 정리해준다.

**더 구체적인 요청도 가능하다**:

```
"users 테이블에서 이메일이 gmail인 사용자만 보여줘"
```

```
"최근 7일간 가입한 사용자 수를 알려줘"
```

자연어로 요청하면 Claude가 알아서 적절한 SQL을 생성한다.

### 4.2 데이터 삽입

read_only 모드를 끄면 데이터 삽입도 가능하다.

먼저 설정 파일에서 `read_only=false`로 변경하자.

```json
{
  "mcpServers": {
    "supabase": {
      "url": "https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=false"
    }
  }
}
```

Claude Code를 재시작한 후 다음과 같이 요청하자.

```
"users 테이블에 새로운 사용자를 추가해줘. 
이름은 'John', 이메일은 'john@example.com'으로"
```

Claude가 INSERT 쿼리를 생성하고 실행을 요청한다.
사용자가 승인하면 데이터가 추가된다.

### 4.3 테이블 생성

새 테이블도 만들 수 있다.

```
"comments 테이블을 만들어줘. 
컬럼은 id, user_id, content, created_at으로"
```

Claude가 CREATE TABLE 쿼리를 생성한다.
스키마를 검토한 후 승인하면 테이블이 생성된다.

### 4.4 복잡한 쿼리

JOIN이나 집계 쿼리도 자연어로 요청할 수 있다.

```
"각 사용자별로 작성한 댓글 수를 보여줘"
```

```
"이번 달 가입한 사용자 중 댓글을 1개 이상 작성한 사람은 몇 명이야?"
```

Claude가 복잡한 SQL도 알아서 작성한다.
따라서 SQL을 완벽하게 몰라도 데이터베이스 작업이 가능하다.

## 5. 보안 및 팁

### 5.1 보안 고려사항

MCP 서버를 사용할 때는 보안에 주의해야 한다.

**프로덕션 데이터 연결 금지**:
- MCP는 개발/테스트 환경에서만 사용하자
- 실제 서비스 데이터베이스에는 절대 연결하지 말자
- AI가 실수로 중요한 데이터를 삭제할 수 있다

**read-only 모드 활용**:
- 기본적으로 read_only=true로 설정하자
- 쓰기 작업이 필요할 때만 일시적으로 끄자
- 작업 완료 후 다시 켜자

**프로젝트 스코핑**:
- project_ref 파라미터로 특정 프로젝트만 접근하도록 제한하자
- 여러 프로젝트에 접근 권한을 주지 말자

**API 키 관리**:
- 설정 파일에 API 키를 직접 넣지 말자
- 환경변수로 관리하는 게 안전하다
- 공개 저장소에 절대 올리지 말자

### 5.2 효과적인 사용 팁

**구체적으로 요청하기**:
- "데이터 보여줘" ❌
- "users 테이블에서 최근 10명의 이메일과 가입일을 보여줘" ✅

**단계별로 진행하기**:
- 복잡한 작업은 한 번에 하지 말자
- 먼저 조회해서 확인하고, 그 다음 수정하자

**쿼리 검토하기**:
- Claude가 생성한 SQL을 항상 확인하자
- 이상한 부분이 있으면 수정을 요청하자

**도구 명시하기**:
- "Supabase MCP 도구를 사용해서 users 테이블 조회해줘"
- 이렇게 명시하면 토큰을 절약할 수 있다

## 6. 정리

Claude Code와 Supabase MCP 서버를 연결하는 방법을 알아봤다.

**핵심 내용 정리**:
- MCP는 AI와 외부 시스템을 연결하는 표준 프로토콜이다
- Supabase는 공식 MCP 서버를 제공한다
- 설정 파일에 MCP 서버 정보를 추가하면 된다
- 자연어로 데이터베이스 작업을 할 수 있다
- read_only 모드로 안전하게 사용하자

**다음 단계**:
- 다른 MCP 서버도 추가해보자 (GitHub, Notion 등)
- 여러 MCP 서버를 조합해서 복잡한 워크플로우를 만들어보자
- 프로젝트에 맞는 커스텀 MCP 서버를 개발해보자

MCP 서버를 잘 활용하면 Claude Code의 생산성이 크게 향상된다.
데이터베이스 작업뿐만 아니라 다양한 외부 도구와 연동할 수 있다.
따라서 개발 워크플로우가 훨씬 편리해진다.