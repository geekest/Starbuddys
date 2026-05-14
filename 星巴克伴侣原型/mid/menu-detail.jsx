// mid/menu-detail.jsx — 选饮品菜单 + 饮品记录详情页（字段重构版）
// 字段与枚举完全对齐官方星巴克 App；所有分区对每款饮品统一展示，未选项不计入记录

// ====== 字段枚举配置 ======

const TEMPERATURE_OPTIONS = [
  { label: '特别热', value: 'extra-hot' },
  { label: '热',     value: 'hot'       },
  { label: '微热',   value: 'warm'      },
  { label: '冰',     value: 'iced'      },
  { label: '少冰',   value: 'light-ice' },
  { label: '去冰',   value: 'no-ice'    },
];

const ESPRESSO_ROAST_OPTIONS = [
  { label: '经典浓缩(深烘)', value: 'classic' },
  { label: '金烘浓缩(浅烘)', value: 'golden',  isNew: true },
  { label: '低因浓缩(深烘)', value: 'decaf'   },
];

const ESPRESSO_TYPE_OPTIONS = [
  { label: '原萃浓缩', sub: '浓郁醇香，焦糖般甜感', value: 'ristretto' },
  { label: '精萃浓缩', sub: '精炼萃取，倍感甜郁',   value: 'espresso'  },
  { label: '满萃浓缩', sub: '深度萃取，焦香饱满',   value: 'lungo'     },
];

const MILK_OPTIONS = [
  { label: '全脂牛奶', value: 'whole'  },
  { label: '巴旦木奶', value: 'almond' },
  { label: '燕麦奶',   value: 'oat'   },
  { label: '脱脂牛奶', value: 'skim'  },
];

const FOAM_OPTIONS = [
  { label: '标准奶泡',     value: 'standard' },
  { label: '奶泡较多(干)', value: 'dry'      },
  { label: '奶泡较少(湿)', value: 'wet'      },
];

const SUGAR_FREE_FLAVOR_OPTIONS = [
  { label: '香草风味',       value: 'vanilla',          icon: 'vanilla'  },
  { label: '榛果风味',       value: 'hazelnut',         icon: 'hazelnut' },
  { label: '海盐焦糖风味',   value: 'salted-caramel',   icon: 'caramel'  },
  { label: '大溪地香草风味', value: 'tahitian-vanilla', icon: 'tahitian' },
  { label: '莓莓风味',       value: 'berry',            icon: 'berry'    },
  { label: '糯香斑斓风味',   value: 'pandan',           icon: 'pandan'   },
];

const SWEETNESS_OPTIONS = [
  { label: '经典糖',     value: 'classic'  },
  { label: '0热量代糖', value: 'zero-cal' },
  { label: '不另外加糖', value: 'no-sugar' },
];

const DRINK_BASE_OPTIONS = [
  { label: '稀奶油',           value: 'cream'         },
  { label: '椰浆',             value: 'coconut'       },
  { label: '摩卡酱',           value: 'mocha-sauce'   },
  { label: '比利时黑巧风味酱', value: 'belgium-choco' },
];

const DRINK_TOP_OPTIONS = [
  { label: '标准提打稀奶油',   value: 'standard-whip' },
  { label: '加少量提打稀奶油', value: 'light-whip'    },
  { label: '去提打稀奶油',     value: 'no-whip'       },
  { label: '少提打稀奶油',     value: 'less-whip'     },
  { label: '多提打稀奶油',     value: 'extra-whip'    },
];

const SAUCE_OPTIONS = [
  { label: '摩卡淋酱',   value: 'mocha-drizzle'  },
  { label: '焦糖风味酱', value: 'caramel-drizzle' },
  { label: '可可碎片',   value: 'cocoa-crumble'  },
];

// ====== 图标组件 ======

