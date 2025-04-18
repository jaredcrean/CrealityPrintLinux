{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  
  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs   = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    packages.${system}.crealityprint = pkgs.callPackage ./crealityprint.nix { };
  
    defaultPackage.${system} = self.packages.${system}.crealityprint;
    apps.${system}.crealityprint = {
      type = "app";
      program = "${self.packages.${system}.crealityprint}/bin/CrealityPrint";
    };
    defaultApp.${system} = self.apps.${system}.crealityprint;
  };
}
