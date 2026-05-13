// mid/drinks.jsx — illustrated drink icons + drink data

// ---- color palette for drinks ----
const C = {
  porcelain: '#F5F2EA',
  porcelainShadow: '#E5E0D5',
  porcelainEdge: '#D8D2C5',
  glass: '#F0F4F5',
  glassEdge: '#D5DDE0',
  liquidDark: '#3A2615',
  liquidMid:  '#6B4225',
  liquidLight: '#A87850',
  cream: '#E5D4B0',
  oat: '#DDC8A0',
  vanilla: '#EFE0BD',
  foam: '#FBF6E8',
  whip: '#FFFAF0',
  caramel: '#C58A3A',
  caramelDeep: '#9A6A28',
  chocolate: '#4A2511',
  matcha: '#7DA268',
  matchaDark: '#5C7E48',
  peach: '#F0B5A8',
  peachDark: '#D38978',
  tea: '#C0793E',
  teaDark: '#8E5728',
  lemon: '#EDCB6A',
  lemonDark: '#B89A3F',
  ice: '#D7E8EC',
  iceEdge: '#A8C0C8',
  green: '#1F6B47',
};

// ====== Hot ceramic mug ======
const MugHot = ({ liquid = C.liquidMid, foam, foamColor = C.foam, art, accent }) => (
  <g>
    {/* saucer */}
    <ellipse cx="50" cy="86" rx="34" ry="4.5" fill={C.porcelainShadow}/>
    <ellipse cx="50" cy="84" rx="34" ry="4.5" fill={C.porcelain}/>
    {/* handle */}
    <path d="M 73 48 Q 92 50 92 64 Q 92 78 73 80" fill="none" stroke={C.porcelainShadow} strokeWidth="6"/>
    <path d="M 73 48 Q 90 50 90 64 Q 90 78 73 80" fill="none" stroke={C.porcelain} strokeWidth="4.5"/>
    {/* mug body */}
    <path d="M 21 41 Q 21 38 24 38 H 76 Q 79 38 79 41 V 78 Q 79 84 73 84 H 27 Q 21 84 21 78 Z" fill={C.porcelain}/>
    {/* shadow on mug right */}
    <path d="M 70 42 Q 75 42 75 47 V 80 Q 75 83 71 83" fill={C.porcelainShadow} opacity="0.6"/>
    {/* rim ellipse top */}
    <ellipse cx="50" cy="40" rx="29" ry="6" fill={C.porcelainShadow}/>
    <ellipse cx="50" cy="40" rx="27.5" ry="5.2" fill={liquid}/>
    {/* liquid inner highlight */}
    {liquid !== C.liquidDark && (
      <ellipse cx="50" cy="38.5" rx="22" ry="3" fill={liquid} opacity="0.6"/>
    )}
    {/* foam blanket */}
    {foam === 'cap' && (
      <>
        <ellipse cx="50" cy="38" rx="25" ry="5" fill={foamColor}/>
        <ellipse cx="42" cy="36.5" rx="9" ry="2.5" fill="#fff" opacity="0.7"/>
        <ellipse cx="58" cy="37" rx="6" ry="1.8" fill="#fff" opacity="0.7"/>
      </>
    )}
    {foam === 'micro' && (
      <ellipse cx="50" cy="39" rx="25" ry="3.2" fill={foamColor} opacity="0.95"/>
    )}
    {foam === 'whip' && (
      <>
        <ellipse cx="50" cy="36" rx="22" ry="4.5" fill={C.whip}/>
        <path d="M 32 36 Q 36 28 42 32 Q 46 24 52 30 Q 58 22 64 30 Q 68 26 70 36 Z" fill={C.whip}/>
        <ellipse cx="42" cy="31" rx="3" ry="1.5" fill="#fff" opacity="0.7"/>
      </>
    )}
    {/* latte art swirl */}
    {art === 'rosetta' && (
      <g stroke={foamColor || '#fff'} strokeWidth="1.4" fill="none" opacity="0.95">
        <path d="M 32 40 Q 50 36 68 40"/>
        <path d="M 38 38.5 Q 50 41 62 38.5"/>
        <path d="M 50 36 V 43" strokeWidth="1.6"/>
      </g>
    )}
    {art === 'heart' && (
      <path d="M 50 36 C 45 34 42 36 44 39 L 50 43 L 56 39 C 58 36 55 34 50 36 Z" fill={foamColor || '#fff'} opacity="0.95"/>
    )}
    {/* drizzle pattern */}
    {accent === 'caramel-grid' && (
      <g stroke={C.caramel} strokeWidth="1.5" fill="none" opacity="0.95">
        <path d="M 30 38 L 70 38"/>
        <path d="M 30 42 L 70 42"/>
        <path d="M 36 35 L 36 45"/>
        <path d="M 50 34 L 50 46"/>
        <path d="M 64 35 L 64 45"/>
      </g>
    )}
    {accent === 'choco-drizzle' && (
      <g stroke={C.chocolate} strokeWidth="1.3" fill="none" opacity="0.95">
        <path d="M 32 32 Q 38 34 38 30 Q 38 28 42 30 Q 44 32 48 30"/>
        <path d="M 52 32 Q 56 28 60 32 Q 64 30 68 32"/>
      </g>
    )}
    {accent === 'cocoa-dust' && (
      <g fill={C.chocolate} opacity="0.65">
        {[[40,35],[45,33],[50,35],[55,33],[58,36],[44,37],[52,36]].map((p,i) => <circle key={i} cx={p[0]} cy={p[1]} r="0.6"/>)}
      </g>
    )}
    {/* light highlight on mug */}
    <ellipse cx="32" cy="50" rx="3" ry="9" fill="#fff" opacity="0.55"/>
  </g>
);

