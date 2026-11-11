{
  description = "francis's nix-config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Repackages Anthropic's official Linux .deb; nixpkgs has no Claude desktop.
    claude-desktop = {
      url = "github:aaddrick/claude-desktop-debian";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      git-hooks,
      sops-nix,
      claude-desktop,
    }:
    let
      system = "x86_64-linux";

      # Stable stopped updating claude-code at 2.1.223, and its vscode fails to build.
      unstableOverlay = _final: prev: {
        inherit (unstable) claude-code vscode;
        vscode-extensions = prev.vscode-extensions // {
          inherit (unstable.vscode-extensions) anthropic;
        };
      };
      overlays = [
        unstableOverlay
        claude-desktop.overlays.default
      ];
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      # allowUnfree MUST be set here: passing `pkgs` makes Home Manager ignore
      # its own `nixpkgs.config`, so setting it inside home/common.nix does
      # nothing. legacyPackages carries no config either.
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        inherit overlays;
      };
    in
    {
      homeConfigurations."francis@linux" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/linux.nix ];
      };

      nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
        modules = [
          {
            nixpkgs = {
              hostPlatform = system;
              inherit overlays;
            };
          }
          ./hosts/vm/configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.francis = ./home/linux.nix;
            };
          }
        ];
      };

      checks.${system} = {
        # `nix flake check` does not build homeConfigurations on its own.
        home = self.homeConfigurations."francis@linux".activationPackage;

        pre-commit = git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt.enable = true;
            statix.enable = true;
            deadnix.enable = true;
            commitlint = {
              enable = true;
              entry = "pnpm exec commitlint --edit";
              stages = [ "commit-msg" ];
            };
            nix-flake-check = {
              enable = true;
              entry = "nix flake check";
              pass_filenames = false;
              stages = [ "pre-push" ];
            };
          };
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        inherit (self.checks.${system}.pre-commit) shellHook;
        packages = self.checks.${system}.pre-commit.enabledPackages ++ [
          pkgs.nodejs
          pkgs.pnpm
          pkgs.sops
        ];
      };
    };
}