// 无糖风味图标（线描风格，32px）
const FlavorIcon = ({ type, active }) => {
  const s = active ? 'var(--amber)' : 'var(--ink-2)';
  const w = 1.6;
  const icons = {
    vanilla: (
      <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
        <path d="M16 3C14 3 12 7 12 11C12 15 14 16 16 16C18 16 20 15 20 11C20 7 18 3 16 3Z" stroke={s} strokeWidth={w} strokeLinejoin="round"/>
        <path d="M3 16C3 14 7 12 11 12C15 12 16 14 16 16C16 18 15 20 11 20C7 20 3 18 3 16Z" stroke={s} strokeWidth={w} strokeLinejoin="round"/>
        <path d="M16 29C14 29 12 25 12 21C12 17 14 16 16 16C18 16 20 17 20 21C20 25 18 29 16 29Z" stroke={s} strokeWidth={w} strokeLinejoin="round"/>
        <path d="M29 16C29 18 25 20 21 20C17 20 16 18 16 16C16 14 17 12 21 12C25 12 29 14 29 16Z" stroke={s} strokeWidth={w} strokeLinejoin="round"/>
        <circle cx="16" cy="16" r="3" stroke={s} strokeWidth={w}/>
      </svg>
    ),
    hazelnut: (
      <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
        <path d="M16 5C11 5 8 9 8 14C8 21 12 25 16 28C20 25 24 21 24 14C24 9 21 5 16 5Z" stroke={s} strokeWidth={w} strokeLinejoin="round"/>
        <path d="M12 11C12 9 14 8 16 8C18 8 20 9 20 11" stroke={s} strokeWidth={w} strokeLinecap="round"/>
        <path d="M16 8V5" stroke={s} strokeWidth={w} strokeLinecap="round"/>
      </svg>
    ),
    caramel: (
      <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
        <path d="M16 6L27 12V24L16 30L5 24V12Z" stroke={s} strokeWidth={w} strokeLinejoin="round"/>
        <path d="M16 6V18" stroke={s} strokeWidth={w}/>
        <path d="M5 12L16 18L27 12" stroke={s} strokeWidth={w}/>
        <path d="M5 24L16 18" stroke={s} strokeWidth={w} opacity="0.5"/>
        <path d="M27 24L16 18" stroke={s} strokeWidth={w} opacity="0.5"/>
      </svg>
    ),
    tahitian: (
      <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
        <path d="M16 28V12" stroke={s} strokeWidth={w} strokeLinecap="round"/>
        <path d="M16 16C16 16 10 13 8 8C11 8 15 11 16 16Z" stroke={s} strokeWidth={w} strokeLinejoin="round"/>
        <path d="M16 16C16 16 22 13 24 8C21 8 17 11 16 16Z" stroke={s} strokeWidth={w} strokeLinejoin="round"/>
        <path d="M16 21C16 21 10 18 8 13C11 13 15 16 16 21Z" stroke={s} strokeWidth={w} strokeLinejoin="round"/>
        <path d="M16 21C16 21 22 18 24 13C21 13 17 16 16 21Z" stroke={s} strokeWidth={w} strokeLinejoin="round"/>
      </svg>
    ),
    berry: (
      <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
        <circle cx="16" cy="21" r="5" stroke={s} strokeWidth={w}/>
        <circle cx="10" cy="16" r="4" stroke={s} strokeWidth={w}/>
        <circle cx="22" cy="16" r="4" stroke={s} strokeWidth={w}/>
        <circle cx="16" cy="12" r="3.5" stroke={s} strokeWidth={w}/>
        <path d="M16 8.5C16 7 17.5 6 16 5C14.5 6 16 7 16 8.5" stroke={s} strokeWidth="1.2" strokeLinecap="round"/>
      </svg>
    ),
    pandan: (
      <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
        <path d="M16 28C8 22 5 14 7 6C11 8 14 18 16 28Z" stroke={s} strokeWidth={w} strokeLinejoin="round"/>
        <path d="M16 28C24 22 27 14 25 6C21 8 18 18 16 28Z" stroke={s} strokeWidth={w} strokeLinejoin="round"/>
        <path d="M7 6C13 9 16 20 16 28" stroke={s} strokeWidth="1" opacity="0.45" strokeLinecap="round"/>
      </svg>
    ),
  };
  return icons[type] || (
    <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
      <circle cx="16" cy="16" r="10" stroke={s} strokeWidth={w}/>
    </svg>
  );
};

