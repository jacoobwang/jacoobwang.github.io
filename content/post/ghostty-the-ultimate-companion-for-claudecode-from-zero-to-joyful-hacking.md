---
title: "Ghostty：Claude Code的最佳搭档，从零到快乐鬼混"
date: 2026-03-16T00:00:00+08:00
draft: false
description: "最近发现了一款很好用的 Terminal，非常适合 AI Coding 工具，之前我一直用 iTerm 配合 zsh 来操作命令行，但它在 node 服务开的多的情况下会变卡"
---

最近发现了一款很好用的 Terminal，非常适合 AI Coding 工具，之前我一直用 iTerm 配合 zsh 来操作命令行，但它在 node 服务开的多的情况下会变卡。

以下内容原文出处来源于 X 上的 **@BruceBlue**，写的非常细致， respect。

你是不是也遇到过这些崩溃时刻：
```
终端卡得像老牛拉车？
Claude写代码时输出一堆文字看不清？
想左右分屏（左边让Claude写代码、右边debug）
却不知道怎么加屏幕？
配置一改就弹窗报错？
```

慌！ Ghostty就是为你准备的！ 它像一个调皮的小鬼，跑得飞快、长得漂亮，还天生和Claude是好搭档。

这篇全新入门文章，我把所有坑都踩过一遍，用最简单的话 + 手把手截图 + 基础命令教你。 

读完5分钟，你就能：
```
打开Ghostty就自动进Claude
Cmd + D 一键左右添加屏幕
Cmd + Shift + Enter 一键放大Claude输出
配上彩虹状态栏 + 快乐现场
准备好了吗？我们一起“鬼混”开发吧！🚀
```

