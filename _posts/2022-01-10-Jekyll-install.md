---
layout: post
title:  "Jekyll 설치와 사이트 만들기"
categories: jekyll installation
---

### 1. Homebrew 이용하여 ruby Upgrade on the Mac
```bash
~ $ brew install rbenv
~ $ rbenv install 3.0.1
```
Windows에서 ruby설치는 installer 받아서 설치한다.

### 2. Jekyll 설치
```bash
~ $ gem install jekyll bundler
```
### 3. Jekyll site 만들기
```
~ $ jekyll new my-awesome-site
~ $ cd my-awesome-site
~/my-awesome-site $ bundle exec jekyll serve
```
로컬에서 서버가 구동된다. 브라우저에서 localhost:4000 으로 접속하면 된다.
첫 사이트 생성 완료!!
`jekyll new <site_name>` 에서 `<site_name>`에 해당하는 directory가 존재하고 파일들이 있으면 에러가 난다. 최소 비어있는 directory거나 아직 생성되어있지 않아야 한다.
### 4. github에 올리기
* 먼저 github에 repository를 만든다.
* repo 이름은 username.github.io 로 만들 것!
* git의 원격 저장소로 설정하기
```
~/my-awesome-site $ git init
~/my-awesome-site $ git add .
~/my-awesome-site $ git commit -m "first site"
~/my-awesome-site $ git push origin master
```

정상적으로 push가 되면 이제 브라우저에서 *https://username.github.io* 로 접속하면 로컬에서 보던 것과 똑같이 보인다. 다만, 페이지 생성에 시간이 소요되어 수십초 내지 몇 분 후에 정상적으로 나온다. 즉각적인 확인이 안되어 조금 답답하다.
따라서, 조금 바꾸고 github에서 적용된 것을 확인하기 보다는 로컬에서 확인 후 모든 것이 다 되었다고 생각될 때, 한번에 올려서 확인하는 것이 정신건강에 좋을 것 같다.

