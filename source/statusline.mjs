#!/usr/bin/env node
// Claude Code Status Line — Context Used Layout

const C = {
  g: '\x1b[32m',
  y: '\x1b[33m',
  r: '\x1b[31m',
  c: '\x1b[36m',
  d: '\x1b[90m',
  n: '\x1b[0m'
};

// ── Model ─────────────────────────────

function fieldModel(d) {
  const name = d.model?.display_name || '?';
  const color = /opus/i.test(name) ? C.g : C.y;
  return `${color}${name}${C.n}`;
}

// ── Context Used ──────────────────────

function fieldContextUsed(d) {

  const used = Math.round(d.context_window?.used_percentage || 0);

  let color = C.g;

  if (used >= 70)
    color = C.r;
  else if (used >= 40)
    color = C.y;

  return `${color}context used:${used}%${C.n}`;
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

  if (total >= 1_000_000)
    label = (total / 1_000_000).toFixed(1) + 'M';
  else if (total >= 1_000)
    label = Math.round(total / 1_000) + 'K';
  else
    label = String(total);

  return `${C.y}total tokens:${label}${C.n}`;
}

// ── Duration ──────────────────────────

function fieldDuration(d) {

  const ms = d.cost?.total_duration_ms || 0;

  const totalMin = Math.floor(ms / 60000);
  const hrs = Math.floor(totalMin / 60);
  const mins = totalMin % 60;

  const fmt =
    hrs > 0
      ? `${hrs}:${String(mins).padStart(2, '0')}`
      : `${totalMin}m`;

  return `${C.d}duration:${fmt}${C.n}`;
}

// ── Full Path ─────────────────────────

function fieldFullPath(d) {

  const dir = d.workspace?.current_dir || d.cwd || '';

  if (!dir)
    return '';

  return `${C.d}${dir}${C.n}`;
}

// ── Field Order ───────────────────────

const FIELDS = [
  fieldModel,
  fieldContextUsed,
  fieldProject,
  fieldTokens,
  fieldDuration,
  fieldFullPath
];

// ── Input / Output ────────────────────

let raw = '';

process.stdin.setEncoding('utf8');

process.stdin.on('data', chunk => {
  raw += chunk;
});

process.stdin.on('end', () => {

  try {

    const data = JSON.parse(raw);

    const sep = `${C.d}|${C.n}`;

    const line = FIELDS
      .map(fn => fn(data))
      .filter(Boolean)
      .join(` ${sep} `);

    process.stdout.write(line + '\n');

  }

  catch {

    process.stdout.write('statusline: parse error\n');

  }

});