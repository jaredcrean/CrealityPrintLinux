{
  description = "CrealityPrint AppImage packaged for Nix";

  ############################################################
  # Inputs (pin nixpkgs so nix never tries to write a lock)
  ############################################################
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

  ############################################################
  # Outputs
  ############################################################
  outputs = { self, nixpkgs }:
  let
    eachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
    pkgsFor = system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;        # ← users need no env vars / flags
    };
  in
  {
    ######################  Packages  #######################
    packages = eachSystem (sys: {
      crealityprint = (pkgsFor sys).callPackage ./crealityprint.nix { };
    });
    defaultPackage = eachSystem (sys: self.packages.${sys}.crealityprint);

    ########################  Apps  #########################
    apps = eachSystem (sys: {
      crealityprint = {
        type = "app";
        program = "${self.packages.${sys}.crealityprint}/bin/crealityprint";
      };
    });
    defaultApp = eachSystem (sys: self.apps.${sys}.crealityprint);
  };
}

