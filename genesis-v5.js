async function GENESIS_V5_BOOT() {
  const meta = await fetch("api/genesis-meta.json").then(r => r.json());
  window.GENESIS = meta;

  log("[GENESIS] V5 META LOADED (" + meta.modules.length + " modules)");
  log("[GENESIS] Bootflow: " + meta.bootflow.join(" → "));

  for (let i = 0; i < meta.bootflow.length; i++) {
    await new Promise(r => setTimeout(r, 150));
    log("[BOOT] " + meta.bootflow[i]);
  }

  log("[GENESIS] SYSTEM ONLINE (V5)");
}
