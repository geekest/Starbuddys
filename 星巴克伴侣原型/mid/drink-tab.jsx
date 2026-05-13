// mid/drink-tab.jsx — 喝一杯 (idle + result states)

// ====== Espresso machine illustration ======
const EspressoMachine = ({ brewing = false }) => (
  <svg viewBox="0 0 320 480" width="100%" height="100%" style={{ display: 'block' }}>
    <defs>
      <linearGradient id="bodyG" x1="0" y1="0" x2="1" y2="0">
        <stop offset="0%" stopColor="#0E4A2E"/>
        <stop offset="35%" stopColor="#1F6B47"/>
        <stop offset="65%" stopColor="#1F6B47"/>
        <stop offset="100%" stopColor="#0A3A23"/>
      </linearGradient>
      <linearGradient id="bodyTop" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0%" stopColor="#185F40"/>
        <stop offset="100%" stopColor="#1F6B47"/>
      </linearGradient>
      <linearGradient id="chromeG" x1="0" y1="0" x2="1" y2="0">
        <stop offset="0%" stopColor="#A8A39A"/>
        <stop offset="50%" stopColor="#ECE7DC"/>
        <stop offset="100%" stopColor="#807B70"/>
      </linearGradient>
      <linearGradient id="chromeV" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0%" stopColor="#D4CFC2"/>
        <stop offset="100%" stopColor="#807B70"/>
      </linearGradient>
      <linearGradient id="wood" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0%" stopColor="#8E5728"/>
        <stop offset="100%" stopColor="#5C3618"/>
      </linearGradient>
      <radialGradient id="glow" cx="50%" cy="50%" r="50%">
        <stop offset="0%" stopColor="#fff" stopOpacity="0.6"/>
        <stop offset="100%" stopColor="#fff" stopOpacity="0"/>
      </radialGradient>
    </defs>

    {/* floor shadow */}
    <ellipse cx="160" cy="448" rx="140" ry="10" fill="#000" opacity="0.10"/>

    {/* HOPPER (top dark) */}
    <path d="M 80 20 Q 80 8 92 8 H 228 Q 240 8 240 20 V 60 H 80 Z" fill="#2A1B12"/>
    <path d="M 80 20 Q 80 8 92 8 H 228 Q 240 8 240 20 V 22 H 80 Z" fill="#3D2A1E"/>
    {/* hopper glass window */}
    <rect x="100" y="22" width="120" height="32" rx="4" fill="#F0E8D8" opacity="0.18"/>
    <rect x="100" y="22" width="120" height="3" fill="#fff" opacity="0.12"/>
    {/* beans inside hopper */}
    <g>
      {[[120,42,-12],[136,38,18],[152,44,-5],[168,40,22],[184,43,-18],[200,38,8],[216,42,-3],[128,48,15],[160,48,-10],[192,49,5],[140,32,-20],[176,33,12],[208,33,-8]].map((p, i) => (
        <g key={i} transform={`translate(${p[0]} ${p[1]}) rotate(${p[2]})`}>
          <ellipse rx="4.2" ry="2.6" fill="#3D2515"/>
          <path d="M 0 -2 Q 0 0 0 2" stroke="#1A0E08" strokeWidth="0.5"/>
        </g>
      ))}
    </g>

    {/* MAIN BODY */}
    <path d="M 40 60 Q 40 56 44 56 H 276 Q 280 56 280 60 V 312 Q 280 318 274 318 H 46 Q 40 318 40 312 Z" fill="url(#bodyG)"/>
    {/* top highlight band */}
    <rect x="40" y="60" width="240" height="4" fill="url(#bodyTop)" opacity="0.6"/>
    {/* inner panel */}
    <rect x="56" y="76" width="208" height="222" rx="12" fill="#FAF7F0"/>
    <rect x="56" y="76" width="208" height="4" rx="12" fill="#E5E0D5"/>

    {/* DISPLAY */}
    <rect x="76" y="92" width="168" height="52" rx="8" fill="#0E1815"/>
    <rect x="76" y="92" width="168" height="6" rx="8" fill="#1B2A22"/>
    <text x="160" y="113" textAnchor="middle" fontSize="9" fill="#7FD8A6" fontFamily="ui-monospace, monospace" letterSpacing="3">
      {brewing ? 'EXTRACTING…' : 'READY · 第 12 杯'}
    </text>
    <text x="160" y="134" textAnchor="middle" fontSize="18" fill="#E9F2EC" fontFamily="ui-monospace, monospace" fontWeight="700" letterSpacing="2">
      {brewing ? '17.4s ▮▮▮▮▯' : '今日 · 1 杯'}
    </text>

    {/* knobs */}
    <g>
      <circle cx="92" cy="174" r="13" fill="url(#chromeG)"/>
      <circle cx="92" cy="174" r="9" fill="#1A1A18"/>
      <rect x="91" y="166" width="2" height="9" fill="#fff" rx="1"/>
      <text x="92" y="200" textAnchor="middle" fontSize="7" fill="#3D3D38" fontFamily="ui-monospace">STEAM</text>
    </g>
    <g>
      <circle cx="228" cy="174" r="13" fill="url(#chromeG)"/>
      <circle cx="228" cy="174" r="9" fill="#1A1A18"/>
      <rect x="227" y="170" width="2" height="9" fill="#fff" rx="1" transform="rotate(45 228 174)"/>
      <text x="228" y="200" textAnchor="middle" fontSize="7" fill="#3D3D38" fontFamily="ui-monospace">WATER</text>
    </g>

    {/* BIG BREW BUTTON */}
    <g>
      {!brewing && <circle cx="160" cy="180" r="38" fill="url(#glow)"/>}
      <rect x="124" y="155" width="72" height="50" rx="14" fill="#0E4A2E" stroke="#0A3A23" strokeWidth="1"/>
      <rect x="124" y="155" width="72" height="6" rx="14" fill="#1F6B47"/>
      <rect x="124" y="199" width="72" height="6" rx="14" fill="#082819"/>
      <text x="160" y="186" textAnchor="middle" fontSize="14" fill="#fff" fontWeight="800" letterSpacing="2">BREW</text>
    </g>

    {/* brand mark */}
    <text x="160" y="232" textAnchor="middle" fontSize="9" fill="#0E4A2E" fontWeight="700" letterSpacing="4">STARBUDDYS</text>

    {/* group head */}
    <rect x="120" y="252" width="80" height="22" rx="4" fill="url(#chromeV)"/>
    <ellipse cx="160" cy="252" rx="40" ry="3" fill="#fff" opacity="0.4"/>
    {/* portafilter (chrome cylinder) */}
    <rect x="134" y="272" width="52" height="14" rx="2" fill="url(#chromeV)"/>
    {/* wood handle */}
    <rect x="186" y="274" width="76" height="14" rx="4" fill="url(#wood)"/>
    <rect x="190" y="276" width="68" height="3" rx="1" fill="#A87850" opacity="0.6"/>
    <circle cx="254" cy="281" r="3" fill="#3D1F0E"/>
    {/* spouts */}
    <rect x="146" y="286" width="4" height="7" rx="1" fill="#3D3D38"/>
    <rect x="166" y="286" width="4" height="7" rx="1" fill="#3D3D38"/>

    {/* espresso streams (only when brewing) */}
    {brewing && (
      <g>
        <path d="M 148 293 Q 147 308 148 322" stroke="#3D2515" strokeWidth="1.6" fill="none" strokeDasharray="2 1.5"/>
        <path d="M 168 293 Q 169 308 168 322" stroke="#3D2515" strokeWidth="1.6" fill="none" strokeDasharray="2 1.5"/>
      </g>
    )}

    {/* steam wand on right side */}
    <g>
      <rect x="282" y="160" width="6" height="4" rx="1" fill="url(#chromeG)"/>
      <line x1="285" y1="164" x2="297" y2="320" stroke="url(#chromeV)" strokeWidth="3.5"/>
      <line x1="285" y1="164" x2="297" y2="320" stroke="#fff" strokeWidth="1" opacity="0.4"/>
      <circle cx="297" cy="322" r="3.5" fill="#5A5A55"/>
      {/* steam */}
      <g opacity="0.55" fill="none" stroke="#9E9E96" strokeWidth="1.5" strokeLinecap="round">
        <path d="M 290 295 Q 286 282 292 274"/>
        <path d="M 298 285 Q 304 276 300 268"/>
      </g>
    </g>

    {/* drip tray */}
    <rect x="40" y="312" width="240" height="22" rx="4" fill="#1A1A18"/>
    <rect x="56" y="320" width="208" height="2" fill="#0E1815"/>
    <rect x="56" y="322" width="208" height="3" fill="#2A2A28"/>

    {/* CUP */}
    <g transform="translate(126, 340)">
      <ellipse cx="34" cy="64" rx="44" ry="5" fill="#000" opacity="0.10"/>
      <ellipse cx="34" cy="62" rx="44" ry="5" fill="#E5E0D5"/>
      <ellipse cx="34" cy="61" rx="44" ry="5" fill="#F5F2EA"/>
      {/* handle */}
      <path d="M 60 24 Q 74 24 74 36 Q 74 48 60 48" fill="none" stroke="#F5F2EA" strokeWidth="4"/>
      <path d="M 60 24 Q 72 24 72 36 Q 72 48 60 48" fill="none" stroke="#E5E0D5" strokeWidth="2"/>
      {/* cup body */}
      <path d="M 8 18 Q 8 14 12 14 H 56 Q 60 14 60 18 V 52 Q 60 58 54 58 H 14 Q 8 58 8 52 Z" fill="#F5F2EA"/>
      <path d="M 56 18 Q 58 18 58 20 V 54 Q 58 56 55 56" fill="#E5E0D5" opacity="0.7"/>
      {/* rim */}
      <ellipse cx="34" cy="18" rx="26" ry="4.5" fill="#E5E0D5"/>
      {/* liquid */}
      <ellipse cx="34" cy="18" rx="24" ry="3.6" fill={brewing ? '#3A2615' : '#3A2615'}/>
      {brewing && <ellipse cx="34" cy="17.5" rx="20" ry="1.8" fill="#C58A3A" opacity="0.9"/>}
      <ellipse cx="14" cy="34" rx="1.5" ry="10" fill="#fff" opacity="0.6"/>
    </g>
  </svg>
);

