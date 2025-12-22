---
title: "Claude Code + Supabase MCP 服务器完整指南：从安装到使用的初学者教程"
date: 2025-12-22T07:30:20+09:00
lastmod: 2025-12-22T07:45:22+09:00
draft: false
description: "从初学者角度学习如何将 Claude Code 与 Supabase 作为 MCP 服务器连接，使用自然语言管理数据库。从安装到实际使用和安全考量的逐步说明。"
tags: ["Claude Code", "Supabase", "MCP", "Model Context Protocol", "데이터베이스", "AI 개발도구", "자연어 쿼리", "개발 생산성"]
categories: ["DevOps"]
image: "https://urinfo24.com/cdn-cgi/image/width=1200,format=auto,quality=85/https://images.urinfo24.com/featured/claude-code-supabase-mcp-setup-featured.jpg"
lightgallery: true
---

<!--
Image Prompt: /Users/freein/Work/blog/images/image-prompt/claude-code-supabase-mcp-setup-prompt.txt
Featured Image: https://images.urinfo24.com/featured/claude-code-supabase-mcp-setup-featured.jpg
-->

在使用 Claude Code 时，有时会想要访问外部数据。
特别是数据库操作，每次都需要打开控制面板编写 SQL，这很麻烦。
在这种情况下，使用 MCP 服务器可以让你在 Claude Code 中使用自然语言处理数据库。

本文从初学者角度介绍如何将 Claude Code 与 Supabase 作为 MCP 服务器连接。
让我们从安装到实际使用逐步进行。

## 1. 什么是 MCP

### 1.1 MCP 的概念

MCP（Model Context Protocol）是 AI 模型与外部工具和数据交互的标准协议。
简单来说，可以把它想象成连接 AI 与外部系统的桥梁。

以前，如果 AI 想要访问外部数据，每次都必须创建自定义 API。
这导致开发成本高昂且维护困难。
MCP 是 Anthropic 为解决这些问题而创建的标准化方法。

### 1.2 为什么需要它

Claude Code 擅长编写代码，但没有访问外部数据的方法。
对于数据库查询、文件系统访问、API 调用等，你必须手动完成所有操作。

使用 MCP 服务器可以用自然语言执行这些任务。
例如，如果你请求"显示用户表中最近注册的 10 个用户"，Claude 会自动编写并执行 SQL。
这大大提高了开发生产力。

## 2. Supabase MCP 服务器安装指南

### 2.1 前置条件

首先，让我们检查所需的条件。

**必要条件**：
- Node.js（v16 或更高版本）
- 已安装 Claude Code
- Supabase 账户

让我们检查 Node.js 版本。

```bash
node --version
```

v16 或更高版本即可。

### 2.2 Supabase 项目设置

登录 Supabase 控制面板（https://supabase.com）。
创建新项目或使用现有项目。

在项目设置中检查以下信息：
- 项目 URL（例如：`https://xxxxx.supabase.co`）
- API Keys → `anon` 公钥

这些信息稍后将在 MCP 服务器配置中使用。

**重要**：`service_role` 密钥具有完整权限，请谨慎使用。
仅在开发环境中使用，切勿上传到公共仓库。

### 2.3 生成 Supabase MCP 服务器 URL

Supabase 提供官方 MCP 服务器。
你可以在控制面板的"Connect" → "MCP"选项卡中生成自定义 MCP URL。

URL 格式如下：

```
https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=true
```

**查询参数说明**：
- `project_ref`：限制为特定项目（推荐）
- `read_only`：启用只读模式（推荐）

只读模式可防止意外的数据修改。
在早期开发期间启用此选项是安全的。

### 2.4 Claude Code 配置

现在让我们在 Claude Code 中配置 MCP 服务器。

#### macOS 配置

配置文件路径如下：

```
~/Library/Application Support/Claude/claude_desktop_config.json
```

如果文件不存在，请创建它。

