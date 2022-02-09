---
layout: post
title: Raspberry Pi Build HAT 사용하기
categories: [Raspberrypi, Lego, Build-HAT]
tags: [raspberrypi, buildhat, lego]
---

### 1. Build HAT 사용준비

* [Build HAT](https://www.raspberrypi.com/documentation/accessories/build-hat.html) 문서를 참고하여 준비하는데, 핵심은 Serial Port 설정이다.

* GUI 환경에서 "Raspberry Pi Configuration"을 활용하던가, `sudo rasp-config`로 설정한다.
* Interface의 Serial 을 Enable하고, Serial Console 은 Disable한다.
* Serial Port를 쓰도록 설정하지 않으면, `/dev/serial0`{: .filepath} 가 없다는 **Error** 가 뜬다.
* 그 외에는 전용 Power Supply를 쓰면 Pi와 Lego Motor를 함께 구동하는데 충분한 전력이 공급된다.

### 2. Python 3, Build HAT library 준비하기

* 기본적으로 Python 3가 Pi에는 설치되어 있다. 그걸 그대로 써도 되고, 혹은 업그레이드 정도만 하면 된다.
```bash
  $ sudo apt update 
  $ sudo apt install python3 idle3
```
Pi 에서 작업을 하고, IDE환경이 필요하면 idle3도 추가한다. Windows와 같은 Desktop PC가 있다면, SSH 연결해서 VS Code로 원격으로 작업하는 것이 편하다.

* Build HAT Python Library를 설치한다.
```bash
  $ pip3 install buildhat
```

와 같이 python library까지 설치하면 준비는 완료되었다.

### 3. Build HAT 테스트

* 아래와 같은 간단한 예제를 작성하여 실행해본다.

```python
  import time
  from signal import pause
  from buildhat import Motor
  
  motor = Motor('A')
  motor.set_default_speed(30)
  
  print("Position", motor.get_aposition())
  
  def handle_motor(speed, pos, apos):
      print("Motor", speed, pos, apos)
  
  motor.when_rotated = handle_motor
  
  print("Run for degrees")
  motor.run_for_degrees(360)
  time.sleep(3)
  
  print("Run for seconds")
  motor.run_for_seconds(5)
  time.sleep(3)
  
  print("Run for rotations")
  motor.run_for_rotations(2)
  time.sleep(3)
  
  print("Start motor")
  motor.start()
  time.sleep(3)
  print("Stop motor")
  motor.stop()
  
  pause()
```
* 맨 처음 실행하면 firmware writing으로 시간이 좀 지난 후 작동한다.
* 위 예제를 실행해보면 Default Speed 를 30으로 설정했는데, 30으로 돌때도 있고, 50으로 돌때도 있다. 확인이 필요해 보인다.
