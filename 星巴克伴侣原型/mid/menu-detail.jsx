// mid/menu-detail.jsx — 选饮品菜单 + 详情记录页

// ====== Drink picker bottom sheet ======
const DrinkPicker = () => {
  const cats = ['热门', '经典咖啡', '星冰乐', '冰摇茶', '茶瓦纳'];
  const items = ['oat-latte', 'caramel-macchiato', 'latte', 'americano', 'mocha', 'flat-white', 'cappuccino', 'mocha-frap', 'peach-oolong'];
  return (
    <PhoneMF screenLabel="03 选饮品·弹窗">
      {/* faded underlying screen */}
      <div style={{ flex: 1, position: 'relative', background: 'linear-gradient(to bottom, rgba(0,0,0,0.05), rgba(0,0,0,0.4))' }}>
        <div style={{ position: 'absolute', inset: 0, opacity: 0.5, padding: '14px 24px', pointerEvents: 'none' }}>
          <div style={{ fontSize: 12, color: 'var(--ink-2)' }}>下午好，咖啡因</div>
          <h1 style={{ marginTop: 2 }}>今天喝什么?</h1>
          <div style={{ marginTop: 50, height: 380, background: 'var(--green-tint)', borderRadius: 20 }}/>
        </div>

        {/* sheet */}
        <div style={{
          position: 'absolute', left: 0, right: 0, bottom: 0, top: 96,
          background: 'var(--paper)', borderRadius: '24px 24px 0 0',
          boxShadow: '0 -8px 24px rgba(0,0,0,0.12)',
          display: 'flex', flexDirection: 'column',
        }}>
          {/* handle */}
          <div style={{ display: 'flex', justifyContent: 'center', paddingTop: 10 }}>
            <div style={{ width: 40, height: 4, background: 'var(--line-2)', borderRadius: 2 }}/>
          </div>

          {/* header */}
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '10px 20px 0' }}>
            <h2>选一杯</h2>
            <IconBtn><I.close size={18}/></IconBtn>
          </div>

          {/* search */}
          <div style={{ padding: '12px 20px 0' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 8, background: 'var(--cream)', borderRadius: 12, padding: '10px 14px', color: 'var(--ink-3)', fontSize: 13 }}>
              <I.search size={18}/>
              <span>搜咖啡名 / 系列</span>
            </div>
          </div>

          {/* categories */}
          <div style={{ display: 'flex', gap: 8, padding: '14px 20px 0', overflowX: 'auto' }}>
            {cats.map((c, i) => <span key={c} className={'pill' + (i === 0 ? ' active' : '')}>{c}</span>)}
          </div>

          {/* grid */}
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

          {/* footer */}
          <div style={{ padding: '12px 20px 24px', borderTop: '1px solid var(--line)', background: 'var(--paper)' }}>
            <button className="btn-primary" style={{ width: '100%' }}>选好了 · 下一步 →</button>
          </div>
        </div>
      </div>
    </PhoneMF>
  );
};

