---
title: "Claude Code + Supabase MCPサーバー完全ガイド：初心者向けインストールから活用まで"
date: 2025-12-22T07:30:20+09:00
lastmod: 2025-12-22T07:45:22+09:00
draft: false
description: "Claude CodeとSupabaseをMCPサーバーとして接続し、自然言語でデータベースを管理する方法を初心者向けに解説。インストールから実践的な使い方、セキュリティ配慮まで段階的に説明します。"
tags: ["Claude Code", "Supabase", "MCP", "Model Context Protocol", "데이터베이스", "AI 개발도구", "자연어 쿼리", "개발 생산성"]
categories: ["DevOps"]
image: "https://urinfo24.com/cdn-cgi/image/width=1200,format=auto,quality=85/https://images.urinfo24.com/featured/claude-code-supabase-mcp-setup-featured.jpg"
lightgallery: true
---

<!--
Image Prompt: /Users/freein/Work/blog/images/image-prompt/claude-code-supabase-mcp-setup-prompt.txt
Featured Image: https://images.urinfo24.com/featured/claude-code-supabase-mcp-setup-featured.jpg
-->

Claude Codeを使っていると、外部データにアクセスしたいことがあります。
特にデータベース操作は、毎回ダッシュボードを開いてSQLを書く必要があり、面倒です。
こんなとき、MCPサーバーを使えば、Claude Codeで自然言語を使ってデータベースを扱えるようになります。

この記事では、Claude CodeとSupabaseをMCPサーバーとして接続する方法を、初心者向けに解説します。
インストールから実践的な使い方まで、順番に進めていきましょう。

## 1. MCPとは何か

### 1.1 MCPの概念

MCP（Model Context Protocol）は、AIモデルが外部のツールやデータと連携するための標準プロトコルです。
簡単に言うと、AIと外部システムを繋ぐ橋のような役割を果たします。

従来、AIが外部データにアクセスしたい場合、毎回カスタムAPIを作る必要がありました。
これでは開発コストが高く、メンテナンスも大変でした。
MCPは、この問題を解決するためにAnthropicが作った標準化されたアプローチです。

### 1.2 なぜ必要なのか

Claude Codeはコードを書くのは得意ですが、外部データにアクセスする手段がありませんでした。
データベース検索、ファイルシステムアクセス、API呼び出しなど、すべて手動で行う必要がありました。

MCPサーバーを使うことで、これらの作業を自然言語で行えるようになります。
例えば「usersテーブルから最近登録された10人のユーザーを見せて」と依頼すれば、ClaudeがSQLを自動で書いて実行してくれます。
これにより、開発の生産性が大幅に向上します。

## 2. Supabase MCPサーバーのインストールガイド

### 2.1 前提条件

まずは必要な環境を確認しましょう。

**必須要件**：
- Node.js（v16以上）
- Claude Codeがインストール済み
- Supabaseアカウント

Node.jsのバージョンを確認してみましょう。

```bash
node --version
```

v16以上であれば問題ありません。

### 2.2 Supabaseプロジェクトのセットアップ

Supabaseダッシュボード（https://supabase.com）にログインします。
新しいプロジェクトを作成するか、既存のプロジェクトを使用します。

プロジェクト設定で以下の情報を確認してください：
- Project URL（例：`https://xxxxx.supabase.co`）
- API Keys → `anon` public key

この情報は後ほどMCPサーバーの設定で使用します。

**重要**：`service_role`キーは全権限を持つため、慎重に扱ってください。
開発環境でのみ使用し、公開リポジトリにアップロードしないようにしましょう。

### 2.3 Supabase MCPサーバーURLの生成

SupabaseはオフィシャルMCPサーバーを提供しています。
ダッシュボードの'Connect' → 'MCP'タブで、カスタムMCP URLを生成できます。

URLの形式は以下の通りです：

```
https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=true
```

**クエリパラメータの説明**：
- `project_ref`：特定プロジェクトに制限（推奨）
- `read_only`：読み取り専用モードを有効化（推奨）

読み取り専用モードは、誤ってデータを変更することを防ぎます。
開発初期段階では、このオプションを有効にしておくと安全です。

### 2.4 Claude Codeの設定

次に、Claude CodeでMCPサーバーを設定します。

#### macOSでの設定

設定ファイルのパスは以下の通りです：

```
~/Library/Application Support/Claude/claude_desktop_config.json
```

ファイルが存在しない場合は作成します。

