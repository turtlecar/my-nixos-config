{ config, lib, pkgs, pkgs-unstable, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
  };

  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    settings.auto-optimise-store = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;
  hardware.cpu.amd.updateMicrocode = true;
  boot.initrd.kernelModules = [ "amdgpu" ];

  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
  };

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery.governor = "powersave";
      battery.turbo = "never";
      charger.governor = "performance";
      charger.turbo = "auto";
    };
  };

  programs.gamemode.enable = true;

  networking.hostName = "nixkif";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Jakarta";

  services.displayManager.ly = {
    enable = true;
    settings = {
      allow_empty_password = false;
      animation = "none";
      asterisk = null;
      auth_fails = 5;
      battery_id = "BAT0";
      bigclock = "en";
      bigclock_seconds = true;
      brightness_down_cmd = "$PREFIX_DIRECTORY/bin/brightnessctl -q -n s 5%-";
      brightness_up_cmd = "$PREFIX_DIRECTORY/bin/brightnessctl -q -n s +5%";
      clear_password = true;
      clock = "%A, %d %B %y";
      xinitrc = null;
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [ brightnessctl kitty grim pulseaudio swayidle swaylock-effects rofi ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    wlr.settings.screencast = {
      output_name = "eDP-1";
      chooser_type = "simple";
      chooser_cmd = "${pkgs.slurp}/bin/slurp -f '%o' -or";
    };
  };

  security.polkit.enable = true;

  services.printing.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    audio.enable = true;
    wireplumber.enable = true;
    jack.enable = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      '';
  };

  users.users.akif = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.amdgpu.opencl.enable = true;

  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
  };

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [ thunar-archive-plugin thunar-volman ];
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    wget
    tree
    fastfetch
    bat
    btop
    autotiling
    slurp
    waybar
    wl-clipboard
    wl-clip-persist
    satty
    mate-polkit
    nwg-look
    xdg-user-dirs
    librewolf
    spotify
    zoom-us
    gruvbox-dark-gtk
    gruvbox-dark-icons-gtk
    capitaine-cursors-themed
    lazygit
    curl
    fzf
    ripgrep
    fd
    gcc
    clang
    gnumake
    tree-sitter
    nodejs
    stylua
    luarocks
    cargo
    nixfmt
    prettier
    shfmt
    statix
    lua
    python3
    pyright
    clang-tools
    lua-language-server
    zig
    zls
    rustc
    rust-analyzer
    nixd
    cmatrix
    cbonsai
    cowsay
    sl
    figlet
    fortune
    asciiquarium-transparent
    cava
    pkgs-unstable.pi-coding-agent
    lilypond
    fluidsynth
    ffmpeg
    mpv
    zathura
    playerctl
    kdePackages.qtstyleplugin-kvantum
    davinci-resolve
    alsa-utils
    piper-tts
    pipes
    whisper-cpp
  ];

  services.flatpak.enable = true;
  services.flatpak.packages = [
    "org.vinegarhq.Sober"
  ];

  environment.etc."xdg/user-dirs.defaults".text = ''
    DESKTOP=
    DOWNLOAD=downloads
    TEMPLATES=templates
    PUBLICSHARE=
    DOCUMENTS=documents
    MUSIC=documents/music
    PICTURES=documents/pictures
    VIDEOS=documents/videos
    PROJECTS=projects
  '';

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];

  security.sudo.enable = true;
  networking.firewall.enable = true;

  system.stateVersion = "26.05"; 
}

