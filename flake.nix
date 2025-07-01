{
  description = "dev flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    zls = {
      url = "github:zigtools/zls";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        zig-overlay.follows = "zig-overlay";
      };
    };

    nil = {
      url = "github:oxalica/nil";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      zig-overlay,
      zls,
      nil,
    }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };

      vimLsp = pkgs.vimUtils.buildVimPlugin {
        name = "lsp";
        src = pkgs.fetchFromGitHub {
          owner = "yegappan";
          repo = "lsp";
          rev = "0110ae71fd10e798e68b1c203735ca2143833d9c";
          hash = "sha256-A4f9i1WZU/9Qlv1hJeS+MCRlDjy0oDavsFC2IEgNIVE=";
        };
      };

      vim = pkgs.vim.customize {
        vimrcConfig = {
          packages.vim = with pkgs.vimPlugins; {
            start = [
              vimLsp

              ctrlp-vim # Fuzzy file finder.
              pear-tree # Auto pairs.

              gruvbox
            ];
          };
          customRC = builtins.readFile ./.vimrc;
        };
      };
    in
    {
      packages.${system} = {
        zig-master =
          pkgs.runCommand "zig-master"
            {
              buildInputs = [ pkgs.makeWrapper ];
            }
            ''
              mkdir -p $out/bin
              makeWrapper ${zig-overlay.packages.${system}.master}/bin/zig $out/bin/zig-master
            '';

        zig-13 =
          pkgs.runCommand "zig-13"
            {
              buildInputs = [ pkgs.makeWrapper ];
            }
            ''
              mkdir -p $out/bin
              makeWrapper ${zig-overlay.packages.${system}."0.13.0"}/bin/zig $out/bin/zig-13
            '';
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          vim
          pkgs.git

          # Nix
          nil.packages.${system}.default

          # Zig
          zig-overlay.packages.${system}."0.14.0"
          self.packages.${system}.zig-13
          self.packages.${system}.zig-master
          zls.packages.${system}.zls

          # C++
          pkgs.llvmPackages_19.clang-unwrapped

          # Rust
          pkgs.rustc
          pkgs.cargo
          pkgs.rust-analyzer

          # Go
          pkgs.go
          pkgs.gopls

          # Typescript
          pkgs.typescript-language-server

          # Python
          pkgs.python312
          pkgs.python312Packages.python-lsp-server

          # C#
          pkgs.dotnetCorePackages.sdk_9_0_1xx
          pkgs.omnisharp-roslyn
        ];
      };
    };
}
