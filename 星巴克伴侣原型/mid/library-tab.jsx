// mid/library-tab.jsx — 饮品库·图鉴式

const LibraryTab = () => {
  // total stats
  const allIds = DRINK_GROUPS.flatMap(g => g.ids);
  const drankCount = allIds.filter(id => DRINKS[id].drank > 0).length;

  return (
    <PhoneMF screenLabel="05 饮品库·图鉴">
      {/* header */}
      <div style={{ padding: '12px 24px 4px' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <h1>饮品图鉴</h1>
          <div style={{ display: 'flex', gap: 8 }}>
            <IconBtn><I.search size={20}/></IconBtn>
            <IconBtn><I.settings size={18}/></IconBtn>
          </div>
        </div>

        {/* progress card */}
        <div style={{
          marginTop: 12,
          background: 'linear-gradient(135deg, #0E4A2E 0%, #1F6B47 100%)',
          borderRadius: 18, padding: '14px 18px',
          color: '#fff', display: 'flex', alignItems: 'center', gap: 14,
          boxShadow: '0 6px 20px rgba(14, 74, 46, 0.18)',
        }}>
          <div style={{ width: 56, height: 56, borderRadius: 28, background: 'rgba(255,255,255,0.16)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <I.crown size={28}/>
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 11, opacity: 0.8, letterSpacing: '0.06em' }}>已收集</div>
            <div style={{ display: 'flex', alignItems: 'baseline', gap: 4 }}>
              <span style={{ fontSize: 28, fontWeight: 800, fontFamily: 'ui-monospace, monospace' }}>{drankCount}</span>
              <span style={{ fontSize: 14, opacity: 0.7 }}>/ {allIds.length}</span>
            </div>
            <div style={{ height: 5, background: 'rgba(255,255,255,0.16)', borderRadius: 3, marginTop: 6, overflow: 'hidden' }}>
              <div style={{ width: `${drankCount/allIds.length*100}%`, height: '100%', background: '#fff' }}/>
            </div>
          </div>
          <div style={{ textAlign: 'right' }}>
            <div style={{ fontSize: 11, opacity: 0.8 }}>下一目标</div>
            <div style={{ fontSize: 13, fontWeight: 700 }}>20 款</div>
          </div>
        </div>

        {/* filter pills */}
        <div style={{ display: 'flex', gap: 8, marginTop: 14, overflowX: 'auto' }}>
          {[['全部', allIds.length], ['已喝', drankCount], ['未喝', allIds.length - drankCount], ['新品', 3]].map(([l, n], i) => (
            <span key={l} className={'pill' + (i === 0 ? ' active' : '')} style={{ padding: '6px 14px' }}>
              {l} <span style={{ marginLeft: 4, opacity: 0.7, fontWeight: 500 }}>{n}</span>
            </span>
          ))}
        </div>
      </div>

      <Scroll>
        <div style={{ padding: '18px 20px 24px' }}>
          {DRINK_GROUPS.map((g, gi) => {
            const gDrank = g.ids.filter(id => DRINKS[id].drank > 0).length;
            return (
              <div key={g.cat} style={{ marginTop: gi === 0 ? 0 : 26 }}>
                <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 14 }}>
                  <h3 style={{ fontSize: 15 }}>
                    {g.cat}
                    <span style={{ fontSize: 11, fontWeight: 500, color: 'var(--ink-3)', marginLeft: 8 }}>{gDrank}/{g.ids.length}</span>
                  </h3>
                  {gDrank === g.ids.length && (
                    <span style={{ fontSize: 10, padding: '3px 8px', borderRadius: 6, background: 'var(--amber-soft)', color: 'var(--amber)', fontWeight: 700 }}>★ 全收集</span>
                  )}
                </div>
                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', rowGap: 18, columnGap: 12 }}>
                  {g.ids.map(id => {
                    const d = DRINKS[id];
                    const locked = d.drank === 0;
                    return (
                      <div key={id} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6, position: 'relative' }}>
                        <div style={{ position: 'relative' }}>
                          <DrinkIcon
                            name={id}
                            size={92}
                            bg={locked ? '#EFEDE6' : 'var(--cream)'}
                            locked={locked}
                            ringColor={d.drank >= 20 ? 'var(--amber)' : null}
                          />
                          {d.drank > 0 && (
                            <div style={{
                              position: 'absolute', top: -2, right: -2,
                              background: d.drank >= 20 ? 'var(--amber)' : 'var(--green-deep)',
                              color: '#fff', fontSize: 10, fontWeight: 700,
                              padding: '2px 8px', borderRadius: 10,
                              boxShadow: '0 2px 5px rgba(0,0,0,0.15)',
                            }}>×{d.drank}</div>
                          )}
                        </div>
                        <div style={{ fontSize: 12, textAlign: 'center', fontWeight: locked ? 500 : 700, color: locked ? 'var(--ink-3)' : 'var(--ink)', lineHeight: 1.25 }}>{d.name}</div>
                        <div style={{ fontSize: 10, color: locked ? 'var(--ink-3)' : 'var(--green-deep)', textAlign: 'center' }}>
                          {locked ? '未解锁' : `已喝 ${d.drank} 次`}
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            );
          })}
        </div>
      </Scroll>

      <TabBarMF active="library"/>
    </PhoneMF>
  );
};

Object.assign(window, { LibraryTab });
