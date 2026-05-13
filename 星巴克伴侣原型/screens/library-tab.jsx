// library-tab.jsx — 饮品库 tab, 2 variants

const LibraryV1 = () => {
  const sections = [
    { name: '经典咖啡', items: [
      ['经典拿铁', 1], ['美式', 3], ['卡布奇诺', 0],
      ['焦糖玛奇朵', 2], ['馥芮白', 2], ['浓缩', 0],
      ['摩卡', 1], ['燕麦拿铁', 4], ['香草拿铁', 0],
    ]},
    { name: '星冰乐', items: [
      ['摩卡星冰乐', 2], ['焦糖星冰乐', 1], ['抹茶星冰乐', 0],
      ['可可碎片', 0],
    ]},
    { name: '冰摇茶', items: [
      ['冰摇红茶', 1], ['冰摇桃桃乌龙', 3], ['冰摇柠檬', 0],
    ]},
  ];
  return (
    <Phone screenLabel="06 饮品库 · 图鉴式">
      <div style={{ padding: '14px 20px 6px' }}>
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
          <div style={{ fontSize: 22, fontWeight: 700 }}>饮品库</div>
          <div style={{ fontSize: 11, color: 'var(--ink-muted)' }}>🔍  ⚙</div>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 4 }}>
          <div style={{ fontSize: 13, color: 'var(--ink-soft)' }}>已收集</div>
          <div style={{ fontSize: 15, fontWeight: 700, color: 'var(--accent)' }}>12 / 48</div>
          <div style={{ flex: 1, height: 6, background: 'var(--paper-soft)', borderRadius: 3, marginLeft: 8 }}>
            <div style={{ width: '25%', height: '100%', background: 'var(--accent)', borderRadius: 3 }}/>
          </div>
        </div>
        <div style={{ display: 'flex', gap: 6, marginTop: 10 }}>
          <Pill active>全部</Pill><Pill>已喝</Pill><Pill>未喝</Pill><Pill>新品</Pill>
        </div>
      </div>

      <Screen scroll>
        <div style={{ padding: '6px 20px 12px', position: 'relative' }}>
          {sections.map((sec, si) => (
            <div key={sec.name} style={{ marginTop: si === 0 ? 8 : 22 }}>
              <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 10 }}>
                <div style={{ fontSize: 14, fontWeight: 600 }}>{sec.name}</div>
                <div style={{ fontSize: 11, color: 'var(--ink-muted)' }}>{sec.items.filter(x=>x[1]>0).length}/{sec.items.length}</div>
              </div>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', rowGap: 14, columnGap: 10 }}>
                {sec.items.map(([name, drank], i) => (
                  <div key={i} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, position: 'relative' }}>
                    <div className="ph" style={{
                      width: 84, height: 84, borderRadius: '50%',
                      opacity: drank > 0 ? 1 : 1,
                      background: drank > 0 ? 'var(--paper-soft)' : '#e8e6e0',
                      backgroundImage: drank > 0 ? 'var(--hatch)' : 'none',
                      color: drank > 0 ? 'var(--ink-soft)' : 'var(--ink-muted)',
                    }}>{drank > 0 ? '图' : '?'}</div>
                    {drank > 0 ? (
                      <div style={{ position: 'absolute', top: -3, right: 8, fontSize: 9, color: 'var(--paper)', background: 'var(--accent)', padding: '1px 5px', borderRadius: 8 }}>×{drank}</div>
                    ) : (
                      <div style={{ position: 'absolute', top: 30, fontSize: 18, color: 'var(--ink-muted)' }}>🔒</div>
                    )}
                    <div style={{ fontSize: 11, textAlign: 'center', marginTop: 2, color: drank > 0 ? 'var(--ink)' : 'var(--ink-muted)' }}>{name}</div>
                    <div style={{ fontSize: 9, color: drank > 0 ? 'var(--accent)' : 'var(--ink-muted)' }}>{drank > 0 ? `喝过 ${drank} 次` : '还没喝过'}</div>
                  </div>
                ))}
              </div>
            </div>
          ))}

          {/* fast scroll bar */}
          <div style={{ position: 'fixed' }}/>
        </div>
      </Screen>

      {/* annotations overlayed on right edge */}
      <div className="callout" style={{ position: 'absolute', top: 200, right: 4, width: 90 }}>未喝过：剪影 + 锁</div>
      <div className="callout" style={{ position: 'absolute', top: 360, right: 4, width: 90 }}>右侧可加快速字母索引</div>

      <TabBar active="library" />
    </Phone>
  );
};