// ====== Demitasse (espresso) ======
const Demitasse = () => (
  <g>
    <ellipse cx="50" cy="85" rx="30" ry="3.5" fill={C.porcelainShadow}/>
    <ellipse cx="50" cy="83.5" rx="30" ry="3.5" fill={C.porcelain}/>
    <path d="M 70 58 Q 82 59 82 67 Q 82 75 70 76" fill="none" stroke={C.porcelain} strokeWidth="4"/>
    <path d="M 30 53 Q 30 50 33 50 H 67 Q 70 50 70 53 V 75 Q 70 80 65 80 H 35 Q 30 80 30 75 Z" fill={C.porcelain}/>
    <path d="M 64 55 Q 67 55 67 58 V 77 Q 67 79 64 79" fill={C.porcelainShadow} opacity="0.6"/>
    <ellipse cx="50" cy="52" rx="19" ry="3.5" fill={C.porcelainShadow}/>
    <ellipse cx="50" cy="52" rx="18" ry="3" fill={C.liquidDark}/>
    {/* crema */}
    <ellipse cx="50" cy="51.4" rx="15" ry="1.8" fill={C.caramel} opacity="0.85"/>
    <ellipse cx="45" cy="51" rx="3" ry="0.7" fill="#fff" opacity="0.4"/>
    <ellipse cx="36" cy="62" rx="2" ry="8" fill="#fff" opacity="0.5"/>
  </g>
);

// ====== Tall iced cup (clear plastic) ======
const IcedCup = ({ liquid = C.tea, accent }) => (
  <g>
    {/* straw */}
    <rect x="62" y="6" width="4.5" height="32" rx="2" fill={C.green}/>
    {/* cup outline / glass */}
    <path d="M 22 28 H 78 L 73 90 Q 73 92 71 92 H 29 Q 27 92 27 90 Z" fill={C.glass} opacity="0.55"/>
    {/* liquid */}
    <path d="M 24 40 H 76 L 72 88 Q 72 90 70 90 H 30 Q 28 90 28 88 Z" fill={liquid}/>
    {/* ice cubes */}
    <g fill="#fff" opacity="0.65">
      <rect x="32" y="45" width="14" height="14" rx="2" transform="rotate(-8 39 52)"/>
      <rect x="50" y="42" width="13" height="13" rx="2" transform="rotate(12 56 48)"/>
      <rect x="38" y="62" width="12" height="12" rx="2" transform="rotate(-4 44 68)"/>
      <rect x="54" y="60" width="11" height="11" rx="2" transform="rotate(18 59 65)"/>
    </g>
    {/* rim */}
    <ellipse cx="50" cy="28" rx="28" ry="5" fill={C.glassEdge}/>
    <ellipse cx="50" cy="27.5" rx="26.5" ry="3.8" fill={C.glass}/>
    {/* lemon slice */}
    {accent === 'lemon' && (
      <g transform="translate(46, 22)">
        <circle r="7" fill={C.lemon} stroke={C.lemonDark} strokeWidth="0.8"/>
        <g stroke={C.lemonDark} strokeWidth="0.6" opacity="0.7">
          <path d="M 0 -6 V 6"/><path d="M -6 0 H 6"/>
          <path d="M -4 -4 L 4 4"/><path d="M -4 4 L 4 -4"/>
        </g>
      </g>
    )}
    {/* peach */}
    {accent === 'peach' && (
      <g>
        <circle cx="42" cy="52" r="4" fill={C.peachDark} opacity="0.85"/>
        <circle cx="58" cy="68" r="3" fill={C.peachDark} opacity="0.85"/>
      </g>
    )}
    {/* highlight stripe */}
    <rect x="30" y="32" width="3" height="55" rx="1.5" fill="#fff" opacity="0.55"/>
  </g>
);

