// app.jsx — main composition

const App = () => (
  <DesignCanvas title="StarBuddys · 低保真线框稿" subtitle="4 tab × 多版本对比">
    <DCSection id="intro" title="项目说明" subtitle="本稿为低保真线框，黑线 + 深绿强调；图片占位为斜纹方/圆。">
      <DCArtboard id="readme" label="设计说明" width={420} height={520} chrome="none">
        <div style={{ padding: 24, background: '#ffffff', height: '100%', fontFamily: '"PingFang SC", system-ui, sans-serif', overflow: 'auto', borderRadius: 10, border: '1.5px solid #2a2a28' }}>
          <div style={{ fontSize: 24, fontWeight: 800, letterSpacing: '-0.01em' }}>StarBuddys</div>
          <div style={{ fontSize: 12, color: '#1f5c3f', marginTop: 4, fontWeight: 600 }}>记录我每天的咖啡 · 低保真线框稿</div>

          <hr style={{ margin: '16px 0', border: 0, borderTop: '1px solid #e5e3dc' }}/>

          <div style={{ fontSize: 13, lineHeight: 1.7, color: '#3a3a36' }}>
            <p style={{ margin: '0 0 10px' }}><b>视觉方向</b>：现代清新，白底 + 深绿强调（#1f5c3f），sans-serif 字体，不刻意装饰。</p>
            <p style={{ margin: '0 0 10px' }}><b>覆盖屏幕</b>：</p>
            <ul style={{ margin: '0 0 10px 18px', padding: 0 }}>
              <li>喝一杯 · <b>3 个版本</b>（复古扭蛋机 / 半手动咖啡机 / 未来感伪 3D）</li>
              <li>选饮品菜单弹窗 + 饮品详情记录页</li>
              <li>饮品库 · 2 个版本（图鉴式 / 横滑分组）</li>
              <li>历史 · 月历 + 明细</li>
              <li>我的 · <b>3 个版本</b>徽章墙（网格 / 精选大卡 / 分类列表）</li>
            </ul>
            <p style={{ margin: '0 0 10px' }}><b>线框风格</b>：黑色 1.5px 描边、斜纹占位、深绿色注释文字。所有图标/图片均为占位。</p>
            <p style={{ margin: '0 0 10px' }}><b>下一步</b>：选定每个 tab 的版本，进入中保真 → 高保真 + 交互原型。</p>
          </div>

          <hr style={{ margin: '16px 0', border: 0, borderTop: '1px solid #e5e3dc' }}/>

          <div style={{ fontSize: 11, color: '#9a9690' }}>
            提示：拖拽画布可平移，鼠标滚轮缩放；任意画板可双击进入聚焦预览，← / → 切换、Esc 退出。
          </div>
        </div>
      </DCArtboard>
    </DCSection>

    <DCSection id="drink" title="① 喝一杯" subtitle="3 个扭蛋机风格对比 · 重点对比项">
      <DCArtboard id="drink-v1" label="A · 复古实体扭蛋机" width={375} height={812}><DrinkV1 /></DCArtboard>
      <DCArtboard id="drink-v2" label="B · 半手动咖啡机" width={375} height={812}><DrinkV2 /></DCArtboard>
      <DCArtboard id="drink-v3" label="C · 未来感伪 3D" width={375} height={812}><DrinkV3 /></DCArtboard>
    </DCSection>

    <DCSection id="record" title="① b. 选饮品 + 记一杯" subtitle="底部「喝一杯」CTA 流程；选饮品弹窗 → 详情记录页">
      <DCArtboard id="menu" label="选饮品 · 弹窗" width={375} height={812}><DrinkMenu /></DCArtboard>
      <DCArtboard id="detail" label="详情·记一杯" width={375} height={1080}><DetailPage /></DCArtboard>
    </DCSection>

    <DCSection id="library" title="② 饮品库" subtitle="图鉴式收集 · 已喝点亮 / 未喝剪影">
      <DCArtboard id="lib-v1" label="A · 平铺图鉴" width={375} height={812}><LibraryV1 /></DCArtboard>
      <DCArtboard id="lib-v2" label="B · 横滑分组" width={375} height={812}><LibraryV2 /></DCArtboard>
    </DCSection>

    <DCSection id="history" title="③ 历史" subtitle="传统月历 + 当月汇总 + 明细列表">
      <DCArtboard id="hist-v1" label="月历 · 明细" width={375} height={812}><HistoryV1 /></DCArtboard>
    </DCSection>

    <DCSection id="me" title="④ 我的" subtitle="3 种徽章墙布局 · 设置项一致 · 重点对比项">
      <DCArtboard id="me-v1" label="A · 网格徽章墙" width={375} height={812}><ProfileV1 /></DCArtboard>
      <DCArtboard id="me-v2" label="B · 精选大卡 + 小徽章" width={375} height={812}><ProfileV2 /></DCArtboard>
      <DCArtboard id="me-v3" label="C · 分类徽章墙" width={375} height={812}><ProfileV3 /></DCArtboard>
    </DCSection>
  </DesignCanvas>
);

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