// 浓缩杯型图标（原萃/精萃/满萃）
const EspressoCupIcon = ({ type, active }) => {
  const c = active ? 'var(--green-deep)' : 'var(--ink-2)';
  const cups = {
    ristretto: (
      <svg width="40" height="40" viewBox="0 0 40 40" fill="none">
        <path d="M10 14L12 32H28L30 14Z" stroke={c} strokeWidth="1.5" strokeLinejoin="round" fill={active ? 'var(--green-pale)' : 'none'}/>
        <path d="M8 14H32" stroke={c} strokeWidth="1.5" strokeLinecap="round"/>
        <path d="M30 20C34 20 36 22 36 26C36 30 34 32 30 32" stroke={c} strokeWidth="1.5" strokeLinecap="round"/>
        <path d="M14 9H26" stroke={c} strokeWidth="1.2" strokeLinecap="round" opacity="0.4"/>
        <path d="M17 6H23" stroke={c} strokeWidth="1.2" strokeLinecap="round" opacity="0.3"/>
      </svg>
    ),
    espresso: (
      <svg width="40" height="40" viewBox="0 0 40 40" fill="none">
        <path d="M8 12L11 34H29L32 12Z" stroke={c} strokeWidth="1.5" strokeLinejoin="round" fill={active ? 'var(--green-pale)' : 'none'}/>
        <path d="M6 12H34" stroke={c} strokeWidth="1.5" strokeLinecap="round"/>
        <path d="M32 20C36 20 38 22 38 26C38 30 36 32 32 32" stroke={c} strokeWidth="1.5" strokeLinecap="round"/>
        <path d="M13 7H27" stroke={c} strokeWidth="1.2" strokeLinecap="round" opacity="0.4"/>
      </svg>
    ),
    lungo: (
      <svg width="40" height="40" viewBox="0 0 40 40" fill="none">
        <path d="M8 10L11 36H29L32 10Z" stroke={c} strokeWidth="1.5" strokeLinejoin="round" fill={active ? 'var(--green-pale)' : 'none'}/>
        <path d="M6 10H34" stroke={c} strokeWidth="1.5" strokeLinecap="round"/>
        <path d="M32 18C36 18 38 20 38 24C38 28 36 30 32 30" stroke={c} strokeWidth="1.5" strokeLinecap="round"/>
      </svg>
    ),
  };
  return cups[type] || cups.espresso;
};

// 勾选图标
const CheckIcon = ({ size = 16 }) => (
  <svg width={size} height={size} viewBox="0 0 16 16" fill="none">
    <circle cx="8" cy="8" r="7.5" fill="var(--green-deep)" stroke="var(--green-deep)"/>
    <path d="M4.5 8L7 10.5L11.5 6" stroke="#fff" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
  </svg>
);

// 空圆圈（未选）
const EmptyCircle = ({ size = 16 }) => (
  <svg width={size} height={size} viewBox="0 0 16 16" fill="none">
    <circle cx="8" cy="8" r="7.5" stroke="var(--line-2)" strokeWidth="1"/>
  </svg>
);

// ====== 局部原子组件 ======

const btnCircle = {
  width: 36, height: 36, borderRadius: 18,
  border: '1px solid var(--line-2)', background: 'var(--paper)',
  display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
  color: 'var(--ink)', cursor: 'pointer', padding: 0,
};

const btnSmallCircle = {
  width: 28, height: 28, borderRadius: 14,
  border: '1px solid var(--line-2)', background: 'var(--paper)',
  display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
  color: 'var(--ink)', cursor: 'pointer', padding: 0,
};

// 带标题的表单分区
const Section = ({ title, extra, children }) => (
  <div>
    <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 10 }}>
      <h3 style={{ fontSize: 14, fontWeight: 700 }}>{title}</h3>
      {extra}
    </div>
    {children}
  </div>
);

// 卡片式分区容器
const FormCard = ({ children, style }) => (
  <div style={{
    background: 'var(--paper)', borderRadius: 16,
    padding: '16px', margin: '0 20px',
    boxShadow: '0 1px 4px rgba(0,0,0,0.06)',
    display: 'flex', flexDirection: 'column', gap: 16,
    ...style,
  }}>{children}</div>
);

