{ pkgs, ... }:
let
  # nixpkgs Firefox only has en-US built in, and reads others from this path.
  dictionaries = pkgs.symlinkJoin {
    name = "firefox-dictionaries";
    paths = with pkgs.hunspellDicts; [
      en_GB-ise
      de_DE
    ];
  };
in
{
  # UI settings Firefox Sync does not cover. Bookmarks, history and extensions come from Sync.
  programs.firefox = {
    enable = true;
    profiles.default.settings = {
      # Copied from the live Fedora profile. To update: rearrange in Firefox, then copy
      # browser.uiCustomization.state from about:config.
      "browser.uiCustomization.state" = {
        placements = {
          widget-overflow-fixed-list = [ ];
          unified-extensions-area = [
            "ublock0_raymondhill_net-browser-action"
            "_5caff8cc-3d2e-4110-a88a-003cc85b3858_-browser-action"
            "_6ac85730-7d0f-4de0-b3fa-21142dd85326_-browser-action"
            "jid1-zadieub7xozojw_jetpack-browser-action"
          ];
          nav-bar = [
            "back-button"
            "forward-button"
            "stop-reload-button"
            "customizableui-special-spring1"
            "vertical-spacer"
            "urlbar-container"
            "bookmarks-menu-button"
            "customizableui-special-spring2"
            "downloads-button"
            "fxa-toolbar-menu-button"
            "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
            "nordvpnproxy_nordvpn_com-browser-action"
            "unified-extensions-button"
            "sidebar-button"
            "reset-pbm-toolbar-button"
          ];
          toolbar-menubar = [
            "menubar-items"
          ];
          TabsToolbar = [
            "tabbrowser-tabs"
            "new-tab-button"
            "customizableui-special-spring6"
            "alltabs-button"
            "smartwindow-group-tabs-button"
            "ai-window-toggle"
          ];
          vertical-tabs = [ ];
          PersonalToolbar = [
            "personal-bookmarks"
          ];
        };
        seen = [
          "developer-button"
          "screenshot-button"
          "ipprotection-button"
          "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
          "_5caff8cc-3d2e-4110-a88a-003cc85b3858_-browser-action"
          "_6ac85730-7d0f-4de0-b3fa-21142dd85326_-browser-action"
          "ublock0_raymondhill_net-browser-action"
          "jid1-zadieub7xozojw_jetpack-browser-action"
          "nordvpnproxy_nordvpn_com-browser-action"
          "reset-pbm-toolbar-button"
          "smartwindow-group-tabs-button"
          "ai-window-toggle"
        ];
        dirtyAreaCache = [
          "nav-bar"
          "vertical-tabs"
          "unified-extensions-area"
          "widget-overflow-fixed-list"
          "toolbar-menubar"
          "TabsToolbar"
          "PersonalToolbar"
        ];
        currentVersion = 28;
        newElementCount = 6;
      };
      # A new profile otherwise moves the sidebar button to the far left or drops it, ignoring the
      # state above. Both are set on Fedora; tested headless against this Firefox.
      "browser.toolbarbuttons.introduced.sidebar-button" = true;
      "browser.engagement.sidebar-button.has-used" = true;
      "sidebar.position_start" = false;
      "sidebar.revamp.defaultLauncherVisible" = false;
      "sidebar.visibility" = "hide-on-close";
      "sidebar.main.tools" = "aichat,syncedtabs,history,bookmarks,{446900e4-71c2-419f-a6a7-df9c091e268b}";
      "spellchecker.dictionary" = "en-GB,de-DE";
      "spellchecker.dictionary_path" = "${dictionaries}/share/hunspell";
      # Passwords live in Bitwarden.
      "signon.rememberSignons" = false;
      "extensions.formautofill.creditCards.enabled" = false;
      "extensions.formautofill.addresses.enabled" = false;
    };
  };
}
