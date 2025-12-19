---
title: "Git 주요 명령어 치트 시트 (Atlassian Cheat Sheet 기반)"
date: 2025-01-01T00:00:00+09:00
lastmod: 2025-01-01T00:00:00+09:00
draft: false
description: 
tags: ["git", "command", "cheatsheet"]
categories: ["Tutorial"]
image: "https://urinfo24.com/cdn-cgi/image/width=1200,format=auto,quality=85/https://images.urinfo24.com/featured/git-command-list-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A modern, professional tech illustration for "Git 주요 명령어 치트 시트 (Atlassian Cheat Sheet 기반)".
- Style: Clean, professional, flat design with technical elements
- Subject: Visual representation of git command list
- Elements: Technical icons, symbols, code snippets, terminal windows, relevant tech logos
- Colors: Blue and gray tech tones, white background, accent colors for highlights
- Mood: Professional, modern, educational, technical
- Composition: Centered layout with balanced elements, clean and organized

Technical keywords: git,  "command,  "cheatsheet

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/git-command-list-featured.jpg

NOTE: Hugo will serve this from /images/git-command-list-featured.jpg
-->

Atlassian의 Git Cheat Sheet를 기반으로, 자주 사용하는 Git 명령어들을 마크다운 형식으로 정리한 문서입니다. 각 명령어의 기본 사용법과 옵션을 빠르게 찾아볼 수 있습니다.
<!--more-->

---

## GIT BASICS

| 명령어 | 설명 |
| :--- | :--- |
| `git init <directory>` | 지정된 디렉터리에 빈 Git 저장소 생성. 인수를 사용하지 않으면 현재 디렉터리를 Git 저장소로 초기화합니다. |
| `git commit -amend` | Staged된 변경사항과 이전 커밋을 합쳐서 마지막 커밋을 대체합니다. Staging 영역에 변경사항이 없을 경우, 마지막 커밋 메시지를 수정하는 데 사용됩니다. |
| `git clone <repo>` | `<repo>`에 위치한 저장소를 로컬 머신으로 복제합니다. 원본 저장소는 로컬 파일 시스템이나 HTTP 또는 SSH를 통한 원격 머신에 위치할 수 있습니다. |
| `git rebase <base>` | 현재 브랜치를 `<base>` 위로 리베이스합니다. `<base>`는 커밋 ID, 브랜치 이름, 태그 또는 HEAD에 대한 상대적 참조가 될 수 있습니다. |
| `git config user.name <name>` | 현재 저장소의 모든 커밋에 사용할 작성자 이름 정의. 개발자들은 보통 `-global` 플래그를 사용하여 현재 사용자의 구성 옵션을 설정합니다. |
| `git reflog` | 로컬 저장소의 HEAD에 대한 변경 로그를 표시합니다. 날짜 정보를 표시하려면 `--relative-date` 플래그를, 모든 참조를 표시하려면 `--all` 플래그를 추가합니다. |
| `git add <directory>` | `<directory>` 내의 모든 변경사항을 다음 커밋을 위해 Stage 합니다. 특정 파일에 대해 변경하려면 `<directory>`를 `<file>`로 대체합니다. |
| `git commit -m "<message>"` | Stage된 스냅샷을 커밋하고, 텍스트 편집기를 실행하는 대신 `<message>`를 커밋 메시지로 사용합니다. |
| `git status` | Staged, Unstaged 및 Untracked 상태의 파일을 나열합니다. |
| `git log` | 기본 형식을 사용하여 전체 커밋 히스토리를 표시합니다. 추가 사용자 정의 옵션은 아래를 참조하십시오. |
| `git diff` | Index와 작업 디렉터리 사이의 Unstaged 변경사항을 표시합니다. |

---

## GIT BRANCHES

| 명령어 | 설명 |
| :--- | :--- |
| `git branch` | 저장소 내의 모든 브랜치를 나열합니다. `<branch>` 인수를 추가하여 해당 이름의 새 브랜치를 생성합니다. |
| `git checkout -b <branch>` | `<branch>`라는 이름의 새 브랜치를 생성하고 체크아웃합니다. 기존 브랜치를 체크아웃하려면 `-b` 플래그를 생략합니다. |
| `git merge <branch>` | `<branch>`를 현재 브랜치로 병합합니다. |

---

## REMOTE REPOSITORIES

| 명령어 | 설명 |
| :--- | :--- |
| `git remote add <name> <url>` | 원격 저장소에 대한 새 연결을 만듭니다. 원격을 추가한 후, 다른 명령에서 `<url>`의 단축키로 `<name>`을 사용할 수 있습니다. |
| `git fetch <remote> <branch>` | 저장소에서 특정 `<branch>`를 가져옵니다. 모든 원격 참조를 가져오려면 `<branch>`를 생략합니다. |
| `git pull <remote>` | 지정된 원격의 현재 브랜치 복사본을 가져오고, 즉시 로컬 복사본으로 병합합니다. |
| `git push <remote> <branch>` | 필요한 커밋 및 객체와 함께 브랜치를 `<remote>`로 푸시합니다. 원격 저장소에 해당 이름의 브랜치가 없으면 생성합니다. |

---

## UNDOING CHANGES (변경 취소)

| 명령어 | 설명 |
| :--- | :--- |
| `git revert <commit>` | [cite_start]`<commit>`에서 수행된 모든 변경사항을 되돌리는 새 커밋을 생성한 다음, 이를 현재 브랜치에 적용합니다. [cite: 3] |
| `git reset <file>` | Staging 영역에서 `<file>`을 제거하지만, 작업 디렉터리는 변경하지 않은 상태로 둡니다. [cite_start]이는 변경사항을 덮어쓰지 않고 파일을 Unstage합니다. [cite: 3] |
| `git clean -n` | 작업 디렉터리에서 **제거될 파일**을 보여줍니다. [cite_start]제거를 실행하려면 `-n` 플래그 대신 `-f` 플래그를 사용합니다. [cite: 3] |

