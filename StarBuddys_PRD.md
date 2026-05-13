# StarBuddys · 星巴克伴侣 PRD

> 给 Claude Code 的实现说明书 · 基于中保真原型 + 真实菜单数据
> Owner: Harvey · 平台: iOS 17+ · 技术栈: Swift 5.9 + SwiftUI · 离线优先
> 版本: v1.0 (MVP)

---

## 0. 怎么用这份 PRD

这份 PRD 是写给 **Claude Code** 直接动手实现的。它具备三个特性:

1. **设计令牌已固定** —— 颜色/字号/圆角/间距全部从 HTML 原型抽取，不要再二次发明
2. **种子数据已就绪** —— `drinks.seed.json` (73 款真实饮品) + `PhotoReference/` (77 张 PNG) 在仓库中，直接 import 进 Asset/Bundle
3. **原型路径**: `星巴克伴侣原型/mid/*.jsx` —— 凡有疑义都以此为准

⚠️ **原型与实现的两处必要 gap**:
- 原型里只画了 15 款示意饮品 (SVG 矢量),实现里换用 73 款真实 PNG (放到 `Assets.xcassets`,文件名见 seed)
- 原型用 React + CSS,实现转 SwiftUI;但视觉、间距、色板必须 1:1 还原

---

## 1. 产品定位

### 一句话定义
StarBuddys 是一款给重度星巴克用户的**饮品记录 + 收藏图鉴 App**,把每一杯咖啡变成一次有仪式感的"扭蛋",把累计消费变成可视化的成就墙。

### 核心隐喻 ☕️
**半自动咖啡机** —— 首页是一台立体感十足的绿色咖啡机,中央有一颗大大的 `BREW` 按钮。点击按钮 = 让"今日运势"随机扭出一杯推荐饮品。

### 三个核心价值
| 价值          | 用户场景                  | 对应模块           |
| ----------- | --------------------- | -------------- |
| 🎲 **决策辅助** | "今天喝什么纠结 10 分钟"       | 喝一杯 Tab (随机扭蛋) |
| 📔 **饮品日记** | "想记下今天这杯的感受/花费/搭配"    | 详情·记一杯         |
| 🏆 **成就收集** | "我已经喝过多少款了? 还差几款全收集?" | 饮品库 + 我的 Tab   |

### 不做什么 (Non-goals, MVP 阶段)
- ❌ 社交/分享/动态信息流 (v2 再考虑)
- ❌ 点单跳转星巴克 App / 比价
- ❌ 后端账号系统 (本地存储,iCloud 备份留作 v1.1)
- ❌ AI 推荐 / 口味学习模型
- ❌ Apple Watch / Widget (留作 v1.1)

---

## 2. 信息架构

```
StarBuddys
├── ① 喝一杯 Tab (默认首页)
│   ├── A · 待机态 (咖啡机 idle + 上一杯卡片 + "我自己选"二级入口)
│   ├── B · 扭出态 (咖啡机 brewing + 推荐结果卡从底部弹起)
│   ├── C · 选饮品弹层 (BottomSheet · 搜索/分类/网格)
│   └── D · 详情·记一杯页 (push 进入,完整记录表单)
├── ② 饮品库 Tab (图鉴式)
│   ├── 总进度卡 (深绿渐变)
│   ├── 筛选 Pills (全部/已喝/未喝/新品)
│   └── 分类分组 + 平铺网格 (3 列,未喝灰锁,已喝点亮带 ×N)
├── ③ 历史 Tab (月历)
│   ├── 月历 (饮品图标点缀日期 cell)
│   ├── 月汇总三联卡 (杯数/花费/连击)
│   ├── 当月最爱卡
│   └── 明细列表 (时间倒序)
└── ④ 我的 Tab (徽章墙)
    ├── 用户头部 (深绿渐变 + Lv 进度 + 4 项快速统计)
    ├── 4 大徽章组 (饮品收集/类型大师/单品狂热/累计里程碑)
    └── 设置区 (分享/语言/反馈/评价/关于)
```

底部 TabBar: `喝一杯 · 饮品库 · 历史 · 我的`,4 项等分,高度 84pt (含 home indicator 18pt safe area)。

---

## 3. 设计系统 (Design Tokens)

> 从 `mid/system.jsx` + 各 tab jsx 抽取。**Claude Code 实现时,把这些做成 `enum AppTheme`,全局复用,不要散落写死。**

### 3.1 颜色 (Color)

