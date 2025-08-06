{ config, inputs, pkgs, ... }:

let
  user = "mmkamron";
  sshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOk8iAnIaa1deoc7jw8YACPNVka1ZFJxhnU4G74TmS+p"
  ];
in {
  imports = [
    ../../modules/nixos/disk-config.nix
    ../../modules/shared
  ];

  time.timeZone = "Asia/Tashkent";

  networking = {
    networkmanager.enable = true;
  };

  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
    };
    sway = {
      enable = true;
      xwayland.enable = true;
      extraPackages = with pkgs; [i3status-rust wmenu wl-clipboard swaybg];
    };
    waybar = {
      enable = true;
    };
  };

  #https://nixos.wiki/wiki/MPD
  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/${toString config.users.users."mmkamron".uid}";
  };

  services = {
    openssh.enable = true;
    mpd = {
      user = "mmkamron";
      enable = true;
      musicDirectory = "/home/mmkamron/music";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    kanata = {
      enable = true;
      keyboards.main.configFile = "/etc/nixos/x380.kbd";
    };
    tailscale = {
      enable = true;
    };
  };

  users.users = {
    ${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = sshKeys;
    };
  };

  environment.systemPackages = with pkgs; [
  ];

  system.stateVersion = "25.05";
}
