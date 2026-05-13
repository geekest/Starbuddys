// history-tab.jsx — 历史 tab, traditional month calendar + detail list

const HistoryV1 = () => {
  // build a 5月 calendar — 1日 is 周五
  const firstDayOffset = 4; // Mon=0...Sun=6, so 周五 = 4
  const daysInMonth = 31;
  const cells = [];
  for (let i = 0; i < firstDayOffset; i++) cells.push(null);
  for (let d = 1; d <= daysInMonth; d++) cells.push(d);
  while (cells.length % 7) cells.push(null);

  // mark drank days with icons
  const drank = {
    2: 'L', 3: 'L', 5: 'A', 6: 'F', 8: 'L', 9: 'M', 10: 'L',
    11: 'F', 13: 'L', 14: 'L', 15: 'A', 16: 'M',
    20: 'L', 22: 'F', 24: 'L', 25: 'L', 27: 'A', 29: 'M', 30: 'L',
  };
  // 13 is today
  const today = 13;

  const dayCell = (d) => {
    if (!d) return <div key={Math.random()} />;
    const has = drank[d];
    const isToday = d === today;
    return (
      <div key={d} style={{ aspectRatio: '1', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', position: 'relative' }}>
        <div style={{
          width: 32, height: 32, borderRadius: 16,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          fontSize: 13,
          background: isToday ? 'var(--accent)' : 'transparent',
          color: isToday ? 'var(--paper)' : 'var(--ink)',
          fontWeight: isToday ? 700 : 400,
          border: has && !isToday ? '1px solid var(--line-soft)' : 'none',
        }}>{d}</div>
        {has && !isToday && (
          <div style={{ position: 'absolute', bottom: 0, width: 6, height: 6, borderRadius: 3, background: 'var(--accent)' }}/>
        )}
      </div>
    );
  };

  return (
    <Phone screenLabel="08 历史 · 月历">
      <div style={{ padding: '14px 20px 6px' }}>
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
          <div style={{ fontSize: 22, fontWeight: 700 }}>历史</div>
          <div style={{ fontSize: 12, color: 'var(--ink-soft)' }}>2026年 ⌄</div>
        </div>
      </div>

      {/* month nav */}
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 18, padding: '8px 20px 4px' }}>
        <span style={{ color: 'var(--ink-muted)' }}>‹</span>
        <span style={{ fontSize: 15, fontWeight: 600 }}>5 月</span>
        <span style={{ color: 'var(--ink-muted)' }}>›</span>
      </div>

      {/* weekday header */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)', padding: '0 16px', fontSize: 10, color: 'var(--ink-muted)', textAlign: 'center' }}>
        {['一','二','三','四','五','六','日'].map(d => <div key={d} style={{ padding: '4px 0' }}>{d}</div>)}
      </div>

      {/* days grid */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)', padding: '0 16px' }}>
        {cells.map(dayCell)}
      </div>

      {/* monthly summary */}
      <div style={{ margin: '14px 20px 6px', border: '1.2px solid var(--line)', borderRadius: 12, padding: 12, display: 'flex', gap: 12, alignItems: 'center' }}>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 11, color: 'var(--ink-muted)' }}>5 月共喝了</div>
          <div style={{ fontSize: 20, fontWeight: 700 }}>19 <span style={{ fontSize: 12, fontWeight: 400, color: 'var(--ink-soft)' }}>杯</span></div>
        </div>
        <div style={{ width: 1, height: 30, background: 'var(--line-soft)' }}/>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 11, color: 'var(--ink-muted)' }}>累计花费</div>
          <div style={{ fontSize: 20, fontWeight: 700 }}>¥ 612</div>
        </div>
        <div style={{ width: 1, height: 30, background: 'var(--line-soft)' }}/>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 11, color: 'var(--ink-muted)' }}>最爱</div>
          <div style={{ fontSize: 14, fontWeight: 700 }}>燕麦拿铁</div>
        </div>
      </div>

      {/* detail list */}
      <Screen scroll>
        <div style={{ padding: '4px 20px 14px' }}>
          <div style={{ fontSize: 12, color: 'var(--ink-soft)', marginBottom: 6 }}>明细</div>
          {[
            ['5月13日 周三', '燕麦丝绒拿铁', '大杯 / 正常冰 / 少糖', '¥ 38', 4],
            ['5月11日 周一', '美式', '中杯 / 热饮 / 标准', '¥ 27', 3],
            ['5月11日 周一', '焦糖玛奇朵', '大杯 / 热饮', '¥ 36', 5],
            ['5月10日 周日', '冰摇桃桃乌龙', '超大杯 / 少冰', '¥ 30', 4],
            ['5月9日 周六', '摩卡星冰乐', '大杯 / 正常冰', '¥ 38', 2],
            ['5月8日 周五', '馥芮白', '中杯 / 热饮', '¥ 33', 5],
          ].map(([date, name, spec, price, rating], i) => (
            <div key={i} style={{ display: 'flex', gap: 10, alignItems: 'center', padding: '10px 0', borderBottom: '1px solid var(--line-soft)' }}>
              <div className="ph" style={{ width: 40, height: 40, borderRadius: '50%' }}>图</div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 10, color: 'var(--ink-muted)' }}>{date}</div>
                <div style={{ fontSize: 13, fontWeight: 600 }}>{name}</div>
                <div style={{ fontSize: 11, color: 'var(--ink-soft)' }}>{spec}</div>
              </div>
              <div style={{ textAlign: 'right' }}>
                <div style={{ fontSize: 13, fontWeight: 600 }}>{price}</div>
                <div style={{ fontSize: 11, color: 'var(--accent)' }}>{'♥'.repeat(rating)}<span style={{ color: 'var(--line-soft)' }}>{'♡'.repeat(5-rating)}</span></div>
              </div>
            </div>
          ))}
        </div>
      </Screen>

      <div className="callout" style={{ position: 'absolute', top: 240, right: 6, width: 96 }}>有喝则日期下方<br/>显示小绿点（或图标）</div>
      <div className="callout" style={{ position: 'absolute', top: 460, right: 6, width: 96 }}>整月汇总卡<br/>杯数 / 花费 / 最爱</div>

      <TabBar active="history" />
    </Phone>
  );
};

Object.assign(window, { HistoryV1 });
