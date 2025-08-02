{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [
  pavucontrol
  direnv
  flameshot
  alacritty
  dunst
  waybar
  networkmanagerapplet
  wofi
  rmpc
]