// 分区间距
const Gap = ({ h = 12 }) => <div style={{ height: h }}/>;

// 温度/甜度/奶泡等选项的标签行
const ChipRow = ({ options, selected }) => (
  <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
    {options.map(opt => {
      const active = opt.value === selected;
      return (
        <div key={opt.value} style={{
          padding: '8px 14px', borderRadius: 10, fontSize: 13,
          fontWeight: active ? 700 : 500,
          background: active ? 'var(--green-pale)' : 'transparent',
          border: '1.5px solid ' + (active ? 'var(--green-deep)' : 'var(--line)'),
          color: active ? 'var(--green-deep)' : 'var(--ink)',
          display: 'flex', alignItems: 'center', gap: 4,
          cursor: 'pointer',
        }}>
          {opt.label}
          {opt.isNew && (
            <span style={{
              fontSize: 9, fontWeight: 700, letterSpacing: 0.5,
              background: 'var(--amber)', color: '#fff',
              padding: '1px 5px', borderRadius: 4,
            }}>NEW</span>
          )}
        </div>
      );
    })}
  </div>
);

// 浓缩类型三格卡片（原萃/精萃/满萃）
const EspressoTypeCards = ({ selected }) => (
  <div style={{ display: 'flex', gap: 8 }}>
    {ESPRESSO_TYPE_OPTIONS.map(opt => {
      const active = opt.value === selected;
      return (
        <div key={opt.value} style={{
          flex: 1, padding: '10px 6px', borderRadius: 12, textAlign: 'center',
          background: active ? 'var(--green-pale)' : 'var(--paper)',
          border: '1.5px solid ' + (active ? 'var(--green-deep)' : 'var(--line)'),
          cursor: 'pointer', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4,
        }}>
          <EspressoCupIcon type={opt.value} active={active}/>
          <div style={{ fontSize: 12, fontWeight: active ? 700 : 500, color: active ? 'var(--green-deep)' : 'var(--ink)' }}>{opt.label}</div>
          <div style={{ fontSize: 10, color: active ? 'var(--green)' : 'var(--ink-3)', lineHeight: 1.3 }}>{opt.sub}</div>
        </div>
      );
    })}
  </div>
);

// 浓缩份数计数行
const ShotCountRow = ({ count }) => (
  <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
    <span style={{ fontSize: 13, fontWeight: 600, color: 'var(--green-deep)' }}>浓缩份数</span>
    <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
      <button style={btnSmallCircle}><I.minus size={14}/></button>
      <span style={{ fontSize: 16, fontWeight: 800, minWidth: 56, textAlign: 'center', fontFamily: 'ui-monospace, monospace', color: 'var(--ink)' }}>
        {count} 浓缩份数
      </span>
      <button style={btnSmallCircle}><I.plus size={14}/></button>
    </div>
  </div>
);

// 无糖风味 3 列网格
const FlavorGrid = ({ options, selected = [] }) => (
  <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 10 }}>
    {options.map(opt => {
      const active = selected.includes(opt.value);
      return (
        <div key={opt.value} style={{
          padding: '14px 8px 12px', borderRadius: 12, textAlign: 'center',
          background: active ? 'var(--green-pale)' : 'var(--paper)',
          border: '1.5px solid ' + (active ? 'var(--green-deep)' : 'var(--line)'),
          cursor: 'pointer',
          display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6,
        }}>
          <FlavorIcon type={opt.icon} active={active}/>
          <div style={{ fontSize: 11, fontWeight: active ? 700 : 500, color: active ? 'var(--green-deep)' : 'var(--ink)', lineHeight: 1.2 }}>
            {opt.label}
          </div>
          <div style={{ marginTop: 2 }}>
            {active ? <CheckIcon size={16}/> : <EmptyCircle size={16}/>}
          </div>
        </div>
      );
    })}
  </div>
);

