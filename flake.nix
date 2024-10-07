{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs =
    { nixpkgs
    , flake-utils
    , ...
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      corepackEnable = pkgs.runCommand "corepack-enable" { } ''
        mkdir -p $out/bin
        ${pkgs.nodejs_20}/bin/corepack enable --install-directory $out/bin
      '';

    in
    {
      formatter = pkgs.alejandra;

      devShells = {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs_20
            corepackEnable
            erlang_26
            gleam
            rebar3
          ]

          # For file_system on Linux.
          # ++ lib.optionals stdenv.isLinux [ inotify-tools wxGTK ]

          # For file_system on macOS.
          ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
            # For file_system on macOS.
            CoreFoundation
            CoreServices
            # wxmac
          ]);

          shellHook = ''
            ${pkgs.gleam}/bin/gleam --version
          '';

        };
      };
    });
}
