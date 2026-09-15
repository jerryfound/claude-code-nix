{
  description = "Claude Code packaged from official prebuilt npm binaries, updated daily";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      overlay = final: prev: {
        claude-code = final.callPackage ./package.nix { };
      };
    in
    {
      overlays.default = overlay;

      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ overlay ];
            # The CLI itself is unfree; allow just this package so the
            # flake's own packages/apps outputs build standalone.
            config.allowUnfreePredicate = pkg:
              nixpkgs.lib.getName pkg == "claude-code";
          };
        in
        {
          default = pkgs.claude-code;
          claude-code = pkgs.claude-code;
        });

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.claude-code}/bin/claude";
        };
      });
    };
}
