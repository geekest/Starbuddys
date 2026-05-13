# StarBuddys · 星巴克伴侣

> 把每一杯咖啡，变成一次有仪式感的扭蛋。

![Platform](https://img.shields.io/badge/Platform-iOS%2017%2B-green)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![License](https://img.shields.io/badge/License-MIT-blue)

---

## 这是什么

StarBuddys 是一款专为重度星巴克用户设计的**饮品记录 App**。

核心体验是一台放在首页的绿色半自动咖啡机——按下 **BREW** 按钮，今日运势随机推荐一款饮品；选好之后，几步记录下这杯的规格、花费和感受。积累下来，你就有了一面属于自己的**饮品成就墙**。

---

## 主要功能

### ☕ 喝一杯
点击咖啡机上的 BREW 按钮，根据当前时段、季节、以及你的喝酒历史，智能推荐一款饮品。也可以自己挑，或者直接复刻上一杯。

### 📔 记一杯
记录杯型、温度、糖度、风味添加，App 自动帮你算好花了多少钱。保存后可以看到这是你第几次喝这款。

### 📚 饮品图鉴
73 款真实在售饮品，喝过的点亮，没喝过的灰锁。一眼看到自己解锁了多少，还差多少全收集。

### 📅 历史月历
带饮品图标的日历视图，每月杯数、花费、连击天数一览无余，还有当月最爱饮品卡片。

### 🏆 成就徽章
16 颗徽章，分 4 个组：饮品收集 / 类型大师 / 单品狂热 / 累计里程碑。喝的越多，解锁越多。

---

## 截图

> *(Coming soon)*

---

## 本地运行

需要 macOS + Xcode 16+，部署目标 iOS 17。

```bash
git clone https://github.com/geekest/Starbuddys.git
cd Starbuddys
open Starbuddys/Starbuddys.xcodeproj
```

将 `PhotoReference/` 文件夹中的饮品图片拖入 `Assets.xcassets`，文件名去掉 `.PNG` 后缀即可。然后选择模拟器或真机运行。

---

## 技术栈

- SwiftUI + SwiftData，纯离线本地存储，无后端依赖
- 73 款饮品数据来自星巴克中国真实菜单

---

## 路线图

- **v1.0 (当前)** — 核心记录流程 + 图鉴 + 徽章墙
- **v1.1** — iCloud 同步、桌面 Widget、数据导出
- **v2.0** — 社交分享、动态信息流

---

## License

MIT © 2026 Harvey
