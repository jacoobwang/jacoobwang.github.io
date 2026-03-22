---
title: "useLayoutEffect与useEffect：React Hooks 理解"
date: 2019-11-07T00:00:00+08:00
draft: false
description: "深入理解 React 中 useEffect 和 useLayoutEffect 的区别与使用场景"
---

React Hooks 改变了我们在函数组件中管理状态和副作用的方式，为处理组件逻辑提供了更直观、灵活的途径。在众多可用的 Hooks 中，useEffect和useLayoutEffect在管理副作用（特别是涉及 DOM 更新或异步任务的副作用）方面起着关键作用。

选择正确的 Hook 对于保持最佳性能和流畅的用户体验至关重要。useEffect和useLayoutEffect都可用于类似任务，但基于执行时机和行为，它们各有特定优势。理解这些差异有助于避免不必要的重新渲染，并确保最佳的用户体验。

## 理解useEffect

### 用途

useEffect是 React 函数组件中处理副作用的首选 Hook，它取代了类组件中的生命周期方法，如componentDidMount、componentDidUpdate和componentWillUnmount，将它们整合为一个高效的 Hook。

### 工作原理

与类组件中同步运行的生命周期方法不同，useEffect在组件渲染之后执行。这种延迟执行允许浏览器在运行任何副作用之前更新屏幕，使useEffect不会阻塞渲染。因此，它非常适合那些不需要立即进行 DOM 更新的操作，如数据获取或事件监听器。

### 常见用例

useEffect用途广泛，常用于涉及非阻塞副作用的任务，以下是一些useEffect的理想场景：

**1. 数据获取**：使用useEffect从 API 获取数据并更新组件状态，且不影响初始渲染。

```js
useEffect(() => {
  async function fetchData() {
    const response = await fetch('https://api.example.com/data');
    const data = await response.json();
    setData(data);
  }
  fetchData();
}, []);
```

**2. 设置事件监听器**：使用useEffect在组件挂载时设置事件监听器，并在卸载时清理

```js
useEffect(() => {
  const handleResize = () => setWindowSize(window.innerWidth);
  window.addEventListener('resize', handleResize);

  return () => window.removeEventListener('resize', handleResize);
}, []);
```

**3. 管理异步任务**：使用useEffect处理定时器或与本地存储交互，确保这些任务在组件挂载后运行

```js
useEffect(() => {
  const timer = setTimeout(() => {
    setIsVisible(true);
  }, 1000);

  return () => clearTimeout(timer);
}, []);
```

由于useEffect的非阻塞特性，它通常是默认选择，是处理大多数副作用且不干扰初始渲染的高效方式。

## useLayoutEffect与useEffect的区别

### 用途

useLayoutEffect与useEffect的主要区别在于时机和执行方式。useEffect在组件渲染之后运行，而useLayoutEffect专门设计用于在渲染后但浏览器绘制之前需要立即进行 DOM 操作的情况。这个时机对于诸如测量或调整 DOM 元素之类的任务至关重要，因为即使稍有延迟也可能导致可见的布局偏移或闪烁，从而破坏用户体验。

### 同步执行

与异步的useEffect不同，useLayoutEffect同步执行。它会等待其中所有 DOM 更新完成，阻塞绘制过程，直到所有更新都应用完毕。这种同步行为使useLayoutEffect非常适合需要精确控制 DOM 布局和外观的任务，有助于避免任何视觉不一致或闪烁。在需要进行 DOM 测量以确保布局稳定的情况下，useLayoutEffect与useEffect的这种区别就显得尤为重要。

### 示例：使用useLayoutEffect进行 DOM 测量

在下面的示例中，useLayoutEffect用于在元素渲染后立即测量其宽度。此测量允许在浏览器绘制之前进行布局调整，防止任何可见的偏移。

```js
import React, { useLayoutEffect, useRef, useState } from 'react';

function Box() {
  const boxRef = useRef(null);
  const [width, setWidth] = useState(0);

  useLayoutEffect(() => {
    setWidth(boxRef.current.offsetWidth);
  }, []);

  return (
    <div
      ref={boxRef}
      style={{ width: `${width}px`, height: '100px', background: 'lightblue' }}
    >
      Measured Width: {width}px
    </div>
  );
}
```

在此代码中，useLayoutEffect确保在用户在屏幕上看到框之前准确更新宽度，防止因延迟测量而可能导致的闪烁，展示了useLayoutEffect在保持稳定布局方面相较于useEffect的关键优势。

## 为性能和用户体验选择正确的 Hook

### 性能影响

useEffect通常对于非视觉效果更具性能优势，因为它在渲染之后运行，使渲染过程保持非阻塞。它最适合于数据获取或事件监听器等不需要 DOM 测量的操作。

相比之下，如果过度使用useLayoutEffect，由于它会阻塞绘制直到其任务完成，可能会减慢渲染速度。仅在必要时使用它，以避免性能瓶颈。

### 避免视觉卡顿

当 DOM 更新在屏幕上产生明显偏移时，就会出现视觉卡顿。使用useLayoutEffect通过在浏览器绘制之前同步应用布局更新来防止这种情况。例如，如果根据内容调整元素的高度，useLayoutEffect可确保此更改无缝进行:

```js
useLayoutEffect(() => {
  const height = calculateHeight();
  setHeight(height);
}, [dependencies]);
```

- **useEffect**：最适合非阻塞、异步任务。
- **useLayoutEffect**：用于同步 DOM 调整以防止闪烁。

### 对比

![对比图](https://jacoobwang.github.io/post-images/1730957976862.png)

## 最佳实践

在useLayoutEffect与useEffect之间进行决策时，遵循以下最佳实践可帮助你充分利用每个 Hook 并保持应用程序的高性能。

- **默认使用useEffect**：在大多数情况下，useEffect应该是你在 React 中处理副作用的默认选择。它针对不影响 DOM 可见状态的任务进行了优化，如数据获取、设置事件监听器和管理订阅。因为useEffect在渲染后异步运行，所以它允许非阻塞更新，从而确保更流畅的性能并防止渲染中不必要的延迟。

- **将useLayoutEffect用于关键 DOM 更新**：仅在需要精确控制 DOM 时使用useLayoutEffect，例如进行布局测量或影响元素可见状态的调整。在需要在渲染后立即测量或修改 DOM 属性的场景中（例如确定元素大小或同步动画），在useLayoutEffect与useEffect的决策中，useLayoutEffect是更好的选择。这有助于防止可能破坏用户体验的布局偏移或闪烁。

- **避免过度使用useLayoutEffect**：虽然useLayoutEffect功能强大，但如果过度使用，其同步性质可能会导致渲染延迟。因为它会阻塞绘制过程直到其任务完成，过度使用useLayoutEffect会减慢应用程序的性能，特别是在性能较低的设备上。为了优化性能，将useLayoutEffect限制在绝对需要立即更新以保持视觉稳定的情况下，并在大多数其他任务中依赖useEffect。

在比较useLayoutEffect与useEffect时，请记住useEffect非常适合异步、非阻塞任务，而useLayoutEffect应保留用于需要立即进行 DOM 更新以防止任何视觉不一致的情况。
