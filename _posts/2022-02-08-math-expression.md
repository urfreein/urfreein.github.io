---
layout: post
title: 포스트에 수식표현하기
categories: [LaTeX, MathJax]
tags: [mathjax]
use_math: true
---

### 1. MathJax 이용하기

* Jekyll Blog에서 Markdown 으로 수식을 표현하기 위해서는 MathJax를 쓸 수 있도록 설정해야 한다. 아래와 같은 순서로 따라해 보자.
    * `mathjax_support.html`{: .filepath } 만들기
    `_includes`{: .filepath} 폴더에 `mathjax_support.html`{: .filepath}을 생성하고, 아래 내용을 붙여넣어 저장하자.
    
    ```html
    <script type="text/x-mathjax-config">
    MathJax.Hub.Config({
        jax: ["input/TeX","input/MathML","input/AsciiMath","output/CommonHTML"],
        extensions: ["tex2jax.js","mml2jax.js","asciimath2jax.js","MathMenu.js","MathZoom.js","AssistiveMML.js", "a11y/accessibility-menu.js"],
        TeX: {
          equationNumbers: {
            autoNumber: "AMS"
          }
        },
        tex2jax: {
        inlineMath: [ ['$', '$'], ['\\(','\\)'] ],
        processEscapes: true
        }
    });
    MathJax.Hub.Register.MessageHook("Math Processing Error",function (message) {
          alert("Math Processing Error: "+message[1]);
        });
    MathJax.Hub.Register.MessageHook("TeX Jax - parse error",function (message) {
          alert("Math Processing Error: "+message[1]);
        });
    </script>
    <script type="text/javascript" async
        src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.7/latest.js?config=TeX-MML-AM_CHTML">
    </script>
    ```
    {: .nolineno file="_includes/mathjax_support.html" }

    * `head.html`{: .filepath} 수정하기

    `_include`{: .filepath} 폴더의 `head.html`{: .filepath}의 `<head></head>`사이에 아래 내용을 추가한다. 
    
    ```html
    <!-- MathJax -->
    {% if page.use_math %}
        {% include mathjax_support.html %}
    {% endif %}
    ```
    {: .nolineno file="_includes/head.html" }

    > 한가지 주의할 점이 이 블로그는 Jekyll Blog에 Chirpy Theme를 적용해서 `_include/head.html`{: .filepath}를 수정했는데, 다른 문서에는 `_layout/default.html`{: .filepath}를 같은 방법으로 수정하라고 나온다. 따라서, 자신의 Jekyll Blog의 커스터마이징 방법을 잘 알고 하자.
    {: .prompt-note }

* Markdown 으로 수식 표현 하기

**YAML front-matter** 부분에 `use_math: true`를 삽입하여, 수식을 표현할 포스트임을 알립니다.

이제부터 LaTeX과 같은 표현으로 수식을 블로그에 표현할 수 있습니다.
수식을 표현하는 방법은 관련 블로그등을 찾아서 해봅시다.
아래는 제가 테스트해 본 것입니다.

인라인 수식은 `$ x + y = 1 $`라고 쓰면, $ x+y=1 $ 이렇게 됩니다.

물론 `\\( x + y = 1 \\)`  이렇게 써도, \\( x + y = 1 \\) 똑같이 표현 됩니다. 

하지만, `$ ... $`를 쓰는 것은 과거에는 허용되었지만 mathjax.org에서 더 이상 추천하지 않는 방법입니다. 왜냐하면 달러를 표현할 때 문장안에서 자주 쓰일 수 있기 때문입니다.

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


이렇게 표현됩니다.

> LaTeX 문법과 정확히 일치하지 않는 경우도 있다고 합니다. 따라서, 잘 비교해보며 사용합시다.
{: .prompt-note }

### 2. 참고 사이트

* [MathJax] : Jekyll에서 MathJax를 쓰기위해 configuration 설정을 위해 참고.
* Jekll github blog에 수식을 표현하기 위해 [Jekyll Github 블로그에 MathJax로 수학식 표시하기](https://mkkim85.github.io/blog-apply-mathjax-to-jekyll-and-github-pages/) 사이트를 참고했는데, 조금 오래된 내용이라, [MathJax]를 참고하여 일부 수정했다. 하지만 최초 설정하는 힌트를 얻기에는 충분하다.
* [Markdown 수식 표현 방법] : 여기서 markdown으로 수식 표현하는 것을 배워보자. 이 사이트 말고도 유사한 블로그는 많다.

[MathJax]:http://docs.mathjax.org/en/v2.7-latest/index.html
[Markdown 수식 표현 방법]:https://velog.io/@d2h10s/LaTex-Markdown-%EC%88%98%EC%8B%9D-%EC%9E%91%EC%84%B1%EB%B2%95