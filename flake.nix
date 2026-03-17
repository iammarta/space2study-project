{
  description = "Space2Study Dev Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      { 
        # Development shell configuration
        devShells.default = pkgs.mkShell {
          # Tools and languages to include in the shell environment
          buildInputs = [
            pkgs.nodejs-18_x
            pkgs.nodePackages.npm
            pkgs.rsync
            pkgs.git
            pkgs.cypress
            pkgs.python3
          ];
          
          # Custom shell prompt and greeting message
          shellHook = ''
            export PS1="\n\[\033[1;32m\][nix-shell: \w]\$ \[\033[0m\]"
            
            echo "🌿 Welcome to the Space2Study environment!"
            echo "Node.js: $(node -v)"
            echo "NPM:     $(npm -v)"
          '';
        };
      }
    );
}