---

## REWRITING GIT HISTORY

| 명령어 | 설명 |
| :--- | :--- |
| `git commit -amend` | Staged된 변경사항과 이전 커밋을 합쳐서 마지막 커밋을 대체합니다. Staging 영역에 변경사항이 없을 경우, 마지막 커밋 메시지를 수정하는 데 사용됩니다. |

---

## Additional Options +

### GIT CONFIG

| 명령어 | 설명 |
| :--- | :--- |
| `git config --global user.name <name>` | 현재 사용자가 수행하는 모든 커밋에 사용할 작성자 이름을 정의합니다. |
| `git config --global user.email <email>` | 현재 사용자가 수행하는 모든 커밋에 사용할 작성자 이메일을 정의합니다. |
| `git config --global alias.<alias-name> <git-command>` | Git 명령어의 단축키를 생성합니다. 예: `alias.glog "log --graph --oneline"`을 설정하면 `"git glog"`는 `"git log --graph --oneline"`과 동일하게 작동합니다. |
| `git config --system core.editor <editor>` | 시스템의 모든 사용자가 명령에 사용하는 텍스트 편집기를 설정합니다. `<editor>` 인수는 원하는 편집기를 실행하는 명령이어야 합니다 (예: `vi`). |
| `git config --global -edit` | 수동 편집을 위해 전역 구성 파일을 텍스트 편집기로 엽니다. |

---

### GIT LOG

| 명령어 | 설명 |
| :--- | :--- |
| `git log <limit>` | 커밋 수를 `<limit>`만큼 제한합니다. 예: `git log -5`는 5개의 커밋으로 제한합니다. |
| `git log --oneline` | 각 커밋을 한 줄로 요약합니다. |
| `git log -p` | 각 커밋의 전체 `diff`를 표시합니다. |
| `git log --stat` | 어떤 파일이 변경되었는지와 각 파일에서 추가되거나 삭제된 줄의 상대적인 수를 포함합니다. |
| `git log --author="<pattern>"` | 특정 작성자의 커밋을 검색합니다. |
| `git log --grep="<pattern>"` | `<pattern>`과 일치하는 커밋 메시지를 가진 커밋을 검색합니다. |
| `git log <since>..<until>` | `<since>`와 `<until>` 사이에 발생한 커밋을 표시합니다. 인수는 커밋 ID, 브랜치 이름, `HEAD` 또는 다른 종류의 리비전 참조가 될 수 있습니다. |
| `git log <file>` | 지정된 파일이 포함된 커밋만 표시합니다. |
| `git log --graph --decorate` | `--graph` 플래그는 커밋 메시지 왼쪽에 텍스트 기반 커밋 그래프를 그립니다. `--decorate`는 표시된 커밋의 브랜치 또는 태그 이름을 추가합니다. |

---

### GIT DIFF

| 명령어 | 설명 |
| :--- | :--- |
| `git diff HEAD` | 작업 디렉터리와 마지막 커밋 사이의 차이점을 표시합니다. |
| `git diff --cached` | Stage된 변경사항과 마지막 커밋 사이의 차이점을 표시합니다. |

---

### GIT RESET

| 명령어 | 설명 |
| :--- | :--- |
| `git reset` | Staging 영역을 가장 최근 커밋과 일치하도록 재설정하지만, 작업 디렉터리는 변경하지 않습니다. |
| `git reset --hard` | Staging 영역과 작업 디렉터리를 모두 가장 최근 커밋과 일치하도록 재설정하고, 작업 디렉터리의 모든 변경사항을 덮어씁니다. |
| `git reset <commit>` | 현재 브랜치 팁을 `<commit>`으로 뒤로 이동하고, Staging 영역을 일치하도록 재설정하지만, 작업 디렉터리는 그대로 둡니다. |
| `git reset --hard <commit>` | 이전과 동일하지만, Staging 영역과 작업 디렉터리를 모두 일치하도록 재설정합니다. 커밋되지 않은 변경사항과 `<commit>` 이후의 모든 커밋을 삭제합니다. |

---

### GIT REBASE

| 명령어 | 설명 |
| :--- | :--- |
| `git rebase -i <base>` | 현재 브랜치를 `<base>` 위로 **대화형으로** 리베이스합니다. 편집기를 실행하여 각 커밋이 새 base로 어떻게 전송될지에 대한 명령을 입력합니다. |

---

### GIT PULL

| 명령어 | 설명 |
| :--- | :--- |
| `git pull --rebase <remote>` | 원격의 현재 브랜치 복사본을 가져와 **Merge 대신 Rebase**를 사용하여 로컬 복사본으로 통합합니다. |

---

### GIT PUSH

| 명령어 | 설명 |
| :--- | :--- |
| `git push <remote> --force` | non-fast-forward merge가 발생하더라도 Git 푸시를 강제로 실행합니다. **경고:** 이 플래그가 무엇을 하는지 확실히 알지 못한다면 사용하지 마십시오. |
| `git push <remote> --all` | 로컬의 모든 브랜치를 지정된 원격으로 푸시합니다. |
| `git push <remote> --tags` | 태그는 브랜치를 푸시하거나 `--all` 플래그를 사용할 때 자동으로 푸시되지 않습니다. `--tags` 플래그는 모든 로컬 태그를 원격 저장소로 보냅니다. |

---