// phone.jsx — low-fi phone frame + tab bar shared across all screens

const Phone = ({ children, screenLabel }) => (
  <div className="phone wf" data-screen-label={screenLabel}>
    <div className="phone-status">
      <span>9:41</span>
      <span className="status-icons">
        <svg width="16" height="10" viewBox="0 0 16 10" fill="none"><rect x="0.5" y="3" width="2" height="6" stroke="currentColor"/><rect x="4" y="2" width="2" height="7" stroke="currentColor"/><rect x="7.5" y="0.5" width="2" height="9" stroke="currentColor"/><rect x="11" y="0.5" width="2" height="9" stroke="currentColor"/></svg>
        <svg width="14" height="10" viewBox="0 0 14 10" fill="none"><path d="M7 2 C 9.5 2 11.6 3 13 4.3" stroke="currentColor" fill="none"/><path d="M7 4.5 C 8.6 4.5 10 5.1 11 6" stroke="currentColor" fill="none"/><circle cx="7" cy="7.5" r="1" fill="currentColor"/></svg>
        <svg width="22" height="10" viewBox="0 0 22 10" fill="none"><rect x="0.5" y="0.5" width="18" height="9" rx="2" stroke="currentColor"/><rect x="19.5" y="3.5" width="1.5" height="3" fill="currentColor"/><rect x="2" y="2" width="13" height="6" fill="currentColor"/></svg>
      </span>
    </div>
    <div className="phone-body">{children}</div>
  </div>
);

const TabIcon = ({ name }) => {
  // simple line icons; all 22x22 in a circle
  const icons = {
    drink: <svg width="14" height="16" viewBox="0 0 14 16" fill="none"><path d="M2 4 H12 L11 14 Q11 15 10 15 H4 Q3 15 3 14 Z" stroke="currentColor" strokeWidth="1.3"/><path d="M3 7 H11" stroke="currentColor" strokeWidth="1"/></svg>,
    library: <svg width="16" height="14" viewBox="0 0 16 14" fill="none"><rect x="1" y="1" width="4" height="4" rx="0.5" stroke="currentColor"/><rect x="6" y="1" width="4" height="4" rx="0.5" stroke="currentColor"/><rect x="11" y="1" width="4" height="4" rx="0.5" stroke="currentColor"/><rect x="1" y="6" width="4" height="4" rx="0.5" stroke="currentColor"/><rect x="6" y="6" width="4" height="4" rx="0.5" stroke="currentColor"/><rect x="11" y="6" width="4" height="4" rx="0.5" stroke="currentColor"/></svg>,
    history: <svg width="14" height="14" viewBox="0 0 14 14" fill="none"><rect x="1" y="2" width="12" height="11" rx="1" stroke="currentColor"/><path d="M1 5 H13" stroke="currentColor"/><path d="M4 1 V3" stroke="currentColor"/><path d="M10 1 V3" stroke="currentColor"/></svg>,
    me: <svg width="14" height="14" viewBox="0 0 14 14" fill="none"><circle cx="7" cy="5" r="2.5" stroke="currentColor"/><path d="M2 13 Q2 8.5 7 8.5 Q12 8.5 12 13" stroke="currentColor" fill="none"/></svg>,
  };
  return <div className="tab-icon" style={{border:'none'}}>{icons[name]}</div>;
};

const TabBar = ({ active = 'drink' }) => (
  <div className="phone-tab">
    {[
      ['drink', '喝一杯'],
      ['library', '饮品库'],
      ['history', '历史'],
      ['me', '我的'],
    ].map(([k, label]) => (
      <div key={k} className={'tab-item' + (k === active ? ' active' : '')}>
        <TabIcon name={k} />
        <span>{label}</span>
      </div>
    ))}
  </div>
);

// Common scrollable content area
const Screen = ({ children, scroll = false, style }) => (
  <div style={{ flex: 1, minHeight: 0, overflow: scroll ? 'auto' : 'hidden', ...style }}>
    {children}
  </div>
);

// small low-fi atoms
const Box = ({ children, style, className = '', ...rest }) => (
  <div className={'stroke ' + className} style={{ borderRadius: 6, padding: 8, ...style }} {...rest}>{children}</div>
);
const Hatched = ({ style, label, ...rest }) => (
  <div className="ph" style={style} {...rest}>{label}</div>
);
const Pill = ({ children, active, style }) => (
  <span style={{
    display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
    padding: '4px 10px', borderRadius: 999,
    border: '1.2px solid ' + (active ? 'var(--accent)' : 'var(--line)'),
    background: active ? 'var(--accent-soft)' : 'transparent',
    color: active ? 'var(--accent)' : 'var(--ink)',
    fontSize: 11, fontWeight: active ? 600 : 400, ...style,
  }}>{children}</span>
);
const Anno = ({ children, style }) => (
  <div style={{
    color: 'var(--accent)', fontSize: 11, fontStyle: 'italic',
    display: 'flex', alignItems: 'center', gap: 4, ...style,
  }}>{children}</div>
);

Object.assign(window, { Phone, TabBar, Screen, Box, Hatched, Pill, Anno, TabIcon });
