---
layout: post
title: Windows 10에서 Docker 사용해보기
categories: [docker]
tags: [docker]
---

### 1. Docker 사용 준비

* Windows 10에 Docker Desktop을 설치하기 위해서는 WSL2 기능이 필요하다.
* 본 블로그의 [WSL2 Installation]을 참고하여, 2번 과정까지만 진행한 후에 아래 과정 진행하면 된다.

### 2. Docker Desktop 설치하기

* [Docker Desktop Installer]를 다운로드하여 설치한다.
* 설치하고, tutorial을 진행하면 간단한 리눅스 컨테이너를 하나 만들고 실행하는 것 까지 해볼 수 있다.
* Docker Desktop의 설정에서 필요한 것들이 이미 체크되어 있어서, 각종 설치 문서, 블로그에 나오는 설정을 따로 할 필요는 없었다.

### 3. Docker 연습 해보기

* [Docker Reference Documentation]을 참고하여 여러가지 CLI 명령을 알 수 있다.

* 간단한 연습
```powershell
> docker search ubuntu # ubuntu image searching
> docker pull ubuntu:latest # ubuntu의 latest version을 가져오기. latest대신 특정 버전을 써도 된다.
> docker images # local에 있는 docker image들을 볼 수 있다.
> docker create -i -t --name ubuntu-test ubuntu # ubuntu image로 ubuntu-test라는 이름의 container를 interactive pseudo-tty 모드로 만든다.
> docker start ubuntu-test # 위에서 만들어진 ubuntu-test라는 container를 시작한다.
> docker ps -a # local에 있는 모든 container를 본다. 실행된 것만 보려면 -a 를 빼면된다.
> docker attach ubuntu-test # 시작된 ubuntu-test라는 container로 들어간다. 여기서는 입출력되는 TTY모드로 생성했으니, 즉, shell로 들어간다.
root@782fef02d798:~# 
```
이렇게 container형태로 실행된 ubuntu의 shell에 들어가는까지 해봤다. 최소한의 것만 있어서 사실 shell에 들어가서 할 수 있는게 별로 없다. 물론, 평소 linux쓰듯이 필요한 것들을 설치해서 가상 linux처럼 쓸 수 있지만, container 본질과는 좀 다르다. 완전한 Linux가 필요하면 VM이나 WSL2를 이용하는 것이 좋을 것 같다.


[WSL2 Installation]:https://urfreein.github.io/posts/WSL2-Installation/
[Docker Desktop Installer]:https://www.docker.com/products/docker-desktop
[Docker Reference Documentation]:https://docs.docker.com/reference/