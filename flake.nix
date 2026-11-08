{
  description = "NixOS system with MangoWM";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    mangowm = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, mangowm, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit mangowm; };
      modules = [
        ./configuration.nix
        {
          environment.systemPackages = [
            mangowm.packages.x86_64-linux.default
          ];
        }
      ];
    };
  };
}
