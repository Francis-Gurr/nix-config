// `@commitlint/config-conventional` with two deviations — a leading gitmoji enforced per
// type, and subject-line only. An independent copy of the same config in the `dotfiles`
// repo, deliberately not shared: this repo must validate its own commits when cloned alone.
import config from '@commitlint/config-conventional';

// Single source of truth: the gitmoji per type. Exposed via the prompt enum below so
// `commitlint --print-config json` is authoritative for agents.
const GITMOJI = {
  build: '📦️',
  chore: '🔧',
  ci: '👷',
  docs: '📝',
  feat: '✨',
  fix: '🐛',
  perf: '⚡️',
  refactor: '♻️',
  revert: '⏪️',
  style: '🎨',
  test: '🧪',
};

const emojiRegexPart = Object.values(GITMOJI)
  .map((value) => value.trim())
  .join('|');

const typeEnum = Object.fromEntries(
  Object.entries(config.prompt.questions.type.enum).map(([type, def]) => [
    type,
    { ...def, emoji: GITMOJI[type] ?? def.emoji },
  ]),
);

/** @type {import('@commitlint/types').UserConfig} */
export default {
  extends: ['@commitlint/config-conventional'],
  parserPreset: {
    parserOpts: {
      headerPattern: new RegExp(`^(${emojiRegexPart})\\s+(\\w*)(?:\\((.*)?\\))?!?:\\s+(.*)$`),
      breakingHeaderPattern: new RegExp(`^(${emojiRegexPart})\\s+(\\w*)(?:\\((.*)?\\))?!:\\s+(.*)$`),
      headerCorrespondence: ['emoji', 'type', 'scope', 'subject'],
    },
  },
  plugins: [
    {
      rules: {
        'type-emoji': ({ type, emoji }) => {
          if (!type || !(type in GITMOJI)) return [true];
          const want = GITMOJI[type];
          const got = emoji?.trim() ?? '';
          return [got === want, `type "${type}" must use the ${want} emoji (got ${got || 'none'})`];
        },
      },
    },
  ],
  prompt: {
    questions: {
      type: { enum: typeEnum, headerWithEmoji: true },
    },
  },
  rules: {
    // Deviation 1: require the gitmoji that matches the type.
    'type-emoji': [2, 'always'],
    // Deviation 2: subject line only. Errors (not warns); commitlint's defaultIgnores
    // skips merge/revert commits, so their auto-generated bodies still commit.
    'body-empty': [2, 'always'],
    'footer-empty': [2, 'always'],
  },
};
