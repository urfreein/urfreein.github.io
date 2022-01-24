---
layout: post
title: "Raspberry Pi Build HAT을 위한 Raspberry Pi 준비하기"
categories: [Raspberrypi, installation]
tags: [raspberrypi]
---
   
### 1. Raspberry Pi 준비
* WiFi를 바로 이용하기 위해서는 Raspberry Pi 3 이상의 버전을 사용한다. 그 이전버전은 USB WiFi 모듈을 별도로 준비하거나, 유선을 이용해야 한다.
* 가능하면 별도의 전원장치를 이용하는 것이 좋다. 5V-3A가 되어야 하는데, 스마트폰용으로 많이 나오는 것들은 전압은 5V를 만족하지만, 전류가 2A 이하이다.
  전류가 낮으면, OS설치후 전압이 낮다는 경고가 계속 뜬다.(그래서 결국 새로 전원장치를 새로 샀다.)
* PI 3은 Micro USB 5Pin Type으로 전원을 받고, Pi 4는 USB-C Type이다. 가능하면 중간에 스위치가 달려있는 케이블이 좋다.
* Display Cable은 HDMI를 이용하는데, Pi 4는 Micro HDMI로 연결되므로 맞는 케이블을 미리 준비한다.
* MicroSD Card가 필요하다. 8GB이상이 필요한데, 요즘은 가격이 싸니 용량이 큰 것으로 사서 쓰자. Classic Game Console로 쓸거라면 최소 128GB 정도는 되어야 왠만한 게임들을 다 넣을 수 있다. 난 그냥 예전에 쓰던 32GB를 쓰기로 했다.

