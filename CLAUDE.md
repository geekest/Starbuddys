# Starbuddys 项目上下文

## 项目简介
Starbuddys 是一款 iOS 个人饮品记录 App，帮助用户记录、管理在星巴克和 Manner 喝过的饮品及定制化参数（杯型、温度、奶型、浓缩等），并支持成就解锁与推荐功能。

## 技术栈
- **语言**：Swift 5.9+
- **UI 框架**：SwiftUI
- **数据持久化**：SwiftData（`@Model`，`ModelContainer`，无 CoreData）
- **架构**：单一 App Target + Services 层（DrinkRepository / BrewRecommender / AchievementEngine / FavoritesStore）+ Views 层（按 Tab 组织）+ Models 层
- **数据来源**：本地 JSON 种子文件（`drinks.seed.json` / `manner_menu.json`）在启动时解码注入
- **图片资源**：饮品图片存于 `Assets.xcassets`，以中文饮品名命名，`Drink.imageAssetName` 负责剥除扩展名后查找

## 目录结构
```
Starbuddys/
├── Starbuddys/                  # 主 Target
│   ├── Models/                  # Drink、CupRecord、枚举（Enums.swift）
│   ├── Services/                # 业务逻辑层（Repository / Recommender / Achievements）
│   ├── Views/                   # UI，按 Tab 分子目录 + Components/
│   │   ├── DrinkTab/            # 核心点单与推荐流程
│   │   ├── HistoryTab/          # 饮品历史记录
│   │   ├── LibraryTab/          # 饮品百科
│   │   ├── ProfileTab/          # 个人主页 & 成就
│   │   ├── Components/          # 通用组件（DCard、DrinkAvatar 等）
│   │   └── Root/                # RootView（TabView 入口）
│   ├── Theme/                   # 颜色（AppColor）、字体（AppFont）、阴影（AppShadow）
│   └── Assets.xcassets/         # 图片 & 颜色资源
├── drinks.seed.json             # 星巴克饮品数据
├── manner_menu.json             # Manner 饮品数据
└── StarBuddys_PRD.md            # 产品需求文档
```

## 核心数据模型
- `Drink`：静态饮品信息，从 JSON 解码，不存入 SwiftData
- `CupRecord`：用户每次喝的记录，SwiftData `@Model`，所有枚举以 `rawValue: String` 存储
- `FlavorAddon`：口味附加项（Manner 定制），以 JSON `Data` 存入 CupRecord

## 关键枚举（修改须谨慎，影响持久化数据）
`CupSize` / `Temperature` / `MilkType` / `EspressoType` / `EspressoStrength` / `FoamLevel` / `SweetOption` / `SweetPosition` / `WhippedCreamLevel` / `FlavorSyrup` / `SugarLevel`  
⚠️ rawValue 是持久化 key，**不得随意改动已有 case 的 rawValue**，否则会静默破坏旧记录。

## 品牌支持
- `BrandType.starbucks`：星巴克，饮品分 16 个 category
- `BrandType.manner`：Manner，饮品分 9 个 category
- `DrinkCategory` 通过 `brand` 属性区分归属

---

## 代码规范
- **注释**：一律用中文，逻辑说明写在关键分支或复杂计算旁
- **命名**：函数、变量、类型名用英文（驼峰），只有面向用户展示的字符串用中文
- **禁止直接操作主分支**：所有改动通过分支 + PR 合并，主分支始终保持可编译可运行状态

## AI 协作约束
- **变更枚举 rawValue 前必须提示风险**：涉及 CupRecord 持久化字段的枚举修改，需明确告知可能破坏已有数据
- **不主动删除已有代码**：重构前先确认，删除逻辑须经明确授权
- **优先复用已有组件**：新 UI 先检索 `Views/Components/`，不重复造轮子
- **修改 seed JSON 须同步 Assets**：新增饮品图片必须同时加入 `Assets.xcassets`，否则会显示占位图

---

## PR 规范
- 所有 Pull Request 的标题、描述、变更说明必须用中文填写
- PR 标题格式：`简洁描述`，例如：`新增用户登录模块；`
- PR 描述包含：变更原因、实现方案、测试说明

## commit 规范
- 所有 commit 的标题、描述、变更说明必须用中文填写
- commit 标题格式：`[类型] 简洁描述`，例如：`[功能] 新增用户登录模块；[修复] 更新枚举值；[优化] 提升代码可靠性并修复bug`
- commit 描述要求用不超过30个汉字描述清楚做了什么

## brnach 规范
- 所有 branch 的命名都必须使用中文，branch标题不能超过15个汉字，末尾不要有奇怪的英文字符。