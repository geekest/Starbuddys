// mid/system.jsx — phone frame, tab bar, shared atoms

const PhoneMF = ({ children, screenLabel, bg = 'var(--paper)' }) => (
  <div className="phone-mf mf" data-screen-label={screenLabel} style={{ background: bg }}>
    <div className="island"></div>
    <div className="status">
      <span>9:41</span>
      <span style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
        <svg width="18" height="11" viewBox="0 0 18 11" fill="currentColor"><rect x="0" y="6" width="3" height="5" rx="0.5"/><rect x="5" y="3.5" width="3" height="7.5" rx="0.5"/><rect x="10" y="1" width="3" height="10" rx="0.5"/><rect x="15" y="-1" width="3" height="12" rx="0.5" opacity="0.3"/></svg>
        <svg width="16" height="11" viewBox="0 0 16 11" fill="none" stroke="currentColor" strokeWidth="1.4"><path d="M8 3.5 C 10.5 3.5 12.5 4.4 14 5.6"/><path d="M8 5.7 C 9.6 5.7 11 6.3 12 7.2"/><circle cx="8" cy="9" r="1.1" fill="currentColor" stroke="none"/></svg>
        <svg width="26" height="12" viewBox="0 0 26 12" fill="none"><rect x="0.5" y="0.5" width="22" height="11" rx="2.5" stroke="currentColor" opacity="0.6"/><rect x="23.5" y="3.5" width="2" height="5" rx="0.5" fill="currentColor" opacity="0.4"/><rect x="2" y="2" width="17" height="8" rx="1.5" fill="currentColor"/></svg>
      </span>
    </div>
    <div className="body">{children}</div>
  </div>
);

const TabBarMF = ({ active = 'drink' }) => {
  const tabs = [
    ['drink',   '喝一杯', I.tabDrink],
    ['library', '饮品库', I.tabLibrary],
    ['history', '历史',   I.tabHistory],
    ['me',      '我的',   I.tabMe],
  ];
  return (
    <div className="tabbar">
      {tabs.map(([k, label, icon]) => (
        <div key={k} className={'tab' + (k === active ? ' active' : '')}>
          <span className="ic">{icon({ size: 24, active: k === active })}</span>
          <span style={{ fontWeight: k === active ? 600 : 500 }}>{label}</span>
        </div>
      ))}
    </div>
  );
};

// scroll area
const Scroll = ({ children, style }) => (
  <div className="scroll" style={{ flex: 1, minHeight: 0, overflowY: 'auto', ...style }}>{children}</div>
);

// nav header
const NavHeader = ({ left, title, right, sticky = false, style }) => (
  <div style={{
    display: 'flex', alignItems: 'center', justifyContent: 'space-between',
    padding: '8px 20px', minHeight: 44,
    background: 'var(--paper)',
    position: sticky ? 'sticky' : 'relative', top: 0, zIndex: 5,
    ...style,
  }}>
    <div style={{ display: 'flex', alignItems: 'center', gap: 8, minWidth: 44 }}>{left}</div>
    <div style={{ fontSize: 16, fontWeight: 700 }}>{title}</div>
    <div style={{ display: 'flex', alignItems: 'center', gap: 8, minWidth: 44, justifyContent: 'flex-end' }}>{right}</div>
  </div>
);

// icon button
const IconBtn = ({ children, onClick, style }) => (
  <button onClick={onClick} style={{
    width: 36, height: 36, borderRadius: 12,
    background: 'var(--paper)', border: '1px solid var(--line)',
    display: 'flex', alignItems: 'center', justifyContent: 'center',
    color: 'var(--ink)', padding: 0, cursor: 'pointer',
    ...style,
  }}>{children}</button>
);

// progress bar
const Progress = ({ value, total, color = 'var(--green)', height = 6 }) => (
  <div style={{ height, background: 'var(--green-pale)', borderRadius: height / 2, overflow: 'hidden' }}>
    <div style={{ width: `${Math.min(100, value/total*100)}%`, height: '100%', background: color }} />
  </div>
);

// segmented control (used for cup size, sugar etc)
const Segmented = ({ items, value, accent = 'var(--green-deep)' }) => (
  <div style={{ display: 'flex', gap: 8 }}>
    {items.map((it, i) => {
      const active = (value === undefined ? i === 0 : value === it.value);
      return (
        <div key={i} style={{
          flex: 1, padding: '10px 8px', borderRadius: 12, textAlign: 'center',
          background: active ? 'var(--green-pale)' : 'var(--paper)',
          border: '1.5px solid ' + (active ? accent : 'var(--line)'),
          color: active ? accent : 'var(--ink)',
          transition: 'all 120ms',
        }}>
          <div style={{ fontSize: 13, fontWeight: active ? 700 : 500 }}>{it.label}</div>
          {it.sub && <div style={{ fontSize: 10, color: active ? accent : 'var(--ink-3)', marginTop: 2, opacity: 0.8 }}>{it.sub}</div>}
        </div>
      );
    })}
  </div>
);

// chip group (for temperature, milk options etc)
const ChipGroup = ({ items, value }) => (
  <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
    {items.map((it, i) => {
      const active = (value === undefined ? i === Math.min(items.length-1, 1) : value === it);
      return (
        <span key={i} className={'pill' + (active ? ' soft' : '')}>{it}</span>
      );
    })}
  </div>
);

Object.assign(window, { PhoneMF, TabBarMF, Scroll, NavHeader, IconBtn, Progress, Segmented, ChipGroup });
