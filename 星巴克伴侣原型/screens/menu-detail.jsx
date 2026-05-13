// menu-detail.jsx — 饮品选择 bottom sheet + 详细记录页

// =========== drink menu (bottom sheet, full screen) ===========
const DrinkMenu = () => {
  const categories = ['经典咖啡', '星冰乐', '冰摇茶', '茶瓦纳', '其他'];
  const drinks = [
    ['经典拿铁', 1], ['美式', 3], ['卡布奇诺', 0], ['焦糖玛奇朵', 2],
    ['馥芮白', 2], ['浓缩咖啡', 0], ['摩卡', 1], ['燕麦拿铁', 4],
    ['香草拿铁', 0],
  ];
  return (
    <Phone screenLabel="04 选饮品菜单（弹层）">
      {/* dimmed background hinting underlying drink tab */}
      <div style={{ flex: 1, position: 'relative', background: 'rgba(0,0,0,0.05)' }}>
        {/* underlying screen ghost */}
        <div style={{ position: 'absolute', inset: 0, opacity: 0.25, padding: '14px 20px' }}>
          <div style={{ fontSize: 22, fontWeight: 700 }}>今天喝什么?</div>
          <div style={{ width: '60%', height: 200, marginTop: 80, background: 'var(--paper-soft)', backgroundImage: 'var(--hatch)', borderRadius: 100, marginLeft: 'auto', marginRight: 'auto' }} />
        </div>

        {/* sheet */}
        <div style={{ position: 'absolute', left: 0, right: 0, bottom: 0, top: 100, background: 'var(--paper)', borderTop: '1.5px solid var(--line)', borderRadius: '16px 16px 0 0', display: 'flex', flexDirection: 'column' }}>
          {/* drag handle */}
          <div style={{ display: 'flex', justifyContent: 'center', paddingTop: 8 }}>
            <div style={{ width: 36, height: 4, background: 'var(--line-soft)', borderRadius: 2 }} />
          </div>
          {/* sheet header */}
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '8px 20px 0' }}>
            <div style={{ fontSize: 17, fontWeight: 700 }}>选择饮品</div>
            <div style={{ width: 24, height: 24, border: '1.2px solid var(--line)', borderRadius: 12, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 12 }}>✕</div>
          </div>
          {/* search */}
          <div style={{ margin: '10px 20px 0' }}>
            <div style={{ border: '1.2px solid var(--line)', borderRadius: 10, padding: '8px 12px', display: 'flex', alignItems: 'center', gap: 8, color: 'var(--ink-muted)', fontSize: 13 }}>
              <span>🔍</span><span>搜咖啡名 / 系列</span>
            </div>
          </div>
          {/* categories */}
          <div style={{ display: 'flex', gap: 8, padding: '12px 20px 0', overflowX: 'auto' }}>
            {categories.map((c, i) => <Pill key={c} active={i === 0}>{c}</Pill>)}
          </div>
          {/* grid */}
          <div style={{ flex: 1, overflow: 'auto', padding: '14px 20px 12px' }}>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 14 }}>
              {drinks.map(([name, drank], i) => (
                <div key={i} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6, position: 'relative' }}>
                  <div className="ph" style={{ width: 80, height: 80, borderRadius: '50%', position: 'relative', opacity: drank > 0 ? 1 : 0.5, border: i === 4 ? '2px solid var(--accent)' : '1.2px solid var(--line)' }}>图</div>
                  {drank > 0 && (
                    <div style={{ position: 'absolute', top: -2, right: 14, background: 'var(--accent)', color: 'var(--paper)', fontSize: 9, padding: '1px 5px', borderRadius: 8 }}>×{drank}</div>
                  )}
                  <div style={{ fontSize: 11, textAlign: 'center', fontWeight: i === 4 ? 600 : 400 }}>{name}</div>
                </div>
              ))}
            </div>
          </div>
          {/* CTA */}
          <div style={{ padding: '8px 20px 16px', borderTop: '1.2px solid var(--line-soft)' }}>
            <div style={{ background: 'var(--ink)', color: 'var(--paper)', textAlign: 'center', padding: '12px', borderRadius: 12, fontSize: 14, fontWeight: 600 }}>选好了 · 下一步</div>
          </div>
        </div>

        <div className="callout" style={{ position: 'absolute', top: 110, right: 8, width: 90 }}>下拉关闭<br/>顶部 ✕ 关闭</div>
        <div className="callout" style={{ position: 'absolute', top: 240, right: 4, width: 100 }}>右上角次数标<br/>= 喝过几次</div>
      </div>
    </Phone>
  );
};