```swift
extension Color {
    // 品牌主色
    static let sbGreenDeep   = Color(hex: "#0E4A2E")   // 主按钮、强调字、徽章
    static let sbGreen       = Color(hex: "#1F6B47")   // 次级品牌色、渐变中段
    static let sbGreenPale   = Color(hex: "#E9F2EC")   // 浅绿底 (pill 选中、卡片底)
    static let sbGreenTint   = Color(hex: "#F4F9F5")   // 极浅绿 (信息卡背景)

    // 中性
    static let sbCream       = Color(hex: "#FAF7F0")   // 奶白 (搜索框底)
    static let sbPaper       = Color(hex: "#FFFFFF")   // 纸白 (卡片/Sheet)
    static let sbPaper2      = Color(hex: "#FAF9F5")   // 次级纸白 (备注框)
    static let sbCanvas      = Color(hex: "#F0EEE9")   // App 背景 (画布米色)

    // 墨色 (文字)
    static let sbInk         = Color(hex: "#161614")   // 主文
    static let sbInk1        = Color(hex: "#3D3D38")   // 次文
    static let sbInk2        = Color(hex: "#6E6E68")   // 辅助文
    static let sbInk3        = Color(hex: "#9E9E96")   // 占位/禁用

    // 线条
    static let sbLine        = Color(hex: "#E8E5DC")
    static let sbLine2       = Color(hex: "#D5D2C8")

    // 风味点缀 (用于不同饮品系列的色彩标识)
    static let sbAmber       = Color(hex: "#C08A3A")   // 金烘/焦糖/NEW 标签
    static let sbAmberSoft   = Color(hex: "#F6EDD7")
    static let sbRose        = Color(hex: "#C26C7E")   // 玫瑰/单品狂热
    static let sbRoseSoft    = Color(hex: "#F4E2E6")
    static let sbBerry       = Color(hex: "#884E5E")   // 莓莓
    static let sbMatcha      = Color(hex: "#6B9168")   // 抹茶
}
```

### 3.2 字体 (Typography)

中文用 **PingFang SC**,英文/数字 fallback 系统字体,**数字部分使用 monospace 等宽** (`ui-monospace`,SwiftUI 里用 `.monospacedDigit()`)。

| Token | Size | Weight | 用途 |
|---|---|---|---|
| `title-xl` | 28 | 800 | 喝一杯 tab 主标题 ("今天喝什么?") |
| `title-l`  | 22 | 800 | 详情饮品名、历史明细日期 |
| `title-m`  | 20 | 700 | Sheet 标题、月份大字 |
| `title-s`  | 16 | 700 | 导航栏标题 |
| `body-l`   | 15 | 600 | 主按钮文字 |
| `body-m`   | 14 | 500/700 | 列表项 |
| `body-s`   | 13 | 500 | 表单内文 |
| `caption`  | 11–12 | 500 | 辅助说明、时间、单位 |
| `label`    | 10–11 | 700 | 大写 letter-spacing 标签 (`STARBUDDYS`、`NEW`) |
| `num-display` | 22–28 | 800 monospace | 价格、统计数字 |

### 3.3 圆角 (Corner Radius)

- 手机框/卡片大圆角: **20pt** (Sheet 顶部)、**18pt** (进度卡)、**16pt** (普通卡片)
- 按钮: **14pt**
- Pill / 标签: **999pt** (full pill) 或 **8–10pt** (方形 chip)
- 图标按钮: **12pt** (36×36)

### 3.4 间距 (Spacing)

横向 padding 主流 **20pt** (内容容器),24pt (标题区)。卡片内 padding 14pt。tab 间纵向 26pt。

### 3.5 阴影 (Shadow)

```swift
static let shadowSm = Shadow(radius: 3, x: 0, y: 1, opacity: 0.06)
static let shadowMd = Shadow(radius: 16, x: 0, y: 4, opacity: 0.07)
static let shadowLg = Shadow(radius: 36, x: 0, y: 12, opacity: 0.10)
```

按钮专属阴影 (深绿色):`0 8 20 rgba(14, 74, 46, 0.25)`。

### 3.6 共享组件 (必须抽出复用)

| 组件 | 用途 | 参考 |
|---|---|---|
| `PhoneFrame` | 不需要,iOS 实现时直接占满屏幕 | — |
| `TabBar` | 底部 4 Tab | `system.jsx` |
| `NavHeader` | 二级页导航 (左返回 + 中标题 + 右图标) | `system.jsx` |
| `IconBtn` | 36×36 圆角图标按钮 | `system.jsx` |
| `Pill` | 标签胶囊,3 态: 普通 / `.active` 深绿 / `.soft` 浅绿 | `system.jsx` |
| `Segmented` | 杯型/温度选择器,active 浅绿底 + 深绿描边 | `system.jsx` |
| `ChipGroup` | 多选标签组 | `system.jsx` |
| `ProgressBar` | 进度条 (浅绿底 + 深绿填充) | `system.jsx` |
| `DrinkAvatar` | 圆形饮品头像,支持: bg / locked / ringColor / 角标 ×N | `drinks.jsx` |
| `Badge` | 徽章,支持: kind / unlocked / size,12 种 SVG 艺术风格 | `badges.jsx` |
| `DCard` | 通用白底圆角卡片,16pt 圆角 + shadowSm | — |

---

## 4. 数据模型

### 4.1 实体定义 (Swift `Codable`)

