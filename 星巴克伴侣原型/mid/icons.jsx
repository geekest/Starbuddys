// mid/icons.jsx — system icons (line style)

const Icon = ({ size = 20, stroke = 1.6, children, viewBox = '0 0 24 24', style }) => (
  <svg width={size} height={size} viewBox={viewBox} fill="none" stroke="currentColor" strokeWidth={stroke} strokeLinecap="round" strokeLinejoin="round" style={style}>
    {children}
  </svg>
);

const I = {
  // tab icons — filled when active
  tabDrink: ({ size = 24, active }) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <path d="M6 7 H18 L17 19 Q17 21 15 21 H9 Q7 21 7 19 Z" stroke="currentColor" strokeWidth="1.6" fill={active ? 'currentColor' : 'none'} fillOpacity={active ? 0.12 : 0}/>
      <path d="M18 9 Q22 9 22 13 Q22 16 18 16" stroke="currentColor" strokeWidth="1.6" fill="none"/>
      <path d="M10 4 Q10 6 12 6 Q14 6 14 8" stroke="currentColor" strokeWidth="1.4" strokeLinecap="round" fill="none" opacity={active ? 1 : 0.6}/>
    </svg>
  ),
  tabLibrary: ({ size = 24, active }) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <rect x="3" y="3" width="7" height="7" rx="2" stroke="currentColor" strokeWidth="1.6" fill={active ? 'currentColor' : 'none'} fillOpacity={active ? 0.12 : 0}/>
      <rect x="14" y="3" width="7" height="7" rx="2" stroke="currentColor" strokeWidth="1.6" fill={active ? 'currentColor' : 'none'} fillOpacity={active ? 0.12 : 0}/>
      <rect x="3" y="14" width="7" height="7" rx="2" stroke="currentColor" strokeWidth="1.6" fill={active ? 'currentColor' : 'none'} fillOpacity={active ? 0.12 : 0}/>
      <rect x="14" y="14" width="7" height="7" rx="2" stroke="currentColor" strokeWidth="1.6" fill={active ? 'currentColor' : 'none'} fillOpacity={active ? 0.12 : 0}/>
    </svg>
  ),
  tabHistory: ({ size = 24, active }) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <rect x="3" y="4" width="18" height="17" rx="3" stroke="currentColor" strokeWidth="1.6" fill={active ? 'currentColor' : 'none'} fillOpacity={active ? 0.12 : 0}/>
      <path d="M3 9 H21" stroke="currentColor" strokeWidth="1.6"/>
      <path d="M8 2 V6" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"/>
      <path d="M16 2 V6" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"/>
    </svg>
  ),
  tabMe: ({ size = 24, active }) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
      <circle cx="12" cy="8" r="4" stroke="currentColor" strokeWidth="1.6" fill={active ? 'currentColor' : 'none'} fillOpacity={active ? 0.12 : 0}/>
      <path d="M3 21 C 3 16 7 14 12 14 C 17 14 21 16 21 21" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" fill={active ? 'currentColor' : 'none'} fillOpacity={active ? 0.12 : 0}/>
    </svg>
  ),

  chevLeft: (p) => <Icon {...p}><path d="M15 6 L9 12 L15 18"/></Icon>,
  chevRight: (p) => <Icon {...p}><path d="M9 6 L15 12 L9 18"/></Icon>,
  chevDown: (p) => <Icon {...p}><path d="M6 9 L12 15 L18 9"/></Icon>,
  close: (p) => <Icon {...p}><path d="M6 6 L18 18"/><path d="M18 6 L6 18"/></Icon>,
  search: (p) => <Icon {...p}><circle cx="11" cy="11" r="6"/><path d="M16 16 L20 20"/></Icon>,
  plus: (p) => <Icon {...p}><path d="M12 5 V19"/><path d="M5 12 H19"/></Icon>,
  minus: (p) => <Icon {...p}><path d="M5 12 H19"/></Icon>,
  refresh: (p) => <Icon {...p}><path d="M20 8 V13 H15"/><path d="M20 13 A 8 8 0 1 1 16 6.5"/></Icon>,
  heart: (p) => <Icon {...p}><path d="M12 20 C 6 16 3 12 3 8.5 C 3 6 5 4 7.5 4 C 9.5 4 11 5.5 12 7 C 13 5.5 14.5 4 16.5 4 C 19 4 21 6 21 8.5 C 21 12 18 16 12 20 Z"/></Icon>,
  heartFill: (p) => <Icon {...p}><path d="M12 20 C 6 16 3 12 3 8.5 C 3 6 5 4 7.5 4 C 9.5 4 11 5.5 12 7 C 13 5.5 14.5 4 16.5 4 C 19 4 21 6 21 8.5 C 21 12 18 16 12 20 Z" fill="currentColor"/></Icon>,
  share: (p) => <Icon {...p}><path d="M12 4 V15"/><path d="M8 8 L12 4 L16 8"/><path d="M5 14 V19 A1 1 0 0 0 6 20 H18 A1 1 0 0 0 19 19 V14"/></Icon>,
  settings: (p) => <Icon {...p}><circle cx="12" cy="12" r="3"/><path d="M19 12 A 7 7 0 0 0 18.7 10.2 L20.3 8.9 L18.9 6.5 L17 7.3 A 7 7 0 0 0 14 5.6 L13.7 3.5 H10.3 L10 5.6 A 7 7 0 0 0 7 7.3 L5.1 6.5 L3.7 8.9 L5.3 10.2 A 7 7 0 0 0 5 12 A 7 7 0 0 0 5.3 13.8 L3.7 15.1 L5.1 17.5 L7 16.7 A 7 7 0 0 0 10 18.4 L10.3 20.5 H13.7 L14 18.4 A 7 7 0 0 0 17 16.7 L18.9 17.5 L20.3 15.1 L18.7 13.8 A 7 7 0 0 0 19 12 Z"/></Icon>,
  star: (p) => <Icon {...p}><path d="M12 3 L14.5 9 L21 9.5 L16 13.5 L17.5 20 L12 16.5 L6.5 20 L8 13.5 L3 9.5 L9.5 9 Z"/></Icon>,
  starFill: (p) => <Icon {...p}><path d="M12 3 L14.5 9 L21 9.5 L16 13.5 L17.5 20 L12 16.5 L6.5 20 L8 13.5 L3 9.5 L9.5 9 Z" fill="currentColor"/></Icon>,
  lock: (p) => <Icon {...p}><rect x="5" y="11" width="14" height="10" rx="2"/><path d="M8 11 V7 A 4 4 0 0 1 16 7 V11"/></Icon>,
  flame: (p) => <Icon {...p}><path d="M12 3 C 14 7 16 9 16 13 C 16 17 14 20 12 20 C 10 20 8 17 8 13 C 8 10 10 8 12 3 Z"/></Icon>,
  bell: (p) => <Icon {...p}><path d="M6 16 L6 11 A 6 6 0 0 1 18 11 L18 16 L20 19 H4 Z"/><path d="M10 19 A 2 2 0 0 0 14 19"/></Icon>,
  globe: (p) => <Icon {...p}><circle cx="12" cy="12" r="9"/><path d="M3 12 H21"/><path d="M12 3 C 9 6 8 9 8 12 C 8 15 9 18 12 21"/><path d="M12 3 C 15 6 16 9 16 12 C 16 15 15 18 12 21"/></Icon>,
  info: (p) => <Icon {...p}><circle cx="12" cy="12" r="9"/><path d="M12 8 V8.1"/><path d="M12 12 V16"/></Icon>,
  message: (p) => <Icon {...p}><path d="M4 6 A 2 2 0 0 1 6 4 H18 A 2 2 0 0 1 20 6 V15 A 2 2 0 0 1 18 17 H 10 L 6 21 V 17 H 6 A 2 2 0 0 1 4 15 Z"/></Icon>,
  arrowRight: (p) => <Icon {...p}><path d="M5 12 H19"/><path d="M13 6 L19 12 L13 18"/></Icon>,
  crown: (p) => <Icon {...p}><path d="M3 8 L7 14 L12 5 L17 14 L21 8 L19 19 H5 Z"/></Icon>,
};

Object.assign(window, { I, Icon });
