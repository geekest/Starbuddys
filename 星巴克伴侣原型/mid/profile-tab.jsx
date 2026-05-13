// mid/profile-tab.jsx — 我的·分类徽章墙

const ACHIEVEMENT_GROUPS = [
  {
    title: '饮品收集',
    subtitle: '已收集 12 / 15 款',
    progress: 12 / 15,
    badges: [
      { kind: 'starter', name: '初尝者', desc: '解锁 10 款', prog: 12, total: 10, unlocked: true },
      { kind: 'half',    name: '半个鉴赏家', desc: '解锁 24 款', prog: 12, total: 24, unlocked: false },
      { kind: 'full',    name: '全饮品达人', desc: '解锁全部款式', prog: 12, total: 48, unlocked: false },
      { kind: 'starter', name: '新品先锋', desc: '当月新品全喝', prog: 1, total: 3, unlocked: false, locked: true },
    ],
  },
  {
    title: '类型大师',
    subtitle: '0 / 3 类已通关',
    progress: 0,
    badges: [
      { kind: 'classicMaster', name: '经典咖啡通关', desc: '喝过全部经典咖啡', prog: 7, total: 9, unlocked: false },
      { kind: 'frapMaster',    name: '星冰乐通关', desc: '喝过全部星冰乐', prog: 2, total: 4, unlocked: false },
      { kind: 'teaMaster',     name: '冰摇茶通关', desc: '喝过全部冰摇茶', prog: 2, total: 3, unlocked: false },
      { kind: 'frapMaster',    name: '茶瓦纳通关', desc: '解锁全部茶瓦纳', prog: 0, total: 5, unlocked: false, locked: true },
    ],
  },
  {
    title: '单品狂热',
    subtitle: '燕麦丝绒拿铁 47 杯',
    progress: 0.47,
    badges: [
      { kind: 'fan10',  name: '一见钟情',  desc: '同款喝 10 次', prog: 47, total: 10, unlocked: true },
      { kind: 'fan50',  name: '老情人',    desc: '同款喝 50 次', prog: 47, total: 50, unlocked: false },
      { kind: 'fan100', name: '此生挚爱',  desc: '同款喝 100 次', prog: 47, total: 100, unlocked: false },
      { kind: 'fan10',  name: '专一',      desc: '一周只喝一款', prog: 5, total: 7, unlocked: false },
    ],
  },
  {
    title: '累计里程碑',
    subtitle: '累计 187 杯',
    progress: 187 / 500,
    badges: [
      { kind: 'starter', name: '100 杯',  desc: '累计达 100 杯', prog: 187, total: 100, unlocked: true },
      { kind: 'cup100',  name: '200 杯',  desc: '累计达 200 杯', prog: 187, total: 200, unlocked: false },
      { kind: 'cup500',  name: '500 杯',  desc: '累计达 500 杯', prog: 187, total: 500, unlocked: false },
      { kind: 'cup500',  name: '1000 杯', desc: '累计达 1000 杯', prog: 187, total: 1000, unlocked: false, locked: true },
    ],
  },
];

