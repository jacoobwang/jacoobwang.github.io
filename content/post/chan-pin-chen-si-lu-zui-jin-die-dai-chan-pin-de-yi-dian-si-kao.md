---
title: "产品沉思录：最近迭代产品的一点思考"
date: 2026-06-22T00:00:00+08:00
draft: false
description: "从 Builder 视角复盘 Workus 最近产品迭代中的架构、界面细节和体验取舍"
---

回顾过去我做过的事情，在职业生涯早期做了2年多的业务开发，就是压根不带脑子按照需求完成就可以，有严格的需求评审流程，有导师帮忙评估实现难点，有测试帮你做上线前的质量把关，我只需要想清楚业务逻辑，活做完一个接一个，做了2年左右就有点乏味了。

后面加入了一个比较大的前端团队（非常不错的团队），开始有机会在内部孵化产品，开始从 0 到 1 做一个产品，这里也是有产品、设计师，但话语权慢慢变多了，不再仅仅是评估能不能做，开始尝试挑战产品合理性，那会儿还搞过封闭开发，是一段值得怀念的岁月。

而今天我在一家 Startup，我不定义我是一个前端工程师或后端工程师，那我是什么呢？我是一个 Builder 。我拥有了更大的 Scope，我可以引进我想要的技术方案，我可以决定界面上的每一个字号需要设置多大，或者是每一个间距的 px 需要设置多少，我可以完成我想要的产品的交互实现，我影响着产品的方方面面。这正是 Startup 魅力所在，现如今的大厂很少能有这种氛围。

### 作为产品 Builder，好的架构是成功的开始

![](https://fastly.jsdelivr.net/gh/bucketio/img6@main/2026/06/18/1781777231619-16be0b70-a977-4d0e-a76d-499f2d44c609.png)

前台“对话智能”由 Workus-agent Rust agentd 承担，Workus-ai 做 WebSocket 网关和 UI 状态管理。

后台 “任务执行 Runtime” 由 Workus-ai 的 Campaign orchestration 承担，按 sales/sourcing 分别落到 Temporal 或事件驱动 Job 编排。

#### Workus 的对话 Agent 运行时
它负责 Agent Session、推理循环、工具调用、确认流程和事件流输出。

- **Session Runtime**：维护每个用户对话的 Agent Session，支持继续对话、历史恢复、compact、rollback、cancel 等操作。

- **Reasoning Loop**：接收 start_task / user_input，驱动模型理解需求、规划步骤、选择工具。

- **Tool Execution**：调用 sourcing、sales、review、create task card 等工具能力。

- **Human-in-the-loop**：支持确认点、结构化补充信息、用户审批或修改。

- **Event Streaming**：把 assistant message、tool call、tool result、UI card、状态变化等作为事件流输出给 workus-ai。

- **Runtime Isolation**：通过独立 Rust 服务承载对话运行时，和 workus-ai 的业务 API / 后台编排解耦。

### 作为产品 Builder，狠抓细节才能赢得用户体验
过去一段时间大家都被 Claude code 冲击，一度很多人喊出了不再需要 GUI 的论述。但我始终觉得 GUI 在当下以及未来仍然必不可少，好的界面好的交互是超越同行的关键。

#### 我可以接受产品失败，但不能接受被骂难用

在 UI 设计师离开之后，我做了一些 UI 细节上的变化，为了让界面看起来更精致。

#### 1、字号变小，间距变小，内容轻量化

![](https://fastly.jsdelivr.net/gh/bucketio/img5@main/2026/06/18/1781779445775-9935e926-0213-4a1f-a723-eedeb196de78.png)

左边是之前的版本，右边是新的版本。

旧版本信息过多，容易造成注意力分散，新的版本砍掉了 professional 的展现，settings 也隐藏了起来。另外导航的字号和间距大小都了细微调整。甚至对于导航的顺序也参考 AI 的建议做了微调。

![](https://fastly.jsdelivr.net/gh/bucketio/img2@main/2026/06/18/1781779683047-ad14d2f6-bcb5-4e19-852a-a0f764a0a9ff.png)

整体对比一下差别就很大了，右边明显更加专业，容易受信任。

#### 2、内容聚合，减少注意力干扰
这一点对我来说应该算是刻在骨子里的，人的注意力是有限的，当打开一个页面，如果需要我去找功能，那这个设计就是失败的。

![](https://fastly.jsdelivr.net/gh/bucketio/img6@main/2026/06/18/1781780245086-a7d88a32-a5fd-4c94-8a81-b136fe77f711.png)

上面是旧版，下面是新版。在笔记本屏幕上这两个界面优化后的体验截然不同，这是一个收件箱界面，我们需要让用户关注到 message 窗口和左侧的收件列表。所以我采取了收起右侧 sidebar 的设计，另外拉通了顶部，旧版本这里只是一个 Inbox 标题占用了 70px 的高度过于浪费。

还有最重要的优化在于搜索区域的精简。左边旧版本拆成了多个 section，实际上都是用来做过滤的，通过线段分割，只是增加了理解难度，而新版本将这些收归到一个 search input 上，言简意赅。

![](https://fastly.jsdelivr.net/gh/bucketio/img2@main/2026/06/18/1781780474850-5c7deb0d-deac-4678-9778-7296f0586c1c.png)

#### 3、关注交互，更多的 tooltip
下拉选择更多 agent，不用平铺出来，过去很多产品采用平铺的方式，随着功能增多就变得越来越难看。
![](https://fastly.jsdelivr.net/gh/bucketio/img7@main/2026/06/18/1781780718459-a8313b66-e0bc-430c-a349-03d879166a20.png)

做到每一个 icon 都有 toolkit，每一个超出的信息都能有 tooltip，不要让用户去猜。
![](https://fastly.jsdelivr.net/gh/bucketio/img9@main/2026/06/18/1781780892380-4f655502-0c29-44f8-b224-2da210a2d8c2.png)

每一个可点击按钮，都需要有 hover 体验变化。

#### 收与放
就像快与慢，好的产品体验大都具有相似性，最难的设计往往是如何在想要展现更多信息的时候做好设计，收放自如是一种智慧。
