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
  # systemd.services.mpd.environment = {
  #   XDG_RUNTIME_DIR = "/run/user/${toString config.users.users."mmkamron".uid}";
  # };
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = ["" "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} --autologin mmkamron --noclear --keep-baud %I 115200,38400,9600 $TERM"];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  services = {
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    kanata = {
      enable = true;
      keyboards.main.configFile = "/etc/nixos/apple.kbd";
    };
    tailscale = {
      enable = true;
    };
    blueman.enable = true;
    logind.lidSwitch = "ignore";
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 50;
        STOP_CHARGE_THRESH_BAT0 = 60;
      };
    };
  };

  users.users = {
    ${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = sshKeys;
    };
  };

  environment.systemPackages = with pkgs; [
  ];

  system.stateVersion = "25.05";
}