![](https://fastly.jsdelivr.net/gh/bucketio/img18@main/2026/03/16/1773669722258-0fe93cfb-2ca9-45cd-96cc-0de41e261616.png)


> Ghostty官网：https://ghostty.org/

Ghostty由HashiCorp联合创始人 @mitchellh  从2021年开始当“副业”鼓捣，用Zig语言写的核心。2024年底正式开源。

**它的三大好处**（小白最爱）：

- **超级快**：GPU加速（macOS用Metal），Claude输出再长也不卡，滚动丝滑像丝绸。
- **超级漂亮**：原生macOS界面，支持透明毛玻璃、Catppuccin紫色主题、完美连字字体，看代码眼睛不累。
- **超级好用**：支持Kitty图形协议（Claude让你画图？图片直接在终端显示！）、Quick Terminal下拉幽灵、一键分屏、永久保存布局。
  
一句话总结：Ghostty不逼你“要么快要么丑”，它全都要！ 免费开源，还在狂迭代。

### 第一步：安装Ghostty（超级简单，3分钟）
在你的Mac终端（或者已经打开的Ghostty）里敲下面这行，回车：
```
brew install --cask ghostty
```

安装完直接在Spotlight搜索 **Ghostty** 打开它。 第一次打开可能会出现两个窗口（一个是下拉的幽灵终端），别担心，我们马上解决！


**基础命令**： 想随时打开Ghostty？按 **Command + 空格**，输入 “Ghostty” 回车就行。

### 第二步：我的极致稳定配置（已上传GitHub，最推荐方式）
我为你打磨的最终稳定版配置已经上传到GitHub了（随时可以更新）：

**推荐方式（最简单）：**
- 打开我的： https://github.com/BruceLanLan/bruceblue-ghostty-config
- 点击文件 config（蓝色链接）
- 点击右上角 Raw 按钮（显示纯文本）
- 全选复制全部内容
- 在你的Mac上敲命令打开配置文件：
``` 
  open ~/.config/ghostty/config
```
- 把刚才复制的内容全部粘贴进去（覆盖原内容）
- 保存 → 按 Cmd + Shift + , 重载配置

**或者直接下载**： 在仓库页面点击绿色 Code 按钮 → Download ZIP，解压后把里面的 config 文件复制到 ~/.config/ghostty/ 文件夹里即可。

**这个配置已经包含：**
1. Catppuccin Mocha紫色主题
2. Cmd + D 左右添加屏幕
3. Cmd + Shift + Enter 一键放大Claude输出
4. 零报错、布局永久保存

### 第三步：基础命令（记住这5个就够了）
- **Cmd + D → 左右** 添加屏幕（最常用！左边Claude写代码，右边debug）
- **Cmd + Shift + Enter** → 一键放大当前屏幕（看Claude长输出超爽，再按恢复）
- **Cmd + W** → 关闭当前屏幕
- **Cmd + Shift + ,** → 重载配置（改完主题或分屏后一定要按！）
- **Cmd + Q** → 完全退出Ghostty（重启推荐用这个）


![](https://fastly.jsdelivr.net/gh/bucketio/img4@main/2026/03/16/1773670090328-3e767267-ddd5-4059-b9e9-0fffc15270c0.png)


### 第四步：美化（主题 + Starship彩虹状态栏）
**换主题：** 在config里确认 theme = Catppuccin Mocha（紫色最舒服），重载即可。

**加彩虹状态栏**（显示git、时间、CPU）：
- 安装：Bash:
```
brew install starship
starship preset catppuccin-powerline -o ~/.config/starship.toml
```

- 然后在 ~/.zshrc 最下面加一行：
```
eval "$(starship init zsh)"
```

- 保存 → Cmd + Q 重启Ghostty:

![](https://fastly.jsdelivr.net/gh/bucketio/img12@main/2026/03/16/1773670202062-f34eadaf-99de-4fa5-8376-9cd26a200492.png)

### 第五步：快乐现场（左右分屏 + 监控）
**安装监控工具：**
```
brew install fastfetch btop
```

**布置：**
- 按 Cmd + D 添加右侧屏幕
- 左边敲 claude
- 右边敲 fastfetch（系统信息）
- 再按 Cmd + Shift + D 加下方屏幕，敲 btop（实时CPU监控）
- 用 Cmd + Shift + Enter 放大任意屏幕


![](https://fastly.jsdelivr.net/gh/bucketio/img7@main/2026/03/16/1773670277929-3f54e6dd-6a27-4748-8bc1-d503f6849599.png)

### 从今天起，你不再是终端小白，而是鬼混大师👻

现在，闭上眼睛，想象一下……

你轻轻按下 **Cmd + D**，屏幕右侧瞬间“啪”地多出一个新世界。 左边Claude正在为你飞速写代码，右边fastfetch彩虹般跳出来，btop实时监控着CPU温度。 再按 **Cmd + Shift + Enter**，Claude的长篇输出像魔法一样铺满整个屏幕，字体连字优雅闪烁，紫色毛玻璃背景温柔发光……

那一刻，你会突然笑出声：原来开发可以这么爽！

**Ghostty不是一个普通的终端，它是Claude最默契的灵魂伴侣。**

从第一次被配置报错搞得头大，到现在轻松左右分屏、一键放大Claude输出…… 你已经完成了华丽转身。

去吧，兄弟。

**现在就行动起来：**

1. 打开我的GitHub仓：https://github.com/BruceLanLan/bruceblue-ghostty-config
2. 复制 config 文件内容
3. 粘贴到你的 ~/.config/ghostty/config
4. 毫不犹豫地敲下 **Cmd + D**，创建你人生第一个左右分屏

让Claude负责思考， 让Ghostty负责鬼混， 而你，只需要负责收割快乐与效率。
从这一刻开始，你的Mac不再只有一个冷冰冰的终端， 而是多了一个聪明、快速、会分屏、还会陪你一起鬼混的AI搭档。

欢迎正式加入幽灵开发者大军！

你的开发体验，从今天起，正式起飞。👻✨

原文链接：
https://x.com/BruceBlue/status/2032703807189299694
