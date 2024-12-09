{
  nixConfig = {
    extra-substituters = [
      "https://cache.soopy.moe"
    ];
    extra-trusted-public-keys = [ "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs =
    { nixpkgs, nixos-hardware, ... }:
    {
      # ===== remove everything below this =====
      templates.default = {
        path = builtins.filterSource (
          path: _:
          (
            !builtins.elem (builtins.baseNameOf path) [
              "README.md"
              "LICENSE"
              "flake.lock"
            ]
          )
        ) ./.;
        description = "A flake to quickly get started to use NixOS on a T2 Mac device.";
      };
      # ===== remove everything above this =====

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      # replace yourHostname with your actual hostname!
      nixosConfigurations.yourHostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix

          ./nix/substituter.nix
          nixos-hardware.nixosModules.apple-t2
        ];
      };
    };
}
