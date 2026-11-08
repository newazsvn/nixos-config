# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "nixos";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # cachyos-level responsiveness: zram and sysctl tweaks
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
  };

  # Graphics Hardware Acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Load proprietary NVIDIA driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required for Wayland compositors (MangoWM / wlroots)
    modesetting.enable = true;

    # Power management
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Use the proprietary production/stable driver
    open = false;

    # Enable the Nvidia settings menu
    nvidiaSettings = true;

    # Select the production driver package
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Flatpak support
  services.flatpak.enable = true;

  # Login manager: tuigreet
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd mango";
        user = "greeter";
      };
    };
  };

  # Screen sharing and desktop portals
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  # Gaming and compatibility stack
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;

  # Low-latency pipewire audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Dynamic linked fix (allow non-nix binaries)
  programs.nix-ld.enable = true;

  # Define a user account.
  users.users."newaj" = {
    isNormalUser = true;
    description = "newaj";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # System & Core Utilities
    wget
    git
    pavucontrol
    wl-clipboard
    appimage-run
    flatpak

    # Network & Tray
    networkmanagerapplet

    # Compositor & SceneFX Stack
    xwayland-satellite

    # Shell, Desktop & Theming
    alacritty
    fuzzel
    waybar
    mako
    swaybg
    papirus-icon-theme
    catppuccin-gtk
    adwaita-icon-theme

    # Applications
    firefox
    networkmanagerapplet
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    file-roller
    tumbler


    # Gaming & Wine Stack
    bottles
    wine-staging
    winetricks
    mangohud
    lutris
    heroic
    protonup-qt
  ];

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # Nix Settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts
    noto-fonts-color-emoji
    font-awesome
  ];

  system.stateVersion = "26.05";
}