// ====== Idle screen ======
const DrinkTabIdle = () => (
  <PhoneMF screenLabel="01 喝一杯·待机">
    {/* header */}
    <div style={{ padding: '12px 24px 0' }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div>
          <div style={{ fontSize: 12, color: 'var(--ink-2)', fontWeight: 500 }}>下午好，咖啡因</div>
          <h1 style={{ marginTop: 2 }}>今天喝什么?</h1>
        </div>
        <IconBtn><I.bell size={20}/></IconBtn>
      </div>
    </div>

    <Scroll>
      {/* machine */}
      <div style={{ padding: '4px 8px 0', position: 'relative' }}>
        <div style={{ height: 470, position: 'relative' }}>
          <EspressoMachine brewing={false}/>
        </div>
        {/* sub text */}
        <div style={{ textAlign: 'center', marginTop: -8, fontSize: 13, color: 'var(--ink-2)' }}>
          点击 <span style={{ background: 'var(--green-pale)', color: 'var(--green-deep)', padding: '2px 8px', borderRadius: 10, fontWeight: 700, fontSize: 12 }}>BREW</span> 让今日运势随机出杯
        </div>
      </div>

      {/* last brew card */}
      <div style={{ padding: '20px 20px 0' }}>
        <div className="mf-card" style={{ padding: 14, display: 'flex', alignItems: 'center', gap: 14, border: '1px solid var(--line)' }}>
          <DrinkIcon name="oat-latte" size={56} bg="var(--green-tint)"/>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ fontSize: 11, color: 'var(--ink-2)' }}>上一杯 · 今天 9:12</div>
            <div style={{ fontSize: 15, fontWeight: 700, marginTop: 1 }}>燕麦丝绒拿铁</div>
            <div style={{ fontSize: 11, color: 'var(--ink-2)' }}>大杯 / 热饮 / 标准糖 · ¥ 38</div>
          </div>
          <div style={{ color: 'var(--green-deep)', fontSize: 12, fontWeight: 600 }}>再来一杯 →</div>
        </div>
      </div>

      {/* secondary action */}
      <div style={{ padding: '12px 20px 24px', display: 'flex', gap: 10 }}>
        <div className="btn-ghost" style={{ flex: 1 }}>我自己选 →</div>
      </div>
    </Scroll>

    <TabBarMF active="drink"/>
  </PhoneMF>
);

