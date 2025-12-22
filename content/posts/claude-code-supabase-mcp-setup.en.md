---
title: "Claude Code + Supabase MCP Server Complete Guide: From Installation to Utilization for Beginners"
date: 2025-12-22T07:30:20+09:00
lastmod: 2025-12-22T07:45:22+09:00
draft: false
description: "Learn how to connect Claude Code with Supabase as an MCP server to manage databases using natural language from a beginner's perspective. Step-by-step explanation from installation to practical use and security considerations."
tags: ["Claude Code", "Supabase", "MCP", "Model Context Protocol", "데이터베이스", "AI 개발도구", "자연어 쿼리", "개발 생산성"]
categories: ["DevOps"]
image: "https://urinfo24.com/cdn-cgi/image/width=1200,format=auto,quality=85/https://images.urinfo24.com/featured/claude-code-supabase-mcp-setup-featured.jpg"
lightgallery: true
---

<!--
Image Prompt: /Users/freein/Work/blog/images/image-prompt/claude-code-supabase-mcp-setup-prompt.txt
Featured Image: https://images.urinfo24.com/featured/claude-code-supabase-mcp-setup-featured.jpg
-->

When using Claude Code, there are times when you want to access external data.
Database operations, in particular, can be cumbersome as you need to open the dashboard and write SQL every time.
In such cases, using MCP servers allows you to handle databases using natural language in Claude Code.

This article covers how to connect Claude Code with Supabase as an MCP server from a beginner's perspective.
Let's proceed step by step from installation to practical use.

## 1. What is MCP

### 1.1 The Concept of MCP

MCP (Model Context Protocol) is a standard protocol for AI models to interact with external tools and data.
Simply put, think of it as a bridge connecting AI with external systems.

Previously, if AI wanted to access external data, you had to create custom APIs every time.
This resulted in high development costs and difficult maintenance.
MCP is a standardized approach created by Anthropic to solve these problems.

### 1.2 Why is it Needed

Claude Code excels at writing code but had no way to access external data.
For database queries, file system access, API calls, etc., you had to do everything manually.

Using MCP servers allows you to perform these tasks with natural language.
For example, if you request "Show me the 10 most recently registered users from the users table," Claude automatically writes and executes the SQL.
This significantly improves development productivity.

## 2. Supabase MCP Server Installation Guide

### 2.1 Prerequisites

First, let's check what's needed.

**Essential requirements**:
- Node.js (v16 or higher)
- Claude Code installed
- Supabase account

Let's check the Node.js version.

```bash
node --version
```

v16 or higher is fine.

### 2.2 Supabase Project Setup

