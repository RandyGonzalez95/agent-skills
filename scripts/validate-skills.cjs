// Validate the curated catalog without installing skills or dependencies.
// Run: node scripts/validate-skills.cjs
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const { spawnSync } = require('node:child_process');
const root = path.dirname(__dirname);
const curated = path.join(root, '.claude', 'skills');
const errors = [];
const check = (condition, message) => { if (!condition) errors.push(message); };
const walk = dir => fs.readdirSync(dir, { withFileTypes: true }).flatMap(e =>
  e.isDirectory() ? walk(path.join(dir, e.name)) : [path.join(dir, e.name)]);
const hash = file => crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex');
const files = walk(curated);
const skills = files.filter(f => path.basename(f) === 'SKILL.md');
const names = new Set();

// These entrypoints intentionally use a simple YAML subset. This is not a
// general YAML parser or a substitute for the official Python validator.
for (const file of skills) {
  const text = fs.readFileSync(file, 'utf8');
  const fm = text.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n/);
  check(fm, `Missing frontmatter: ${file}`);
  if (!fm) continue;
  const lines = fm[1].split(/\r?\n/);
  const fields = {};
  for (const line of lines) {
    if (!line.trim()) continue;
    const match = line.match(/^([a-z-]+):(?: (.*))?$/);
    if (!match) {
      check(/^  [a-z-]+: .+$/.test(line), `Unsupported frontmatter syntax: ${file}: ${line}`);
      continue;
    }
    check(!Object.hasOwn(fields, match[1]), `Duplicate key: ${file}: ${match[1]}`);
    fields[match[1]] = match[2] || '';
    check(['name', 'description', 'license', 'metadata'].includes(match[1]), `Unknown key: ${file}: ${match[1]}`);
    check(!/[:#]\s/.test(match[2] || ''), `Ambiguous unquoted scalar: ${file}: ${match[1]}`);
  }
  const name = fields.name;
  check(typeof name === 'string' && /^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(name) && name.length <= 64, `Invalid name: ${file}`);
  check(name === path.basename(path.dirname(file)), `Name/folder mismatch: ${file}`);
  check(!names.has(name), `Duplicate skill name: ${name}`);
  names.add(name);
  check(fields.description && fields.description.length <= 1024 && !/[<>]/.test(fields.description), `Invalid description: ${file}`);
  check(!/\[TODO:/i.test(text), `Unfinished scaffold: ${file}`);
  const agentFile = path.join(path.dirname(file), 'agents', 'openai.yaml');
  // UI metadata is optional.
  if (fs.existsSync(agentFile)) {
    const agent = fs.readFileSync(agentFile, 'utf8');
    for (const field of ['display_name', 'short_description', 'default_prompt']) {
      const m = agent.match(new RegExp('^  ' + field + ': (.+)$', 'm'));
      check(m, `Missing ${field}: ${name}`);
      if (m) {
        try {
          const value = JSON.parse(m[1]);
          check(typeof value === 'string', `Invalid ${field}: ${name}`);
          if (field === 'short_description') check(value.length >= 25 && value.length <= 64, `UI description length: ${name}`);
          if (field === 'default_prompt') check(value.includes('$' + name), `Stale invocation: ${name}`);
        } catch { errors.push(`Unquoted UI value: ${name}: ${field}`); }
      }
    }
    // Preserve existing skills' invocation policy; absence means runtime default.
    check(!/allow_implicit_invocation: (?!true\b|false\b)/.test(agent), `Invalid invocation policy: ${name}`);
  }
}

let links = 0;
for (const file of files.filter(f => /\.(md|yaml)$/.test(f))) {
  const text = fs.readFileSync(file, 'utf8');
  check(!/\b(?:Iris|irisdtsui|Blue Dot|The Fold|Canary MedTech|Randy|Aron Sogi|ASTRA)\b/i.test(text), `Inherited identity: ${file}`);
  check(!/\/Users\/|collection:\/\/|5029840882/.test(text), `Inherited account/path: ${file}`);
  if (!file.endsWith('.md')) continue;
  for (const m of text.matchAll(/\[[^\]]*\]\(([^)]+)\)/g)) {
    const target = m[1].split('#')[0];
    if (!target || /^[a-z]+:/i.test(target)) continue;
    links++;
    const resolved = path.resolve(path.dirname(file), target);
    check(resolved.startsWith(curated + path.sep), `Link escapes portable catalog: ${file}: ${target}`);
    check(fs.existsSync(resolved), `Broken link: ${file}: ${target}`);
  }
}

const syntax = spawnSync(process.execPath, ['--check', path.join(curated, 'web-design/tools/extract.mjs')], { encoding: 'utf8' });
check(syntax.status === 0, `Extractor syntax error: ${syntax.stderr}`);
for (const file of files.filter(f => f.endsWith('.json'))) {
  try { JSON.parse(fs.readFileSync(file, 'utf8')); } catch { errors.push(`Invalid JSON: ${file}`); }
}
if (errors.length) { console.error(errors.join('\n')); process.exit(1); }
console.log(JSON.stringify({ skills: skills.length, localLinks: links, extractorSyntax: 'pass', status: 'pass' }, null, 2));
