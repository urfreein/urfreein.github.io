---
layout: post
title: Utterances reply 테스트 해보기
categories: [utterances]
tags: [utterances]
---

### 1. Utterances 연결하기

[Utterances](https://utteranc.es/) 에서 **Install** 클릭하여 자신의 블로그사이트용 github repository를 선택하여 이용한다. 상세한 설치 요령은 다른 유저의 블로그들을 검색하면 많이 나오니 생략한다. 이 블로그에서 사용중인 Chirpy Theme는 이미 적용이 되어있어서, `_config.yml`{: .filepath}의 아래 부분을 수정하면 바로 모든 포스트에 적용된다.

만일 댓글 기능을 원하지 않는 포스트는 **front matter**부분에 `comments: false` 라고 써주면 된다.

```yaml
comments:
  active: utterances        # The global switch for posts comments, e.g., 'disqus'.  Keep it empty means disable
  # The active options are as follows:
  disqus:
    shortname:    # fill with the Disqus shortname. › https://help.disqus.com/en/articles/1717111-what-s-a-shortname
  # utterances settings › https://utteranc.es/
  utterances:
    repo: <gh-username>/<gh-username>.github.io         # <gh-username>/<repo>
    issue_term: pathname  # < url | pathname | title | ...>
```
{: .nolineno file="_config.yml" }

### 2. Test 해보기

github에 로그인한 유저들을 대상으로 댓글을 달 수 있다. 달린 댓글은 github의 블로그용 repository에 issue로 등록이 되는 것 같다. 거기서도 댓글을 달 수 있지만, 블로그에서 이용하는 것이 편하다.

test는 그저 페이지 리로드해서 아래 부분에 댓글을 달 수 있게 생겼는지 보면 되겠다.
