{
  description = "NixOS Config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # 1. Agregamos el input de Lanzaboote
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nvf,
      lanzaboote, # 2. Lo recibimos en los argumentos de outputs
      ...
    }:

    {
      packages."x86_64-linux".default =
        (nvf.lib.neovimConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [ ./nvf-config.nix ];
        }).neovim;

      nixosConfigurations."1L5-Thunder-Nix" = nixpkgs.lib.nixosSystem {
        specialArgs.inputs = inputs;
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          # 3. Agregamos el módulo de Lanzaboote aquí
          lanzaboote.nixosModules.lanzaboote
          (
            { pkgs, lib, ... }:
            {

              environment.systemPackages = [
                # For debugging and troubleshooting Secure Boot.
                pkgs.sbctl
              ];

              # Lanzaboote currently replaces the systemd-boot module.
              # This setting is usually set to true in configuration.nix
              # generated at installation time. So we force it to false
              # for now.
              boot.loader.systemd-boot.enable = lib.mkForce false;

              boot.lanzaboote = {
                enable = true;
                pkiBundle = "/var/lib/sbctl";
              };
            }
          )

          home-manager.nixosModules.home-manager
          inputs.nvf.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {
                pkgs-stable = inputs.nixpkgs-stable.legacyPackages."x86_64-linux";
              };
              users.ale = {
                imports = [ ./home-config.nix ];
              };
            };
          }
        ];
      };
    };
}
