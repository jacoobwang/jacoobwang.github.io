---
title: "我开源了一个内容创作助手 Skill - Wechat Super  Powe"
date: 2026-04-07T22:21:46+08:00
draft: false
description: ""
slug: "wechat-super-power"
---

昨天我写了一篇我深入研究了 `Wechat Skills` 并自己开发了一套 `WeChat Skill` ，今天继续把这个 `Skill` 完善了下，使得它变成一个**内容创作助手**。

![](https://fastly.jsdelivr.net/gh/bucketio/img19@main/2026/04/06/1775453918360-9c7e1a0e-f831-4a04-840c-659364e489c5.png)


### 功能介绍
##### 知识库
输入微信文章链接，下载内容并生成 `Markdown` 到知识库。
![](https://fastly.jsdelivr.net/gh/bucketio/img8@main/2026/04/06/1775454061899-5a4e171c-c1c3-4fb0-b3b7-aee59460449c.png)

目前是保存到本地目录，如果你想上传到飞书文档，只需要安装飞书相关的 `Skills` 就可以直接上传。

![](https://fastly.jsdelivr.net/gh/bucketio/img18@main/2026/04/06/1775454201052-1bf5d53d-72b0-4234-bfdc-0a9bb440c665.png)

知识库没有使用 `RAG` ，使用的是 `Markdown` 文档方便阅读，后续也可以考虑 `chunk embeding` 下！

![](https://fastly.jsdelivr.net/gh/bucketio/img3@main/2026/04/06/1775454355974-e20a79c3-0bd8-42a5-9c53-66dd0ffb0108.png)


##### 基于知识库写文章
基于现有知识库使用 `wechat-super-power skill` 帮我写一篇 `Claude Code` 架构的文章。

它会经历3个步骤：
- **爆点分析**，提取核心冲突点
- **框架选择**，内置了多种文章框架
- **写作**，内置写作的 `prompt`

![](https://fastly.jsdelivr.net/gh/bucketio/img3@main/2026/04/06/1775454677696-05acc5ed-7062-4aa8-b080-4ffdc85e6449.png)


#### 全流程自动化创作
当然，你也可以全流程自动化，就输入以下提示词：
> 使用 wechat-super-power skill 帮我写一篇 RAG 的文章

它会自动获取 RAG 的文章整理成知识库。

![](https://fastly.jsdelivr.net/gh/bucketio/img19@main/2026/04/06/1775455411948-6b49341b-e0bf-400b-8600-c7b24e996450.png)


最后在本地目录下就能看到成稿。

![](https://fastly.jsdelivr.net/gh/bucketio/img15@main/2026/04/06/1775455630527-b1e9e137-330f-4a62-8b1b-bc28d0b84403.png)

#### 查重复
检测下 AI 浓度，把上面生成的文章拿去跑了下，居然全部为“人能文本”。
![](https://fastly.jsdelivr.net/gh/bucketio/img13@main/2026/04/06/1775455782468-f6801f07-e601-42dc-9183-12fe5d21c3ce.png)


### 安装到小龙虾

帮我安装这个 skills ->
https://clawhub.ai/jacoobwang/wechat-super-power

### 最后
项目目前开源，大家有兴趣的自己玩下。
> https://github.com/jacoobwang/wechat-super-power