// =========== detail / record page ===========
const DetailPage = () => (
  <Phone screenLabel="05 饮品详情·记一杯">
    <Screen scroll>
      {/* top nav */}
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '12px 16px' }}>
        <div style={{ width: 32, height: 32, border: '1.2px solid var(--line)', borderRadius: 16, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 14 }}>←</div>
        <div style={{ fontSize: 13, color: 'var(--ink-muted)' }}>记一杯</div>
        <div style={{ width: 32, height: 32, border: '1.2px solid var(--line)', borderRadius: 16, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 12 }}>♡</div>
      </div>

      {/* hero */}
      <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', padding: '4px 20px 12px', borderBottom: '1.2px solid var(--line-soft)' }}>
        <div className="ph" style={{ width: 140, height: 140, borderRadius: '50%' }}>饮品图</div>
        <div style={{ fontSize: 18, fontWeight: 700, marginTop: 10 }}>燕麦丝绒拿铁</div>
        <div style={{ fontSize: 11, color: 'var(--ink-muted)', marginTop: 2 }}>Oatmilk Velvet Latte · 经典咖啡</div>
      </div>

      {/* form */}
      <div style={{ padding: '14px 20px', display: 'flex', flexDirection: 'column', gap: 16 }}>
        {/* 日期 */}
        <Row label="日期">
          <span style={{ fontSize: 13 }}>2026 / 05 / 13 · 周三 · 上午</span>
          <span style={{ marginLeft: 'auto', fontSize: 11, color: 'var(--ink-muted)' }}>修改</span>
        </Row>

        {/* 杯型 */}
        <Group label="杯型">
          <Seg items={[['中杯', '355ml'], ['大杯', '473ml', true], ['超大杯', '591ml']]} />
        </Group>

        {/* 温度 */}
        <Group label="温度">
          <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
            {['热饮', '少冰', '正常冰', '去冰', '热饮·热一点'].map((t, i) => (
              <Pill key={t} active={i === 2}>{t}</Pill>
            ))}
          </div>
        </Group>

        {/* 糖度 */}
        <Group label="糖度">
          <Seg items={[['标准'], ['少糖', '', true], ['半糖'], ['微糖'], ['无糖']]} />
        </Group>

        {/* 浓度 / shot */}
        <Group label="浓缩 Shot">
          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            <Btn>−</Btn>
            <div style={{ fontSize: 16, minWidth: 30, textAlign: 'center', fontWeight: 600 }}>×2</div>
            <Btn>+</Btn>
            <span style={{ marginLeft: 'auto', fontSize: 11, color: 'var(--ink-muted)' }}>额外加浓 +¥4</span>
          </div>
        </Group>

        {/* 奶 */}
        <Group label="牛奶">
          <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
            {['标准奶', '低脂', '燕麦奶', '豆奶', '不加奶'].map((t, i) => (
              <Pill key={t} active={i === 2}>{t}</Pill>
            ))}
          </div>
        </Group>

        {/* 风味 */}
        <Group label="风味添加">
          <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
            {[
              ['香草风味糖浆', false],
              ['焦糖风味糖浆', true],
              ['榛果风味糖浆', false],
              ['海盐奶盖', false],
            ].map(([n, on]) => (
              <div key={n} style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '6px 10px', border: '1.2px solid ' + (on ? 'var(--accent)' : 'var(--line-soft)'), borderRadius: 8, background: on ? 'var(--accent-soft)' : 'transparent' }}>
                <span style={{ fontSize: 13 }}>{n}</span>
                <span style={{ fontSize: 11, color: 'var(--ink-muted)' }}>{on ? '× 1 ✓' : '+'}</span>
              </div>
            ))}
          </div>
        </Group>

        {/* 评分 */}
        <Group label="评分">
          <div style={{ display: 'flex', gap: 4, fontSize: 22, color: 'var(--accent)' }}>
            <span>♥</span><span>♥</span><span>♥</span><span>♥</span><span style={{ color: 'var(--line-soft)' }}>♡</span>
          </div>
        </Group>

        {/* 备注 */}
        <Group label="备注">
          <div className="stroke-soft" style={{ borderRadius: 8, padding: '8px 10px', fontSize: 12, color: 'var(--ink-muted)', minHeight: 60 }}>写点什么…（地点 / 心情 / 配什么吃的）</div>
        </Group>
      </div>

      {/* CTA */}
      <div style={{ padding: '8px 20px 16px', display: 'flex', gap: 10, position: 'sticky', bottom: 0, background: 'var(--paper)', borderTop: '1.2px solid var(--line-soft)' }}>
        <div style={{ flex: 1, border: '1.2px solid var(--line)', borderRadius: 12, padding: 12, textAlign: 'center', fontSize: 13 }}>不喝了</div>
        <div style={{ flex: 2, background: 'var(--accent)', color: 'var(--paper)', borderRadius: 12, padding: 12, textAlign: 'center', fontSize: 14, fontWeight: 600 }}>保存这一杯</div>
      </div>
    </Screen>
  </Phone>
);

const Group = ({ label, children }) => (
  <div>
    <div style={{ fontSize: 12, color: 'var(--ink-soft)', marginBottom: 6, fontWeight: 500 }}>{label}</div>
    {children}
  </div>
);
const Row = ({ label, children }) => (
  <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
    <span style={{ fontSize: 12, color: 'var(--ink-soft)', minWidth: 40 }}>{label}</span>
    {children}
  </div>
);
const Seg = ({ items }) => (
  <div style={{ display: 'flex', gap: 6 }}>
    {items.map(([t, sub, active], i) => (
      <div key={i} style={{
        flex: 1, padding: '8px 6px', borderRadius: 8, textAlign: 'center',
        border: '1.2px solid ' + (active ? 'var(--accent)' : 'var(--line-soft)'),
        background: active ? 'var(--accent-soft)' : 'transparent',
        color: active ? 'var(--accent)' : 'var(--ink)',
      }}>
        <div style={{ fontSize: 13, fontWeight: active ? 600 : 500 }}>{t}</div>
        {sub && <div style={{ fontSize: 10, color: 'var(--ink-muted)', marginTop: 2 }}>{sub}</div>}
      </div>
    ))}
  </div>
);
const Btn = ({ children }) => (
  <div style={{ width: 30, height: 30, borderRadius: 15, border: '1.2px solid var(--line)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 14 }}>{children}</div>
);

Object.assign(window, { DrinkMenu, DetailPage });
