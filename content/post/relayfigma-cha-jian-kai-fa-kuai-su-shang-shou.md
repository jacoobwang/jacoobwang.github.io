---
title: "Relay/Figma 插件开发快速上手"
date: 2023-03-08T00:00:00+08:00
draft: false
description: "Figma/Relay 插件开发入门指南，包括沙箱环境、双向通信和调试技巧"
---

## 背景

最近在负责 D2C 生成组件代码的需求，首先我们在设计工具上实现了一个组件绑定功能。大概就是研发需要选择设计组件然后逐个绑定设计属性，生成代码就能包含组件代码，提高代码可用率。

由于手动绑定研发组件需要一个个点击表单，效率较低。大家的时间都很宝贵，因此批量操作通过自动化的方式就尤其有必要，插件是解决方案之一。

## 插件介绍

Figma 插件是扩展 Figma 设计工具功能的小程序。这些插件可以自动化设计流程，提供额外的设计资源，或者增强协作功能。设计师和开发者可以使用插件来提高工作效率，减少重复性工作。插件市场包含各种类型的插件，例如图标生成器、颜色工具、原型插件等。用户可以在 Figma 的插件商店中找到并安装这些插件，以满足特定的设计需求。

而 Relay 插件跟 Figma 插件一摸一样，所以开发 relay 插件直接先在 figma 环境开发即可。

## 搭建初始项目

> 具体可以参考这篇文章 https://www.figma.com/plugin-docs/plugin-quickstart-guide/

![初始化项目](https://jacoobwang.github.io/post-images/1741423655578.png)

初始化项目之后，我们就得到这样一个初始化工程：

![项目结构](https://jacoobwang.github.io/post-images/1741423683824.png)

## 插件运行环境

为了保持第三方代码的安全性，不会因为恶意代码影响 figma 平台运行，figma 提供了一套沙箱环境来执行 js 代码，并在沙箱环境中提供相应的 API 操作图层数据，从而达到插件与 figma 的交互。

在figma的沙箱环境是可以执行所有的 es6 语法，但不提供浏览器 DOM API。如果需要使用浏览器 API 或自定义 UI 则需要使用 `figma.showUI()` 方法实现，`figma.showUI` 的实质则是创建一个 iframe 来运行你的 UI 代码。

在沙箱与iframe之间则通过 `postMessage` 进行通信，这套架构在vscode的插件实现上也是类似方案。

![架构图](https://jacoobwang.github.io/post-images/1741423726085.png)

## 逻辑与 UI 分离

首先，项目拆分成两个目录：

- **native** 用来存放逻辑相关的代码。执行在 sandbox 里的 js 代码，也是调用 figma API 的逻辑，如获取节点、创建节点、修改节点等；
- **web** 用来存放前端 UI 代码，用来渲染插件的界面。

![目录结构](https://jacoobwang.github.io/post-images/1741423762414.png)

## 双向通信

在 Figma 插件的上下文中：

1. iframe 内部的 JavaScript 可以通过 `parent.postMessage()` 向插件的主脚本发送消息。
2. 而 `figma.ui.postMessage()` 是在插件的主脚本中使用的,用于向 iframe 发送消息。

所以,通信流程是这样的:

- iframe -> 主脚本: `parent.postMessage()`
- 主脚本 -> iframe: `figma.ui.postMessage()`

![通信流程](https://jacoobwang.github.io/post-images/1741423813216.png)

下面展示了主脚本发送消息和接收消息的核心代码：

```typescript
import * as EventEmitter from 'events'
export const Event = new EventEmitter()
interface MessageEvent{
    callback: string;
}

interface RPCEventData{
    code:number; // 0:失败 1：成功
    msg?:string;
    data?:any;
}

figma.ui.onmessage = msg => {
    Event.emit(msg.type, msg.body)
}

/**
 * 往 ui 层发送信息
 * @param command 事件
 * @param body 返回内容
 * @param customize 是否自定义
 */
export function post(command:string | MessageEvent, body:any | RPCEventData) {
    let type = command
    if ( typeof(command) === 'object' ) {
        type = command.callback
    }

    let code = 0
    let data = body
    if (body instanceof Error) {
        code = 1
        data = body.message + body.stack
    }

    figma.ui.postMessage({ type, data: { code, data } })
}
```

## 调试

有以下两种调试方式：

1. 在开发过程中，可以使用 Figma 的开发模式来测试和调试插件。在 Figma 中，选择 "开发" -> "开发插件"，然后选择插件项目的根目录。这样，每次修改代码后，只需在 Figma 中重新运行插件即可查看最新的效果。

2. 也可以选择在浏览器调试，把插件代码打包成1个 js 文件，然后在平台随机抓一个插件的 js 请求，把这个 js 请求代理到本地就可以开始调试了。这里推荐使用 chrome dev tools 自带的 overrides 功能，非常方便，不需要任何代理软件或插件。

![调试](https://jacoobwang.github.io/post-images/1741423859850.png)

## 发布

当插件开发完成并经过充分测试后，可以将其发布到 Figma 插件商店，供其他用户使用。在 Figma 中，选择 "开发" -> "提交插件"，按照提示填写插件的相关信息，如名称、描述、截图等，然后提交审核。审核通过后，插件就会在 Figma 插件商店中上线。

## 问题

figma 运行正常，relay 报错："TypeError: Cannot read properties of undefined (reading 'Array') at runInContext"

![报错](https://jacoobwang.github.io/post-images/1741423900736.png)

经过 debug 定位发现是 lodash 里获取 context 未获取到后报错，context 获取是通过 root 来，root 定义如下：

```typescript
var freeGlobal = typeof global == 'object' && global && global.Object === Object && global;

/** Detect free variable `self`. */
var freeSelf = typeof self == 'object' && self && self.Object === Object && self;

/** Used as a reference to the global object. */
var root = freeGlobal || freeSelf || Function('return this')();
```

可以看到 root 其实是获取的全局对象（global object），即在浏览器中的window对象，或在Node.js中的global对象。

报错原因就是沙箱环境限制了全局对象的获取，导致异常。

**解决办法**：1. 沙箱环境里支持获取全局对象或者传入空对象作为全局对象； 2. 放弃使用 lodash 。

## 沙箱环境 Realms

figma 沙箱采用 Realms shim 的技术，该技术将创建沙箱和支持插件作为潜在用例，Realms API 大致如下：

```typescript
let g = window; // outer global
let r = new Realm(); // realm object

let f = r.evaluate("(function() { return 17 })");

f() === 17 // true

Reflect.getPrototypeOf(f) === g.Function.prototype // false
Reflect.getPrototypeOf(f) === r.global.Function.prototype // true
```

实际上，可以使用已有的 JavaScript 功能来实现该技术，沙箱可以隐藏全局变量，shim 起作用的核心大致如下：

```typescript
function simplifiedEval(scopeProxy, userCode) {
  'use strict'
  with (scopeProxy) {
    eval(userCode)
  }
}
```

`with(obj)` 创建了一个新的作用域，在该作用域内可以使用 obj 的属性来解析变量。
