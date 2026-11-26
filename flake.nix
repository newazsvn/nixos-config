{
  description = "NixOS system with MangoWM and Noctalia";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    mangowm = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
  };

  outputs = inputs@{ self, nixpkgs, mangowm, noctalia, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager # <--- THIS IS REQUIRED
        {
          environment.systemPackages = [
            mangowm.packages.x86_64-linux.default
          ];
        }
        environment.shellInit.bashLoginInteractive = ''
          export PATH="$HOME/.cargo/bin:$PATH"
          '';
        ];
    };
  };
}