// ====== Detail / record page ======
const DetailPage = () => (
  <PhoneMF screenLabel="04 详情·记一杯">
    <NavHeader
      left={<IconBtn><I.chevLeft size={20}/></IconBtn>}
      title="记一杯"
      right={<IconBtn><I.heart size={20}/></IconBtn>}
    />

    <Scroll>
      {/* hero */}
      <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', padding: '4px 20px 18px' }}>
        <div style={{
          width: 168, height: 168, borderRadius: '50%',
          background: 'linear-gradient(135deg, #FAF7F0 0%, #F1ECD7 100%)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: 'inset 0 -4px 12px rgba(0,0,0,0.05)',
        }}>
          <DrinkIcon name="caramel-macchiato" size={156} bg="transparent"/>
        </div>
        <div style={{ fontSize: 22, fontWeight: 800, marginTop: 14, letterSpacing: '-0.01em' }}>焦糖玛奇朵</div>
        <div style={{ fontSize: 12, color: 'var(--ink-2)', marginTop: 2 }}>Caramel Macchiato · 经典咖啡</div>

        {/* date + first-time tag */}
        <div style={{ display: 'flex', gap: 6, marginTop: 10 }}>
          <span style={{ fontSize: 11, padding: '4px 10px', borderRadius: 8, background: 'var(--amber-soft)', color: 'var(--amber)', fontWeight: 600 }}>第一次喝</span>
          <span style={{ fontSize: 11, padding: '4px 10px', borderRadius: 8, background: 'var(--green-pale)', color: 'var(--green-deep)', fontWeight: 600 }}>2026/05/13 · 下午</span>
        </div>
      </div>

      {/* form sections */}
      <div style={{ padding: '0 20px 16px', display: 'flex', flexDirection: 'column', gap: 22 }}>
        {/* 杯型 */}
        <Section title="杯型">
          <Segmented items={[
            { label: '中杯', sub: '355ml', value: 'tall' },
            { label: '大杯', sub: '473ml', value: 'grande' },
            { label: '超大杯', sub: '591ml', value: 'venti' },
          ]} value="grande"/>
        </Section>

        {/* 温度 */}
        <Section title="温度">
          <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
            {['热饮', '正常冰', '少冰', '去冰'].map((t, i) => (
              <span key={t} className={'pill' + (i === 0 ? ' soft' : '')} style={{ padding: '8px 14px', fontSize: 13 }}>{t}</span>
            ))}
          </div>
        </Section>

        {/* 糖度 */}
        <Section title="糖度">
          <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
            {['标准', '少糖', '半糖', '微糖', '无糖'].map((t, i) => (
              <span key={t} className={'pill' + (i === 1 ? ' soft' : '')} style={{ padding: '8px 14px', fontSize: 13 }}>{t}</span>
            ))}
          </div>
        </Section>

        {/* Shot */}
        <Section title="浓缩 Shot">
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <button style={btnCircle}><I.minus size={16}/></button>
            <div style={{ fontSize: 22, fontWeight: 800, minWidth: 60, textAlign: 'center', fontFamily: 'ui-monospace, monospace' }}>×2</div>
            <button style={btnCircle}><I.plus size={16}/></button>
            <div style={{ marginLeft: 'auto', fontSize: 12, color: 'var(--ink-2)' }}>+1 shot · ¥4</div>
          </div>
        </Section>

        {/* 牛奶 */}
        <Section title="牛奶">
          <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
            {['标准奶', '低脂奶', '燕麦奶', '豆奶', '不加奶'].map((t, i) => (
              <span key={t} className={'pill' + (i === 2 ? ' soft' : '')} style={{ padding: '8px 14px', fontSize: 13 }}>{t}</span>
            ))}
          </div>
        </Section>

        {/* 风味添加 */}
        <Section title="风味添加" extra={<span style={{ fontSize: 11, color: 'var(--green-deep)', fontWeight: 600 }}>+ 添加</span>}>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
            {[
              ['焦糖风味糖浆', true, '× 1'],
              ['香草风味糖浆', false, ''],
              ['海盐奶盖', false, ''],
            ].map(([n, on, q], i) => (
              <div key={i} style={{
                display: 'flex', alignItems: 'center', justifyContent: 'space-between',
                padding: '12px 14px', borderRadius: 12,
                background: on ? 'var(--green-pale)' : 'var(--paper)',
                border: '1px solid ' + (on ? 'var(--green-deep)' : 'var(--line)'),
              }}>
                <span style={{ fontSize: 13, fontWeight: on ? 600 : 500 }}>{n}</span>
                <span style={{ fontSize: 12, color: on ? 'var(--green-deep)' : 'var(--ink-3)', fontWeight: on ? 700 : 500 }}>{on ? `${q} ✓` : '+'}</span>
              </div>
            ))}
          </div>
        </Section>

        {/* 评分 */}
        <Section title="今日感受">
          <div style={{ display: 'flex', gap: 8 }}>
            {[0,1,2,3,4].map((i) => (
              <div key={i} style={{ color: i < 4 ? 'var(--green-deep)' : 'var(--line-2)' }}>
                {i < 4 ? <I.starFill size={28}/> : <I.star size={28}/>}
              </div>
            ))}
          </div>
        </Section>

        {/* 备注 */}
        <Section title="备注">
          <div style={{
            border: '1px solid var(--line)', borderRadius: 12,
            padding: 12, fontSize: 13, color: 'var(--ink-3)',
            minHeight: 72, background: 'var(--paper-2)',
          }}>写点什么…（地点 / 心情 / 配什么吃的）</div>
        </Section>

        {/* 价格 */}
        <div style={{ background: 'var(--green-tint)', borderRadius: 14, padding: '12px 16px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <div>
            <div style={{ fontSize: 11, color: 'var(--ink-2)' }}>本杯花费</div>
            <div style={{ fontSize: 22, fontWeight: 800, color: 'var(--green-deep)' }}>¥ 41</div>
          </div>
          <div style={{ fontSize: 11, color: 'var(--ink-2)', textAlign: 'right' }}>本月累计<br/><span style={{ fontSize: 15, fontWeight: 700, color: 'var(--ink)' }}>¥ 653</span></div>
        </div>
      </div>

      {/* CTA bar */}
      <div style={{ padding: '8px 20px 22px', display: 'flex', gap: 10, position: 'sticky', bottom: 0, background: 'var(--paper)', borderTop: '1px solid var(--line)' }}>
        <button className="btn-ghost" style={{ flex: '0 0 92px' }}>放弃</button>
        <button className="btn-primary" style={{ flex: 1 }}>保存这一杯 ✓</button>
      </div>
    </Scroll>
  </PhoneMF>
);

const btnCircle = {
  width: 36, height: 36, borderRadius: 18,
  border: '1px solid var(--line-2)', background: 'var(--paper)',
  display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
  color: 'var(--ink)', cursor: 'pointer', padding: 0,
};

const Section = ({ title, extra, children }) => (
  <div>
    <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 10 }}>
      <h3 style={{ fontSize: 14 }}>{title}</h3>
      {extra}
    </div>
    {children}
  </div>
);

Object.assign(window, { DrinkPicker, DetailPage });
