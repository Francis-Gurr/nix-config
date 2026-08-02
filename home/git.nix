{ config, lib, ... }:
{
  programs = {
    git = {
      enable = true;
      lfs.enable = true;

      # Written by hand per machine, and ignored by git when absent, so a work
      # address never reaches this repo.
      includes = [
        {
          condition = "gitdir:~/dev/work/";
          path = "~/.config/git/work.inc";
        }
      ];

      ignores = [
        ".python-version"
        "**/.claude/settings.local.json"
      ];

      settings = {
        user = {
          name = "Francis-Gurr";
          email = "francis@gurrmail.com";
        };

        alias = {
          fetch = "! git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '$2 == \"[gone]\" {print $1}' | xargs -r git branch -D";
          glog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
          recent = "branch --sort=-committerdate --format=\"%(committerdate:relative)%09%(refname:short)\"";
          rlog = "!git --no-pager log --decorate --pretty=oneline --abbrev-commit --color=always| less -N";
          stash-all = "stash save --include-untracked";
          undo = "reset --soft HEAD^";
        };

        branch.sort = "-committerdate";
        commit.verbose = true;
        core.editor = "nvim";
        diff = {
          algorithm = "histogram";
          colorMoved = "default";
          colorMovedWS = "allow-indentation-change";
          submodule = "log";
        };
        fetch = {
          prune = true;
          recurseSubmodules = "on-demand";
        };
        help.autocorrect = "prompt";
        init.defaultBranch = "main";
        merge.conflictStyle = "zdiff3";
        pull = {
          rebase = true;
          recurseSubmodules = "on-demand";
        };
        push = {
          autoSetupRemote = true;
          default = "simple";
          recurseSubmodules = "check";
        };
        rebase.autostash = true;
        rerere.enabled = true;
        status.submoduleSummary = true;
        submodule.recurse = true;
        transfer.fsckobjects = true;
        url."git@github.com:".insteadOf = "https://github.com/";
      };
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        line-numbers = true;
        side-by-side = true;
      };
    };

    lazygit = {
      enable = true;

      settings = {
        git = {
          autoStageResolvedConflicts = false;

          # Same delta as the terminal, minus its pager — lazygit scrolls itself.
          # Everything else is inherited from the [delta] section in git config.
          paging = {
            colorArg = "always";
            pager = "${lib.getExe config.programs.delta.finalPackage} --paging=never";
          };
        };

        keybinding.universal = {
          quit = "<esc>";
          return = "<backspace>";
        };
      };
    };
  };
}