// 可计数的列表项（饮品主体 / 淋酱）
const CountableList = ({ options, counts = {} }) => (
  <div>
    {options.map((opt, i) => {
      const count = counts[opt.value] || 0;
      const isLast = i === options.length - 1;
      return (
        <div key={opt.value} style={{
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
          padding: '13px 0',
          borderBottom: isLast ? 'none' : '1px solid var(--line)',
        }}>
          <span style={{ fontSize: 14, fontWeight: 500 }}>{opt.label}</span>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            {count > 0 && (
              <>
                <button style={btnSmallCircle}><I.minus size={14}/></button>
                <span style={{ fontSize: 15, fontWeight: 700, minWidth: 20, textAlign: 'center' }}>{count}</span>
              </>
            )}
            <button style={{
              ...btnSmallCircle,
              background: count === 0 ? 'var(--paper)' : 'var(--green-pale)',
              border: count === 0 ? '1px solid var(--line-2)' : '1px solid var(--green-deep)',
              color: count === 0 ? 'var(--ink)' : 'var(--green-deep)',
            }}><I.plus size={14}/></button>
          </div>
        </div>
      );
    })}
  </div>
);

// 饮品顶部选项（Chip 单选）
const TopChipRow = ({ options, selected }) => (
  <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
    {options.map(opt => {
      const active = opt.value === selected;
      return (
        <div key={opt.value} style={{
          padding: '8px 12px', borderRadius: 10, fontSize: 12,
          fontWeight: active ? 700 : 500,
          background: active ? 'var(--green-pale)' : 'transparent',
          border: '1.5px solid ' + (active ? 'var(--green-deep)' : 'var(--line)'),
          color: active ? 'var(--green-deep)' : 'var(--ink)',
          cursor: 'pointer',
        }}>{opt.label}</div>
      );
    })}
  </div>
);

// 进阶选择标题行（可展开）
const AdvancedHeader = ({ expanded = true }) => (
  <div style={{
    display: 'flex', alignItems: 'center', gap: 10,
    padding: '12px 20px',
    background: 'var(--paper)', margin: '0 20px', borderRadius: 16,
    boxShadow: '0 1px 4px rgba(0,0,0,0.06)',
    cursor: 'pointer',
  }}>
    {/* 小人图标 */}
    <div style={{
      width: 34, height: 34, borderRadius: 17,
      background: 'var(--green-pale)',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      flexShrink: 0,
    }}>
      <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
        <circle cx="10" cy="6" r="3" stroke="var(--green-deep)" strokeWidth="1.4"/>
        <path d="M4 18C4 14.7 6.7 12 10 12C13.3 12 16 14.7 16 18" stroke="var(--green-deep)" strokeWidth="1.4" strokeLinecap="round"/>
      </svg>
    </div>
    <span style={{ fontSize: 14, fontWeight: 700, flex: 1 }}>进阶选择</span>
    <svg width="18" height="18" viewBox="0 0 18 18" fill="none" style={{ transform: expanded ? 'rotate(180deg)' : 'none', transition: '200ms' }}>
      <path d="M4.5 6.75L9 11.25L13.5 6.75" stroke="var(--ink-2)" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  </div>
);

// 五星评分
const StarRating = ({ value = 4 }) => (
  <div style={{ display: 'flex', gap: 6 }}>
    {[1, 2, 3, 4, 5].map(i => (
      <div key={i} style={{ color: i <= value ? 'var(--amber)' : 'var(--line-2)', cursor: 'pointer' }}>
        {i <= value
          ? <I.starFill size={30}/>
          : <I.star size={30}/>}
      </div>
    ))}
  </div>
);

