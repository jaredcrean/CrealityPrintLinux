{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";   # or a commit hash
  
  outputs = { self, nixpkgs }:
  let
    eachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
    pkgs   = import nixpkgs {
      inherit system;
      config.allowUnfree = true;   # built‑in → no env var or --impure needed
    };
  in {
    packages = eachSystem (sys: {
      crealityprint = (pkgs sys).callPackage ./crealityprint.nix { };
    });
    defaultPackage = eachSystem (sys: self.packages.${sys}.crealityprint);
    apps = eachSystem (sys: {
      crealityprint = {
        type = "app";
        program = "${self.packages.${sys}.crealityprint}/bin/crealityprint";
      };
    });
    defaultApp = eachSystem (sys: self.apps.${sys}.crealityprint);
  };
}