```bash
mkdir -p ~/Library/Application\ Support/Claude
touch ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

#### Windows 配置

在 Windows 上，使用以下路径：

```
%APPDATA%\Claude\claude_desktop_config.json
```

在资源管理器地址栏中输入 `%APPDATA%\Claude`。

## 3. 连接验证

### 3.1 编写配置文件

打开 `claude_desktop_config.json` 文件并添加以下内容。

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

**参数说明**：
- `command`：使用 `npx`（直接执行 npm 包）
- `args`：MCP 服务器包和认证信息

**或使用托管 MCP 服务器**：

```json
{
  "mcpServers": {
    "supabase": {
      "url": "https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=true"
    }
  }
}
```

托管方法更简单。
它自动处理 OAuth 2.1 认证。

### 3.2 连接测试

重启 Claude Code。
点击菜单中的工具图标查看已连接的 MCP 服务器列表。

如果看到"supabase"服务器，说明成功了。

让我们做一个简单测试。

```
对 Claude 说："Supabase anon key 是什么？"
```

Claude 查询项目信息并告诉你。
如果这样可以工作，MCP 服务器就正确连接了。

## 4. 实际使用示例

现在让我们实际执行数据库操作。

### 4.1 表查询

最基本的操作是表查询。

```
对 Claude 说："显示 users 表的所有数据"
```

Claude 自动编写并执行 SELECT 查询。
它将结果整理成格式良好的表格。

**也可以提出更具体的请求**：

```
"显示 users 表中只有 Gmail 邮箱的用户"
```

```
"告诉我最近 7 天有多少用户注册"
```

当你用自然语言请求时，Claude 会自动生成适当的 SQL。

### 4.2 数据插入

当禁用只读模式时，也可以插入数据。

首先，在配置文件中更改 `read_only=false`。

```json
{
  "mcpServers": {
    "supabase": {
      "url": "https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=false"
    }
  }
}
```

重启 Claude Code 后，像这样提出请求。

```
"向 users 表添加新用户。
名字应该是 'John'，邮箱应该是 'john@example.com'"
```

Claude 生成 INSERT 查询并请求执行。
当用户批准时，数据被添加。

### 4.3 表创建

你也可以创建新表。

```
"创建一个 comments 表。
列应该是 id、user_id、content、created_at"
```

Claude 生成 CREATE TABLE 查询。
在审查模式并批准后，表被创建。

### 4.4 复杂查询

JOIN 或聚合查询也可以用自然语言请求。

```
"显示每个用户写的评论数量"
```

```
"本月注册的用户中有多少人至少写了 1 条评论？"
```

Claude 也会自动编写复杂的 SQL。
这使得即使不完全了解 SQL 也能进行数据库操作。

## 5. 安全性和技巧

### 5.1 安全考量

使用 MCP 服务器时应考虑安全性。

**禁止生产数据连接**：
- 仅在开发/测试环境中使用 MCP
- 切勿连接到实际服务数据库
- AI 可能会意外删除重要数据

**使用只读模式**：
- 默认设置 read_only=true
- 只有在需要写操作时才临时禁用
- 完成工作后重新启用

**项目范围限制**：
- 仅使用 project_ref 参数限制对特定项目的访问
- 不要给多个项目访问权限

**API 密钥管理**：
- 不要将 API 密钥直接放在配置文件中
- 使用环境变量管理更安全
- 切勿上传到公共仓库

### 5.2 有效使用技巧

**提出具体请求**：
- "显示数据" ❌
- "显示 users 表中最近 10 个用户的邮箱和注册日期" ✅

**逐步进行**：
- 不要一次性进行复杂操作
- 先查询检查，然后修改

**审查查询**：
- 始终检查 Claude 生成的 SQL
- 如果有可疑部分，请求修改

**指定工具**：
- "使用 Supabase MCP 工具查询 users 表"
- 这样指定可以节省令牌

## 6. 总结

我们学习了如何将 Claude Code 与 Supabase MCP 服务器连接。

**关键内容总结**：
- MCP 是连接 AI 与外部系统的标准协议
- Supabase 提供官方 MCP 服务器
- 在配置文件中添加 MCP 服务器信息
- 可以使用自然语言执行数据库操作
- 为了安全使用只读模式

**下一步**：
- 尝试添加其他 MCP 服务器（GitHub、Notion 等）
- 通过组合多个 MCP 服务器创建复杂工作流
- 开发适合你项目的自定义 MCP 服务器

MCP 服务器的良好使用大大提高了 Claude Code 的生产力。
除了数据库操作外，你还可以与各种外部工具集成。
这使开发工作流变得更加便利。