// 价格行（点击弹出数字键盘）
const PriceInput = ({ price = 0, monthTotal = 0 }) => (
  <div style={{
    background: 'var(--green-tint)', borderRadius: 14, margin: '0 20px',
    padding: '14px 16px',
  }}>
    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
      <div>
        <div style={{ fontSize: 11, color: 'var(--ink-2)', marginBottom: 4 }}>本杯花费</div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
          <span style={{ fontSize: 24, fontWeight: 800, color: 'var(--green-deep)', fontFamily: 'ui-monospace, monospace' }}>
            ¥ {price}
          </span>
          {/* 编辑图标 */}
          <div style={{
            width: 22, height: 22, borderRadius: 6,
            background: 'var(--green-pale)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            cursor: 'pointer',
          }}>
            <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
              <path d="M8.5 1.5L10.5 3.5L4 10H2V8L8.5 1.5Z" stroke="var(--green-deep)" strokeWidth="1.2" strokeLinejoin="round"/>
            </svg>
          </div>
        </div>
      </div>
      <div style={{ fontSize: 11, color: 'var(--ink-2)', textAlign: 'right' }}>
        本月累计<br/>
        <span style={{ fontSize: 16, fontWeight: 700, color: 'var(--ink)' }}>¥ {monthTotal}</span>
      </div>
    </div>
    {/* 数字键盘（展示态，实际弹出为模态） */}
    <div style={{
      marginTop: 12, padding: '10px 12px', borderRadius: 10,
      background: 'rgba(255,255,255,0.7)', border: '1px dashed var(--line-2)',
      display: 'flex', alignItems: 'center', gap: 6,
    }}>
      <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
        <rect x="1" y="1" width="5" height="4" rx="1" stroke="var(--ink-3)" strokeWidth="1"/>
        <rect x="8" y="1" width="5" height="4" rx="1" stroke="var(--ink-3)" strokeWidth="1"/>
        <rect x="1" y="7" width="5" height="4" rx="1" stroke="var(--ink-3)" strokeWidth="1"/>
        <rect x="8" y="7" width="5" height="4" rx="1" stroke="var(--ink-3)" strokeWidth="1"/>
      </svg>
      <span style={{ fontSize: 11, color: 'var(--ink-3)' }}>点击价格数字可自定义输入</span>
    </div>
  </div>
);

// ====== 选饮品底部弹层 ======
const DrinkPicker = () => {
  const cats = ['热门', '经典咖啡', '星冰乐', '冰摇茶', '茶瓦纳'];
  const items = ['oat-latte', 'caramel-macchiato', 'latte', 'americano', 'mocha', 'flat-white', 'cappuccino', 'mocha-frap', 'peach-oolong'];
  return (
    <PhoneMF screenLabel="03 选饮品·弹窗">
      <div style={{ flex: 1, position: 'relative', background: 'linear-gradient(to bottom, rgba(0,0,0,0.05), rgba(0,0,0,0.4))' }}>
        <div style={{ position: 'absolute', inset: 0, opacity: 0.5, padding: '14px 24px', pointerEvents: 'none' }}>
          <div style={{ fontSize: 12, color: 'var(--ink-2)' }}>下午好，咖啡因</div>
          <h1 style={{ marginTop: 2 }}>今天喝什么?</h1>
          <div style={{ marginTop: 50, height: 380, background: 'var(--green-tint)', borderRadius: 20 }}/>
        </div>

        <div style={{
          position: 'absolute', left: 0, right: 0, bottom: 0, top: 96,
          background: 'var(--paper)', borderRadius: '24px 24px 0 0',
          boxShadow: '0 -8px 24px rgba(0,0,0,0.12)',
          display: 'flex', flexDirection: 'column',
        }}>
          <div style={{ display: 'flex', justifyContent: 'center', paddingTop: 10 }}>
            <div style={{ width: 40, height: 4, background: 'var(--line-2)', borderRadius: 2 }}/>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '10px 20px 0' }}>
            <h2>选一杯</h2>
            <IconBtn><I.close size={18}/></IconBtn>
          </div>
          <div style={{ padding: '12px 20px 0' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 8, background: 'var(--cream)', borderRadius: 12, padding: '10px 14px', color: 'var(--ink-3)', fontSize: 13 }}>
              <I.search size={18}/>
              <span>搜咖啡名 / 系列</span>
            </div>
          </div>
          <div style={{ display: 'flex', gap: 8, padding: '14px 20px 0', overflowX: 'auto' }}>
            {cats.map((c, i) => <span key={c} className={'pill' + (i === 0 ? ' active' : '')}>{c}</span>)}
          </div>
          <div className="scroll" style={{ flex: 1, overflowY: 'auto', padding: '18px 20px 12px' }}>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', rowGap: 18, columnGap: 12 }}>
              {items.map((id) => {
                const d = DRINKS[id];
                return (
                  <div key={id} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6, position: 'relative' }}>
                    <div style={{ position: 'relative' }}>
                      <DrinkIcon name={id} size={88} bg="var(--cream)"/>
                      {d.drank > 0 && (
                        <div style={{
                          position: 'absolute', top: -2, right: -2,
                          background: 'var(--green-deep)', color: '#fff',
                          fontSize: 10, fontWeight: 700,
                          padding: '2px 7px', borderRadius: 10,
                          boxShadow: '0 2px 6px rgba(14,74,46,0.25)',
                        }}>×{d.drank}</div>
                      )}
                    </div>
                    <div style={{ fontSize: 12, textAlign: 'center', fontWeight: 600, lineHeight: 1.2 }}>{d.name}</div>
                  </div>
                );
              })}
            </div>
          </div>
          <div style={{ padding: '12px 20px 24px', borderTop: '1px solid var(--line)', background: 'var(--paper)' }}>
            <button className="btn-primary" style={{ width: '100%' }}>选好了 · 下一步 →</button>
          </div>
        </div>
      </div>
    </PhoneMF>
  );
};

