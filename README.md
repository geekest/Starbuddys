# StarBuddys · 星巴克伴侣

<p align="center">
  <em>把每一杯咖啡，变成一次有仪式感的扭蛋。</em><br/>
  <em>Turn every cup of coffee into a ritual.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS%2017%2B-1F6B47?style=flat-square"/>
  <img src="https://img.shields.io/badge/Swift-5.9-F05138?style=flat-square"/>
  <img src="https://img.shields.io/badge/Status-MVP%20v1.0-0E4A2E?style=flat-square"/>
  <img src="https://img.shields.io/badge/License-MIT-lightgrey?style=flat-square"/>
</p>

---

## What is StarBuddys? / 这是什么？

**EN** — StarBuddys is a personal drink-tracking app for Starbucks regulars. The home screen features a vintage espresso machine: hit **BREW** and it picks a drink for you based on the time of day and your history. Log what you ordered, see how much you've spent, and build your own collection of unlocked drinks and achievement badges.

**中文** — StarBuddys 是一款为重度星巴克用户设计的饮品记录 App。首页是一台复古咖啡机，按下 **BREW** 按钮，它会根据当前时段和你的历史记录随机推荐一款饮品。记录下每一杯的规格和花费，慢慢解锁属于你的饮品图鉴和成就徽章墙。

---

## Features / 功能

|  | EN | 中文 |
|--|----|----|
| ☕ | **Brew** — tap once to get a smart drink recommendation | 一键扭出今日推荐饮品 |
| 📔 | **Log** — record size, temp, sugar, add-ons & price | 记录规格，自动计算花费 |
| 📚 | **Collection** — 73 real menu drinks, light up the ones you've tried | 73 款真实饮品，喝过的点亮 |
| 📅 | **History** — calendar view with monthly stats & streaks | 月历回顾，连击天数一览 |
| 🏆 | **Badges** — 16 achievements across 4 categories | 16 颗成就徽章，越喝越多 |

---

## Screenshots / 截图

> Coming soon

---

## Getting Started / 本地运行

Requires macOS with Xcode 16+ and an iOS 17 simulator or device.

```bash
git clone https://github.com/geekest/Starbuddys.git
open Starbuddys/Starbuddys.xcodeproj
```

Drop the drink images from `PhotoReference/` into `Assets.xcassets` (remove the `.PNG` extension from each filename), then run the app.

> 需要 macOS + Xcode 16+，运行目标 iOS 17。将 `PhotoReference/` 里的图片拖入 `Assets.xcassets`，文件名去掉 `.PNG` 后缀，选择模拟器运行即可。

---

## Roadmap / 路线图

- **v1.0** *(current / 当前)* — Core logging, drink collection, badges
- **v1.1** — iCloud sync, home screen Widget, data export
- **v2.0** — Social sharing, community feed

---

## License

MIT © 2026 Harvey
