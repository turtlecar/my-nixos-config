{
    description = "My nixos flake lol";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
	nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
	nix-flatpak.url = "github:gmodena/nix-flatpak";
    };

    outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
        let
	    system = "x86_64-linux";
	    pkgs-unstable = import nixpkgs-unstable {
                inherit system;
	    };
        in {
            nixosConfigurations.nixkif = nixpkgs.lib.nixosSystem {
                inherit system;
		specialArgs = { inherit inputs pkgs-unstable; };
		modules = [
		    ./hardware-configuration.nix
		    ./configuration.nix
		    inputs.nix-flatpak.nixosModules.nix-flatpak
		];
	    };
	};
}
