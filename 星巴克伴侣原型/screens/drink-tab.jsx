// drink-tab.jsx — 喝一杯 tab, three variants

// Shared header for the drink tab
const DrinkHeader = ({ subtitle }) => (
  <div style={{ padding: '14px 20px 4px' }}>
    <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
      <div style={{ fontSize: 22, fontWeight: 700, letterSpacing: '-0.01em' }}>今天喝什么?</div>
      <div style={{ fontSize: 11, color: 'var(--ink-muted)' }}>已记 12 杯</div>
    </div>
    <div style={{ fontSize: 12, color: 'var(--ink-soft)', marginTop: 2 }}>{subtitle}</div>
  </div>
);

// ---- shared result card (small preview at bottom) ----
const ResultCard = ({ note }) => (
  <div style={{ margin: '0 20px', border: '1.5px solid var(--line)', borderRadius: 12, padding: 12, display: 'flex', gap: 12, alignItems: 'center', background: 'var(--paper)' }}>
    <div className="ph" style={{ width: 56, height: 56, borderRadius: '50%' }}>图</div>
    <div style={{ flex: 1, minWidth: 0 }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
        <span style={{ fontSize: 10, color: 'var(--ink-muted)' }}>刚刚扭出</span>
        <span style={{ fontSize: 10, color: 'var(--accent)', border: '1px solid var(--accent)', borderRadius: 3, padding: '0 4px' }}>NEW</span>
      </div>
      <div style={{ fontSize: 15, fontWeight: 600, marginTop: 2 }}>燕麦丝绒拿铁</div>
      <div style={{ fontSize: 11, color: 'var(--ink-muted)' }}>经典咖啡 · 推荐热饮</div>
    </div>
    <div style={{ display: 'flex', gap: 6 }}>
      <div style={{ width: 32, height: 32, borderRadius: 8, border: '1.2px solid var(--line)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 14 }}>↻</div>
      <div style={{ width: 64, height: 32, borderRadius: 8, background: 'var(--ink)', color: 'var(--paper)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 12, fontWeight: 600 }}>记一杯</div>
    </div>
    {note}
  </div>
);

// ===================================================================
// V1 — 复古实体扭蛋机
// ===================================================================
const VintageGachapon = () => (
  <svg viewBox="0 0 240 360" width="100%" height="100%" style={{ display: 'block' }}>
    {/* body */}
    <rect x="40" y="180" width="160" height="155" rx="6" fill="#f7f5ef" stroke="#1f1f1d" strokeWidth="2"/>
    {/* base feet */}
    <rect x="32" y="335" width="20" height="14" rx="2" fill="#f7f5ef" stroke="#1f1f1d" strokeWidth="2"/>
    <rect x="188" y="335" width="20" height="14" rx="2" fill="#f7f5ef" stroke="#1f1f1d" strokeWidth="2"/>
    {/* top dome / glass globe */}
    <circle cx="120" cy="120" r="80" fill="#ffffff" stroke="#1f1f1d" strokeWidth="2"/>
    {/* highlight */}
    <path d="M 80 80 Q 95 60 130 60" stroke="#1f1f1d" strokeWidth="1" fill="none" opacity="0.4"/>
    {/* capsules inside */}
    <g>
      <circle cx="90" cy="100" r="11" fill="#e3ede5" stroke="#1f1f1d"/>
      <circle cx="120" cy="95" r="11" fill="#f7f5ef" stroke="#1f1f1d"/>
      <circle cx="148" cy="105" r="11" fill="#1f5c3f" opacity="0.85"/>
      <circle cx="80" cy="130" r="11" fill="#f7f5ef" stroke="#1f1f1d"/>
      <circle cx="105" cy="130" r="11" fill="#1f5c3f" opacity="0.4"/>
      <circle cx="130" cy="128" r="11" fill="#e3ede5" stroke="#1f1f1d"/>
      <circle cx="155" cy="135" r="11" fill="#f7f5ef" stroke="#1f1f1d"/>
      <circle cx="95" cy="158" r="11" fill="#1f5c3f" opacity="0.85"/>
      <circle cx="120" cy="160" r="11" fill="#e3ede5" stroke="#1f1f1d"/>
      <circle cx="145" cy="160" r="11" fill="#f7f5ef" stroke="#1f1f1d"/>
      <circle cx="115" cy="180" r="11" fill="#f7f5ef" stroke="#1f1f1d"/>
      <circle cx="138" cy="184" r="11" fill="#1f5c3f" opacity="0.4"/>
    </g>
    {/* dispense neck */}
    <rect x="105" y="195" width="30" height="14" fill="#f7f5ef" stroke="#1f1f1d" strokeWidth="2"/>
    {/* knob */}
    <circle cx="120" cy="232" r="20" fill="#ffffff" stroke="#1f1f1d" strokeWidth="2"/>
    <rect x="118" y="216" width="4" height="32" fill="#1f1f1d"/>
    <rect x="104" y="230" width="32" height="4" fill="#1f1f1d"/>
    <text x="120" y="236" textAnchor="middle" fontSize="9" fill="#1f1f1d">TURN</text>
    {/* coin slot */}
    <rect x="65" y="225" width="22" height="4" rx="2" fill="#1f1f1d"/>
    <text x="76" y="245" textAnchor="middle" fontSize="8" fill="#5a5a55">COIN</text>
    {/* label */}
    <rect x="155" y="218" width="32" height="20" rx="2" fill="#fff" stroke="#1f1f1d" strokeWidth="1"/>
    <text x="171" y="231" textAnchor="middle" fontSize="7" fill="#1f1f1d">¥1</text>
    {/* output tray */}
    <rect x="65" y="280" width="110" height="44" rx="3" fill="#ffffff" stroke="#1f1f1d" strokeWidth="2"/>
    <path d="M 65 280 L 175 280" stroke="#1f1f1d" strokeWidth="1" strokeDasharray="3 3"/>
    {/* capsule in tray */}
    <ellipse cx="120" cy="306" rx="16" ry="14" fill="#1f5c3f" stroke="#1f1f1d" strokeWidth="1.5"/>
    <path d="M 104 306 Q 120 296 136 306" stroke="#ffffff" strokeWidth="1" fill="none" opacity="0.8"/>
  </svg>
);

const DrinkV1 = () => (
  <Phone screenLabel="01 喝一杯 · 复古扭蛋机">
    <DrinkHeader subtitle="点一下扭蛋机，让今天的咖啡随机来" />
    <Screen>
      <div style={{ position: 'relative', flex: 1, padding: '4px 20px 0' }}>
        <div style={{ position: 'absolute', top: 6, left: 20, fontSize: 10, color: 'var(--accent)' }}>← 顶栏品牌 / 当日已喝杯数</div>
        <div style={{ height: 420, margin: '24px 0 0', position: 'relative' }}>
          <VintageGachapon />
          {/* annotation lines */}
          <div className="callout" style={{ top: 60, right: -4, width: 130 }}>玻璃球内是 12 颗咖啡胶囊<br/>颜色代表未喝 / 已喝</div>
          <div className="callout" style={{ top: 200, left: -8, width: 110 }}>转把可点击或长按<br/>触发扭蛋动画</div>
          <div className="callout" style={{ top: 285, right: -6, width: 110 }}>胶囊掉到出口<br/>→ 弹出饮品详情</div>
        </div>
        <div style={{ marginTop: 4, textAlign: 'center', fontSize: 12, color: 'var(--ink-soft)' }}>点击转把，随机抽取一款咖啡</div>
      </div>
      <div style={{ paddingBottom: 12 }}>
        <ResultCard />
        <div className="callout" style={{ position: 'relative', textAlign: 'center', marginTop: 4 }}>底部「喝一杯」CTA 直接打开饮品菜单（见单独原型）</div>
      </div>
    </Screen>
    <TabBar active="drink" />
  </Phone>
);

// ===================================================================
// V2 — 半手动咖啡机
// ===================================================================
const SemiAutoMachine = () => (
  <svg viewBox="0 0 240 360" width="100%" height="100%" style={{ display: 'block' }}>
    {/* base counter */}
    <rect x="10" y="305" width="220" height="40" rx="3" fill="#f7f5ef" stroke="#1f1f1d" strokeWidth="2"/>
    <path d="M 10 320 L 230 320" stroke="#1f1f1d" strokeWidth="0.8" opacity="0.4"/>

    {/* machine body */}
    <rect x="50" y="50" width="140" height="180" rx="8" fill="#ffffff" stroke="#1f1f1d" strokeWidth="2"/>
    {/* top tray with beans */}
    <rect x="60" y="62" width="120" height="22" rx="3" fill="#f7f5ef" stroke="#1f1f1d" strokeWidth="1.5"/>
    {/* coffee beans */}
    {[0,1,2,3,4,5,6].map(i => (
      <ellipse key={i} cx={70 + i*15} cy={73} rx="4.5" ry="3" fill="#1f5c3f" stroke="#1f1f1d" strokeWidth="0.8"/>
    ))}
    {/* display screen */}
    <rect x="62" y="92" width="116" height="36" rx="3" fill="#1f1f1d"/>
    <text x="120" y="108" textAnchor="middle" fontSize="9" fill="#e3ede5">EXTRACTING…</text>
    <text x="120" y="120" textAnchor="middle" fontSize="11" fill="#fff" fontWeight="600">25.4s ▮▮▮▮▮▯</text>
    {/* knobs */}
    <circle cx="78" cy="148" r="9" fill="#fff" stroke="#1f1f1d" strokeWidth="1.5"/>
    <line x1="78" y1="141" x2="78" y2="148" stroke="#1f1f1d" strokeWidth="1.5"/>
    <circle cx="100" cy="148" r="9" fill="#fff" stroke="#1f1f1d" strokeWidth="1.5"/>
    <line x1="100" y1="148" x2="104" y2="143" stroke="#1f1f1d" strokeWidth="1.5"/>
    {/* big lever button */}
    <rect x="125" y="138" width="55" height="22" rx="11" fill="#1f5c3f" stroke="#1f1f1d" strokeWidth="1.5"/>
    <text x="152" y="153" textAnchor="middle" fontSize="10" fill="#fff" fontWeight="700">BREW</text>

    {/* group head */}
    <rect x="98" y="172" width="44" height="22" rx="3" fill="#f7f5ef" stroke="#1f1f1d" strokeWidth="1.5"/>
    {/* portafilter handle */}
    <rect x="98" y="196" width="44" height="14" fill="#ffffff" stroke="#1f1f1d" strokeWidth="1.5"/>
    <rect x="142" y="198" width="36" height="10" rx="3" fill="#1f1f1d"/>
    {/* spouts */}
    <rect x="108" y="210" width="3" height="6" fill="#1f1f1d"/>
    <rect x="129" y="210" width="3" height="6" fill="#1f1f1d"/>
    {/* coffee stream */}
    <path d="M 109.5 217 Q 109 235 110 250" stroke="#5a3a1a" strokeWidth="1.5" fill="none" strokeDasharray="2 2"/>
    <path d="M 130.5 217 Q 131 235 130 250" stroke="#5a3a1a" strokeWidth="1.5" fill="none" strokeDasharray="2 2"/>

    {/* steam wand */}
    <line x1="190" y1="172" x2="208" y2="218" stroke="#1f1f1d" strokeWidth="2"/>
    <circle cx="208" cy="220" r="2.5" fill="#1f1f1d"/>
    {/* steam */}
    <path d="M 200 200 Q 196 192 202 184" stroke="#1f1f1d" strokeWidth="1" fill="none" opacity="0.4"/>
    <path d="M 206 195 Q 210 188 206 180" stroke="#1f1f1d" strokeWidth="1" fill="none" opacity="0.4"/>

    {/* cup */}
    <path d="M 95 252 L 100 295 Q 100 300 105 300 L 135 300 Q 140 300 140 295 L 145 252 Z" fill="#ffffff" stroke="#1f1f1d" strokeWidth="2"/>
    {/* coffee in cup */}
    <ellipse cx="120" cy="254" rx="24" ry="4" fill="#5a3a1a" opacity="0.85"/>
    {/* saucer */}
    <ellipse cx="120" cy="304" rx="34" ry="5" fill="#ffffff" stroke="#1f1f1d" strokeWidth="1.5"/>

    {/* annotation: lever action */}
    <path d="M 152 165 L 168 138" stroke="#1f5c3f" strokeWidth="1" strokeDasharray="2 2"/>
  </svg>
);

const DrinkV2 = () => (
  <Phone screenLabel="02 喝一杯 · 半手动咖啡机">
    <DrinkHeader subtitle="按下 BREW 拉杆，随机出一杯" />
    <Screen>
      <div style={{ position: 'relative', flex: 1, padding: '4px 20px 0' }}>
        <div style={{ height: 430, margin: '20px 0 0', position: 'relative' }}>
          <SemiAutoMachine />
          <div className="callout" style={{ top: 50, right: -4, width: 110 }}>豆仓里的豆数 =<br/>未喝过的款式</div>
          <div className="callout" style={{ top: 150, right: -4, width: 100 }}>BREW 即扭蛋<br/>触发萃取动效</div>
          <div className="callout" style={{ top: 240, left: -4, width: 100 }}>萃取动画完成<br/>→ 杯中出现咖啡</div>
        </div>
        <div style={{ marginTop: 6, textAlign: 'center', fontSize: 12, color: 'var(--ink-soft)' }}>按下 BREW · 萃取一杯今日所得</div>
      </div>
      <div style={{ paddingBottom: 12 }}>
        <ResultCard />
        <div className="callout" style={{ position: 'relative', textAlign: 'center', marginTop: 4 }}>「↻」= 不喝这杯，重新扭一次</div>
      </div>
    </Screen>
    <TabBar active="drink" />
  </Phone>
);

// ===================================================================
// V3 — 未来感伪 3D
// ===================================================================
const FuturisticOrb = () => (
  <svg viewBox="0 0 240 360" width="100%" height="100%" style={{ display: 'block' }}>
    <defs>
      <radialGradient id="orb" cx="40%" cy="35%" r="65%">
        <stop offset="0%" stopColor="#ffffff" stopOpacity="0.9"/>
        <stop offset="35%" stopColor="#cfe2d4" stopOpacity="0.7"/>
        <stop offset="70%" stopColor="#1f5c3f" stopOpacity="0.85"/>
        <stop offset="100%" stopColor="#0b2a1a" stopOpacity="1"/>
      </radialGradient>
      <radialGradient id="orbShadow" cx="50%" cy="50%" r="50%">
        <stop offset="0%" stopColor="#000" stopOpacity="0.25"/>
        <stop offset="100%" stopColor="#000" stopOpacity="0"/>
      </radialGradient>
      <linearGradient id="plate" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0%" stopColor="#f7f5ef" stopOpacity="0.7"/>
        <stop offset="100%" stopColor="#c8c5bc" stopOpacity="0.7"/>
      </linearGradient>
    </defs>

    {/* ambient halo */}
    <ellipse cx="120" cy="160" rx="105" ry="100" fill="#1f5c3f" opacity="0.06"/>
    <ellipse cx="120" cy="160" rx="80" ry="75" fill="#1f5c3f" opacity="0.08"/>

    {/* floating capsules */}
    <g opacity="0.7">
      <circle cx="35" cy="80" r="8" fill="#e3ede5" stroke="#1f1f1d"/>
      <circle cx="210" cy="110" r="6" fill="#1f5c3f"/>
      <circle cx="40" cy="240" r="7" fill="#1f5c3f" opacity="0.5"/>
      <circle cx="205" cy="230" r="9" fill="#e3ede5" stroke="#1f1f1d"/>
      <circle cx="20" cy="180" r="5" fill="#1f1f1d"/>
      <circle cx="220" cy="170" r="4" fill="#1f5c3f"/>
    </g>

    {/* orb shadow on plate */}
    <ellipse cx="120" cy="262" rx="60" ry="9" fill="url(#orbShadow)"/>

    {/* orb */}
    <circle cx="120" cy="160" r="78" fill="url(#orb)" stroke="#1f1f1d" strokeWidth="1.5"/>
    {/* glass highlight */}
    <ellipse cx="92" cy="120" rx="24" ry="14" fill="#fff" opacity="0.55" transform="rotate(-20 92 120)"/>
    <ellipse cx="148" cy="200" rx="10" ry="5" fill="#fff" opacity="0.3" transform="rotate(-30 148 200)"/>

    {/* central drink icon in orb */}
    <g opacity="0.95">
      <path d="M 105 150 H 135 L 132 178 Q 132 182 128 182 H 112 Q 108 182 108 178 Z" fill="#fff" stroke="#1f1f1d" strokeWidth="1.5"/>
      <ellipse cx="120" cy="151" rx="15" ry="3" fill="#5a3a1a"/>
      <path d="M 112 162 H 128" stroke="#1f1f1d" strokeWidth="0.8" opacity="0.5"/>
    </g>

    {/* glass plate */}
    <ellipse cx="120" cy="268" rx="78" ry="14" fill="url(#plate)" stroke="#1f1f1d" strokeWidth="1.5"/>
    <ellipse cx="120" cy="263" rx="78" ry="14" fill="none" stroke="#1f1f1d" strokeWidth="0.8" opacity="0.5"/>

    {/* tap button */}
    <rect x="60" y="298" width="120" height="38" rx="19" fill="#1f1f1d"/>
    <text x="120" y="322" textAnchor="middle" fontSize="13" fill="#fff" fontWeight="700" letterSpacing="2">TAP TO SPIN</text>
  </svg>
);

const DrinkV3 = () => (
  <Phone screenLabel="03 喝一杯 · 未来感伪 3D">
    <DrinkHeader subtitle="点击底部按钮，让灵感悬浮再落下" />
    <Screen>
      <div style={{ position: 'relative', flex: 1, padding: '4px 20px 0' }}>
        <div style={{ height: 430, margin: '12px 0 0', position: 'relative' }}>
          <FuturisticOrb />
          <div className="callout" style={{ top: 50, right: -4, width: 120 }}>玻璃球内是当日<br/>"灵感载体"<br/>动画时旋转/抖动</div>
          <div className="callout" style={{ top: 210, left: -4, width: 100 }}>玻璃平台 +<br/>投影 暗示 3D 空间</div>
          <div className="callout" style={{ top: 310, right: -4, width: 100 }}>主 CTA 按钮<br/>替代复古转把</div>
        </div>
      </div>
      <div style={{ paddingBottom: 12 }}>
        <ResultCard />
        <div className="callout" style={{ position: 'relative', textAlign: 'center', marginTop: 4 }}>悬浮动效 → 落定 → 卡片从底部上滑</div>
      </div>
    </Screen>
    <TabBar active="drink" />
  </Phone>
);

Object.assign(window, { DrinkV1, DrinkV2, DrinkV3 });
