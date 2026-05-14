// mid/app.jsx — main composition for mid-fi

const App = () => (
  <DesignCanvas title="StarBuddys · 中保真" subtitle="主流程 + 4 tab · 选定方向已收敛">
    <DCSection id="intro" title="设计说明" subtitle="基于低保真选稿 · 半自动咖啡机 / 平铺图鉴 / 分类徽章墙">
      <DCArtboard id="readme" label="设计要点" width={400} height={520} chrome="none">
        <div style={{
          padding: 26, background: '#FFFFFF', height: '100%',
          fontFamily: '"PingFang SC", system-ui, sans-serif',
          overflow: 'auto', borderRadius: 14,
          border: '1px solid #E5E3DC',
          boxShadow: '0 4px 16px rgba(0,0,0,0.05)',
        }}>
          <div style={{ display: 'inline-block', fontSize: 10, color: '#0E4A2E', letterSpacing: 3, fontWeight: 700, background: '#E9F2EC', padding: '4px 8px', borderRadius: 6 }}>STARBUDDYS</div>
          <div style={{ fontSize: 26, fontWeight: 800, letterSpacing: '-0.02em', marginTop: 8 }}>中保真稿</div>

          <hr style={{ margin: '16px 0', border: 0, borderTop: '1px solid #E5E3DC' }}/>

          <div style={{ fontSize: 13, lineHeight: 1.7, color: '#3A3A36' }}>
            <p style={{ margin: '0 0 10px' }}><b>视觉方向</b>：白 / 深绿（#0E4A2E）/ 暖米色，sans-serif (PingFang SC + 系统字体)，现代清新不装饰。</p>
            <p style={{ margin: '0 0 10px' }}><b>覆盖屏幕</b>（7 屏）：</p>
            <ol style={{ margin: '0 0 10px 18px', padding: 0 }}>
              <li>喝一杯·待机：半自动咖啡机 + 上一杯回顾 + 我自己选</li>
              <li>喝一杯·扭出：底部出杯卡 + 推荐配置 + 记一杯 / 刷新</li>
              <li>选饮品·弹层：搜索 / 分类 / 头像式网格 + 喝过次数标</li>
              <li>详情·记一杯：杯型 / 温度 / 糖度 / shot / 奶 / 风味 / 评分 / 备注</li>
              <li>饮品库·图鉴：分组平铺，未喝剪影锁，已喝点亮带次数 + 全收集勋章</li>
              <li>历史·月历：饮品图标点缀日期 + 当月汇总 + 5 月最爱 + 明细</li>
              <li>我的·分类徽章墙：4 大类（收集 / 类型大师 / 单品狂热 / 里程碑）+ 设置</li>
            </ol>
            <p style={{ margin: '0 0 10px' }}><b>插图</b>：15 款饮品 SVG（马克杯 / 浓缩 / 星冰乐 / 冰摇茶）+ 12 颗徽章原创设计。</p>
            <p style={{ margin: '0 0 10px' }}><b>下一步</b>：可继续打磨细节、加入动效原型、补充空状态 / 解锁动画 / 详情子页。</p>
          </div>
        </div>
      </DCArtboard>
    </DCSection>

    <DCSection id="drink" title="① 喝一杯" subtitle="半自动咖啡机 · 待机 → 出杯 → 详情">
      <DCArtboard id="drink-idle"   label="A · 待机"   width={390} height={844}><DrinkTabIdle/></DCArtboard>
      <DCArtboard id="drink-result" label="B · 扭出"   width={390} height={844}><DrinkTabResult/></DCArtboard>
      <DCArtboard id="picker"       label="C · 选饮品弹层" width={390} height={844}><DrinkPicker/></DCArtboard>
      <DCArtboard id="detail"       label="D · 详情·记一杯" width={390} height={2400}><DetailPage/></DCArtboard>
    </DCSection>

    <DCSection id="library" title="② 饮品库" subtitle="图鉴式 · 未喝剪影 / 已喝点亮">
      <DCArtboard id="lib" label="饮品图鉴" width={390} height={1100}><LibraryTab/></DCArtboard>
    </DCSection>

    <DCSection id="history" title="③ 历史" subtitle="月历点缀 + 汇总 + 明细">
      <DCArtboard id="his" label="月历·明细" width={390} height={1180}><HistoryTab/></DCArtboard>
    </DCSection>

    <DCSection id="me" title="④ 我的" subtitle="分类徽章墙 + 支持设置">
      <DCArtboard id="me" label="分类徽章墙" width={390} height={1500}><ProfileTab/></DCArtboard>
    </DCSection>
  </DesignCanvas>
);

ReactDOM.createRoot(document.getElementById('root')).render(<App/>);
