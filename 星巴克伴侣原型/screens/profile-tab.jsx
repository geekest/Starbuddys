// profile-tab.jsx — 我的 tab, 3 variants of badge wall

// ---------- shared user header ----------
const UserHeader = ({ compact }) => (
  <div style={{ padding: compact ? '12px 20px 8px' : '14px 20px 10px', display: 'flex', alignItems: 'center', gap: 12 }}>
    <div className="ph" style={{ width: compact ? 48 : 56, height: compact ? 48 : 56, borderRadius: '50%' }}>头像</div>
    <div style={{ flex: 1 }}>
      <div style={{ fontSize: 16, fontWeight: 700 }}>咖啡因爱好者</div>
      <div style={{ fontSize: 11, color: 'var(--ink-muted)' }}>累计 187 杯 · Lv.7 · 加入 142 天</div>
    </div>
    <div style={{ fontSize: 11, color: 'var(--ink-muted)' }}>设置 ⚙</div>
  </div>
);

// shared badge styles
const BadgeIcons = {
  cup:    <svg width="34" height="34" viewBox="0 0 34 34"><path d="M9 10 H25 L23 27 Q23 29 21 29 H13 Q11 29 11 27 Z" fill="#fff" stroke="#1f1f1d" strokeWidth="1.5"/><path d="M9 15 H25" stroke="#1f1f1d"/><path d="M25 13 Q30 13 30 18 Q30 23 25 23" fill="none" stroke="#1f1f1d" strokeWidth="1.5"/></svg>,
  bean:   <svg width="34" height="34" viewBox="0 0 34 34"><ellipse cx="17" cy="17" rx="9" ry="12" fill="#1f5c3f" stroke="#1f1f1d" strokeWidth="1.5"/><path d="M17 6 Q14 17 17 28" stroke="#fff" strokeWidth="1.2" fill="none"/></svg>,
  latte:  <svg width="34" height="34" viewBox="0 0 34 34"><circle cx="17" cy="17" r="11" fill="#fff" stroke="#1f1f1d" strokeWidth="1.5"/><path d="M11 17 Q14 14 17 17 Q20 20 23 17" stroke="#1f5c3f" strokeWidth="1.5" fill="none"/><circle cx="14" cy="14" r="1.5" fill="#1f1f1d"/></svg>,
  snow:   <svg width="34" height="34" viewBox="0 0 34 34"><path d="M9 12 L17 8 L25 12 L25 22 L17 26 L9 22 Z" fill="#e3ede5" stroke="#1f1f1d" strokeWidth="1.5"/><text x="17" y="20" textAnchor="middle" fontSize="11" fill="#1f1f1d">★</text></svg>,
  leaf:   <svg width="34" height="34" viewBox="0 0 34 34"><path d="M9 25 Q9 10 25 9 Q24 25 9 25 Z" fill="#1f5c3f" opacity="0.85" stroke="#1f1f1d" strokeWidth="1.5"/><path d="M9 25 L20 14" stroke="#fff" strokeWidth="1"/></svg>,
  steam:  <svg width="34" height="34" viewBox="0 0 34 34"><rect x="10" y="14" width="14" height="15" fill="#fff" stroke="#1f1f1d" strokeWidth="1.5"/><path d="M14 12 Q12 8 16 6" stroke="#1f1f1d" strokeWidth="1.2" fill="none"/><path d="M20 12 Q18 8 22 6" stroke="#1f1f1d" strokeWidth="1.2" fill="none"/></svg>,
  art:    <svg width="34" height="34" viewBox="0 0 34 34"><circle cx="17" cy="17" r="11" fill="#fff" stroke="#1f1f1d" strokeWidth="1.5"/><path d="M11 14 Q17 22 23 14 Q17 24 11 14" fill="#5a3a1a" stroke="#1f1f1d" strokeWidth="0.8"/></svg>,
  crown:  <svg width="34" height="34" viewBox="0 0 34 34"><path d="M7 24 L9 12 L14 17 L17 10 L20 17 L25 12 L27 24 Z" fill="#f7d28a" stroke="#1f1f1d" strokeWidth="1.5"/><rect x="7" y="24" width="20" height="3" fill="#1f1f1d"/></svg>,
  fire:   <svg width="34" height="34" viewBox="0 0 34 34"><path d="M17 6 Q22 12 22 18 Q22 26 17 28 Q12 26 12 18 Q12 14 17 6 Z" fill="#c96442" stroke="#1f1f1d" strokeWidth="1.5"/></svg>,
};

