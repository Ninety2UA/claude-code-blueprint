#!/usr/bin/env node
// render-ebook.js — Render ebook-source.html to ebook/claude-code-tools-guide.pdf.
// Serves docs/images over http first (Playwright blocks file:// URLs).
// Usage: node docs/images/render-ebook.js [--port 8792]

const { chromium } = require('playwright');
const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');

const ROOT = path.resolve(__dirname, '../..');
const PORT = process.argv.includes('--port')
  ? parseInt(process.argv[process.argv.indexOf('--port') + 1], 10)
  : 8792;
const PDF_PATH = path.join(ROOT, 'ebook/claude-code-tools-guide.pdf');

(async () => {
  const server = spawn('python3', ['-m', 'http.server', String(PORT), '--directory', __dirname], {
    stdio: 'ignore',
  });
  await new Promise((r) => setTimeout(r, 800));

  let browser;
  try {
    browser = await chromium.launch();
  } catch {
    browser = await chromium.launch({ channel: 'chrome' });
  }

  try {
    const page = await browser.newPage();
    await page.goto(`http://localhost:${PORT}/ebook-source.html`, { waitUntil: 'networkidle' });
    fs.mkdirSync(path.dirname(PDF_PATH), { recursive: true });
    // Chromium ignores CSS named @page rules; the source uses break-before for
    // page boundaries, so preferCSSPageSize + zero margins render it faithfully.
    await page.pdf({
      path: PDF_PATH,
      format: 'A4',
      printBackground: true,
      preferCSSPageSize: true,
      margin: { top: '0', right: '0', bottom: '0', left: '0' },
    });
    const kb = Math.round(fs.statSync(PDF_PATH).size / 1024);
    console.log(`Done! ${path.relative(ROOT, PDF_PATH)} (${kb} KB)`);
  } finally {
    await browser.close();
    server.kill();
  }
})();