// ====== 详情记录页（完整模板，所有字段统一展示） ======
const DetailPage = () => (
  <PhoneMF screenLabel="04 详情·记一杯">
    <NavHeader
      left={<IconBtn><I.chevLeft size={20}/></IconBtn>}
      title="记一杯"
      right={<IconBtn><I.heart size={20}/></IconBtn>}
    />

    <Scroll>
      {/* 饮品主图 + 名称 */}
      <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', padding: '6px 20px 20px' }}>
        <div style={{
          width: 160, height: 160, borderRadius: '50%',
          background: 'linear-gradient(135deg, #FAF7F0 0%, #F1ECD7 100%)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: 'inset 0 -4px 12px rgba(0,0,0,0.05)',
        }}>
          <DrinkIcon name="americano" size={148} bg="transparent"/>
        </div>
        <div style={{ fontSize: 20, fontWeight: 800, marginTop: 12, letterSpacing: '-0.01em', textAlign: 'center' }}>
          海盐焦糖风味美式
        </div>
        <div style={{ fontSize: 12, color: 'var(--ink-2)', marginTop: 3 }}>Salted Caramel Americano · 经典咖啡</div>
        <div style={{ display: 'flex', gap: 6, marginTop: 10 }}>
          <span style={{ fontSize: 11, padding: '3px 10px', borderRadius: 8, background: 'var(--green-pale)', color: 'var(--green-deep)', fontWeight: 600 }}>2026/05/13 · 下午</span>
        </div>
      </div>

      {/* ── 数量 ── */}
      <FormCard>
        <Section title="数量">
          <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
            <button style={btnCircle}><I.minus size={16}/></button>
            <div style={{ fontSize: 22, fontWeight: 800, minWidth: 36, textAlign: 'center', fontFamily: 'ui-monospace, monospace' }}>1</div>
            <button style={btnCircle}><I.plus size={16}/></button>
          </div>
        </Section>
      </FormCard>

      <Gap/>

      {/* ── 杯型 ── */}
      <FormCard>
        <Section title="杯型">
          <Segmented items={[
            { label: '中杯',   sub: '355ml', value: 'tall'   },
            { label: '大杯',   sub: '473ml', value: 'grande' },
            { label: '超大杯', sub: '592ml', value: 'venti'  },
          ]} value="grande"/>
        </Section>
      </FormCard>

      <Gap/>

      {/* ── 温度 ── */}
      <FormCard>
        <Section title="温度">
          <ChipRow options={TEMPERATURE_OPTIONS} selected="iced"/>
        </Section>
      </FormCard>

      <Gap/>

      {/* ── 浓缩咖啡（烘焙 + 萃取类型 + 份数三合一） ── */}
      <FormCard>
        <Section title="浓缩咖啡">
          <ChipRow options={ESPRESSO_ROAST_OPTIONS} selected="classic"/>
        </Section>
        <EspressoTypeCards selected="ristretto"/>
        <ShotCountRow count={3}/>
      </FormCard>

      <Gap/>

      {/* ── 添加或更换牛奶 ── */}
      <FormCard>
        <Section title="添加或更换牛奶">
          <ChipRow options={MILK_OPTIONS} selected="whole"/>
        </Section>
      </FormCard>

      <Gap/>

      {/* ── 奶泡 ── */}
      <FormCard>
        <Section title="奶泡"
          extra={<span style={{ fontSize: 11, color: 'var(--ink-3)' }}>未选则不记录</span>}>
          <ChipRow options={FOAM_OPTIONS} selected={null}/>
          <div style={{ fontSize: 11, color: 'var(--ink-3)', marginTop: 2 }}>例：卡布奇诺专属选项，其他饮品如不选则忽略</div>
        </Section>
      </FormCard>

      <Gap/>

      {/* ── 无糖风味定制/添加 ── */}
      <FormCard>
        <Section title="无糖风味定制/添加">
          <FlavorGrid options={SUGAR_FREE_FLAVOR_OPTIONS} selected={['salted-caramel']}/>
        </Section>
      </FormCard>

      <Gap/>

      {/* ── 甜度选择 ── */}
      <FormCard>
        <Section title="甜度选择"
          extra={<span style={{ fontSize: 11, color: 'var(--ink-3)' }}>未选则不记录</span>}>
          <Segmented items={SWEETNESS_OPTIONS} value="no-sugar"/>
        </Section>
      </FormCard>

      <Gap h={16}/>

      {/* ── 进阶选择（折叠区块标题） ── */}
      <AdvancedHeader expanded={true}/>

      <Gap h={10}/>

      {/* ── 饮品主体 ── */}
      <FormCard>
        <Section title="饮品主体"
          extra={<span style={{ fontSize: 11, color: 'var(--ink-3)' }}>未添加则不记录</span>}>
          <CountableList options={DRINK_BASE_OPTIONS} counts={{}}/>
        </Section>
      </FormCard>

      <Gap/>

      {/* ── 饮品顶部 ── */}
      <FormCard>
        <Section title="饮品顶部"
          extra={<span style={{ fontSize: 11, color: 'var(--ink-3)' }}>未选则不记录</span>}>
          <TopChipRow options={DRINK_TOP_OPTIONS} selected={null}/>
        </Section>
      </FormCard>

      <Gap/>

      {/* ── 淋酱/其它 ── */}
      <FormCard>
        <Section title="淋酱/其它"
          extra={<span style={{ fontSize: 11, color: 'var(--ink-3)' }}>未添加则不记录</span>}>
          <CountableList options={SAUCE_OPTIONS} counts={{}}/>
        </Section>
      </FormCard>

      <Gap h={16}/>

      {/* ── 价格（点击自定义输入） ── */}
      <PriceInput price={33} monthTotal={653}/>

      <Gap h={16}/>

      {/* ── 今日感受（评分） ── */}
      <FormCard>
        <Section title="今日感受">
          <StarRating value={4}/>
        </Section>
      </FormCard>

      <Gap/>

      {/* ── 留言评论 ── */}
      <FormCard>
        <Section title="留言评论">
          <div style={{
            border: '1px solid var(--line)', borderRadius: 12,
            padding: 12, fontSize: 13, color: 'var(--ink-3)',
            minHeight: 80, background: 'var(--paper-2)', lineHeight: 1.6,
          }}>写点什么…（地点 / 心情 / 配什么吃的）</div>
        </Section>
      </FormCard>

      <Gap h={24}/>

      {/* ── 底部操作栏 ── */}
      <div style={{ padding: '8px 20px 24px', display: 'flex', gap: 10, background: 'var(--paper)', borderTop: '1px solid var(--line)' }}>
        <button className="btn-ghost" style={{ flex: '0 0 92px' }}>重新定制</button>
        <button className="btn-primary" style={{ flex: 1 }}>保存这一杯 ✓</button>
      </div>
    </Scroll>
  </PhoneMF>
);

Object.assign(window, { DrinkPicker, DetailPage });