// One badge: ring + icon + name + progress
const Badge = ({ kind, name, prog, total, locked, size = 78, unlocked }) => {
  const isUnlocked = unlocked ?? (prog >= total);
  return (
    <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4 }}>
      <div style={{
        width: size, height: size, borderRadius: '50%',
        background: isUnlocked ? 'var(--accent-soft)' : '#eeece6',
        border: '1.5px solid ' + (isUnlocked ? 'var(--accent)' : 'var(--line-soft)'),
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        position: 'relative', opacity: isUnlocked ? 1 : 0.6,
      }}>
        {BadgeIcons[kind]}
        {locked && (
          <div style={{ position: 'absolute', inset: 0, background: 'rgba(255,255,255,0.55)', borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 18 }}>🔒</div>
        )}
      </div>
      <div style={{ fontSize: 11, fontWeight: 600, textAlign: 'center' }}>{name}</div>
      <div style={{ fontSize: 10, color: isUnlocked ? 'var(--accent)' : 'var(--ink-muted)' }}>{prog} / {total}</div>
    </div>
  );
};

const SettingsList = () => (
  <div style={{ padding: '6px 20px 12px' }}>
    <div style={{ fontSize: 12, color: 'var(--ink-soft)', margin: '6px 0' }}>设置</div>
    <div style={{ border: '1.2px solid var(--line-soft)', borderRadius: 12, overflow: 'hidden' }}>
      {[
        ['↗', '分享给朋友', ''],
        ['◐', '语言', '简体中文'],
        ['✎', '意见反馈', ''],
        ['★', '给我们评价', ''],
        ['ⓘ', '关于 StarBuddys', 'v 1.0.0'],
      ].map(([ic, name, sub], i, arr) => (
        <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '12px 14px', borderBottom: i < arr.length - 1 ? '1px solid var(--line-soft)' : 'none' }}>
          <div style={{ width: 22, height: 22, borderRadius: 6, background: 'var(--paper-soft)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 12 }}>{ic}</div>
          <div style={{ fontSize: 13, flex: 1 }}>{name}</div>
          <div style={{ fontSize: 11, color: 'var(--ink-muted)' }}>{sub}</div>
          <div style={{ color: 'var(--ink-muted)' }}>›</div>
        </div>
      ))}
    </div>
  </div>
);

// ============= V1 — 网格徽章墙 =============
const ProfileV1 = () => {
  const badges = [
    ['cup',   '初尝者',     10, 10],
    ['cup',   '常客',       50, 50],
    ['cup',   '老饕',       50, 100],
    ['bean',  '咖啡迷',     10, 10],
    ['bean',  '半个鉴赏家', 12, 24],
    ['bean',  '全饮品达人',12, 48],
    ['latte', '拿铁忠粉',   23, 50],
    ['latte', '美式信徒',    8, 50],
    ['snow',  '星冰乐控',    3, 4],
    ['leaf',  '冰摇茶探险家',2, 3],
    ['fire',  '同款 ×100',  47, 100],
    ['crown', '里程碑 500', 187, 500],
  ];
  return (
    <Phone screenLabel="09 我的 · 网格徽章墙">
      <UserHeader />

      <Screen scroll>
        <div style={{ padding: '0 20px 8px' }}>
          {/* level progress */}
          <div style={{ border: '1.2px solid var(--line)', borderRadius: 12, padding: 12, marginBottom: 12 }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 11, color: 'var(--ink-muted)' }}>
              <span>Lv.7 咖啡迷</span><span>距离 Lv.8 · 13 杯</span>
            </div>
            <div style={{ height: 8, background: 'var(--paper-soft)', borderRadius: 4, marginTop: 6 }}>
              <div style={{ width: '62%', height: '100%', background: 'var(--accent)', borderRadius: 4 }}/>
            </div>
          </div>

          {/* section header */}
          <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', margin: '8px 0' }}>
            <div style={{ fontSize: 14, fontWeight: 600 }}>成就徽章</div>
            <div style={{ fontSize: 11, color: 'var(--accent)' }}>8 / 24  ›</div>
          </div>

          {/* badges grid */}
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', rowGap: 18, columnGap: 10 }}>
            {badges.map((b, i) => (
              <Badge key={i} kind={b[0]} name={b[1]} prog={b[2]} total={b[3]} />
            ))}
          </div>
        </div>

        <SettingsList />
      </Screen>

      <div className="callout" style={{ position: 'absolute', top: 60, right: 6, width: 80 }}>顶部用户信息</div>
      <div className="callout" style={{ position: 'absolute', top: 280, right: 6, width: 80 }}>3 列网格<br/>勋章+进度</div>

      <TabBar active="me" />
    </Phone>
  );
};