```swift
// 饮品 (静态数据,来自 drinks.seed.json)
struct Drink: Identifiable, Codable, Hashable {
    let id: String                  // "sb_001"
    let nameCN: String              // "香草风味高蛋白拿铁PRO"
    let nameEN: String              // "Vanilla High Protein Latte PRO"
    let category: DrinkCategory     // 顶级分类
    let subCategory: String?        // "高蛋白系列" 等
    let description: String         // 简介
    let sizes: [CupSize: Int]       // 杯型对应价格 (元)
    let imageName: String           // "香草风味高蛋白拿铁PRO.PNG" (Assets 中查找)
    let tags: [DrinkTag]            // 自动 + 手工标注
}

enum DrinkCategory: String, Codable, CaseIterable {
    case craftedCoffee = "手工调制咖啡"
    case frappuccino   = "星冰乐"
    case tea           = "茶饮"
    case refreshers    = "星巴克生咖 Refreshers"
    case other         = "其他饮品"
}

enum CupSize: String, Codable, CaseIterable {
    case tall    // 中杯 355ml
    case grande  // 大杯 473ml
    case venti   // 超大杯 591ml
}

enum DrinkTag: String, Codable {
    case cold, hot, matcha, oatmilk, almondmilk, highProtein,
         noAddedSugar, floral, chocolate, caramel, vanilla, tea, americano, latte
}

// 一杯记录 (用户产生的核心数据)
struct CupRecord: Identifiable, Codable {
    let id: UUID
    let drinkID: String             // -> Drink.id
    let drunkAt: Date               // 喝的时间
    let cupSize: CupSize
    let temperature: Temperature    // 热/正常冰/少冰/去冰
    let sugar: SugarLevel           // 标准/少糖/半糖/微糖/无糖
    let shotCount: Int              // 浓缩 shot 数 (默认 1 或 2)
    let extraShots: Int             // 额外加 shot (¥4/shot)
    let milk: MilkType              // 标准/低脂/燕麦/豆奶/不加奶
    let flavors: [FlavorAddon]      // 风味添加,可多选
    let rating: Int                 // 1–5 星
    let note: String?               // 自由备注
    let photoData: Data?            // 可选,用户拍照
    let computedPrice: Int          // 自动算出的总价 (基础杯型价 + 额外 shot * 4 + 风味费)
    let isFirstTime: Bool           // 是否本款第一次喝
}

enum Temperature: String, Codable, CaseIterable {
    case hot = "热饮", iceNormal = "正常冰", iceLess = "少冰", iceNone = "去冰"
}
enum SugarLevel: String, Codable, CaseIterable {
    case standard = "标准", less = "少糖", half = "半糖", micro = "微糖", none = "无糖"
}
enum MilkType: String, Codable, CaseIterable {
    case whole = "标准奶", lowFat = "低脂奶", oat = "燕麦奶", soy = "豆奶", none = "不加奶"
}
struct FlavorAddon: Codable, Hashable {
    let name: String        // "焦糖风味糖浆"
    let count: Int          // 通常 1
    let extraPrice: Int     // ¥/份,通常 0 或 5
}

// 成就 (按规则在客户端计算,不需要单独持久化解锁状态——每次启动重算)
struct Achievement: Identifiable {
    let id: String              // "starter-10"
    let group: AchievementGroup // .collection / .typeMaster / .singleFan / .milestone
    let name: String            // "初尝者"
    let desc: String            // "解锁 10 款"
    let target: Int
    let progress: Int           // 由 CupRecord 集合实时算出
    let isUnlocked: Bool        // progress >= target
    let badgeKind: String       // 对应 BadgeArt 12 款里的 key
}

enum AchievementGroup: String, CaseIterable {
    case collection  = "饮品收集"
    case typeMaster  = "类型大师"
    case singleFan   = "单品狂热"
    case milestone   = "累计里程碑"
}
```

### 4.2 存储

- **MVP**: SwiftData (iOS 17+) 或 `Codable` + 单文件 JSON (`~/Documents/records.json`)
- 推荐 **SwiftData**,@Model 标注 `CupRecord`,查询性能足够 5 年的个人记录量级
- `Drink` 数据从 `Bundle.main` 读 `drinks.seed.json`,**不入库**
- 图片: PNG 全部放 `Assets.xcassets/Drinks/` 文件夹,以 `imageName` 去后缀作为 asset name (需要在 build phase 写脚本批量重命名)

### 4.3 价格计算公式

```
computedPrice = drink.sizes[cupSize]
              + extraShots * 4
              + flavors.sum { $0.count * $0.extraPrice }
```
若 `drink.sizes[cupSize]` 不存在 (例如该饮品没有中杯),UI 上对应 segmented 项禁用。

---

## 5. 页面详细规格

> 7 屏对照原型 `mid/app.jsx`:① 喝一杯-待机 / ② 喝一杯-扭出 / ③ 选饮品弹层 / ④ 详情记一杯 / ⑤ 饮品库 / ⑥ 历史 / ⑦ 我的

