const modules = [
  { id: 'blipscreator', name: 'Blips Creator', description: 'Karten-Blips erstellen und verwalten', icon: '⌖' },
  { id: 'elevator', name: 'Fahrstuhl', description: 'Gebäude, Etagen und Zugänge verwalten', icon: '⇅' },
  { id: 'logging', name: 'Logging', description: 'Log-Kategorien und Ausgaben verwalten', icon: '▤' },
  { id: 'teleport', name: 'Teleport', description: 'Teleportpunkte konfigurieren', icon: '↗' },
  { id: 'klingel', name: 'Klingelsystem', description: 'Klingeln und Empfänger verwalten', icon: '♧' },
];

export default function App() {
  return (
    <main className="shell">
      <aside className="sidebar">
        <div className="brand"><span className="brand-mark">LV</span><div><strong>LODGE V</strong><small>DEVELOPER PANEL</small></div></div>
        <div className="nav-label">ÜBERSICHT</div>
        <button className="nav-item active">▦ <span>Dashboard</span></button>
        <div className="nav-label">MODULE</div>
        {modules.map((module) => <button className="nav-item" key={module.id}>{module.icon} <span>{module.name}</span></button>)}
        <div className="sidebar-footer">LODGE V · DEVELOPMENT</div>
      </aside>
      <section className="content">
        <header className="topbar"><div><span className="eyebrow">SYSTEMVERWALTUNG</span><h1>Developer Panel</h1></div><div className="status"><i /> FRAMEWORK INITIALISIERT</div></header>
        <section className="welcome"><div><span className="eyebrow orange">LODGE V DEVELOPMENT</span><h2>Zentrale Verwaltung</h2><p>Verwalte deine Entwicklungswerkzeuge und Servermodule an einem Ort.</p></div><div className="welcome-symbol">LV<span>.</span></div></section>
        <div className="section-heading"><div><h3>Module</h3><p>Die Modulbereiche werden schrittweise aktiviert.</p></div><span className="count">05 MODULE GEPLANT</span></div>
        <div className="module-grid">
          {modules.map((module) => <article className="module-card" key={module.id}><div className="module-icon">{module.icon}</div><div className="module-copy"><h4>{module.name}</h4><p>{module.description}</p></div><span className="planned">GEPLANT</span></article>)}
        </div>
        <footer>LODGE V © 2026 <span>lv_dev · v0.1.0</span></footer>
      </section>
    </main>
  );
}