const LibraryV2 = () => {
  // category as horizontal swipe rows, each row a horizontal scroll
  const sections = [
    { name: '经典咖啡', count: '6/9', items: [['经典拿铁', 1], ['美式', 3], ['卡布奇诺', 0], ['焦糖玛奇朵', 2], ['馥芮白', 2]] },
    { name: '星冰乐', count: '2/4', items: [['摩卡星冰乐', 2], ['焦糖星冰乐', 1], ['抹茶星冰乐', 0], ['可可碎片', 0]] },
    { name: '冰摇茶', count: '2/3', items: [['冰摇红茶', 1], ['冰摇桃桃乌龙', 3], ['冰摇柠檬', 0]] },
    { name: '茶瓦纳', count: '1/5', items: [['英式红茶', 0], ['抹茶拿铁', 2], ['伯爵红茶', 0]] },
  ];
  return (
    <Phone screenLabel="07 饮品库 · 横滑分组">
      <div style={{ padding: '14px 20px 6px' }}>
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
          <div style={{ fontSize: 22, fontWeight: 700 }}>饮品库</div>
          <div style={{ fontSize: 11, color: 'var(--ink-muted)' }}>共 48 款 · 已收集 12</div>
        </div>
      </div>

      {/* sticky category nav */}
      <div style={{ display: 'flex', gap: 16, padding: '8px 20px', overflowX: 'auto', borderBottom: '1.2px solid var(--line-soft)' }}>
        {['经典咖啡', '星冰乐', '冰摇茶', '茶瓦纳', '其他'].map((c, i) => (
          <div key={c} style={{
            fontSize: 13, paddingBottom: 6,
            borderBottom: '2px solid ' + (i === 0 ? 'var(--accent)' : 'transparent'),
            color: i === 0 ? 'var(--accent)' : 'var(--ink-soft)',
            fontWeight: i === 0 ? 600 : 400,
            whiteSpace: 'nowrap',
          }}>{c}</div>
        ))}
      </div>

      <Screen scroll>
        <div style={{ padding: '10px 0 12px', position: 'relative' }}>
          {sections.map((sec, si) => (
            <div key={sec.name} style={{ marginTop: si === 0 ? 4 : 18 }}>
              <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', padding: '0 20px', marginBottom: 8 }}>
                <div style={{ fontSize: 14, fontWeight: 600 }}>{sec.name}</div>
                <div style={{ fontSize: 11, color: 'var(--accent)' }}>{sec.count}  ›</div>
              </div>
              <div style={{ display: 'flex', gap: 14, padding: '0 20px', overflowX: 'auto' }}>
                {sec.items.map(([name, drank], i) => (
                  <div key={i} style={{ flex: '0 0 auto', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, width: 84 }}>
                    <div className="ph" style={{
                      width: 84, height: 84, borderRadius: '50%',
                      background: drank > 0 ? 'var(--paper-soft)' : '#e8e6e0',
                      backgroundImage: drank > 0 ? 'var(--hatch)' : 'none',
                      color: drank > 0 ? 'var(--ink-soft)' : 'var(--ink-muted)',
                      position: 'relative',
                    }}>
                      {drank > 0 ? '图' : '?'}
                      {drank > 0 && (
                        <div style={{ position: 'absolute', top: -3, right: -3, fontSize: 9, color: 'var(--paper)', background: 'var(--accent)', padding: '1px 5px', borderRadius: 8 }}>×{drank}</div>
                      )}
                    </div>
                    <div style={{ fontSize: 11, textAlign: 'center', color: drank > 0 ? 'var(--ink)' : 'var(--ink-muted)' }}>{name}</div>
                  </div>
                ))}
                {/* see-all card */}
                <div style={{ flex: '0 0 auto', width: 84, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4 }}>
                  <div style={{ width: 84, height: 84, borderRadius: '50%', border: '1.2px dashed var(--accent)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--accent)', fontSize: 12 }}>查看<br/>全部</div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </Screen>

      <div className="callout" style={{ position: 'absolute', top: 130, right: 4, width: 90 }}>顶部分类条<br/>点击或滚动联动</div>
      <div className="callout" style={{ position: 'absolute', top: 260, right: 4, width: 90 }}>横滑浏览<br/>每组末尾看全部</div>

      <TabBar active="library" />
    </Phone>
  );
};

Object.assign(window, { LibraryV1, LibraryV2 });
