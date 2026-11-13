{ lib, pkgs, ... }:
let
  lua = lib.generators.mkLuaInline;
  bind = key: dispatcher: {
    _args = [
      key
      (lua dispatcher)
    ];
  };
  bindWith = options: key: dispatcher: {
    _args = [
      key
      (lua dispatcher)
      options
    ];
  };
  # Locked binds keep working on the lock screen.
  mediaBind = bindWith { locked = true; };
  repeatingMediaBind = bindWith {
    locked = true;
    repeating = true;
  };

  workspaceBinds = lib.concatMap (
    workspace:
    let
      # Workspace 10 sits on the 0 key.
      key = toString (lib.mod workspace 10);
      number = toString workspace;
    in
    [
      (bind "SUPER + ${key}" "hl.dsp.focus({ workspace = ${number} })")
      (bind "SUPER + SHIFT + ${key}" "hl.dsp.window.move({ workspace = ${number} })")
    ]
  ) (lib.range 1 10);
in
{
  imports = [
    ./common.nix
    ./repos.nix
  ];

  home = {
    homeDirectory = "/home/francis";

    packages = with pkgs; [
      brightnessctl
      imv
      libnotify
      playerctl
      wl-clipboard
    ];
  };

  # Electron only uses the keyring on desktops it recognises, not Hyprland; claude-desktop's launcher reads this.
  systemd.user.sessionVariables.CLAUDE_PASSWORD_STORE = "gnome-libsecret";

  # PAM starts and unlocks the keyring at login, but outside GNOME nothing tells it to serve
  # secrets, so D-Bus starts a second, locked daemon instead.
  systemd.user.services.gnome-keyring-start = {
    Unit = {
      Description = "Hand the PAM-unlocked keyring to the session";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Apps read this through the GTK portal; full theming comes later with Stylix.
  gtk = {
    enable = true;
    colorScheme = "dark";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # The NixOS module installs Hyprland and its portal.
    package = null;
    portalPackage = null;
    settings = {
      # Updates arrive through the flake, so the post-update changelog popup is noise.
      config.ecosystem.no_update_news = true;
      monitor = [
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = "auto";
        }
      ];
      bind = [
        (bind "SUPER + RETURN" "hl.dsp.exec_cmd(\"kitty\")")
        (bind "SUPER + D" "hl.dsp.exec_cmd(\"hyprlauncher\")")

        (bind "SUPER + C" "hl.dsp.window.close()")
        (bind "SUPER + M" "hl.dsp.exit()")
        (bind "SUPER + V" "hl.dsp.window.float({ action = \"toggle\" })")
        (bind "SUPER + P" "hl.dsp.window.pseudo()")
        (bind "SUPER + J" "hl.dsp.layout(\"togglesplit\")")

        (bind "SUPER + left" "hl.dsp.focus({ direction = \"left\" })")
        (bind "SUPER + right" "hl.dsp.focus({ direction = \"right\" })")
        (bind "SUPER + up" "hl.dsp.focus({ direction = \"up\" })")
        (bind "SUPER + down" "hl.dsp.focus({ direction = \"down\" })")

        (bind "SUPER + S" "hl.dsp.workspace.toggle_special(\"magic\")")
        (bind "SUPER + SHIFT + S" "hl.dsp.window.move({ workspace = \"special:magic\" })")
        (bind "SUPER + mouse_down" "hl.dsp.focus({ workspace = \"e+1\" })")
        (bind "SUPER + mouse_up" "hl.dsp.focus({ workspace = \"e-1\" })")

        (bindWith { mouse = true; } "SUPER + mouse:272" "hl.dsp.window.drag()")
        (bindWith { mouse = true; } "SUPER + mouse:273" "hl.dsp.window.resize()")

        (repeatingMediaBind "XF86AudioRaiseVolume" "hl.dsp.exec_cmd(\"wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+\")")
        (repeatingMediaBind "XF86AudioLowerVolume" "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-\")")
        (repeatingMediaBind "XF86AudioMute" "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\")")
        (repeatingMediaBind "XF86AudioMicMute" "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle\")")
        (repeatingMediaBind "XF86MonBrightnessUp" "hl.dsp.exec_cmd(\"brightnessctl -e4 -n2 set 5%+\")")
        (repeatingMediaBind "XF86MonBrightnessDown" "hl.dsp.exec_cmd(\"brightnessctl -e4 -n2 set 5%-\")")

        (mediaBind "XF86AudioNext" "hl.dsp.exec_cmd(\"playerctl next\")")
        (mediaBind "XF86AudioPause" "hl.dsp.exec_cmd(\"playerctl play-pause\")")
        (mediaBind "XF86AudioPlay" "hl.dsp.exec_cmd(\"playerctl play-pause\")")
        (mediaBind "XF86AudioPrev" "hl.dsp.exec_cmd(\"playerctl previous\")")
      ]
      ++ workspaceBinds;
    };
  };

  programs = {
    waybar = {
      enable = true;
      systemd.enable = true;
      # Waybar's built-in config only uses Sway modules.
      settings.mainBar = {
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "pulseaudio"
          "network"
          "clock"
          "tray"
        ];
      };
    };
  };

  services = {
    hyprlauncher = {
      enable = true;
      # Give each app its own scope, so restarting the launcher does not kill everything it opened.
      settings.finders.desktop_launch_prefix = "systemd-run --user --scope --quiet --";
    };
    mako.enable = true;
    hyprpolkitagent.enable = true;
    hyprpaper = {
      enable = true;
      settings.wallpaper = [
        {
          monitor = "";
          path = "${./wallpaper.png}";
        }
      ];
    };
  };
}
