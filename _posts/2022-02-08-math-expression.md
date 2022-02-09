---
layout: post
title: 포스트에 수식표현하기
categories: [LaTeX, MathJax]
tags: [mathjax]
math: true
---

### 1. MathJax 이용하기

* Jekyll Blog에서 Markdown 으로 수식을 표현하기 위해서는 MathJax를 쓸 수 있도록 설정해야 한다. 설정 방법은 아래 참고사이트를 보면 쉽게 할 수 있다.
이 블로그에서 이용하는 Jekyll blog의 Theme중 하나인 Chirpy Theme에서는 이미 적용되어 있어서, **YAML front-matter** 부분에 `math: true`를 삽입하여, 수식을 표현할 포스트임을 표시하면 된다.

* Markdown 으로 수식 표현 하기

이제부터 LaTeX과 같은 표현으로 수식을 블로그에 표현할 수 있다. 수식을 표현하는 방법은 관련 블로그등을 찾아서 해보자.
아래는 테스트로 해본 것.

인라인 수식은 `$ x + y = 1 $`라고 쓰면, $ x+y=1 $ 이렇게 표현 된다.

물론 `\\( x + y = 1 \\)`  이렇게 써도, \\( x + y = 1 \\) 똑같이 표현 된다.

하지만, `$ ... $`를 쓰는 것은 과거에는 허용되었지만 mathjax.org에서 더 이상 추천하지 않는 방법이다. 왜냐하면 달러를 표현할 때 문장안에서 자주 쓰일 수 있기 때문이다.

가운데 정렬 수식은 이렇게

```
$$
    x^2 + y^2 = z^2
$$
```
라고 쓰면,

$$
    x^2 + y^2 = z^2
$$

이렇게 표현되고,

또는,

```
\\[
    x^2 + y^2 = z^2
\\]
```
라고 쓰면,

\\[
    x^2 + y^2 = z^2
\\]


이렇게 표현된다.

> LaTeX 문법과 정확히 일치하지 않는 경우도 있다고 하니, 잘 비교해보며 사용하자.
{: .prompt-note }

### 2. 참고 사이트

* [MathJax] : Jekyll에서 MathJax를 쓰기위해 configuration 설정을 위해 참고.
* Jekll github blog에 수식을 표현하기 위해 [Jekyll Github 블로그에 MathJax로 수학식 표시하기](https://mkkim85.github.io/blog-apply-mathjax-to-jekyll-and-github-pages/) 사이트를 참고했는데, 조금 오래된 내용이라, [MathJax]를 참고하여 일부 수정했다. 하지만 최초 설정하는 힌트를 얻기에는 충분하다.
* [Markdown 수식 표현 방법] : 여기서 markdown으로 수식 표현하는 것을 배워보자. 이 사이트 말고도 유사한 블로그는 많다.

[MathJax]:http://docs.mathjax.org/en/v2.7-latest/index.html
[Markdown 수식 표현 방법]:https://velog.io/@d2h10s/LaTex-Markdown-%EC%88%98%EC%8B%9D-%EC%9E%91%EC%84%B1%EB%B2%95