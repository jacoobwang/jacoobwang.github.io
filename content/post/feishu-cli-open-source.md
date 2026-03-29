---
title: "飞书 Cli 开源了"
date: 2026-03-29T09:59:45+08:00
draft: false
description: ""
slug: "feishu-cli"
---

> “飞书 CLI 现已面向所有用户开源。（真开源，不是要登记还要审核那种）
无论你想让 Claude Code、Codex 还是其他 Agent 直接操作飞书，或是希望围绕飞书构建新一代自动化工作流，欢迎使用”

中午正在开着车，等红灯的时候瞄了眼手机，就看到了上面的消息。第一反应是 “wow 一定要试试”，因为我现在也是高度的 Lark 使用用户！

跑去仓库看了一眼，果然是新鲜出炉的，代码是2小时前提交的。

![](https://fastly.jsdelivr.net/gh/bucketio/img11@main/2026/03/28/1774701406442-cd8af578-142e-49c0-b95a-f47471387257.png)

字节真棒啊，周六还在干活 --- 现在大厂都足够拼搏的！

### 一句话安装
安装特别简单，直接对着我的 Codex 口喷：
```
帮我装一下所有的东西：https://github.com/larksuite/cli/blob/main/README.zh.md
```

上面这个 Prompt 也是卡兹哥的文章上看到的，它是在 Claude Code 上跑的，我在 Codex 上跑了一遍也顺利的完成了安装。

而且建议使用上面的 Prompt 安装，不要直接说安装 飞书 Cli，这样有可能不安装 Skills。

![](https://fastly.jsdelivr.net/gh/bucketio/img2@main/2026/03/28/1774702076744-7df7830d-cda1-4475-b4e6-2aeaae2dd0b3.png)

### 网页授权
飞书的 Cli 需要去读取个人用户数据，所以安装完的第一个步骤就是授权登录。

让 Codex 继续完成登录即可。然后就会给你一个二维码链接，复制到浏览器里面自己手动配置一下。

![](https://fastly.jsdelivr.net/gh/bucketio/img6@main/2026/03/28/1774702697199-578c4114-ff77-4136-a5bf-743bfd879052.png)

点击授权即可完成授权登录。

### 功能

![](https://fastly.jsdelivr.net/gh/bucketio/img12@main/2026/03/28/1774703584649-2f7efa29-f67c-4b26-a1cb-50aab59f29c3.png)

基本上涵盖了我们日常使用的功能，对于我来说最重要的是多维表格和文档功能，以后的技术架构、需求评审等文档可以直接用 AI 生成然后帮我上传到 Lark 上。

### 安全与风险
过于由于数据不互通，Agent 能力不能好好释放，现在有了 Cli，Agent 能够拿到这些数据，但也伴随着风险。

开放是一把双刃剑，AI 的 prompt 注入导致的数据泄漏案例不是1个2个了，因此建议还是开最小的权限（特别是数据敏感型公司）。

另外模型也有幻觉，现在 Agent 可以操作飞书聊天，但如果模型出 bug 了，在群里发疯会带来负面影响。因此当下建议飞书机器人作为私人对话助手使用。

### MCP已死？CLI永生
Cli 会代替 Mcp 吗？

目前我感觉是有这个趋势的，当然建立在安全的沙箱环境的前提下。过去 Mcp 用来把内部服务包装成 Mcp 协议给 AI 使用，但现在越来越多产品开始直接封装 Cli 给 AI 使用。主要基于以下两点：

1、MCP 会把所有 tool schema 一次性注入上下文窗口，吃掉大量 token！即使 Claude 后面给出了工程上的优化方案 - search tools，但是不是所有的 Agent 都是 Claude Code。

2、Cli 是 LLM 天生习得，LLM 训练数据中有大量 CLI 工具的使用案例，git、docker 这些命令对模型来说是"预编译的 schema"，不需要运行时注入任何定义。

CLI 对 Agent 是直觉，MCP 对 Agent 是说明书。说明书写得再好，也比不上已经内化的直觉来得快。