### 5.1 ① 喝一杯 · 待机态 (DrinkTabIdle)

**目标**: 给用户一个仪式感的入口,让选饮品这件事变成一个轻松的扭蛋动作。

**结构**:
1. 顶部 Header: 左侧问候语 "{时段}好,{昵称}" (默认昵称 "Harvey") + 大标题 **"今天喝什么?"**;右侧铃铛 IconBtn (MVP 不实现通知中心,占位即可)
2. 中央咖啡机插画 (470pt 高,SVG 完整还原 `EspressoMachine`)
   - 顶部豆仓显示咖啡豆 (装饰)
   - 显示屏: `READY · 第 N 杯` + `今日 · M 杯` (N=累计杯数,M=今天杯数)
   - 中央大圆角 BREW 按钮 (深绿底白字,带浅光晕),**可点击**
3. 提示文字: "点击 [BREW] 让今日运势随机出杯"
4. 上一杯卡片 (近 24h 内有记录则显示,否则隐藏):
   - 圆形饮品头像 + 名称 + 杯型/温度/糖/价格
   - 右侧 "再来一杯 →" 文字按钮 (点击=以该记录为模板新建一条记录,跳详情页预填)
5. 次级 CTA "我自己选 →" (ghost 按钮,全宽,点击拉起选饮品弹层)
6. 底部 TabBar

**交互**:
- 点 BREW: 触发"扭出"动画 → 切到 5.2 ② 扭出态
- 点上一杯卡片: 跳详情页,以该记录为模板预填
- 点"我自己选 →": 拉起选饮品弹层 (5.3)

**空状态**:
- 还没记录过任何饮品时,上一杯卡片替换为"还没记过 · 按 BREW 开张"提示卡

---

### 5.2 ② 喝一杯 · 扭出态 (DrinkTabResult)

**目标**: BREW 按下后,给用户一个出杯的反馈动画 + 推荐卡。

**结构**:
1. Header 副标题变为 "今日运势·上佳" (随机文案,见 §7.1)
2. 主标题变为 "来一杯…"
3. 咖啡机变成 brewing 状态: `EXTRACTING…` + 进度条 + 浓缩液从喷嘴流下 (虚线动画)
4. 一层 18% 黑色蒙版盖住咖啡机
5. **底部弹起推荐卡** (距底 16pt,圆角 20pt,大阴影):
   - 顶部抓手 (36×4 灰条)
   - 左侧大圆头像 (92pt,带柔和渐变背景)
   - 右侧: NEW 标签 (琥珀色,仅当 isFirstTime=true) + 饮品名 + 英文/分类 + 简介 (2 行省略)
   - 三联推荐配置 (浅绿底):推荐杯型 / 推荐温度 / 推荐糖度
   - 底部一行: 圆形刷新按钮 (52pt,重新扭一次) + 主按钮 "记一杯 →"
   - 提示文字: "← 不想喝? 点 刷新 重新扭 / 下拉关闭"

**推荐算法 (MVP 简化版)**:
```
candidates = allDrinks
            .filter { sb_drinks.sizes 至少包含用户上次选的 cupSize, 兜底大杯 }
权重:
- 用户从没喝过的款 × 2.0 (鼓励解锁)
- 当前小时段匹配 (早=咖啡因; 下午=甜口/星冰乐; 晚=低咖啡因/茶) × 1.5
- 季节匹配 (热天=cold; 冷天=hot) × 1.3
- 距上次喝该款 < 24h × 0.3 (防止刚喝过的)
随机加权抽取 1 款
```

**交互**:
- 下拉手势: 关闭推荐卡 → 回到待机态
- 刷新按钮: 重新跑算法换一款 (带 200ms 卡片淡出/入动画)
- "记一杯 →": push 到详情页 (§5.4),预填推荐配置

---

### 5.3 ③ 选饮品弹层 (DrinkPicker)

**目标**: 用户主动选饮品的入口。Bottom Sheet,占屏 ~75%。

**结构**:
1. 顶部抓手 + 标题 "选一杯" + 右侧关闭按钮
2. 搜索框 (奶白底,占位 "搜咖啡名 / 系列",支持中英文/拼音模糊)
3. 横向分类 Pills (可滚动): `热门` / 5 大分类。"热门" = 用户喝过次数 top 9 + 全局新品的并集
4. 3 列网格 (88pt 头像 + 名称),每个 cell:
   - 圆形头像 (cream 背景)
   - 右上角 "×N" 角标 (深绿,仅当 N≥1)
   - 名称 2 行省略
5. 底部固定栏 (带顶分割线): 主按钮 "选好了 · 下一步 →" (灰态,直到选中一款)

**交互**:
- 点击 cell: 单选高亮 (描边深绿 + 头像缩放 0.95→1.02 弹性动画 200ms)
- 选中后底部按钮变深绿,点击 push 详情页
- 搜索/分类切换: 即时过滤
- 下拉手势: 关闭

---

