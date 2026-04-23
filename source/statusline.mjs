#!/usr/bin/env node

// Claude Code Status Line - 2-Line Layout with Usage Bars
// [UPDATED] v2.1 - restored full labels, full path, 2-line output

const C = {
  g: '\x1b[32m',
  y: '\x1b[33m',
  r: '\x1b[31m',
  c: '\x1b[36m',
  d: '\x1b[90m',
  b: '\x1b[34m',
  n: '\x1b[0m'
};

// ── Progress Bar Builder ──────────────
function makeBar(pct, width = 10) {
  const filled = Math.round((pct / 100) * width);
  const empty = width - filled;
  let color = C.g;
  if (pct >= 80) color = C.r;
  else if (pct >= 50) color = C.y;
  return `${color}${'█'.repeat(filled)}${C.d}${'░'.repeat(empty)}${C.n}`;
}

// ── Reset Countdown ───────────────────
function resetIn(epochSec) {
  if (!epochSec) return '';
  const diffMs = epochSec * 1000 - Date.now();
  if (diffMs <= 0) return 'now';
  const totalMin = Math.floor(diffMs / 60000);
  const h = Math.floor(totalMin / 60);
  const m = totalMin % 60;
  if (h >= 24) {
    const d = Math.floor(h / 24);
    const rh = h % 24;
    return `${d}d${rh}h`;
  }
  return h > 0 ? `${h}h${String(m).padStart(2, '0')}m` : `${m}m`;
}

// ── Model ─────────────────────────────
function fieldModel(d) {
  const name = d.model?.display_name || '?';
  const color = /opus/i.test(name) ? C.g : C.y;
  return `${color}${name}${C.n}`;
}

// ── Context Used ──────────────────────
function fieldContextUsed(d) {
  const used = Math.round(d.context_window?.used_percentage || 0);
  return `Context ${makeBar(used)} ${used}%`;
}

// ── Project Folder ────────────────────
function fieldProject(d) {
  const dir = d.workspace?.current_dir || d.cwd || '';
  const folder = dir.split(/[/\\]/).filter(Boolean).pop() || '~';
  return `${C.c}${folder}${C.n}`;
}

// ── Total Tokens ──────────────────────
function fieldTokens(d) {
  const inp = d.context_window?.total_input_tokens || 0;
  const out = d.context_window?.total_output_tokens || 0;
  const total = inp + out;
  let label;
  if (total >= 1_000_000) label = (total / 1_000_000).toFixed(1) + 'M';
  else if (total >= 1_000) label = Math.round(total / 1_000) + 'K';
  else label = String(total);
  return `${C.y}total tokens:${label}${C.n}`;
}

// ── Duration ──────────────────────────
function fieldDuration(d) {
  const ms = d.cost?.total_duration_ms || 0;
  const totalMin = Math.floor(ms / 60000);
  const hrs = Math.floor(totalMin / 60);
  const mins = totalMin % 60;
  const fmt = hrs > 0
    ? `${hrs}:${String(mins).padStart(2, '0')}`
    : `${totalMin}m`;
  return `${C.d}duration:${fmt}${C.n}`;
}

// ── Full Path ─────────────────────────
function fieldFullPath(d) {
  const dir = d.workspace?.current_dir || d.cwd || '';
  if (!dir) return '';
  return `${C.d}${dir}${C.n}`;
}

// ── 5-Hour Usage ──────────────────────
function fieldUsage5h(d) {
  const rl = d.rate_limits?.five_hour;
  if (!rl) return `Session ${C.d}-- undefined --${C.n}`;
  const pct = Math.round(rl.used_percentage || 0);
  const rst = resetIn(rl.resets_at);
  return `Session ${makeBar(pct)} ${pct}%${rst ? C.d + ' resets in ' + rst + C.n : ''}`;
}

// ── 7-Day Usage ───────────────────────
function fieldUsage7d(d) {
  const rl = d.rate_limits?.seven_day;
  if (!rl) return `Weekly ${C.d}-- undefined --${C.n}`;
  const pct = Math.round(rl.used_percentage || 0);
  const rst = resetIn(rl.resets_at);
  return `Weekly ${makeBar(pct)} ${pct}%${rst ? C.d + ' resets in ' + rst + C.n : ''}`;
}

// ── Line 1: session info ──────────────
const LINE1 = [
  fieldProject,
  fieldModel,
  fieldContextUsed,
  fieldTokens,
  fieldDuration,
  fieldFullPath
];

// ── Line 2: usage bars ───────────────
const LINE2 = [
  fieldUsage5h,
  fieldUsage7d
];

// ── Input / Output ────────────────────
let raw = '';
process.stdin.setEncoding('utf8');
process.stdin.on('data', chunk => { raw += chunk; });
process.stdin.on('end', () => {
  try {
    const data = JSON.parse(raw);
    const sep = `${C.d}|${C.n}`;
    const top = LINE1.map(fn => fn(data)).filter(Boolean).join(` ${sep} `);
    const bot = LINE2.map(fn => fn(data)).filter(Boolean).join(`  ${sep}  `);
    process.stdout.write(top + '\n');
    if (bot) process.stdout.write(bot + '\n');
  } catch {
    process.stdout.write('statusline: parse error\n');
  }
});
