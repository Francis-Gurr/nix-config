{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;

    # The provider paths Home Manager generates arrive as wrapper arguments
    # instead of an init.lua, leaving that file entirely ours.
    sideloadInitLua = true;

    # Replaces the imperative `pnpm add -g neovim` / `pip install pynvim` scripts.
    withNodeJs = true;
    withPython3 = true;

    # On nvim's PATH only, so removing any of these from the profile cannot
    # break the editor. gcc compiles treesitter parsers, yarn builds
    # markdown-preview, and snacks.picker shells out to rg and fd.
    extraPackages = with pkgs; [
      fd
      gcc
      ripgrep
      yarn

      # TypeScript, JavaScript and Vue
      eslint_d
      prettierd
      vscode-langservers-extracted
      vtsls
      vue-language-server

      # Python
      ruff

      # Lua
      lua-language-server
      luajitPackages.luacheck
      stylua

      # Markdown
      markdownlint-cli
      marksman

      # YAML
      yaml-language-server

      # Bash
      bash-language-server
      shellcheck
    ];

    # vtsls loads the Vue TypeScript plugin from this path, which only Nix knows.
    extraWrapperArgs = [
      "--set"
      "VUE_LANGUAGE_SERVER_PATH"
      "${pkgs.vue-language-server}/lib/language-tools/packages/language-server"
    ];
  };

  # A symlink to the working tree rather than a copy into the store: vim.pack
  # writes nvim-pack-lock.json back into this directory, which a read-only
  # store path would forbid. Config edits also apply without a rebuild.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/nix-config/home/nvim";
}
