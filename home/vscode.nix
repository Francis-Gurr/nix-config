{ pkgs, ... }:
let
  # ESLint fixes these on save, so their squiggles are only noise.
  silencedStyleRules = [
    "style/*"
    "format/*"
    "*-indent"
    "*-spacing"
    "*-spaces"
    "*-order"
    "*-dangle"
    "*-newline"
    "*quotes"
    "*semi"
  ];
in
{
  programs.vscode = {
    enable = true;
    # Only the declared extensions load, and nothing updates outside Nix.
    mutableExtensionsDir = false;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        anthropic.claude-code
        charliermarsh.ruff
        davidanson.vscode-markdownlint
        dbaeumer.vscode-eslint
        enkia.tokyo-night
        ms-python.debugpy
        ms-python.python
        ms-python.vscode-pylance
        ms-python.vscode-python-envs
        streetsidesoftware.code-spell-checker
        vitest.explorer
        vue.volar
        yoavbls.pretty-ts-errors
      ];
      userSettings = {
        # ESLint formats instead of Prettier.
        "prettier.enable" = false;
        "editor.formatOnSave" = false;
        "editor.codeActionsOnSave" = {
          "source.fixAll.markdownlint" = "explicit";
          "source.fixAll.eslint" = "explicit";
          "source.organizeImports" = "never";
        };
        "eslint.rules.customizations" = map (rule: {
          inherit rule;
          severity = "off";
          fixable = true;
        }) silencedStyleRules;
        "eslint.validate" = [
          "javascript"
          "javascriptreact"
          "typescript"
          "typescriptreact"
          "vue"
          "html"
          "markdown"
          "json"
          "jsonc"
          "yaml"
          "toml"
          "xml"
          "gql"
          "graphql"
          "astro"
          "svelte"
          "css"
          "less"
          "scss"
          "pcss"
          "postcss"
        ];
        "workbench.colorTheme" = "Tokyo Night";
        "editor.fontFamily" = "'FiraCode Nerd Font', monospace";
        "typescript.updateImportsOnFileMove.enabled" = "always";
        "workbench.settings.applyToAllProfiles" = [ ];
        "cSpell.userWords" = [
          "conninfo"
          "fetchrow"
          "ILIKE"
          "libpq"
          "primevue"
          "pyproject"
        ];
        "editor.minimap.enabled" = false;
        # Hides the built-in Copilot chat and its GitHub sign-in prompt.
        "chat.disableAIFeatures" = true;
        "github.copilot.nextEditSuggestions.enabled" = false;
        "github.copilot.enable" = {
          "*" = false;
          plaintext = false;
          markdown = false;
          scminput = false;
        };
      };
    };
  };
}
