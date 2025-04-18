{
  description = "CrealityPrint AppImage packaged for Nix";

  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";


  outputs = { self, nixpkgs }:
  let
    eachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
    pkgsFor = system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;        # ← users need no env vars / flags
    };
  in
  {
    packages = eachSystem (sys: {
      crealityprint = (pkgsFor sys).callPackage ./crealityprint.nix { };
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

