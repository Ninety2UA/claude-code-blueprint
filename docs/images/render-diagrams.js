#!/usr/bin/env node
// render-diagrams.js — Render each .diagram container in render-diagrams.html to a
// retina PNG in this directory. Playwright blocks file:// URLs, so serve this dir
// over http first. Usage:
//   node render-diagrams.js [--only id1,id2] [--out DIR] [--port 8791]
const { chromium } = require('playwright');
const http = require('http');
const fs = require('fs');
const path = require('path');

const DIR = __dirname;
const args = process.argv.slice(2);
const getArg = (name, def) => {
  const i = args.indexOf(name);
  return i >= 0 && args[i + 1] ? args[i + 1] : def;
};
const only = (getArg('--only', '') || '').split(',').filter(Boolean);
const outDir = path.resolve(getArg('--out', DIR));
const port = parseInt(getArg('--port', '8791'), 10);

// Minimal static server for this directory.
const mime = { '.html': 'text/html', '.css': 'text/css', '.js': 'text/javascript', '.svg': 'image/svg+xml', '.png': 'image/png' };
const server = http.createServer((req, res) => {
  const rel = decodeURIComponent(req.url.split('?')[0]).replace(/^\/+/, '') || 'render-diagrams.html';
  const fp = path.join(DIR, rel);
  if (!fp.startsWith(DIR) || !fs.existsSync(fp) || fs.statSync(fp).isDirectory()) {
    res.writeHead(404); res.end('not found'); return;
  }
  res.writeHead(200, { 'Content-Type': mime[path.extname(fp)] || 'application/octet-stream' });
  fs.createReadStream(fp).pipe(res);
});

(async () => {
  await new Promise((r) => server.listen(port, r));
  fs.mkdirSync(outDir, { recursive: true });
  // Prefer the bundled Chromium; fall back to system Chrome (channel) if the
  // Playwright browser binary isn't installed in this environment.
  let browser;
  try {
    browser = await chromium.launch();
  } catch (e) {
    browser = await chromium.launch({ channel: 'chrome' });
  }
  const page = await browser.newPage({ deviceScaleFactor: 2 });
  await page.goto(`http://localhost:${port}/render-diagrams.html`, { waitUntil: 'networkidle' });
  // Ensure webfonts are fully loaded/painted before capture.
  await page.evaluate(async () => { await document.fonts.ready; });
  await page.waitForTimeout(400);

  const els = await page.$$('.diagram');
  const rendered = [];
  for (const el of els) {
    const id = await el.getAttribute('id');
    if (!id) continue;
    if (only.length && !only.includes(id)) continue;
    await el.scrollIntoViewIfNeeded();
    const outPath = path.join(outDir, `${id}.png`);
    await el.screenshot({ path: outPath });
    const kb = Math.round(fs.statSync(outPath).size / 1024);
    rendered.push(`${id}.png (${kb}KB)`);
  }
  await browser.close();
  server.close();
  console.log(`Rendered ${rendered.length} diagram(s) @2x to ${outDir}:`);
  rendered.forEach((r) => console.log('  ' + r));
})().catch((e) => { console.error(e); server.close(); process.exit(1); });
