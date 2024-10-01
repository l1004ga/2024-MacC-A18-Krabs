## 목차
  - [1. 브랜치 전략](#1-브랜치-전략)
  - [2. 커밋 규칙](#2-커밋-규칙)
  - [3. issue 스타일 가이드](#3-issue-스타일-가이드)
  - [4. pull request 스타일 가이드](#4-pull-request-스타일-가이드)

<br>

## 1. 네이밍 전략
```
- feat: 새로운 기능 추가
- fix: 버그 수정
- docs: 문서 수정
- refactor: 코드 리팩토링
- test: 테스트 코드, 리팩토링 테스트 코드 추가
- chore: 빌드 업무 수정, 패키지 매니저 수정, 잡일
```

## 2. 브랜치 전략
- 브랜치는 `브랜치종류/#이슈번호-설명간단히(영문)` 으로 생성한다.
```
브랜치종류/#이슈번호-간략한설명(영문)
ex) feat/#24-SecondView
```

<br>

### 2-1. 브랜치 규칙
```
1. develop, main 브랜치에서의 작업은 원칙적으로 금지한다.
2. 자신이 담당한 부분 이외에 다른 팀원이 담당한 부분을 수정할 때에는 반드시 변경 사항을 전달한다.
3. 본인의 Pull Request는 본인이 Merge한다.
4. Commit, Push, Merge, Pull Request 등 모든 작업은 앱이 정상적으로 실행되는 지 빌드한 후 수행한다.
```

### 2-2. 브랜치 플로우
```
1. Issue를 생성한다.
2. feature 브랜치를 생성한다.
3. feature 브랜치 내부에서 Add - Commit - Push - Pull Request 의 과정을 거친다.
4. Pull Request가 작성되면 충돌 확인 후 merge 한다.
5. 종료된 Pull Request branch는 삭제한다.
```

<br>

## 3. 커밋 규칙
- 커밋은 `[커밋종류] #이슈번호 커밋내용` 으로 생성한다.
```
[커밋종류] #이슈번호 커밋내용
ex) [feat] #12 MainView 생성
```

<br>

## 4. Issue 스타일 가이드
### Feature Issue
```
---
name: Feature Template
about: 기능 추가시 작성해 주세요
title: ''
labels: enhancement
assignees: ''

---

## Description
추가하려는 기능에 대해 간단히 설명해 주세요

## TODO
할 일 목록을 작성해 주세요

- [ ] 

## ScreenShot
추가할 기능의 스크린샷이 있다면 첨부해 주세요

### ETC
기타 참고사항을 작성해 주세요
```

<br>

### Bug Issue
```
---
name: Bug Template
about: 버그 발생시 작성해 주세요
title: ''
labels: bug
assignees: ''

---

## Problem
무슨 문제인지 간단히 작성해 주세요

- [ ] 

## How to Solve
어떻게 해결했는지 작성해 주세요

- [ ] 

### ETC
기타 참고사항을 작성해 주세요
```

<br>

## 5. Pull Request 스타일 가이드
아래 템플릿을 따르고 있습니다.
```
## 제목 양식
> [카테고리] #{이슈 번호} {PR 내용}
***
## 개요
> 변경 사항 및 관련 이슈에 대해 간단하게 작성해주세요.

### 연관이슈 #{이슈 번호}

## 작업 내용
### 1. 

### 작업 스크린샷 (Optional)

## 리뷰어에게 남길 말 (Optional)
> 리뷰어가 특별히 봐주었으면 하는 부분이 있다면 작성해 주세요
```
