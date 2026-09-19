// Real-browser design extraction for web-design-skill.
//
// Usage: node extract.mjs <url> <outDir>
//
// Writes <outDir>/extracted.json (custom properties actually defined in same-origin
// stylesheets, plus computed styles on real rendered elements, plus any element
// actively animating/transitioning at capture time) and two screenshots. Everything
// in extracted.json traces to a real DOM/CSSOM read at capture time - nothing here is
// inferred or guessed.
import { chromium } from "playwright";
import fs from "node:fs";

const [url, outDir] = process.argv.slice(2);
if (!url || !outDir) {
  console.error("Usage: node extract.mjs <url> <outDir>");
  process.exit(1);
}
fs.mkdirSync(outDir, { recursive: true });

const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });

try {
  await page.goto(url, { waitUntil: "networkidle", timeout: 30000 });
} catch {
  // Some sites never go fully idle (polling, websockets); fall back to a fixed wait.
  await page.waitForTimeout(3000);
}
// Give entrance animations a moment to start so animation/transition sampling below
// has a chance of catching them mid-flight rather than at their rest state.
await page.waitForTimeout(1000);

await page.screenshot({ path: `${outDir}/screenshot-viewport.png` });
await page.screenshot({ path: `${outDir}/screenshot-full.png`, fullPage: true });

const data = await page.evaluate(() => {
  const out = {
    customProperties: {},
    computed: {},
    animatingElements: [],
    stylesheetsRead: 0,
    stylesheetsBlocked: 0,
  };

  // Real CSS custom properties from every readable stylesheet (cross-origin sheets
  // throw on .cssRules access - counted, not silently skipped).
  for (const sheet of document.styleSheets) {
    try {
      for (const rule of sheet.cssRules) {
        if (rule.style) {
          for (const prop of rule.style) {
            if (prop.startsWith("--")) {
              out.customProperties[prop] = rule.style.getPropertyValue(prop).trim();
            }
          }
        }
      }
      out.stylesheetsRead++;
    } catch {
      out.stylesheetsBlocked++;
    }
  }

  // Actually-rendered computed styles - confirms what's used vs. merely defined
  // (e.g. a preloaded font that no element ends up using).
  const sample = (sel) => {
    const el = document.querySelector(sel);
    if (!el) return null;
    const cs = getComputedStyle(el);
    return {
      fontFamily: cs.fontFamily,
      fontSize: cs.fontSize,
      fontWeight: cs.fontWeight,
      color: cs.color,
      backgroundColor: cs.backgroundColor,
      borderRadius: cs.borderRadius,
      boxShadow: cs.boxShadow,
    };
  };
  for (const sel of ["body", "h1", "h2", "p", "button", "a"]) {
    out.computed[sel] = sample(sel);
  }

  // Elements mid-animation/transition right now - the closest thing to ground truth
  // for "does this site actually move," which static CSS can't confirm.
  const all = document.querySelectorAll("*");
  for (const el of all) {
    const cs = getComputedStyle(el);
    const hasAnimation = cs.animationName !== "none";
    const hasTransition = parseFloat(cs.transitionDuration) > 0;
    if (hasAnimation || hasTransition) {
      out.animatingElements.push({
        tag: el.tagName.toLowerCase(),
        class: el.className?.toString().slice(0, 80) ?? "",
        animationName: cs.animationName,
        transitionProperty: cs.transitionProperty,
        transitionDuration: cs.transitionDuration,
      });
    }
    if (out.animatingElements.length >= 30) break;
  }

  return out;
});

fs.writeFileSync(`${outDir}/extracted.json`, JSON.stringify(data, null, 2));
await browser.close();
console.log(`Wrote ${outDir}/extracted.json, screenshot-viewport.png, screenshot-full.png`);
