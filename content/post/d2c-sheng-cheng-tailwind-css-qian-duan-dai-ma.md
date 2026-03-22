---
title: "D2C - 生成 Tailwind Css 前端代码"
date: 2019-03-03T00:00:00+08:00
draft: false
description: "D2C 设计转代码方案，使用 Tailwind CSS 解决类名语义化问题"
---

## 背景

目前 Relay 生成代码功能研发过程中，我们发现 D2C 的难点之一：Class 类名不语义化的问题。D2C 算法生成的类名，如 view0、view1、view2、text0、text1 等缺乏有效含义，对研发不够友好。

## 方案

### 1、使用 LLM 大模型如 GPT4 进行语义优化

经过测试大模型可以优化代码，但存在几个问题：

- 大模型存在 token 限制问题，输入和输出都存在可能超出的情况，特别是输出限制了 8K 大小，很多稿子跑下来就超出了。
- 大模型耗时比较长，一个请求过去要好几秒，使用 SSE 体验会略好一点
- 大模型如果不结合图片做多模态预览效果也会略差一点，比如不同的稿子，在没有图片 input 时候，输出的 class 有一定概率重复，并可能跟设计稿件毫无关联：如 view 大概率会变成 product等。

### 2、生成 Tailwind css 风格的 class，不再需要自定义class

![Tailwind CSS](https://jacoobwang.github.io/post-images/1740971070038.png)

Tailwind CSS 是目前世界上最流行的原子化 CSS 框架。它集成了诸如 flex, pt-4, text-center 和 rotate-90 这样语义化的类名。我们开发者能直接在各种脚本标记语言中编写它们，并把它们组合起来，构建出任何的设计。自从 3.x 大版本开始，Tailwind CSS 把引擎升级为 Just in Time(jit)。这使得我们能够编写代码的同时，实时生成各种 CSS，真正的做到了所写即所得。

**Tailwind CSS 特点：**

- **高度可定制化**
- **响应式设计友好**
- **提高开发速度**
- **代码可读性和维护性**

在 HTML 代码中直接使用工具类来描述样式，使得样式和结构紧密结合，代码的可读性更高。例如，看到 `class="bg-gray-100 p-4 rounded-md"` 这样的代码，就能够很直观地理解这个元素有一个浅灰色的背景、一定的内边距并且是中等圆角。

除了以上优点外，使用 Tailwind CSS 在D2C中还能解决两个问题：

1. 不需要再进行 class 命名；
2. 节省了 css 代码，避免冗余 css。

另外 Tailwind CSS 正在被越来越多团队广泛使用，现在 AI 大模型提供的图片直出代码功能，也是输出 Tailwind CSS；海外知名 D2C 工具也是以 Tailwind CSS 为默认选项：

![D2C工具](https://jacoobwang.github.io/post-images/1740971104790.png)

## 实现 Taiwind CSS Converter

在 D2C 中我们首先获取到挂在 NODE 上的 style，它是原生的 CSS 如下：

```json
{
  "color": "rgb(0, 0, 0)",
  "fontFamily": "Source Han Sans CN",
  "fontWeight": 400,
  "fontSize": 16,
  "lineHeight": 1.5,
  "textAlign": "left",
  "flexShrink": 0
}
```

Tailwind CSS 为每一个 css 属性值预设了新的 class，比如 Display 如下：

![Tailwind Display](https://jacoobwang.github.io/post-images/1740971184254.png)

因此 Converter 核心逻辑就需要按照 Tailwind 文档把全部 CSS 转换一下：

```typescript
import isUnitlessNumber from './isUnitlessNumber'
import { StyleObj } from './types'

const cssToTailwindMap = {
  'display': value => value,
  'overflow': value => {
    const map = {
      'auto': 'overflow-auto',
      'hidden': 'overflow-hidden',
      'clip': 'overflow-clip',
      'visible': 'overflow-visible',
      'scroll': 'overflow-scroll',
      'overflow-x': 'overflow-x-auto',
      'overflow-y': 'overflow-y-auto',
      'overflow-x-hidden': 'overflow-x-hidden',
      'overflow-y-hidden': 'overflow-y-hidden',
      'overflow-x-clip': 'overflow-x-clip',
      'overflow-y-clip': 'overflow-y-clip',
      'overflow-x-visible': 'overflow-x-visible',
      'overflow-y-visible': 'overflow-y-visible',
      'overflow-x-scroll': 'overflow-x-scroll',
      'overflow-y-scroll': 'overflow-y-scroll'
    }
    return map[value]
  },
  'position': value => value,
  // tailwind 规则映射过来
  ...
}

export function convertCssToTailwind (style: StyleObj, styleUnit: string): string {
  const tailwindClasses: string[] = []

  for (const property in style) {
    const tailwindClass = cssToTailwindMap[property]
    if (tailwindClass) {
      const value = (!isUnitlessNumber(property) && typeof style[property] === 'number') ? `${style[property]}${styleUnit}` : style[property]
      tailwindClasses.push(tailwindClass(value))
    }
  }

  return tailwindClasses.join(' ')
}
```

## AST 遍历

生成完 Tailwind class 后，需要把 class 绑定到节点上，通过遍历 AST 节点，以 react 为例：

```typescript
JSXAttribute: astPath => {
    const { node } = astPath
    const attrName = node.name.name

    if (this.isTailWind && attrName === 'className' && t.isStringLiteral(node.value)) {
      const clsNameArr = node.value?.value.split(' ')
      let tailwindCls = ''

      // 转换成 tailwind class
      clsNameArr.forEach((cls, idx) => {
        const convertedCssToTailwind = convertCssToTailwind(this.styleObj[cls], this.styleUnit)
        tailwindCls += convertedCssToTailwind
      })

      // 更新到节点上
      node.value = t.stringLiteral(tailwindCls)
    }
},
```

JSXAttribute 定义了一个处理 JSX 属性的访问器函数，通过 jsx 的 class Name 获取每一个 class 的具体 style然后调用 converter 得到 tailwind CSS，最后通过 `t.stringLiteral` 绑定即完成转换。

效果如下：

![效果](https://jacoobwang.github.io/post-images/1740971270992.png)
