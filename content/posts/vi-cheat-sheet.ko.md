---
title: "VI Command Sheet"
date: 2025-01-01T00:00:00+09:00
lastmod: 2025-01-01T00:00:00+09:00
draft: false
description: 
tags: ["vi", "vim", "editor", "cheatsheet", "command"]
categories: ["Tutorial"]
image: "https://images.urinfo24.com/featured/vi-cheat-sheet-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A modern, professional tech illustration for "VI Command Sheet".
- Style: Clean, professional, flat design with technical elements
- Subject: Visual representation of vi cheat sheet
- Elements: Technical icons, symbols, code snippets, terminal windows, relevant tech logos
- Colors: Blue and gray tech tones, white background, accent colors for highlights
- Mood: Professional, modern, educational, technical
- Composition: Centered layout with balanced elements, clean and organized

Technical keywords: vi,  "vim,  "editor,  "cheatsheet,  "command

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/vi-cheat-sheet-featured.jpg

NOTE: Hugo will serve this from /images/vi-cheat-sheet-featured.jpg
-->

자주 사용하는 vi/vim 명령어들을 정리한 치트 시트입니다. 각 명령어의 기본 사용법을 빠르게 찾아볼 수 있습니다.
<!--more-->

---
## Invoking vi & Modes

| 명령어 형식 | 설명 |
| :--- | :--- |
| `vi filename` | 지정된 파일을 열어 `vi` 에디터를 시작합니다. |
| `[count][command]` | `count`는 명령어의 효과를 반복합니다. |
| **Command mode** | `Vi`가 시작되는 모드이며, 위치 지정 명령이 작동합니다. |
| **Input mode** | 텍스트를 입력하는 모드이며, `Esc` 키를 눌러 명령 모드로 돌아갑니다. |

---

## Input Commands (입력 모드 전환)

이 명령들은 `Esc`를 누를 때까지 `vi`를 입력 모드로 둡니다.

| 명령어 | 설명 |
| :--- | :--- |
| `a` | 커서 뒤에 덧붙입니다 (Append after cursor). |
| `i` | 커서 앞에 삽입합니다 (Insert before cursor). |
| `o` | 현재 줄 아래에 새 줄을 엽니다. |
| `O` | 현재 줄 위에 새 줄을 엽니다. |
| `R` | 교체 (Replace - 덮어쓰기 모드, `Esc`로 종료). |
| `s` | 한 문자를 문자열로 대체합니다 (`Esc`로 종료). |
| `S` | 줄의 나머지를 문자열로 대체합니다 (`Esc`로 종료). |

---

## Cursor Motions (명령 모드)

| 명령어 | 설명 |
| :--- | :--- |
| `h` | 문자 하나 뒤로 이동 (Back a character). |
| `j` | 한 줄 아래로 이동 (Down a line). |
| `k` | 한 줄 위로 이동 (Up a line). |
| `l` | 문자 하나 앞으로 이동 (Forward a character). |
| `0` | 줄의 시작으로 이동 (Beginning of line). |
| `$` | 줄의 끝으로 이동 (End of line). |
| `W` | 한 단어 앞으로 이동 (One word forward). |
| `b` | 한 단어 뒤로 이동 (Back one word). |
| `fc` | 문자 `c`를 찾습니다 (Find c). |
| `G` | 마지막 줄로 이동 (Go to last line). |
| `nG` | `n`번째 줄로 이동 (Go to line n). |

---

## Change & Deletion Commands

| 명령어 | 설명 |
| :--- | :--- |
| `cW` | 한 단어를 변경합니다 (`Esc`로 종료). |
| `cC` | 한 줄을 변경합니다 (`Esc`로 종료) - 줄을 공백으로 만듭니다. |
| `c$` | 줄의 끝까지 변경합니다. |
| `dw` | 한 단어를 일반 버퍼로 삭제합니다. |
| `dd` 또는 `ndd` | `n`줄을 일반 버퍼로 삭제합니다. |
| `D` | 줄의 끝까지 삭제합니다. |
| `X` | 문자를 삭제합니다. |

---

## File & Session Management

| 명령어 | 설명 |
| :--- | :--- |
| `:wq` | 파일에 저장하고 종료합니다. |
| `ZZ` | `:wq`와 동일합니다. |
| `:q!` | 변경사항을 저장하지 않고 종료합니다. |
| `:r file` | 현재 줄 뒤에 파일을 삽입합니다. |
| `:sh` | 셸 명령을 실행합니다 (`<ctrl>d`로 복귀). |

---

## Rearrangement, Copy & Paste

| 명령어 | 설명 |
| :--- | :--- |
| `yy` 또는 `Y` | 한 줄을 일반 버퍼로 Yank(복사)합니다. |
| `"a10yy` | 10줄을 버퍼 `a`에 Yank(복사)합니다. |
| `p` | 일반 버퍼의 텍스트를 커서 **뒤에** 붙여넣습니다 (Put after cursor). |
| `P` | 일반 버퍼의 텍스트를 커서 **앞에** 붙여넣습니다 (Put before cursor). |
| `u` | 마지막 변경을 실행 취소합니다. |
| `U` | 해당 줄의 모든 변경을 실행 취소합니다. |

---

## Search and Replace Commands

| 명령어 | 설명 |
| :--- | :--- |
| `/string` | 앞으로 검색합니다. |
| `?string` | 뒤로 검색합니다. |
| `n` | 검색을 반복합니다. |
| `N` | 검색을 반대 방향으로 반복합니다. |
| `:%s/old_text/new_text/g` | 파일 전체(`%`)에서 `old_text`를 `new_text`로 모두(`g`) 교체합니다. |

---

## Parameters (설정)

| 명령어 | 설명 |
| :--- | :--- |
| `:set number` | 줄 번호를 표시합니다. |
| `:set nonumber` | 줄 번호를 표시하지 않습니다. |
| `:set autoindent` | 캐리지 리턴(줄 바꿈) 후 자동 들여쓰기를 합니다. |
| `:set showmatch` | 입력될 때 일치하는 괄호 쌍을 보여줍니다. |
| `:set showmode` | 화면의 마지막 줄에 모드를 표시합니다. |