### 5.4 ④ 详情·记一杯 (DetailPage)

**目标**: 一屏内完成"记录一杯"的全部表单。这是产品的核心动作页。

**结构** (全部纵向滚动):
1. NavHeader: 返回 + "记一杯" + 右上心形 (收藏到偏好,影响推荐权重,MVP 可仅 UI)
2. Hero 区:
   - 168×168 大圆头像 (柔和渐变背景)
   - 中文名 (22pt 800) + 英文/分类
   - 两个标签:
     - "第一次喝" (琥珀,仅当 isFirstTime=true)
     - "{YYYY/MM/DD · 上午/下午}" (浅绿)
3. 表单 Sections (Section 组件:标题 14pt + 内容):
   - **杯型**: Segmented (中/大/超大,显示 ml 副标),禁用饮品不提供的杯型
   - **温度**: ChipGroup,4 项,默认值跟随推荐 (热饮系列默认热,冷萃/星冰乐默认正常冰)
   - **糖度**: ChipGroup,5 项,默认"标准"
   - **浓缩 Shot**: 减/加按钮 + 中央 ×N 数字 (default = 默认 shot,通常 1 或 2),右侧 "+1 shot · ¥4" 实时提示。仅咖啡类显示
   - **牛奶**: ChipGroup,5 项,默认"标准奶";若饮品本身为燕麦/巴旦木系列,默认对应
   - **风味添加**: 列表式 (而非 Pills),每项 (糖浆名 + 数量),底部有 "+ 添加" 入口拉起搜索糖浆。MVP 给死 ~8 种 (焦糖糖浆/香草糖浆/榛果糖浆/海盐奶盖/淡奶油/巧克力酱/抹茶粉/桂花糖浆),每份 ¥0–5
   - **今日感受**: 5 颗星,默认 4 颗
   - **备注**: 多行文本,占位 "写点什么…(地点 / 心情 / 配什么吃的)"
4. **价格卡** (浅绿底): 左 "本杯花费 ¥XX" (实时计算,monospace 大号) + 右 "本月累计 ¥XXX"
5. 底部固定 CTA Bar:
   - 灰按钮 "放弃" (二次确认弹窗 "确定放弃这次记录?")
   - 主按钮 "保存这一杯 ✓"

**保存后行为**:
- 触发轻量 Haptic (.success)
- 弹一个 1.5s 的 Toast: "已记录 · 这是第 N 次喝 / 第一次喝,徽章 +1 🏆"
- 检查是否触发新徽章解锁,若有 → 全屏解锁动画 (MVP 可简化为 BottomSheet 弹一个庆祝卡)
- 自动返回喝一杯 Tab,显示最新记录的"上一杯"

---

### 5.5 ⑤ 饮品库 Tab (LibraryTab)

**目标**: 图鉴式呈现 73 款饮品的解锁进度,激发"集邮"动机。

**结构**:
1. Header: 大标题 "饮品图鉴" + 右上搜索 + 设置图标
2. **总进度卡** (深绿渐变,18pt 圆角):
   - 左侧 56×56 圆 + crown 图标
   - 中央: `已收集` label + 大数字 `12 / 73` + 进度条 (白色填充)
   - 右侧: `下一目标` + `20 款`
3. 筛选 Pills: 全部 / 已喝 / 未喝 / 新品 (每项带数量)
4. 按 **DrinkCategory** 分组,每组:
   - 分组标题 "{分类} ×{已喝}/{总}" (右侧 "★ 全收集" 琥珀色标,仅当全解锁)
   - 3 列网格,92pt 头像 cell:
     - **未喝**: 灰度 + 锁图标蒙层 + cream 背景
     - **已喝**: 彩色 + 右上角 ×N 角标 (深绿) + 名称下方"已喝 N 次"
     - **狂热 (≥20 次)**: 头像外圈加琥珀色描边 + 角标变琥珀

**交互**:
- 点击已喝饮品: push 到饮品详情页 (§5.7,只读模式)
- 点击未喝饮品: 弹小卡 "还没喝过这款 · 去记一杯" + CTA 跳详情页空表单

**性能要求**: 73 款 grid 必须用 `LazyVGrid`,头像图片 lazy 加载。

---

### 5.6 ⑥ 历史 Tab (HistoryTab)

**目标**: 用日历回顾消费,提供月度统计反馈。

**结构**:
1. NavHeader: 左 "2026 ▾" (点击切年份选择器) + 中"历史" + 右分享 IconBtn
2. 月份切换条: ← / "5 月" (20pt 800) / →
3. 周次标签行: 一 二 三 四 五 六 日 (周一开头)
4. **日历网格** (7 列,aspect-ratio 1:1):
   - 普通日: 灰色数字
   - 有记录日: 黑色加粗数字 + 下方饮品头像 (20pt) 堆叠展示前 2 个 + "+N" 标
   - 今天: 30pt 圆深绿底白字