### 2. Pi OS 설치
1. OS Image를 쉽게 SD Card에 설치해주는 [Raspberry Pi Imager](https://www.raspberrypi.com/software/)를 내려받아 PC에 설치한다.
2. Raspberry Pi Imager를 실행하고, SD Card를 SD Card Reader에 꽂아 연결하고, Imager에서 적당한 PI용 OS를 선택하여 설치한다. 난 기본적인 Linux OS가 필요해서, 목록의 가장 위에 있는 추천 OS를 설치했다. Debian Linux기반의 Rasbian이라 불리는 것이다. 이것외에 다른 여러가지 배포판의 Linux들이 있고, NAS용 OS나 고전 게임들을 위한 RetroPI나 미디어 서버를 위한 OS등 많이 준비되어 있으니 사용 목적에 맞는 것을 선택하여 설치한다.
3. 몇 분간의 설치가 진행되고, 끝나면 SD Card를 뽑아서, 준비한 Raspberry Pi에 꽂는다. 본인은 Pi 4를 구하지 못했다. 반도체 수급 문제인지, 재고가 들어올려면 몇 달은 더 있어야 한단다. 예전에 사두었던 Pi 2, 3가 있었는데, WiFi때문에 Pi 3를 이용했다. OS설치나 기타 소프트웨어 설치는 Pi 4이든 큰 상관없으니 Pi 3에서 설치했던 기록을 남긴다.
4. Raspberry Pi에 전원을 넣고, 모니터, 키보드는 미리 연결해 두고 OS가 올라온 것을 확인한다.
5. 간단한 OS환경 설정을 위한 창이 실행된다.
6. Locale, Timezone 등 적당히 설정한다. Locale은 Ko-KR, Korea등등 찾아서 해주고, Time Zone은 Asia/Seoul로 하면 된거다.
7. 화면 우측 상단을 보면, 윈도즈의 우측 하단의 트레이 같은, 맥의 우측 상단과 같은 곳에 빨간줄이 세로로 그어진 네트워크 설정하는 아이콘을 클릭하여 Wifi를 선택하여 연결할 SSID와 Password 입력하여 Wifi를 연결한다.
8. 여기까지하고 다음 단계로...

### 3. OS 설치후 할 일
* 한글 깨짐 해결
    * OS설치후 Locale을 한국으로 설정하고 리부트를 하면 한글 폰트가 없어 깨져나온다. 왼쪽 위 상단 메뉴에서 터미널 아이콘 클릭하여 터미널을 실행하고, 아래와 같은 과정을 거쳐 한글 입력기 및 한글 폰트를 설치한다.
    ```bash
    $ sudo apt-get install fonts-unfonts-core
    $ sudo apt-get install ibus ibus-hangul
    ```
    * 설치과정에서 Yes/No를 물어보면 yes를 선택한다.
    * `sudo reboot`을 하여, 다시 리부팅하여 한글이 제대로 나오는 것을 확인한다.
* zsh, oh-my-zsh 설치하기
    * 기본 쉘이 bash인데, mac 추세를 따라 zsh을 설치하고, prompt등 꾸미기 위해 oh-my-zsh을 함께 설치한다.
    ```bash
    # zsh installation
    $ sudo apt install zsh
    # oh-my-zsh installation
    $ sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    # 기본 쉘을 zsh로 변경한다.
    $ chsh -s /bin/zsh
    ```
    * `vi ~/.zshrc` 하여 필요한 것들을 uncomment해준다.(별로 해줄건 없음) 아래 내용을 추가하거나 이미 있다면 테마를 agnoster로 바꿔준다.
    ```
    ZSH_THEME="agnoster"
    ```
    * `source ~/.zshrc`하여 변경한 것을 적용하고 확인한다.
* OS Update 하기
    * 설치된 OS에 포함된 패키지 목록을 갱신하고, 필요하면 업데이트 한다. 시간이 꾀 걸린다.
    ```
    $ sudo apt update && sudo apt upgrade
    ```
* 그외 git, python이 없다면 설치하고, python용 Build HAT Library도 설치한다.
```bash
$ sudo apt git
$ sudo apt python
# python용 Build HAT Library를 설치한다.
$ sudo pip3 install buildhat
```

### 4. Remote PC에서 작업하기
* Pi에서 Static IP할당과 SSH, VNC 연결 준비를 해준다.
    * 기본설정-Raspberry Pi Configuration을 실행하고, interface tab에서 SSH, VNC를 Enable한다.
    * 또는, Terminal을 열어서, `sudo raspi-config` 명령으로 Text기반 툴을 실행하여 설정한다.
    * raspi-config를 이용한다면 Interfacing Options에서 변경할 수 있다.
    * Remote PC에서 좀 더 쉽게 Pi를 연결할 수 있도록 Static IP를 할당해준다.
    ```bash
    # ifconfig명령을 실행한 후, Wifi연결했으므로 wlan0 interface의 inet address를 확인
    $ ifconfig
    # ifconfig 로 확인한 IP를 이용하거나, 외우기 쉬운 다른 IP를 할당한다.
    $ sudo vi /etc/dhcpcd.conf
    # dhcpcd.conf에 아래와 같이 입력하고 저장해준다.
    interface wlan0 # 유선이라면 eth0 일 것이다.
    static ip_address=192.168.1.200 # 와 같이 원하는 IP를 적어준다.
    static routers=192.168.1.1 # default gateway의 IP를 적어준다.
    # conf를 다 수정했다면, 네트워킹 서비스를 재시작하고, Pi를 재시작해준다.
    $ sudo /etc/init.d/networking restart
    $ sudo reboot
    ```
* Remote PC에서 SSH 연결해보기
    * 참고로 본인은 Windows Terminal에서 Powershell을 이용한다.
    * Windows Terminal을 실행하고 아래와 같이 연결해본다.
    ```bash
    > ssh pi@192.168.1.200 # Pi에 따로 user를 만들지 않았다면 default user로 pi가 있다.
    or
    > ssh pi@raspberrypi # Pi에서 hostname을 변경하지 않았다면, default는 raspberrypi다.
    ```
    * password를 입력하고 연결이 되는 것을 확인한다.
* Remote PC에서 VNC 연결해보기
    * [VNC Viewer](https://www.realvnc.com/en/connect/download/viewer/)를 사용중인 Remote PC의 OS에 맞게 다운로드하여 설치한다. 본인은 windows 버전 설치.
    * 설치후, VNC Viewer를 실행하여 Host에 `pi@192.168.1.200` or `pi@raspberrypi` 를 입력하여 연결한다. IP만 쓰면 Windows 로그인 유저명으로 로그인 시도를 한다. IP만 쓰면 연결한 User ID를 물어볼 줄 알았다.
    * 한번 연결하고 나면 VNC Viewer에 연결 프로필이 만들어지는데, Properties에 들어가서 필요한 설정을 변경할 수 있는데, 특별히 연결 User ID가 바뀐다거나, Host IP가 바뀐다거나 하지 않으면 변경할 것이 없다.
    * Pi에 모니터 연결없이, VNC 연결하면 해상도가 본인의 모니터 해상도에 비해 작을 수 있는데, 사실 VNC가 그렇게 빠른건 아니라서, 꼭 GUI 환경이 필요할 때 아니면 그닥 연결할 일이 없을 듯 하여, 설정을 변경하지 않았지만, 간단히 하겠다면 VNC연결후, 기본설정-Screen에서 적절한 해상도를 선택하면 된다.
    * 또는 아래와 같이 Terminal을 열어서 바꿔준다.
    ```bash
    $ sudo vi /boot/config.txt
    #framebuffer_width=1280
    #framebuffer_height=720
    # 위 두줄을 uncomment해주고, 뒤에 숫자를 1920x1080등 적당히 바꿔준다.
    $ sudo reboot
    ```
* Remote PC의 Visual Source Code를 SSH연결하여 작업하기
    * VS Code의 Extension중 Remote SSH를 찾아서 설치한다.
    * VS Code의 왼쪽 하단 연결 버튼을 클릭하고, `connect to Host`선택하고, `pi@192.168.1.200` or `pi@raspberrypi`를 입력한다.
    * 새 창이 뜨면서 remote host의 OS를 물어보면, Linux를 선택해 준다.
    * pi의 Password를 입력해주면 드디어 연결이 완료된다.
    * Open Files를 선택하여 pi의 home이 보이는지 확인한다.