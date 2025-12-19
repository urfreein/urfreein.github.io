# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

```bash
# Development server with live reload
hugo server -D

# Production build
hugo

# Build with drafts included
hugo -D
```

Build output goes to `public/`. Hugo automatically processes images (WebP conversion, responsive sizes).

## Architecture

### Hugo Stack Theme Blog

This is a multilingual blog using [Hugo Stack Theme v3](https://github.com/CaiJimmy/hugo-theme-stack). Theme is managed via Hugo Modules (see `go.mod`).

**Site URL:** https://urinfo24.com/

### Configuration

All config files are in `config/_default/`:

| File | Purpose |
|------|---------|
| `config.yaml` | Site settings, languages, pagination |
| `params.yaml` | Theme parameters, widgets, features |
| `menu.yaml` | Navigation menus (main, social) |

### Multilingual Setup

- **Default language:** Korean (ko-kr)
- **Supported:** ko, en, ja, de, fr, es, pt-br, vi, th, hi

Content files use language suffix: `post-name.ko.md`, `post-name.en.md`

### Content Structure

```
content/
├── posts/           # Blog articles (*.{lang}.md)
└── page/
    ├── archives/    # Archive pages per language
    └── search/      # Search pages per language
```

### Post Frontmatter

```yaml
---
title: "Post Title"
date: 2025-01-15T10:00:00+09:00
draft: false
description: "Summary for SEO"
tags: ["tag1", "tag2"]
categories: ["Category"]
image: "featured-image-url"    # Optional cover image
---
```

### Assets

- `assets/img/` - Images processed by Hugo (avatar, logo)
- `static/` - Files copied as-is (favicons, verification files)

### Key Theme Features

- Dark mode toggle (auto/light/dark)
- KaTeX math rendering
- PhotoSwipe image gallery
- Local search
- Reading time & TOC

### Adding New Content

```bash
# Create new post (edit language suffix as needed)
hugo new posts/my-new-post.ko.md
```

### Reference

Detailed theme configuration guide: `stack_theme_guide.md`