Log in to the Supabase dashboard (https://supabase.com).
Create a new project or use an existing one.

Check the following information in project settings:
- Project URL (e.g., `https://xxxxx.supabase.co`)
- API Keys → `anon` public key

This information will be used later in MCP server configuration.

**Important**: The `service_role` key has full permissions, so use it carefully.
Use it only in development environments and never upload it to public repositories.

### 2.3 Generating Supabase MCP Server URL

Supabase provides an official MCP server.
You can generate a custom MCP URL in the dashboard's 'Connect' → 'MCP' tab.

The URL format is as follows:

```
https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=true
```

**Query parameter explanation**:
- `project_ref`: Restrict to specific project (recommended)
- `read_only`: Enable read-only mode (recommended)

Read-only mode prevents accidental data modification.
It's safe to enable this option during early development.

### 2.4 Claude Code Configuration

Now let's configure the MCP server in Claude Code.

#### macOS Configuration

The configuration file path is as follows:

```
~/Library/Application Support/Claude/claude_desktop_config.json
```

Create the file if it doesn't exist.

```bash
mkdir -p ~/Library/Application\ Support/Claude
touch ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

#### Windows Configuration

On Windows, use the following path:

```
%APPDATA%\Claude\claude_desktop_config.json
```

Enter `%APPDATA%\Claude` in the Explorer address bar.

## 3. Connection Verification

### 3.1 Writing Configuration File

Open the `claude_desktop_config.json` file and add the following content.

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

**Parameter explanation**:
- `command`: Use `npx` (direct npm package execution)
- `args`: MCP server package and authentication information

**Or use hosted MCP server**:

```json
{
  "mcpServers": {
    "supabase": {
      "url": "https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=true"
    }
  }
}
```

The hosting approach is simpler.
It automatically handles OAuth 2.1 authentication.

### 3.2 Connection Test

Restart Claude Code.
Click the Tools icon in the menu to see the list of connected MCP servers.

If you see the "supabase" server, it's successful.

Let's do a simple test.

```
To Claude: "What's the Supabase anon key?"
```

Claude queries the project information and tells you.
If this works, the MCP server is properly connected.

## 4. Practical Usage Examples

Now let's actually perform database operations.

### 4.1 Table Queries

The most basic operation is table querying.

```
To Claude: "Show me all data from the users table"
```

Claude automatically writes and executes a SELECT query.
It organizes the results in a nicely formatted table.

**More specific requests are also possible**:

```
"Show me only users with Gmail emails from the users table"
```

```
"Tell me how many users signed up in the last 7 days"
```

When you request in natural language, Claude automatically generates appropriate SQL.

### 4.2 Data Insertion

Data insertion is also possible when read_only mode is disabled.

First, change `read_only=false` in the configuration file.

```json
{
  "mcpServers": {
    "supabase": {
      "url": "https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=false"
    }
  }
}
```

After restarting Claude Code, make a request like this.

```
"Add a new user to the users table. 
Name should be 'John', email should be 'john@example.com'"
```

Claude generates an INSERT query and requests execution.
When the user approves, the data is added.

### 4.3 Table Creation

You can also create new tables.

```
"Create a comments table. 
Columns should be id, user_id, content, created_at"
```

Claude generates a CREATE TABLE query.
After reviewing the schema and approving, the table is created.

### 4.4 Complex Queries

JOIN or aggregate queries can also be requested in natural language.

```
"Show the number of comments written by each user"
```

```
"How many users who signed up this month have written at least 1 comment?"
```

Claude automatically writes complex SQL too.
This makes database operations possible even without perfect SQL knowledge.

## 5. Security and Tips

### 5.1 Security Considerations

Security should be considered when using MCP servers.

**Prohibit production data connections**:
- Use MCP only in development/test environments
- Never connect to actual service databases
- AI might accidentally delete important data

**Utilize read-only mode**:
- Set read_only=true by default
- Temporarily disable only when write operations are needed
- Re-enable after completing work

**Project scoping**:
- Restrict access to specific projects only using the project_ref parameter
- Don't give access permissions to multiple projects

**API key management**:
- Don't put API keys directly in configuration files
- Managing with environment variables is safer
- Never upload to public repositories

### 5.2 Effective Usage Tips

**Make specific requests**:
- "Show data" ❌
- "Show emails and registration dates of the recent 10 users from the users table" ✅

**Proceed step by step**:
- Don't do complex operations all at once
- First query to check, then modify

**Review queries**:
- Always check the SQL generated by Claude
- Request modifications if there are suspicious parts

**Specify tools**:
- "Use the Supabase MCP tool to query the users table"
- Specifying like this can save tokens

## 6. Summary

We've learned how to connect Claude Code with Supabase MCP server.

**Key content summary**:
- MCP is a standard protocol connecting AI with external systems
- Supabase provides an official MCP server
- Add MCP server information to the configuration file
- Database operations can be performed using natural language
- Use read_only mode for safety

**Next steps**:
- Try adding other MCP servers (GitHub, Notion, etc.)
- Create complex workflows by combining multiple MCP servers
- Develop custom MCP servers suitable for your projects

Good utilization of MCP servers significantly improves Claude Code's productivity.
You can integrate with various external tools beyond just database operations.
This makes development workflows much more convenient.