5. 月汇总三联卡: 杯数 / 花费 / 连击天数 (连续喝的最长天数)
6. **当月最爱卡**: 头像 + 名称 + ×N 次 + 心形图标
7. 明细列表 (倒序,显示 5 条 + "查看全部 →"):
   - 48pt 头像 + 日期/时间 + 饮品名 + 规格 + (可选)备注气泡
   - 右侧 ¥价格 + 5 星评分

**交互**:
- 月份左右切换: 滑动手势 + 按钮
- 点击日历某天: 跳到日详情 (该天所有记录),MVP 可简化为滚动到明细列表对应日期
- 点击明细项: push 到只读详情页

---

### 5.7 ⑦ 我的 Tab (ProfileTab)

**目标**: 把累计成就可视化为骄傲的徽章墙。

**结构**:
1. **用户 Header** (深绿渐变,圆角 0,占满屏宽):
   - 右上设置按钮
   - 左侧 64×64 圆形头像 (默认显示用户最爱饮品头像)
   - 右侧昵称 + 副标 "加入 X 天 · Lv.Y 咖啡迷"
   - Lv 进度条 (半透明白底 + 米色填充)
   - 4 项快速统计行: 总杯数 / 已解锁 / 天连击 / 累计花费 (带分隔线)
2. 成就徽章区: 标题 "成就徽章 · 查看全部 →"
3. **4 大徽章组** (`AchievementGroup` 枚举顺序):
   - 每组一张卡: 组名 + 副标 + 进度条 + "展开 ›"
   - 内嵌 4 颗代表徽章 (横排,56pt):
     - 未解锁: 灰度 + 锁图标
     - 已解锁: 彩色 + 下方 "{progress}/{target}"
4. 设置区: 5 项列表 (分享/语言/反馈/评价/关于),底部版本号

**Lv 系统 (简单公式)**:
- `level = floor(sqrt(totalCups / 4))` ,即 Lv.1=4 杯,Lv.7=196 杯,Lv.10=400 杯
- 下一级所需 = `(level+1)^2 * 4 - totalCups`

**徽章规则** (4 组共 16 颗,可扩展):

| 组 | 徽章 | 解锁条件 | badgeKind |
|---|---|---|---|
| 饮品收集 | 初尝者 | 解锁 ≥10 款 | starter |
| 饮品收集 | 半个鉴赏家 | 解锁 ≥24 款 | half |
| 饮品收集 | 全饮品达人 | 解锁全部 73 款 | full |
| 饮品收集 | 新品先锋 | 当月新品全喝 | starter |
| 类型大师 | 经典咖啡通关 | 喝过全部经典咖啡 | classicMaster |
| 类型大师 | 星冰乐通关 | 喝过全部星冰乐 | frapMaster |
| 类型大师 | 茶饮通关 | 喝过全部茶饮 | teaMaster |
| 类型大师 | 高蛋白挑战 | 喝过全部高蛋白系列 | frapMaster |
| 单品狂热 | 一见钟情 | 同款喝 ≥10 次 | fan10 |
| 单品狂热 | 老情人 | 同款喝 ≥50 次 | fan50 |
| 单品狂热 | 此生挚爱 | 同款喝 ≥100 次 | fan100 |
| 单品狂热 | 专一 | 连续一周只喝一款 | fan10 |
| 累计里程碑 | 100 杯 | 累计 ≥100 杯 | starter |
| 累计里程碑 | 200 杯 | 累计 ≥200 杯 | cup100 |
| 累计里程碑 | 500 杯 | 累计 ≥500 杯 | cup500 |
| 累计里程碑 | 1000 杯 | 累计 ≥1000 杯 | cup500 |

---

## 6. 关键用户旅程 (User Journeys)

### 6.1 首次启动 → 第一次记录 (Onboarding)
1. 启动闪屏 (Logo + 深绿渐变,1s 后淡出)
2. 落地"喝一杯 Tab"待机态,因无历史记录,上一杯卡变为"还没记过 · 按 BREW 开张"
3. 用户按 BREW → 扭出推荐 → 点 "记一杯"
4. 详情页保存 → 解锁徽章"初尝者 (1/10)" + Toast"第一次喝 ✓"
5. 自动回到喝一杯 Tab,上一杯卡填充

### 6.2 日常记录路径 (核心高频)
- **A 路径 (随机)**: 喝一杯 Tab → BREW → 推荐卡 → 记一杯 → 详情页 (~10s)
- **B 路径 (主动)**: 喝一杯 Tab → "我自己选" → 弹层选 → 详情页 (~15s)
- **C 路径 (复刻)**: 喝一杯 Tab → 上一杯卡 "再来一杯" → 详情页预填 (~5s)

### 6.3 回顾路径
- 历史 Tab → 选月份 → 看月汇总 → 点明细单条 → 只读详情

---

## 7. 文案策略 (UX Copy)

