---
title: "简单聊一聊单例设计模式"
date: 2024-11-24T00:00:00+08:00
draft: false
description: "详解单例设计模式的实现方式及实际应用场景"
---

你是否曾经遇到过需要在应用程序的多个部分共享一个对象的情况，比如数据库连接、WebSocket 客户端或配置管理器或全局的 Logger 对象？

你如何管理这样一个对象，使其在整个应用程序或进程生命周期中保持一致且可访问？这就是单例设计模式发挥作用的地方。

## 概述

单例是一种创建型设计模式，属于设计模式的一类，用于解决使用new关键字或操作符创建对象的原生方式所带来的不同问题。

单例设计模式主要致力于解决两个主要问题：

1. 我们如何为实例提供一个全局访问点？
2. 我们如何确保一个类或特定类型的对象只有一个实例？

它可以简化并规范我们管理特定种类或类型的全局状态的方式，例如数据库连接、WebSocket 客户端、缓存服务，或者任何我们在整个应用程序生命周期中需要在内存中持久化和修改的内容。

## 如何实现单例设计模式

```typescript
class Singleton {
    private static instance: Singleton

    private construct() {
       // 私有构造函数确保只能通过静态方法创建唯一实例
    }

    public static getInstance () {
        if (!this.instance) {
            this.instance = new Singleton()
        }

        return this.instance
    }
}
```

该类应该定义一个静态属性来存储唯一可共享的实例。**static** 关键字意味着实例对象与类的实例无关，而是与类定义本身相关联。类的构造函数应该标记为private 则无法通过 new 创建实例。获取类实例的唯一方法是调用 getInstance 静态方法。

```typescript
const instance = Singleton.getInstance()
```

我们可以通过调用与单例类相关联的静态方法getInstance来使用上述类。getInstance 方法保证即使我们在代码库的不同位置多次实例化我们的类，我们始终得到相同的实例。

## 第一个实际场景

在 node 服务中，需要记录调用接口产生的 log，因此要设计一个全局的 Logger 集中管理日志行为。

```typescript
class Logger {
  private static instance: Logger;
  private logs: string[] = [];

  private constructor() {}

  public static getInstance(): Logger {
    if (!Logger.instance) {
      Logger.instance = new Logger();
    }
    return Logger.instance;
  }

  public log(message: string) {
    this.logs.push(message);
  }
}

// 使用
const logger = Logger.getInstance();
logger.log('Application started');
```

在这个例子中，private constructor() 确保：

- 不能直接 new Logger()
- 只能通过 Logger.getInstance() 获取唯一实例
- 提供了对日志记录的集中管理

## 第二个实际场景

实现一个内存中的速率限制器服务。用户或黑客可以通过向特定端点发送大量请求来对其进行垃圾邮件攻击。这可能导致漏洞、意外成本或服务器故障。

为了防止这种情况，我们可以实现一个基本的内存速率限制器服务。该服务应该在特定的时间窗口间隔（例如 60 秒）内限制每个 IP 地址的请求数量。

```typescript
class RateLimiterService {
  private static instance: RateLimiterService
  private requests: Map<string, { count: number; lastRequestTime: number }>
  private readonly limit: number // 最大请求数量
  private readonly window: number // 时间窗口（以毫秒为单位）

  private constructor(limit: number = 5, window: number = 60000) {
    this.requests = new Map()
    this.limit = limit
    this.window = window
  }

  // 获取唯一单例实例的方法
  public static getInstance(): RateLimiterService {
    if (!RateLimiterService.instance) {
      RateLimiterService.instance = new RateLimiterService()
    }
    return RateLimiterService.instance
  }

  public isRateLimited(ip: string): boolean {
    const currentTime = Date.now()
    const userRequestData = this.requests.get(ip)

    if (userRequestData) {
      const isExpired =
        currentTime - userRequestData.lastRequestTime > this.window

      if (isExpired) {
        userRequestData.count = 1
        userRequestData.lastRequestTime = currentTime
        return false
      } else {
        userRequestData.count++
        if (userRequestData.count > this.limit) {
          return true
        }
        return false
      }
    } else {
      this.requests.set(ip, { count: 1, lastRequestTime: currentTime })
      return false
    }
  }
}

export default RateLimiterService
```

**RateLimiterService** 类存储了一个映射，该映射跟踪由 IP 地址（映射键）标识的特定用户在给定时间窗口（requests[ip].lastRequestTime）内发出的请求数量（requests[ip].count）。

我们的 **RateLimiterService** 旨在全局使用，或者换句话说，我们不希望每次导入**RateLimiterService** 时都重置由 requests 映射、limit 和 window 变量组成的内部状态值。

## 结论

单例设计模式是在我们的应用程序中有效管理共享资源的强大工具。

**关键要点：**

- 单例确保一个类只有一个实例，并为其提供一个全局访问点。
- 它对于管理共享资源（如数据库连接、配置设置或缓存）很有用。