// ====== Tall frappuccino cup with whipped cream + dome ======
const FrappCup = ({ liquid = C.liquidMid, drizzle }) => (
  <g>
    {/* dome lid */}
    <path d="M 22 24 Q 50 6 78 24" fill={C.glass} opacity="0.55"/>
    <path d="M 22 24 Q 50 6 78 24" fill="none" stroke={C.glassEdge} strokeWidth="1"/>
    {/* straw through dome */}
    <rect x="48" y="2" width="5" height="32" rx="2" fill={C.green}/>
    {/* dome rim */}
    <ellipse cx="50" cy="24" rx="29" ry="3" fill={C.glassEdge}/>
    {/* whipped cream visible through dome */}
    <g opacity="0.95">
      <path d="M 25 24 Q 32 14 40 22 Q 46 10 54 20 Q 62 12 68 22 Q 73 18 75 24 Z" fill={C.whip}/>
      <ellipse cx="38" cy="19" rx="3" ry="1.4" fill="#fff" opacity="0.6"/>
    </g>
    {/* drizzle on whip */}
    {drizzle === 'caramel' && (
      <g stroke={C.caramel} strokeWidth="1.2" fill="none">
        <path d="M 32 22 Q 36 18 40 22 Q 44 18 48 22"/>
        <path d="M 54 21 Q 58 17 62 21 Q 66 19 70 22"/>
      </g>
    )}
    {drizzle === 'choco' && (
      <g stroke={C.chocolate} strokeWidth="1.2" fill="none">
        <path d="M 30 22 Q 34 18 38 22 Q 42 18 46 22"/>
        <path d="M 52 22 Q 56 18 60 22 Q 64 19 68 22"/>
      </g>
    )}
    {/* cup body */}
    <path d="M 24 30 H 76 L 71 90 Q 71 92 69 92 H 31 Q 29 92 29 90 Z" fill={C.glass} opacity="0.6"/>
    <path d="M 26 32 H 74 L 70 89 Q 70 91 68 91 H 32 Q 30 91 30 89 Z" fill={liquid}/>
    {/* internal swirls */}
    <g fill="#fff" opacity="0.25">
      <ellipse cx="40" cy="45" rx="8" ry="2"/>
      <ellipse cx="60" cy="60" rx="6" ry="2"/>
      <ellipse cx="45" cy="75" rx="10" ry="2"/>
    </g>
    {/* highlight */}
    <rect x="32" y="36" width="3" height="50" rx="1.5" fill="#fff" opacity="0.5"/>
  </g>
);

// ====== DrinkIcon: select an illustration by name/id ======
const DRINK_GFX = {
  'latte':       <MugHot liquid={C.liquidMid} foam="micro" art="rosetta" foamColor={C.foam}/>,
  'americano':   <MugHot liquid={C.liquidDark}/>,
  'cappuccino':  <MugHot liquid={C.liquidMid} foam="cap" foamColor={C.foam} accent="cocoa-dust"/>,
  'caramel-macchiato': <MugHot liquid={C.cream} foam="micro" foamColor={C.foam} accent="caramel-grid"/>,
  'flat-white':  <MugHot liquid={C.liquidLight} foam="micro" foamColor="#F2E6D1" art="heart"/>,
  'espresso':    <Demitasse/>,
  'mocha':       <MugHot liquid={C.chocolate} foam="whip" foamColor={C.whip} accent="choco-drizzle"/>,
  'oat-latte':   <MugHot liquid={C.oat} foam="micro" foamColor="#EAD9B5" art="rosetta"/>,
  'vanilla-latte': <MugHot liquid={C.vanilla} foam="micro" foamColor={C.foam} art="rosetta"/>,
  'mocha-frap':  <FrappCup liquid={C.chocolate} drizzle="choco"/>,
  'caramel-frap':<FrappCup liquid={C.cream} drizzle="caramel"/>,
  'matcha-frap': <FrappCup liquid={C.matcha} drizzle="choco"/>,
  'iced-black-tea': <IcedCup liquid={C.tea}/>,
  'peach-oolong': <IcedCup liquid={C.peach} accent="peach"/>,
  'iced-lemon': <IcedCup liquid={C.lemon} accent="lemon"/>,
};