```bash
mkdir -p ~/Library/Application\ Support/Claude
touch ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

#### Windowsでの設定

Windowsでは以下のパスを使用します：

```
%APPDATA%\Claude\claude_desktop_config.json
```

エクスプローラーのアドレスバーに`%APPDATA%\Claude`と入力してください。

## 3. 接続確認

### 3.1 設定ファイルの記述

`claude_desktop_config.json`ファイルを開き、以下の内容を追加します。

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

**パラメータの説明**：
- `command`：`npx`を使用（npmパッケージの直接実行）
- `args`：MCPサーバーパッケージと認証情報

**またはホストMCPサーバーを使用**：

```json
{
  "mcpServers": {
    "supabase": {
      "url": "https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=true"
    }
  }
}
```

ホスティング方式の方がシンプルです。
OAuth 2.1認証を自動で処理してくれます。

### 3.2 接続テスト

Claude Codeを再起動します。
メニューのツールアイコンをクリックすると、接続されたMCPサーバーの一覧が表示されます。

「supabase」サーバーが表示されていれば成功です。

簡単なテストをしてみましょう。

```
Claudeに：「Supabaseのanon keyは何ですか？」
```

Claudeがプロジェクト情報を問い合わせて教えてくれます。
これが動作すれば、MCPサーバーが正しく接続されています。

## 4. 実践的な使用例

いよいよ実際にデータベース操作を行ってみましょう。

### 4.1 テーブルの検索

最も基本的な操作はテーブルの検索です。

```
Claudeに：「usersテーブルのデータを全て見せて」
```

ClaudeがSELECTクエリを自動で書いて実行してくれます。
結果は見やすい表形式で整理して表示されます。

**より具体的な依頼も可能です**：

```
「usersテーブルからGmailのメールアドレスを持つユーザーだけ見せて」
```

```
「最近7日間でサインアップしたユーザーの数を教えて」
```

自然言語で依頼すると、Claudeが適切なSQLを自動生成してくれます。

### 4.2 データの挿入

read_onlyモードを無効にすれば、データの挿入も可能です。

まず、設定ファイルで`read_only=false`に変更します。

```json
{
  "mcpServers": {
    "supabase": {
      "url": "https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=false"
    }
  }
}
```

Claude Codeを再起動後、このような依頼をしてみましょう。

```
「usersテーブルに新しいユーザーを追加して。
名前は'John'、メールは'john@example.com'にして」
```

ClaudeがINSERTクエリを生成し、実行確認を求めてきます。
ユーザーが承認すると、データが追加されます。

### 4.3 テーブル作成

新しいテーブルの作成も可能です。

```
「commentsテーブルを作成して。
カラムはid、user_id、content、created_atで」
```

ClaudeがCREATE TABLEクエリを生成します。
スキーマを確認して承認すれば、テーブルが作成されます。

### 4.4 複雑なクエリ

JOINや集計クエリも自然言語で依頼できます。

```
「各ユーザーが書いたコメントの数を表示して」
```

```
「今月登録したユーザーのうち、1回以上コメントを書いた人は何人？」
```

複雑なSQLもClaudeが自動で書いてくれます。
完璧なSQL知識がなくても、データベース操作が可能になります。

## 5. セキュリティと注意点

### 5.1 セキュリティ上の配慮

MCPサーバーを使用する際は、セキュリティを考慮する必要があります。

**本番データへの接続禁止**：
- 開発・テスト環境でのみMCPを使用
- 実際のサービスデータベースには絶対に接続しない
- AIが誤って重要なデータを削除する可能性があります

**読み取り専用モードの活用**：
- デフォルトはread_only=trueに設定
- 書き込み操作が必要なときだけ一時的に無効化
- 作業完了後は再度有効化

**プロジェクトスコープの制限**：
- project_refパラメータで特定プロジェクトのみアクセス許可
- 複数プロジェクトへのアクセス権限は与えない

**APIキーの管理**：
- 設定ファイルに直接APIキーを記載しない
- 環境変数で管理する方が安全
- 公開リポジトリには絶対にアップロードしない

### 5.2 効果的な使い方のコツ

**具体的な依頼をする**：
- 「データを見せて」❌
- 「usersテーブルから最近10人のユーザーのメールと登録日を表示して」✅

**段階的に進める**：
- 複雑な操作を一度に行わない
- まず検索で確認してから変更

**クエリの確認**：
- Claudeが生成したSQLを必ず確認
- 怪しい部分があれば修正を依頼

**ツールの指定**：
- 「Supabase MCPツールを使ってusersテーブルを検索して」
- このように指定することでトークンを節約できます

## 6. まとめ

Claude CodeとSupabase MCPサーバーの接続方法を学びました。

**重要なポイントの振り返り**：
- MCPはAIと外部システムを繋ぐ標準プロトコル
- SupabaseはオフィシャルなMCPサーバーを提供
- 設定ファイルにMCPサーバー情報を追加
- 自然言語でデータベース操作が可能
- セキュリティのため読み取り専用モードを使用

**今後の発展**：
- 他のMCPサーバー（GitHub、Notionなど）の追加を試す
- 複数MCPサーバーの組み合わせで複雑なワークフロー構築
- プロジェクトに適したカスタムMCPサーバーの開発

MCPサーバーをうまく活用すれば、Claude Codeの生産性が大幅に向上します。
データベース操作以外にも、様々な外部ツールとの連携が可能になります。
これにより、開発ワークフローがより便利になるでしょう。