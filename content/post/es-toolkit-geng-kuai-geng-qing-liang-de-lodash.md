---
title: "es-toolkit 更快更轻量的 lodash"
date: 2024-11-14T00:00:00+08:00
draft: false
description: "es-toolkit 与 lodash 的性能对比及使用示例"
---

lodash 作为前端的基础工具库，已经被大量广泛使用，lodash 提供了非常多的工具函数，涵盖数组、字符串、对象等多种数据结构类型，而且 lodash 有个最大的优点是兼容性好，能处理各种边界情况，不担心各种 undefined null 或者类型不对导致的报错，所以广受欢迎。而最近出来了一个 es-toolkit，是一个基于 es6 新特性的工具函数库，它使用了大量新的 es 新特性，相比 lodash 速度提高 2-3 倍，体积缩小 97%。

## 以下是 es-toolkit 和 lodash 之间的主要比较

1. es-toolkit 提供了与 lodash 类似的关键工具函数，涵盖函数、数组、对象、字符串、数学和 Promise 等领域。
2. es-toolkit 的函数通常比 lodash 的函数更快，因为它们在实现中使用了现代 JavaScript API，并且使用 TypeScript 进行类型检查，减少了对额外防御性代码的需求。
3. 性能基准测试表明，es-toolkit 函数的性能优于 lodash 的等效函数，有时优势明显。
4. es-toolkit 的函数与 lodash 的等效函数相比，包大小显著更小，从而导致更快的加载时间和更好的性能。
5. es-toolkit 通过利用现代 JavaScript 特性并避免 lodash 中存在的相互依赖关系来解决性能和包大小挑战。
6. es-toolkit 的函数大多是独立的，防止意外包含不必要的代码，而在 lodash 中工具函数通常是相互依赖的。

## es-toolkit 的主要特性

1. 函数，包括用于缓存函数结果的memoize和用于限制函数调用频率的debounce。
2. 数组相关函数，如用于过滤重复项的uniq和用于找出数组之间差异的difference。
3. 用于处理 JavaScript 对象的工具，如用于深度克隆的cloneDeep和用于将嵌套对象转换为扁平结构的flattenObject。
4. 字符串操作工具，包括用于将字符串转换为短横线命名法（kebab-case）的kebabCase。
5. 数学助手，如用于生成随机数的random和用于四舍五入的round。
6. 类型保护函数，如用于轻松检查null或undefined值的isNil。
7. 用于处理异步代码的工具，如用于暂停执行一段时间的delay。

## 性能

es-toolkit 的函数通常比 lodash 的函数更快，因为它们在实现中使用了现代 JavaScript API。例如，es-toolkit 的omit函数比 lodash 的 omit 函数快约 11.8 倍。

以下是一个比较 es-toolkit 和 lodash-es 各种函数性能的表格：

![性能对比](https://jacoobwang.github.io/post-images/1731552806381.png)

## 包大小

在包大小方面，es-toolkit 表现出色。较小的包大小意味着你的 Web 应用程序将加载得更快，性能更好，特别是在较慢的网络上。

以下是 es-toolkit 和 lodash-es 中一些常见函数的包大小比较：

![包大小对比](https://jacoobwang.github.io/post-images/1731552949232.png)

es-toolkit 的函数与它们的 Lodash 对应函数相比要小得多。例如，es-toolkit 中的sample函数只有 88 字节，而 Lodash 中的相同函数是 2,000 字节 —— 几乎小了 96%！

## 防抖示例

假设你正在为一个网站构建搜索功能，用户可以在其中查找不同主题的信息。

你希望在用户输入时获取数据，但又不想为每个按键都发送请求；否则，你可能会用太多调用淹没 API。这就是 es-toolkit 的防抖函数派上用场的地方。

它的工作原理如下：

```javascript
import { debounce } from "es-toolkit";

// 一个模拟API调用的函数
function fetchData(query) {
  console.log(`Fetching data for: ${query}`);
}

// 使用es-toolkit的防抖函数
const debouncedFetchData = debounce(fetchData, 1000);

document.getElementById("search-input").addEventListener("input", (event) => {
    const query = event.target.value;
    debouncedFetchData(query);
});
```

在这个例子中，尽管我输入了五个字母，但fetchData函数只在我停止输入一秒钟后才被调用。通过这种方式，我们可以使用防抖函数避免在每次按键时进行不必要的 API 请求。

## 节流示例

假设你的网页上有一个按钮，点击时会加载更多帖子。为了防止按钮被快速点击时进行多次 API 调用，你可以使用 es-toolkit 的节流函数。它确保即使按钮被多次点击，API 调用也只会在设定的时间间隔内发生。

你可以这样使用它：

```javascript
// 节流示例
import { throttle } from "es-toolkit";

// 从API获取帖子的函数
async function fetchPosts() {
  console.log("Fetching new posts...");
  const response = await fetch("https://jsonplaceholder.typicode.com/posts");
  const posts = await response.json();
  console.log("Posts fetched:", posts);
}
// 创建fetchPosts的节流版本
const throttledFetchPosts = throttle(fetchPosts, 2000);

// 在按钮上设置事件监听器
document.getElementById("fetch-more-posts").addEventListener("click", () => {
  console.log("button clicked");
  throttledFetchPosts();
});
```

在这个例子中，即使用户快速点击 "获取更多帖子" 按钮，fetchPosts函数也只会每两秒触发一次。

## es-toolkit 如何解决性能和包大小挑战

你可能好奇 es-toolkit 是如何应对这些挑战的。在底层，es-toolkit 利用现代 JavaScript API 来提供更快的性能和显著更小的包大小。

除此之外，es-toolkit 使用 TypeScript，这有助于减少大量通常在运行时检查参数类型的额外防御性代码。这不仅使代码运行更高效，还最大限度地减少了任何可能减慢速度的不必要开销。

另一个关键区别是 lodash 的工具函数通常是相互依赖的，这意味着导入一个函数可能会连带引入许多其他函数。相比之下，es-toolkit 的函数大多是独立的，这有助于保持你的包轻量级。

## 结论

目前 es-toolkit 刚出来，其生态和覆盖的场景不如 lodash。es-toolkit 可以在某些情况下替代 lodash，尤其是当你只需要一些基本的工具函数时。然而，如果你需要 lodash 提供的全面功能，lodash 仍然是更好的选择。
