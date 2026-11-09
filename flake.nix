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
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      git-hooks,
      ...
    }@inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" ];

      mkHome =
        system: module:
        home-manager.lib.homeManagerConfiguration {
          # allowUnfree MUST be set here: passing `pkgs` makes Home Manager ignore
          # its own `nixpkgs.config`, so setting it inside home/common.nix does
          # nothing. legacyPackages carries no config either.
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = { inherit inputs; };
          modules = [ module ];
        };
    in
    {
      homeConfigurations."francis@linux" = mkHome "x86_64-linux" ./home/linux.nix;

      nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
        modules = [
          { nixpkgs.hostPlatform = "x86_64-linux"; }
          ./hosts/vm/configuration.nix
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

      checks = forEachSystem (system: {
        # `nix flake check` does not build homeConfigurations on its own.
        home = self.homeConfigurations."francis@linux".activationPackage;

        pre-commit = git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt-rfc-style.enable = true;
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
      });

      devShells = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            inherit (self.checks.${system}.pre-commit) shellHook;
            packages = self.checks.${system}.pre-commit.enabledPackages ++ [
              pkgs.nodejs
              pkgs.pnpm
            ];
          };
        }
      );
    };
}