// ============= V2 — 精选大卡 + 小徽章 =============
const ProfileV2 = () => {
  const small = [
    ['bean', '咖啡迷', 10, 10],
    ['snow', '星冰乐控', 3, 4],
    ['latte', '拿铁忠粉', 23, 50],
    ['fire', '同款 ×100', 47, 100],
    ['crown', '里程碑 500', 187, 500],
    ['leaf', '冰摇茶探险家', 2, 3],
    ['art', '风味多变', 6, 10],
    ['steam', '热饮派', 89, 100],
  ];
  return (
    <Phone screenLabel="10 我的 · 精选大卡">
      <UserHeader compact />

      <Screen scroll>
        <div style={{ padding: '0 20px 8px' }}>
          {/* highlight badge card */}
          <div style={{ border: '1.5px solid var(--accent)', borderRadius: 14, padding: 14, background: 'var(--accent-soft)', position: 'relative' }}>
            <div style={{ fontSize: 10, color: 'var(--accent)', letterSpacing: '0.1em' }}>RECENTLY UNLOCKED</div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 14, marginTop: 8 }}>
              <div style={{ width: 76, height: 76, borderRadius: '50%', background: 'var(--paper)', border: '1.5px solid var(--accent)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                {BadgeIcons.crown}
              </div>
              <div>
                <div style={{ fontSize: 17, fontWeight: 700 }}>咖啡因王者</div>
                <div style={{ fontSize: 11, color: 'var(--ink-soft)', marginTop: 2 }}>累计 100 杯达成</div>
                <div style={{ fontSize: 10, color: 'var(--ink-muted)', marginTop: 4 }}>5 月 9 日 · 解锁</div>
              </div>
            </div>
            {/* dot pagination */}
            <div style={{ display: 'flex', justifyContent: 'center', gap: 4, marginTop: 10 }}>
              {[0,1,2].map(i => <div key={i} style={{ width: 6, height: 6, borderRadius: 3, background: i === 0 ? 'var(--accent)' : 'var(--line-soft)' }}/>)}
            </div>
          </div>

          {/* progress in progress */}
          <div style={{ marginTop: 14, fontSize: 13, fontWeight: 600 }}>进行中</div>
          <div style={{ display: 'flex', gap: 8, overflowX: 'auto', padding: '8px 0 4px' }}>
            {[
              ['latte', '拿铁忠粉', 23, 50],
              ['fire', '同款 ×100', 47, 100],
              ['crown', '里程碑 500', 187, 500],
            ].map((b, i) => (
              <div key={i} style={{ flex: '0 0 auto', width: 130, border: '1.2px solid var(--line-soft)', borderRadius: 10, padding: 10 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                  <div style={{ width: 36, height: 36, borderRadius: 18, background: 'var(--paper-soft)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>{BadgeIcons[b[0]]}</div>
                  <div style={{ fontSize: 12, fontWeight: 600 }}>{b[1]}</div>
                </div>
                <div style={{ fontSize: 10, color: 'var(--ink-muted)', marginTop: 6 }}>{b[2]} / {b[3]}</div>
                <div style={{ height: 4, background: 'var(--paper-soft)', borderRadius: 2, marginTop: 4 }}>
                  <div style={{ width: `${(b[2]/b[3]*100)|0}%`, height: '100%', background: 'var(--accent)', borderRadius: 2 }}/>
                </div>
              </div>
            ))}
          </div>

          {/* all badges grid */}
          <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginTop: 12 }}>
            <div style={{ fontSize: 13, fontWeight: 600 }}>已解锁徽章</div>
            <div style={{ fontSize: 11, color: 'var(--accent)' }}>查看全部 ›</div>
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', rowGap: 12, columnGap: 6, marginTop: 8 }}>
            {small.map((b, i) => (
              <Badge key={i} kind={b[0]} name={b[1]} prog={b[2]} total={b[3]} size={56} />
            ))}
          </div>
        </div>

        <SettingsList />
      </Screen>

      <div className="callout" style={{ position: 'absolute', top: 100, right: 6, width: 88 }}>顶部一张<br/>精选大卡<br/>左右滑切换</div>
      <div className="callout" style={{ position: 'absolute', top: 280, right: 6, width: 86 }}>"进行中"<br/>横滑卡片</div>

      <TabBar active="me" />
    </Phone>
  );
};

// ============= V3 — 分类列表（分组式徽章墙） =============
const ProfileV3 = () => {
  const groups = [
    {
      title: '饮品收集',
      subtitle: '12 / 48',
      icons: [
        ['bean', 1], ['bean', 1], ['bean', 1], ['bean', 0],
      ],
    },
    {
      title: '类型大师',
      subtitle: '2 / 5',
      icons: [
        ['snow', 1], ['leaf', 1], ['latte', 0], ['art', 0],
      ],
    },
    {
      title: '单品狂热',
      subtitle: '燕麦拿铁 47 / 100',
      icons: [
        ['fire', 1], ['fire', 1], ['fire', 0], ['fire', 0],
      ],
    },
    {
      title: '里程碑',
      subtitle: '累计 187 杯',
      icons: [
        ['cup', 1], ['cup', 1], ['crown', 0], ['crown', 0],
      ],
    },
  ];

  return (
    <Phone screenLabel="11 我的 · 分类徽章墙">
      <UserHeader compact />

      <Screen scroll>
        <div style={{ padding: '0 20px 8px' }}>
          {/* top stats */}
          <div style={{ display: 'flex', gap: 8, marginBottom: 12 }}>
            {[['187', '总杯数'], ['12', '已解锁'], ['7', '天连击']].map(([n, l], i) => (
              <div key={i} style={{ flex: 1, border: '1.2px solid var(--line-soft)', borderRadius: 10, padding: 10, textAlign: 'center' }}>
                <div style={{ fontSize: 18, fontWeight: 700, color: 'var(--accent)' }}>{n}</div>
                <div style={{ fontSize: 10, color: 'var(--ink-muted)' }}>{l}</div>
              </div>
            ))}
          </div>

          {/* groups */}
          {groups.map((g, gi) => (
            <div key={gi} style={{ marginTop: gi === 0 ? 4 : 16, border: '1.2px solid var(--line-soft)', borderRadius: 12, padding: 12 }}>
              <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
                <div>
                  <div style={{ fontSize: 13, fontWeight: 600 }}>{g.title}</div>
                  <div style={{ fontSize: 10, color: 'var(--ink-muted)', marginTop: 1 }}>{g.subtitle}</div>
                </div>
                <div style={{ fontSize: 11, color: 'var(--accent)' }}>展开 ›</div>
              </div>
              <div style={{ display: 'flex', gap: 10, marginTop: 10 }}>
                {g.icons.map((it, i) => (
                  <div key={i} style={{
                    flex: 1, aspectRatio: '1', borderRadius: '50%',
                    background: it[1] ? 'var(--accent-soft)' : '#eeece6',
                    border: '1.2px solid ' + (it[1] ? 'var(--accent)' : 'var(--line-soft)'),
                    display: 'flex', alignItems: 'center', justifyContent: 'center',
                    opacity: it[1] ? 1 : 0.6,
                    position: 'relative',
                  }}>
                    <div style={{ transform: 'scale(0.7)' }}>{BadgeIcons[it[0]]}</div>
                    {!it[1] && <div style={{ position: 'absolute', fontSize: 12 }}>🔒</div>}
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>

        <SettingsList />
      </Screen>

      <div className="callout" style={{ position: 'absolute', top: 80, right: 6, width: 80 }}>顶部三色统计</div>
      <div className="callout" style={{ position: 'absolute', top: 220, right: 6, width: 86 }}>按主题分组<br/>每组 4 颗代表</div>

      <TabBar active="me" />
    </Phone>
  );
};

Object.assign(window, { ProfileV1, ProfileV2, ProfileV3 });
