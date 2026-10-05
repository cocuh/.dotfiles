{ pkgs, ... }:
let
  # Must equal the hyprland version pacman installs on Arch, where
  # components/hypr is written and tested.
  hyprlandVersion = "0.56.2";

  # The username differs between machines and is not kept in this repository,
  # so it is read from the environment. This is why switch needs --impure.
  username = builtins.getEnv "USER";
  homeDirectory = builtins.getEnv "HOME";
in
{
  assertions = [
    {
      assertion = pkgs.hyprland.version == hyprlandVersion;
      message = ''
        nixpkgs provides hyprland ${pkgs.hyprland.version}, but home.nix expects
        ${hyprlandVersion}.
        - If Arch has ${pkgs.hyprland.version}, set hyprlandVersion to it.
        - Otherwise nixpkgs is behind or ahead of Arch: revert flake.lock and
          run nix flake update again later.
      '';
    }
    {
      assertion = username != "" && homeDirectory != "";
      message = "USER and HOME are empty. Run home-manager with --impure.";
    }
  ];

  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # Puts the Nix-built Mesa at /run/opengl-driver (needs one sudo run; switch
  # prints the command). start-hyprland requires nixGL on non-NixOS unless
  # that path exists.
  targets.genericLinux.enable = true;

  home.packages = [
    pkgs.hyprland
    # hyprland.lua starts these. Their configs in this repository are written
    # against the versions on Arch; the work distribution may ship older ones.
    pkgs.hypridle
    pkgs.hyprpaper
    pkgs.waybar
  ];

  # Screen sharing: the portal backend must match the Hyprland version.
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    configPackages = [ pkgs.hyprland ];
  };
}