### 7.1 喝一杯 · 时段问候
- 早上 (5-11): "早上好,{昵称}" / 大字 "今天喝什么?"
- 中午 (11-14): "午安,{昵称}" / 大字 "来杯解压的?"
- 下午 (14-18): "下午好,{昵称}" / 大字 "今天喝什么?"
- 晚上 (18-23): "晚上好,{昵称}" / 大字 "再来一杯?"
- 深夜 (23-5): "夜深了,{昵称}" / 大字 "还要再喝?"

### 7.2 扭出运势文案 (随机)
"今日运势·上佳" / "宇宙安排了这杯" / "缘分注定" / "这杯,你猜不到吧" / "今日特调"

### 7.3 空状态
- 上一杯卡 (无记录): "还没记过 · 按 BREW 开张"
- 饮品库筛选无结果: "这里还空着,去喝一杯解锁吧 ☕"
- 历史月无记录: "这个月还没记录,翻翻其他月份?"

### 7.4 保存 Toast
- 普通: "已记录这一杯 ✓"
- 首次喝: "🎉 第一次喝 · 解锁 +1"
- 解锁徽章: "🏆 新徽章: {名称}"

---

## 8. 技术约束 & 实现指引

### 8.1 工程结构 (建议)
```
StarBuddys/
├── App/
│   └── StarBuddysApp.swift          // @main, 注入 ModelContainer
├── Theme/
│   ├── AppColor.swift               // 全部色板
│   ├── AppFont.swift
│   └── AppShadow.swift
├── Models/
│   ├── Drink.swift                  // Codable
│   ├── CupRecord.swift              // @Model (SwiftData)
│   ├── Achievement.swift            // 计算属性,不持久化
│   └── Enums.swift                  // CupSize/Temp/Sugar/Milk
├── Services/
│   ├── DrinkRepository.swift        // 加载 seed.json
│   ├── RecordStore.swift            // SwiftData CRUD
│   ├── AchievementEngine.swift      // 实时算解锁状态
│   └── BrewRecommender.swift        // §5.2 推荐算法
├── Views/
│   ├── Components/                  // DrinkAvatar, Pill, Segmented, Badge...
│   ├── DrinkTab/                    // Idle / Result / Picker / Detail
│   ├── LibraryTab/
│   ├── HistoryTab/
│   ├── ProfileTab/
│   └── Root/                        // TabView 容器
├── Resources/
│   ├── drinks.seed.json
│   └── Assets.xcassets/Drinks/      // 73 PNG
└── Tests/
    ├── BrewRecommenderTests.swift
    └── AchievementEngineTests.swift
```

### 8.2 SwiftUI 实现要点
- **TabView**: 使用 `TabView` + 4 个 NavigationStack 子视图,每个 Tab 独立导航栈
- **饮品库 LazyVGrid**: 3 列 fixed,`spacing: 12`,避免在大数据集时卡顿
- **详情页表单**: 用 `ScrollView` + `VStack`,**不要用 Form** (Form 默认样式与设计不符)
- **底部 Sheet**: `.sheet(isPresented:)` + `.presentationDetents([.fraction(0.75), .large])`
- **咖啡机 SVG**: SwiftUI 没有 SVG 渲染,需要把 SVG 转成 `Shape` + `Path` (本 SVG 较复杂,推荐用 **PocketSVG** 或先 export 为 PDF 矢量放 Asset)。**MVP 可妥协**: 把整张咖啡机渲染成两张 PNG (idle / brewing),用 CSS-level 1:1 还原即可
- **动画**:
  - BREW 按下: `.scaleEffect` 0.95 + 200ms spring
  - 推荐卡弹起: `.transition(.move(edge: .bottom).combined(with: .opacity))` + spring
  - 进度条/数字: `.animation(.easeOut(duration: 0.4))`
- **触感**: `UIImpactFeedbackGenerator(style: .light)` for 选择, `.success` for 保存

### 8.3 性能与体积
- 73 张 PNG 单张 ~50KB,总 ~4MB,直接打包入 App 可接受
- 若超 20MB,改用 on-demand resources 按分类分组下载
- 历史月历: 用 `LazyVGrid`,只渲染当前月

### 8.4 国际化 (i18n)
- MVP 仅简体中文,**但代码要为 i18n 留口**: 所有文案走 `String(localized: "key")`,生成 `Localizable.xcstrings`

### 8.5 隐私 & 数据
- 全程离线,不上传任何数据
- Info.plist: 仅声明 `NSPhotoLibraryUsageDescription` (拍照/选照片记录用)
- 不需要定位、通讯录、麦克风权限

---

## 9. MVP 范围 & 里程碑

### 9.1 V1.0 必交付 (MVP)
- [x] 4 Tab 主结构 + 底部导航
- [x] 喝一杯 Tab 完整两态 + BREW 动画
- [x] 选饮品弹层 + 搜索 + 分类筛选
- [x] 详情·记一杯页全表单 + 保存
- [x] 饮品库 73 款 + 进度卡 + 4 种筛选
- [x] 历史月历 + 月汇总 + 明细列表
- [x] 我的 Tab + Lv 系统 + 16 颗徽章
- [x] 全部 73 款饮品 PNG 资源接入
- [x] SwiftData 本地持久化

