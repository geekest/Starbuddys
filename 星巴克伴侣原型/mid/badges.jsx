// mid/badges.jsx — illustrated badge icons + Badge component

const BadgeArt = {
  // 饮品收集类
  starter: ({ unlocked }) => (
    <svg viewBox="0 0 64 64">
      <circle cx="32" cy="32" r="24" fill={unlocked ? '#F4ECD8' : '#EBE7DC'}/>
      <path d="M 22 22 H 42 L 40 46 Q 40 48 38 48 H 26 Q 24 48 24 46 Z" fill="#fff" stroke="#1A1A18" strokeWidth="1.4"/>
      <ellipse cx="32" cy="22" rx="10" ry="2.5" fill="#6B4225"/>
      <path d="M 42 26 Q 48 26 48 32 Q 48 38 42 38" fill="none" stroke="#1A1A18" strokeWidth="1.4"/>
      <text x="32" y="58" textAnchor="middle" fontSize="6" fill="#1A1A18" fontWeight="700">10</text>
    </svg>
  ),
  half: ({ unlocked }) => (
    <svg viewBox="0 0 64 64">
      <circle cx="32" cy="32" r="24" fill={unlocked ? '#E9F2EC' : '#EBE7DC'}/>
      <g transform="translate(20, 18)">
        <ellipse cx="12" cy="14" rx="10" ry="13" fill="#1F6B47" stroke="#0E4A2E" strokeWidth="1.2"/>
        <path d="M 12 2 Q 9 14 12 26" stroke="#fff" strokeWidth="1.2" fill="none"/>
      </g>
      <text x="32" y="58" textAnchor="middle" fontSize="6" fill="#0E4A2E" fontWeight="700">24</text>
    </svg>
  ),
  full: ({ unlocked }) => (
    <svg viewBox="0 0 64 64">
      <circle cx="32" cy="32" r="24" fill={unlocked ? '#FBF1D9' : '#EBE7DC'}/>
      <path d="M 18 28 L 22 18 L 28 24 L 32 14 L 36 24 L 42 18 L 46 28 L 44 42 H 20 Z" fill="#C58A3A" stroke="#9A6A28" strokeWidth="1.2"/>
      <rect x="20" y="40" width="24" height="4" fill="#9A6A28"/>
      <text x="32" y="58" textAnchor="middle" fontSize="6" fill="#9A6A28" fontWeight="700">48</text>
    </svg>
  ),

  // 类型大师
  frapMaster: ({ unlocked }) => (
    <svg viewBox="0 0 64 64">
      <circle cx="32" cy="32" r="24" fill={unlocked ? '#E9F2EC' : '#EBE7DC'}/>
      <path d="M 22 20 Q 32 14 42 20 Z" fill="#fff"/>
      <path d="M 22 22 H 42 L 40 46 Q 40 48 38 48 H 26 Q 24 48 24 46 Z" fill="#7DA268"/>
      <ellipse cx="32" cy="22" rx="10" ry="2.5" fill="#5C7E48"/>
      <rect x="29" y="14" width="3" height="8" fill="#0E4A2E"/>
    </svg>
  ),
  teaMaster: ({ unlocked }) => (
    <svg viewBox="0 0 64 64">
      <circle cx="32" cy="32" r="24" fill={unlocked ? '#F4E2E6' : '#EBE7DC'}/>
      <path d="M 22 22 H 42 L 40 46 Q 40 48 38 48 H 26 Q 24 48 24 46 Z" fill="#F0B5A8" stroke="#1A1A18" strokeWidth="1"/>
      <ellipse cx="32" cy="22" rx="10" ry="2.5" fill="#D38978"/>
      <rect x="34" y="14" width="3" height="8" fill="#0E4A2E"/>
    </svg>
  ),
  classicMaster: ({ unlocked }) => (
    <svg viewBox="0 0 64 64">
      <circle cx="32" cy="32" r="24" fill={unlocked ? '#FBF1D9' : '#EBE7DC'}/>
      <path d="M 22 24 H 42 L 40 46 Q 40 48 38 48 H 26 Q 24 48 24 46 Z" fill="#fff" stroke="#1A1A18" strokeWidth="1.2"/>
      <path d="M 42 28 Q 48 28 48 34 Q 48 40 42 40" fill="none" stroke="#1A1A18" strokeWidth="1.2"/>
      <ellipse cx="32" cy="24" rx="10" ry="2.5" fill="#6B4225"/>
      <path d="M 24 18 Q 26 14 24 12" stroke="#9E9E96" strokeWidth="1" fill="none"/>
      <path d="M 32 18 Q 34 14 32 12" stroke="#9E9E96" strokeWidth="1" fill="none"/>
      <path d="M 40 18 Q 42 14 40 12" stroke="#9E9E96" strokeWidth="1" fill="none"/>
    </svg>
  ),

  // 单品狂热
  fan10: ({ unlocked }) => (
    <svg viewBox="0 0 64 64">
      <circle cx="32" cy="32" r="24" fill={unlocked ? '#F4E2E6' : '#EBE7DC'}/>
      <path d="M 32 12 C 38 18 44 22 44 30 C 44 38 38 46 32 48 C 26 46 20 38 20 30 C 20 22 26 18 32 12 Z" fill="#C26C7E" stroke="#884E5E" strokeWidth="1.4"/>
      <text x="32" y="36" textAnchor="middle" fontSize="11" fill="#fff" fontWeight="800">×10</text>
    </svg>
  ),
  fan50: ({ unlocked }) => (
    <svg viewBox="0 0 64 64">
      <circle cx="32" cy="32" r="24" fill={unlocked ? '#F4E2E6' : '#EBE7DC'}/>
      <path d="M 32 12 C 38 18 44 22 44 30 C 44 38 38 46 32 48 C 26 46 20 38 20 30 C 20 22 26 18 32 12 Z" fill="#C26C7E" stroke="#884E5E" strokeWidth="1.4"/>
      <text x="32" y="37" textAnchor="middle" fontSize="11" fill="#fff" fontWeight="800">×50</text>
    </svg>
  ),
  fan100: ({ unlocked }) => (
    <svg viewBox="0 0 64 64">
      <circle cx="32" cy="32" r="24" fill={unlocked ? '#F4E2E6' : '#EBE7DC'}/>
      <path d="M 32 10 C 38 16 46 22 46 32 C 46 40 38 48 32 50 C 26 48 18 40 18 32 C 18 22 26 16 32 10 Z" fill="#C26C7E" stroke="#884E5E" strokeWidth="1.4"/>
      <text x="32" y="38" textAnchor="middle" fontSize="11" fill="#fff" fontWeight="800">100</text>
    </svg>
  ),

  // 里程碑
  cup100: ({ unlocked }) => (
    <svg viewBox="0 0 64 64">
      <circle cx="32" cy="32" r="24" fill={unlocked ? '#E9F2EC' : '#EBE7DC'}/>
      <path d="M 22 22 H 42 L 40 46 Q 40 48 38 48 H 26 Q 24 48 24 46 Z" fill="#fff" stroke="#0E4A2E" strokeWidth="1.4"/>
      <text x="32" y="40" textAnchor="middle" fontSize="11" fill="#0E4A2E" fontWeight="800">100</text>
    </svg>
  ),
  cup500: ({ unlocked }) => (
    <svg viewBox="0 0 64 64">
      <circle cx="32" cy="32" r="24" fill={unlocked ? '#FBF1D9' : '#EBE7DC'}/>
      <path d="M 18 28 L 22 18 L 28 24 L 32 14 L 36 24 L 42 18 L 46 28 L 44 44 H 20 Z" fill="#C58A3A" stroke="#9A6A28" strokeWidth="1.2"/>
      <text x="32" y="40" textAnchor="middle" fontSize="9" fill="#fff" fontWeight="800">500</text>
    </svg>
  ),
};

const Badge = ({ kind, unlocked, size = 72 }) => {
  const Art = BadgeArt[kind] || BadgeArt.starter;
  return (
    <div style={{
      width: size, height: size, position: 'relative',
      filter: unlocked ? 'none' : 'grayscale(1)',
      opacity: unlocked ? 1 : 0.4,
    }}>
      <Art unlocked={unlocked}/>
      {!unlocked && (
        <div style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <div style={{ width: 24, height: 24, borderRadius: 12, background: 'rgba(0,0,0,0.5)', color: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <I.lock size={13}/>
          </div>
        </div>
      )}
    </div>
  );
};

Object.assign(window, { Badge, BadgeArt });
