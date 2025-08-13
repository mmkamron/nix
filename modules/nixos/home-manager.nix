{ config, pkgs, lib, ... }:

let
  user = "mmkamron";
  xdg_configHome  = "/home/${user}/.config";
  shared-programs = import ../shared/home-manager.nix { inherit config pkgs lib; };
  shared-files = import ../shared/files.nix { inherit config pkgs; };
in
{
  home = {
    enableNixpkgsReleaseCheck = false;
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ./packages.nix {};
    file = shared-files // import ./files.nix { inherit user; };
    stateVersion = "25.05";
  };

  services = {
    mpd = {
      enable = true;
      musicDirectory = "/home/mmkamron/music";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';
      network.listenAddress = "any";
      network.startWhenNeeded = true;
    };
  };

  programs = shared-programs // {};
}