const DrinkIcon = ({ name, size = 64, bg, locked, ringColor, style }) => {
  const gfx = DRINK_GFX[name] || DRINK_GFX['latte'];
  return (
    <div style={{
      width: size, height: size, borderRadius: '50%',
      background: bg || C.porcelain,
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      border: ringColor ? `1.5px solid ${ringColor}` : 'none',
      position: 'relative',
      overflow: 'hidden',
      ...style,
    }}>
      <svg viewBox="0 0 100 100" width="100%" height="100%" style={{ filter: locked ? 'grayscale(1)' : 'none', opacity: locked ? 0.35 : 1 }}>
        {gfx}
      </svg>
      {locked && (
        <div style={{
          position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center',
          background: 'rgba(245, 242, 234, 0.45)',
          color: 'rgba(60,60,60,0.6)',
        }}>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><rect x="5" y="11" width="14" height="10" rx="2"/><path d="M8 11 V7 A 4 4 0 0 1 16 7 V11"/></svg>
        </div>
      )}
    </div>
  );
};

// ====== Drink master data ======
const DRINKS = {
  'latte':       { name: '经典拿铁', en: 'Latte', cat: '经典咖啡', drank: 23 },
  'americano':   { name: '美式',    en: 'Americano', cat: '经典咖啡', drank: 18 },
  'cappuccino':  { name: '卡布奇诺', en: 'Cappuccino', cat: '经典咖啡', drank: 0 },
  'caramel-macchiato': { name: '焦糖玛奇朵', en: 'Caramel Macchiato', cat: '经典咖啡', drank: 12 },
  'flat-white':  { name: '馥芮白',   en: 'Flat White', cat: '经典咖啡', drank: 7 },
  'espresso':    { name: '浓缩咖啡', en: 'Espresso', cat: '经典咖啡', drank: 0 },
  'mocha':       { name: '摩卡',     en: 'Mocha', cat: '经典咖啡', drank: 4 },
  'oat-latte':   { name: '燕麦丝绒拿铁', en: 'Oatmilk Velvet Latte', cat: '经典咖啡', drank: 47 },
  'vanilla-latte': { name: '香草风味拿铁', en: 'Vanilla Latte', cat: '经典咖啡', drank: 0 },
  'mocha-frap':  { name: '摩卡星冰乐', en: 'Mocha Frappé', cat: '星冰乐', drank: 6 },
  'caramel-frap':{ name: '焦糖星冰乐', en: 'Caramel Frappé', cat: '星冰乐', drank: 3 },
  'matcha-frap': { name: '抹茶星冰乐', en: 'Matcha Frappé', cat: '星冰乐', drank: 0 },
  'iced-black-tea': { name: '冰摇红茶', en: 'Iced Black Tea', cat: '冰摇茶', drank: 2 },
  'peach-oolong': { name: '冰摇桃桃乌龙', en: 'Peach Oolong Iced Tea', cat: '冰摇茶', drank: 9 },
  'iced-lemon': { name: '冰摇柠檬',  en: 'Iced Lemon Tea', cat: '冰摇茶', drank: 0 },
};

const DRINK_GROUPS = [
  { cat: '经典咖啡', ids: ['latte', 'americano', 'cappuccino', 'caramel-macchiato', 'flat-white', 'espresso', 'mocha', 'oat-latte', 'vanilla-latte'] },
  { cat: '星冰乐',   ids: ['mocha-frap', 'caramel-frap', 'matcha-frap'] },
  { cat: '冰摇茶',   ids: ['iced-black-tea', 'peach-oolong', 'iced-lemon'] },
];

Object.assign(window, { DrinkIcon, DRINKS, DRINK_GROUPS, C });