### 9.2 V1.1 (一个月内)
- iCloud 同步 (CloudKit)
- 解锁徽章全屏庆祝动画
- 桌面 Widget (今日已喝 / 推荐扭一次)
- 数据导出 CSV/JSON



---

## 10. 验收标准 (Acceptance Criteria)

### 10.1 必过测试用例
1. **首次启动**: 无记录,喝一杯 Tab 上一杯卡显示空态,BREW 可点
2. **BREW 扭出**: 点 BREW 后,1.5s 内出现推荐卡,推荐卡可滑动关闭
3. **记一杯**: 保存后,饮品库对应 cell 从灰锁变彩色 + ×1 角标
4. **价格实时算**: 改杯型 / 加 shot / 改风味,价格卡数字 200ms 内更新
5. **首次喝标识**: 第一次喝某款,详情页和推荐卡都显示"第一次喝"标签
6. **徽章解锁**: 第 10 杯保存后,"初尝者"徽章变彩色,显示 10/10
7. **离线**: 开启飞行模式,全部功能正常
8. **数据持久**: 杀进程重启,所有记录保留

### 10.2 设计还原度
- 颜色 100% 匹配 §3.1 色板,差异 ≤2 (8 位 RGB)
- 字号/间距与原型偏差 ≤2pt
- 圆角误差 ≤1pt
- 动画时长偏差 ≤50ms

### 10.3 性能
- 冷启动 → 喝一杯 Tab 可交互: < 1.5s (iPhone 13 基准)
- 饮品库滚动: 稳定 60fps
- 记一杯保存: < 200ms
- 内存: 后台稳定 < 80MB

---

## 11. 风险 & 盲点 (开篇就要正视)

| 风险 | 影响 | 缓解 |
|---|---|---|
| **咖啡机 SVG 在 SwiftUI 还原成本高** | 主页核心隐喻打折扣 | MVP 用 PNG;v1.1 投入做 SwiftUI Path 矢量 |
| **73 款 PNG 命名含中文括号特殊字符** | Xcode Asset 报错 | Build phase 脚本批量重命名为拼音/ID |
| **菜单更新 (星巴克季度上新)** | 饮品库过时 | 留远程 JSON 接口位 (App Group 共享),v1.1 接入 |
| **价格随地区变化** | 价格不准 | 在设置加"价格基准: 上海" 提示;v1.1 加多地区切换 |
| **推荐算法可能"扭出"用户讨厌的款** | 体验受挫 | 在详情页心形可"不喜欢",影响权重 (MVP 仅 UI) |
| **徽章疲劳** | 后期解锁全靠堆量 | 引入限时月度徽章 (新品先锋) 已埋点 |

---

## 12. 资源清单 (交付物)

仓库 `/Users/geekest/Starbuddys/` 已就绪:
- ✅ `drinks.seed.json` —— 73 款饮品,标准 JSON,含 imageName/tags/sizes
- ✅ `PhotoReference/*.PNG` —— 77 张饮品图 (含部分变体)
- ✅ `星巴克饮品菜单.xlsx` —— 原始 Excel (回查/扩展用)
- ✅ `星巴克菜单{1,2,3}.jpg` —— 星巴克官方菜单原图 (UI 参考)
- ✅ `星巴克伴侣原型/*.jsx` —— React 中保真原型,**视觉/交互唯一真相源**
- ✅ `StarBuddys 中保真.html` —— 浏览器打开即可看完整原型

---

## 13. 给 Claude Code 的开工指令模板

```
我要实现一个 iOS App,名字叫 StarBuddys,产品需求文档在 /Users/geekest/Starbuddys/StarBuddys_PRD.md。

请你:
1. 先完整读 PRD 和 drinks.seed.json,理解产品定位和数据结构
2. 按 §8.1 工程结构创建 Xcode 项目 (Swift 5.9 + SwiftUI + SwiftData,iOS 17+)
3. 第一阶段先完成基础设施:
   - Theme (AppColor / AppFont / AppShadow)
   - Models (Drink Codable + CupRecord @Model)
   - DrinkRepository (加载 seed.json)
   - 共享组件 (DrinkAvatar / Pill / Segmented / Badge)
4. 第二阶段完成 4 Tab 主结构 + TabBar,各 Tab 内放占位
5. 第三阶段按 §5.1 → §5.7 顺序逐屏实现,优先级:
   ① 喝一杯 → ④ 详情记一杯 → ⑤ 饮品库 → ⑥ 历史 → ⑦ 我的
6. 每完成一屏,跑一次 §10.1 对应测试用例
7. 全部完成后,跑 §10.2 设计还原度自检

视觉真相源: 星巴克伴侣原型/mid/*.jsx
设计令牌唯一来源: PRD §3
有疑义优先看原型,其次看 PRD,最后问我。
```

---

