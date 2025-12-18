---
title: "Neovim(nvim) 설치 가이드 (Windows/macOS/Linux)"
date: 2025-01-01T00:00:00+09:00
lastmod: 2025-01-01T00:00:00+09:00
draft: false
description: 
tags: ["neovim", "editor", "dev-environment", "windows", "macos", "linux"]
categories: ["tutorial"]
image: "https://images.urinfo24.com/featured/NeoVim-Installation-guide-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A modern, professional tech illustration for "Neovim(nvim) 설치 가이드 (Windows/macOS/Linux)".
- Style: Clean, professional, flat design with technical elements
- Subject: Visual representation of NeoVim Installation guide
- Elements: Technical icons, symbols, code snippets, terminal windows, relevant tech logos
- Colors: Blue and gray tech tones, white background, accent colors for highlights
- Mood: Professional, modern, educational, technical
- Composition: Centered layout with balanced elements, clean and organized

Technical keywords: neovim,  "editor,  "dev-environment,  "windows,  "macos

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/NeoVim-Installation-guide-featured.jpg

NOTE: Hugo will serve this from /images/NeoVim-Installation-guide-featured.jpg
-->

이 문서는 Windows, macOS, Linux 운영체제에서 Neovim을 설치하고, `lazy.nvim` 기반의 `init.lua` 설정 파일을 구성하는 방법을 안내합니다.
<!--more-->

## 1. Neovim (nvim) 설치 방법

각 운영체제에 맞는 패키지 관리자를 사용하여 Neovim을 설치합니다.

### 1\. Windows (Winget 사용)

Windows 10/11의 기본 패키지 관리자인 `winget`을 사용하여 `Neovim`을 설치하는 것이 가장 권장됩니다.

1.  **Windows Terminal** 또는 **명령 프롬프트\(CMD\)**를 엽니다.

2.  `winget` 명령어를 사용하여 `Neovim`을 설치합니다.

    ```powershell
    winget install Neovim.Neovim
    ```

    > `winget`은 대소문자를 구분하지 않지만, 정확한 패키지 ID는 `Neovim.Neovim`입니다.*
    {: .prompt-info }

### 2\. macOS (Homebrew 사용)

macOS에서는 패키지 관리자 `Homebrew`를 사용합니다.

1.  **Homebrew 설치:** (미설치 시) 터미널에서 다음 명령어를 실행합니다.
    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```
2.  **`Neovim` 설치:** `brew` 명령어를 실행합니다.
    ```bash
    brew install neovim
    ```

### 3\. Linux (APT 또는 DNF 사용)

사용하시는 리눅스 배포판의 기본 패키지 관리자를 사용합니다.

  * **Ubuntu/Debian (APT):**
    ```bash
    sudo apt update
    sudo apt install neovim
    ```
  * **Fedora/CentOS (DNF):**
    ```bash
    sudo dnf install neovim
    ```

-----

## 2. `init.lua` 설정 파일 위치

`Neovim`은 설정을 사용자 홈 디렉터리 내의 특정 폴더에서 관리합니다. `init.lua` 파일은 다음 경로에 위치해야 합니다. `vim`과의 호환성을 위해 `init.vim`을 사용할 수도 있습니다. 이때는 **vimscript**를 이용해서 작성해야 합니다. 다만, 최근 `Neovim`의 권장 방식은 `init.lua`를 사용하는 것이므로, 여기서는 `init.lua`만을 다룹니다.

| 운영체제 | 설정 디렉터리 | `init.lua` 전체 경로 (예시) |
| :--- | :--- | :--- |
| **Linux/macOS** | `~/.config/nvim/` | `~/.config/nvim/init.lua` |
| **Windows** | `%USERPROFILE%\AppData\Local\nvim\` | `C:\Users\Username\AppData\Local\nvim\init.lua` |

> 만약 해당 설정 디렉터리(`nvim` 폴더)가 없다면, 직접 생성해 주어야 합니다.
{: .prompt-warning }

-----

## 3. `init.lua` 설정 예시

이 파일은 **`lazy.nvim` 플러그인 관리자**를 사용하여 `tokyonight` 테마, `lualine` 상태 표시줄, `nvim-tree` 파일 탐색기, 그리고 `LSP`, `Mason`, `nvim-cmp` 등의 개발 환경 플러그인을 설정합니다.

{% raw %}
```lua
-- 리더 키 설정 (모든 단축키의 시작점, <Space> 키로 지정)
vim.g.mapleader = " "

-- 기본적인 Neovim 옵션 설정
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

-- lazy.nvim 설치 및 설정
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 플러그인 목록
local plugins = {
  -- 테마
  { "folke/tokyonight.nvim", lazy = false, priority = 1000,
    config = function()
      vim.cmd.colorscheme "tokyonight"
    end
  },
  
  -- 상태 표시줄
  { "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }
  },
  
  -- 파일 탐색기
  { "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- lazy.nvim이 단축키를 인식하도록 keys 설정
    keys = {
      { "<leader>e", function() require("nvim-tree.api").tree.toggle({ focus = true }) end, desc = "Toggle NvimTree" }
    },
    config = function()
      local api = require("nvim-tree.api")
      
      -- NvimTree 자동 닫기 설정
      vim.api.nvim_create_autocmd("BufEnter", {
        nested = true,
        callback = function()
          if vim.bo.ft == "dps-tree" and #vim.api.nvim_list_wins() == 1 then
            api.tree.close()
          end
        end
      })

      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
      })
    end
  },

  -- LSP (Language Server Protocol)
  { "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local opts = { noremap = true, silent = true }
      
      local on_attach = function(client, bufnr)
        -- 핵심 LSP 키 맵핑
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
        vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts)
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "ruff" },
        handlers = {
          -- [수정됨 ✅] 모든 LSP 서버에 대해 아래의 기본 설정을 자동으로 적용
          function(server_name)
            require("lspconfig")[server_name].setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end,
        }
      })
    end
  },

  -- 자동 완성
  { "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-buffer", "hrsh7th/cmp-path" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        sources = cmp.config.sources({{ name = "nvim_lsp" }, { name = "buffer" }, { name = "path" }}),
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<C-e>'] = cmp.mapping.abort(),
        }),
      })
    end
  },

  -- lazy.nvim: 필수
  { "folke/lazy.nvim", version = "*" }

}

-- lazy.nvim 구동
require("lazy").setup(plugins, {})

-- NeoVim의 커서 모양 변경을 완전히 비활성화, nvim 종료 후 커서 모양이 터미널 기본 커서로 복귀가 안되서 설정.
-- nvim에서 nvim의 커서모양으로 바뀌기 원하면 아랫줄을 삭제
vim.opt.guicursor = ""
```
{% endraw %}