{
  xdg.configFile."agent".source = ./agent;

  # Claude Code owns the rest of ~/.claude, and keeps its mutable state in
  # ~/.claude.json, so name each managed file rather than the directory.
  # CLAUDE.md and skills come from the same sources as ~/.config/agent and
  # therefore cannot drift apart.
  home.file = {
    ".claude/settings.json".source = ./claude/settings.json;
    ".claude/CLAUDE.md".source = ./agent/AGENTS.md;
    ".claude/skills".source = ./agent/skills;
  };
}
