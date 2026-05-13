// mid/history-tab.jsx — 历史·月历 + 当月汇总 + 明细

const HistoryTab = () => {
  // 5月 first day is friday (周五 = idx 4 in 一二三四五六日)
  const firstOff = 4;
  const dim = 31;
  const today = 13;
  const cells = [];
  for (let i = 0; i < firstOff; i++) cells.push(null);
  for (let d = 1; d <= dim; d++) cells.push(d);
  while (cells.length % 7) cells.push(null);

  // map day -> drinks
  const dayDrinks = {
    2: ['latte'], 3: ['americano'], 5: ['oat-latte'], 6: ['mocha-frap'],
    8: ['flat-white'], 9: ['caramel-macchiato'], 10: ['peach-oolong'],
    11: ['americano', 'caramel-macchiato'],
    13: ['oat-latte', 'caramel-macchiato'],
    14: ['latte'], 15: ['mocha'], 16: ['americano'],
    20: ['oat-latte'], 22: ['mocha-frap'], 24: ['latte'],
    25: ['latte'], 27: ['oat-latte'], 29: ['flat-white'], 30: ['caramel-macchiato'],
  };

  return (
    <PhoneMF screenLabel="06 历史·月历">
      <NavHeader
        title="历史"
        left={<span style={{ fontSize: 13, color: 'var(--ink-1)', display: 'flex', alignItems: 'center', gap: 4, fontWeight: 600 }}>2026 <I.chevDown size={16}/></span>}
        right={<IconBtn><I.share size={18}/></IconBtn>}
      />

      <Scroll>
        {/* month nav */}
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '4px 24px 8px' }}>
          <IconBtn style={{ border: 'none' }}><I.chevLeft size={20}/></IconBtn>
          <div style={{ fontSize: 20, fontWeight: 800 }}>5 月</div>
          <IconBtn style={{ border: 'none' }}><I.chevRight size={20}/></IconBtn>
        </div>

        {/* weekday labels */}
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)', padding: '0 16px', fontSize: 11, color: 'var(--ink-3)', textAlign: 'center', fontWeight: 600 }}>
          {['一','二','三','四','五','六','日'].map(d => <div key={d} style={{ padding: '6px 0' }}>{d}</div>)}
        </div>

        {/* calendar grid */}
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)', padding: '4px 16px 4px', rowGap: 2 }}>
          {cells.map((d, i) => {
            if (!d) return <div key={i}/>;
            const drinks = dayDrinks[d] || [];
            const isToday = d === today;
            return (
              <div key={i} style={{
                aspectRatio: '1',
                display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'flex-start',
                padding: '4px 0',
                position: 'relative',
              }}>
                <div style={{
                  width: 30, height: 30, borderRadius: 15,
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  fontSize: 13, fontWeight: isToday ? 800 : (drinks.length ? 700 : 500),
                  background: isToday ? 'var(--green-deep)' : 'transparent',
                  color: isToday ? '#fff' : (drinks.length ? 'var(--ink)' : 'var(--ink-3)'),
                  fontFamily: 'ui-monospace, monospace',
                }}>{d}</div>
                {drinks.length > 0 && (
                  <div style={{ display: 'flex', justifyContent: 'center', marginTop: 2, gap: -8 }}>
                    {drinks.slice(0, 2).map((id, k) => (
                      <div key={k} style={{ marginLeft: k > 0 ? -8 : 0, border: '1.5px solid #fff', borderRadius: '50%', zIndex: 2 - k }}>
                        <DrinkIcon name={id} size={20} bg="var(--cream)"/>
                      </div>
                    ))}
                    {drinks.length > 2 && <span style={{ fontSize: 8, color: 'var(--ink-3)', alignSelf: 'center', marginLeft: 2 }}>+{drinks.length - 2}</span>}
                  </div>
                )}
              </div>
            );
          })}
        </div>

        {/* month summary cards */}
        <div style={{ padding: '12px 20px 0', display: 'flex', gap: 10 }}>
          {[
            ['杯数', '19', '杯'],
            ['花费', '612', '¥'],
            ['连击', '7', '天'],
          ].map(([l, v, u], i) => (
            <div key={l} className="mf-card" style={{ flex: 1, padding: '12px 12px', border: '1px solid var(--line)' }}>
              <div style={{ fontSize: 11, color: 'var(--ink-2)' }}>{l}</div>
              <div style={{ display: 'flex', alignItems: 'baseline', gap: 2, marginTop: 2 }}>
                <span style={{ fontSize: 22, fontWeight: 800, fontFamily: 'ui-monospace, monospace', color: 'var(--green-deep)' }}>{v}</span>
                <span style={{ fontSize: 11, color: 'var(--ink-2)' }}>{u}</span>
              </div>
            </div>
          ))}
        </div>

        {/* favorite */}
        <div style={{ padding: '12px 20px 0' }}>
          <div className="mf-card" style={{ padding: 14, display: 'flex', alignItems: 'center', gap: 12, border: '1px solid var(--line)' }}>
            <DrinkIcon name="oat-latte" size={48} bg="var(--green-tint)"/>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 11, color: 'var(--ink-2)' }}>5 月最爱</div>
              <div style={{ fontSize: 14, fontWeight: 700 }}>燕麦丝绒拿铁 · 6 杯</div>
            </div>
            <div style={{ color: 'var(--rose)' }}><I.heartFill size={18}/></div>
          </div>
        </div>

        {/* detail list header */}
        <div style={{ padding: '20px 24px 4px', display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
          <h3 style={{ fontSize: 14 }}>明细</h3>
          <div style={{ fontSize: 11, color: 'var(--ink-3)' }}>按时间倒序</div>
        </div>

        <div style={{ padding: '0 20px 24px' }}>
          {[
            { date: '5月13日 周三', when: '下午 14:32', drink: 'caramel-macchiato', spec: '大杯 / 热饮 / 标准糖', price: 41, rating: 4, note: '会议续命' },
            { date: '5月13日 周三', when: '上午 09:12', drink: 'oat-latte', spec: '大杯 / 热饮 / 少糖', price: 38, rating: 5 },
            { date: '5月11日 周一', when: '下午 15:40', drink: 'caramel-macchiato', spec: '大杯 / 热饮', price: 36, rating: 5 },
            { date: '5月11日 周一', when: '上午 08:55', drink: 'americano', spec: '中杯 / 热饮 / 标准', price: 27, rating: 3 },
            { date: '5月10日 周日', when: '中午 12:20', drink: 'peach-oolong', spec: '超大杯 / 少冰', price: 30, rating: 4 },
          ].map((e, i, arr) => (
            <div key={i} style={{ display: 'flex', gap: 12, alignItems: 'center', padding: '14px 0', borderBottom: i < arr.length - 1 ? '1px solid var(--line)' : 'none' }}>
              <DrinkIcon name={e.drink} size={48} bg="var(--cream)"/>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 11, color: 'var(--ink-2)' }}>{e.date} · {e.when}</div>
                <div style={{ fontSize: 14, fontWeight: 700, marginTop: 1 }}>{DRINKS[e.drink].name}</div>
                <div style={{ fontSize: 11, color: 'var(--ink-2)' }}>{e.spec}</div>
                {e.note && <div style={{ fontSize: 11, color: 'var(--green-deep)', marginTop: 2 }}>"{e.note}"</div>}
              </div>
              <div style={{ textAlign: 'right' }}>
                <div style={{ fontSize: 14, fontWeight: 700, fontFamily: 'ui-monospace, monospace' }}>¥{e.price}</div>
                <div style={{ display: 'flex', gap: 1, color: 'var(--green-deep)', justifyContent: 'flex-end', marginTop: 2 }}>
                  {[0,1,2,3,4].map(k => (
                    k < e.rating ? <I.starFill key={k} size={11}/> : <I.star key={k} size={11} style={{ color: 'var(--line-2)' }}/>
                  ))}
                </div>
              </div>
            </div>
          ))}

          <div style={{ textAlign: 'center', fontSize: 12, color: 'var(--ink-3)', padding: '14px 0 4px' }}>查看 5 月全部 19 条 →</div>
        </div>
      </Scroll>

      <TabBarMF active="history"/>
    </PhoneMF>
  );
};

Object.assign(window, { HistoryTab });
