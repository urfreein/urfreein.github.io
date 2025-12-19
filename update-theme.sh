#!/bin/bash
# Hugo 모듈 업데이트 스크립트

cd /home/freein/blog/urinfo24-blog

# PATH 설정
export PATH=/usr/local/go/bin:/usr/local/bin:/usr/bin:
echo '📦 Hugo 모듈 업데이트 시작...'
echo ''

echo '현재 버전:'
hugo mod graph

echo ''
echo '업데이트 중...'
hugo mod get -u

echo ''
echo '정리 중...'
hugo mod tidy

echo ''
echo '✅ 업데이트 완료!'
echo ''
echo '새 버전:'
hugo mod graph

echo ''
echo '변경사항:'
git diff go.mod go.sum