// ====== Result screen: drink card slides up ======
const DrinkTabResult = () => (
  <PhoneMF screenLabel="02 喝一杯·扭出">
    <div style={{ padding: '12px 24px 0' }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div>
          <div style={{ fontSize: 12, color: 'var(--ink-2)', fontWeight: 500 }}>今日运势·上佳</div>
          <h1 style={{ marginTop: 2 }}>来一杯…</h1>
        </div>
        <IconBtn><I.bell size={20}/></IconBtn>
      </div>
    </div>

    <div style={{ flex: 1, minHeight: 0, position: 'relative', overflow: 'hidden' }}>
      {/* dim machine */}
      <div style={{ padding: '4px 8px 0', opacity: 0.6, filter: 'blur(0.3px)' }}>
        <div style={{ height: 470, position: 'relative' }}>
          <EspressoMachine brewing={true}/>
        </div>
      </div>

      {/* darken overlay */}
      <div style={{ position: 'absolute', inset: 0, background: 'rgba(15, 25, 18, 0.18)', pointerEvents: 'none' }}/>

      {/* sliding card */}
      <div style={{
        position: 'absolute', left: 16, right: 16, bottom: 16,
        background: 'var(--paper)', borderRadius: 20,
        boxShadow: 'var(--shadow-lg)', padding: 18,
        border: '1px solid var(--line)',
      }}>
        <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 8 }}>
          <div style={{ width: 36, height: 4, background: 'var(--line-2)', borderRadius: 2 }}/>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
          <DrinkIcon name="caramel-macchiato" size={92} bg="#F4ECD8"/>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
              <span style={{ fontSize: 10, fontWeight: 700, letterSpacing: 1, color: 'var(--amber)', background: 'var(--amber-soft)', padding: '2px 8px', borderRadius: 6 }}>NEW · 第一次喝</span>
            </div>
            <div style={{ fontSize: 20, fontWeight: 800, marginTop: 4, letterSpacing: '-0.01em' }}>焦糖玛奇朵</div>
            <div style={{ fontSize: 11, color: 'var(--ink-2)' }}>Caramel Macchiato · 经典咖啡</div>
            <div style={{ fontSize: 12, color: 'var(--ink-1)', marginTop: 6, lineHeight: 1.5 }}>
              浓缩与香草、奶泡的层次结合，最后浇上焦糖。
            </div>
          </div>
        </div>

        {/* facts row */}
        <div style={{ display: 'flex', gap: 8, marginTop: 14 }}>
          {[['推荐杯型', '大杯'], ['推荐温度', '热饮'], ['推荐糖度', '标准']].map(([l, v], i) => (
            <div key={i} style={{ flex: 1, background: 'var(--green-tint)', borderRadius: 10, padding: '8px 0', textAlign: 'center' }}>
              <div style={{ fontSize: 10, color: 'var(--ink-2)' }}>{l}</div>
              <div style={{ fontSize: 13, color: 'var(--green-deep)', fontWeight: 700, marginTop: 2 }}>{v}</div>
            </div>
          ))}
        </div>

        {/* CTA row */}
        <div style={{ display: 'flex', gap: 10, marginTop: 16 }}>
          <button className="btn-ghost" style={{ width: 52, padding: '12px 0', display:'flex', alignItems:'center', justifyContent:'center', flex: '0 0 52px' }}>
            <I.refresh size={20}/>
          </button>
          <button className="btn-primary" style={{ flex: 1 }}>记一杯 →</button>
        </div>
        <div style={{ textAlign: 'center', fontSize: 11, color: 'var(--ink-3)', marginTop: 10 }}>
          ← 不想喝？ 点 刷新 重新扭 / 下拉关闭
        </div>
      </div>
    </div>

    <TabBarMF active="drink"/>
  </PhoneMF>
);

Object.assign(window, { DrinkTabIdle, DrinkTabResult, EspressoMachine });