const ProfileTab = () => (
  <PhoneMF screenLabel="07 我的·分类徽章墙">
    {/* user header */}
    <div style={{ background: 'linear-gradient(135deg, #0E4A2E 0%, #185F40 100%)', color: '#fff', padding: '10px 20px 20px', position: 'relative' }}>
      <div style={{ display: 'flex', justifyContent: 'flex-end' }}>
        <button style={{ background: 'rgba(255,255,255,0.12)', border: 'none', borderRadius: 10, color: '#fff', padding: 8, display: 'flex' }}>
          <I.settings size={18}/>
        </button>
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 14, marginTop: -4 }}>
        <div style={{
          width: 64, height: 64, borderRadius: 32,
          background: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: '0 4px 12px rgba(0,0,0,0.20)',
        }}>
          <DrinkIcon name="oat-latte" size={56} bg="transparent"/>
        </div>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 18, fontWeight: 800 }}>咖啡因爱好者</div>
          <div style={{ fontSize: 11, opacity: 0.8, marginTop: 2 }}>加入 142 天 · Lv.7 咖啡迷</div>
        </div>
      </div>

      {/* lv progress */}
      <div style={{ marginTop: 14, background: 'rgba(255,255,255,0.10)', borderRadius: 12, padding: '10px 14px' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 11, opacity: 0.85 }}>
          <span>Lv.7 · 187 杯</span>
          <span>Lv.8 · 还差 13 杯</span>
        </div>
        <div style={{ height: 5, background: 'rgba(255,255,255,0.15)', borderRadius: 3, marginTop: 6, overflow: 'hidden' }}>
          <div style={{ width: '74%', height: '100%', background: '#F6EDD7' }}/>
        </div>
      </div>

      {/* quick stats */}
      <div style={{ display: 'flex', justifyContent: 'space-around', marginTop: 14 }}>
        {[['187', '总杯数'], ['12', '已解锁'], ['7', '天连击'], ['¥3.6k', '累计花费']].map(([n, l], i, arr) => (
          <div key={i} style={{ flex: 1, textAlign: 'center', position: 'relative' }}>
            <div style={{ fontSize: 18, fontWeight: 800, fontFamily: 'ui-monospace, monospace' }}>{n}</div>
            <div style={{ fontSize: 10, opacity: 0.8, marginTop: 1 }}>{l}</div>
            {i < arr.length - 1 && <div style={{ position: 'absolute', right: 0, top: 4, bottom: 4, width: 1, background: 'rgba(255,255,255,0.16)' }}/>}
          </div>
        ))}
      </div>
    </div>

    <Scroll>
      {/* badge groups */}
      <div style={{ padding: '14px 20px 0' }}>
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 8 }}>
          <h2>成就徽章</h2>
          <span style={{ fontSize: 11, color: 'var(--green-deep)', fontWeight: 600 }}>查看全部 →</span>
        </div>

        {ACHIEVEMENT_GROUPS.map((g, gi) => (
          <div key={g.title} className="mf-card" style={{ marginTop: 12, padding: 14, border: '1px solid var(--line)' }}>
            <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between' }}>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 14, fontWeight: 700 }}>{g.title}</div>
                <div style={{ fontSize: 11, color: 'var(--ink-2)', marginTop: 2 }}>{g.subtitle}</div>
                <div style={{ height: 4, background: 'var(--green-pale)', borderRadius: 2, marginTop: 6, width: 160 }}>
                  <div style={{ width: `${Math.min(100, g.progress*100)}%`, height: '100%', background: 'var(--green-deep)', borderRadius: 2 }}/>
                </div>
              </div>
              <span style={{ fontSize: 11, color: 'var(--green-deep)', fontWeight: 600 }}>展开 ›</span>
            </div>

            {/* 4 badge representatives */}
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr 1fr', gap: 10, marginTop: 14 }}>
              {g.badges.map((b, bi) => (
                <div key={bi} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4 }}>
                  <Badge kind={b.kind} unlocked={b.unlocked && !b.locked} size={56}/>
                  <div style={{ fontSize: 10, textAlign: 'center', fontWeight: b.unlocked ? 700 : 500, color: b.unlocked ? 'var(--ink)' : 'var(--ink-3)', lineHeight: 1.2 }}>{b.name}</div>
                  <div style={{ fontSize: 9, color: b.unlocked ? 'var(--green-deep)' : 'var(--ink-3)' }}>
                    {b.locked ? '未解锁' : `${Math.min(b.prog, b.total)}/${b.total}`}
                  </div>
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>

      {/* settings */}
      <div style={{ padding: '20px 20px 24px' }}>
        <div style={{ fontSize: 14, fontWeight: 700, marginBottom: 10 }}>支持与设置</div>
        <div className="mf-card" style={{ border: '1px solid var(--line)', overflow: 'hidden' }}>
          {[
            ['share', '分享给朋友', null, I.share],
            ['lang', '语言', '简体中文', I.globe],
            ['fb', '意见反馈', null, I.message],
            ['rate', '给我们评价', '★★★★☆', I.star],
            ['about', '关于 StarBuddys', 'v 1.0.0', I.info],
          ].map(([k, name, sub, Ic], i, arr) => (
            <div key={k} style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '14px 14px', borderBottom: i < arr.length - 1 ? '1px solid var(--line)' : 'none' }}>
              <div style={{ width: 32, height: 32, borderRadius: 10, background: 'var(--green-pale)', color: 'var(--green-deep)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                <Ic size={16}/>
              </div>
              <div style={{ flex: 1, fontSize: 14, fontWeight: 500 }}>{name}</div>
              {sub && <div style={{ fontSize: 11, color: 'var(--ink-3)' }}>{sub}</div>}
              <I.chevRight size={16} style={{ color: 'var(--ink-3)' }}/>
            </div>
          ))}
        </div>

        <div style={{ textAlign: 'center', fontSize: 10, color: 'var(--ink-3)', marginTop: 16 }}>
          StarBuddys · v 1.0.0 (build 2026.05)
        </div>
      </div>
    </Scroll>

    <TabBarMF active="me"/>
  </PhoneMF>
);

Object.assign(window, { ProfileTab });
