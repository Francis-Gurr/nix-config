{ lib, ... }:
{
  programs.obsidian = {
    enable = true;
    cli.enable = true;

    # communityPlugins, themes, cssSnippets and hotkeys are deliberately left
    # unset: the module only writes a file when its option is non-null, and
    # community-plugins.json must stay Obsidian's, since LiveSync's data.json
    # holds the CouchDB credentials and cannot live in a public repo.
    # Both vaults share one setup so the agent skills work the same in either.
    vaults = lib.genAttrs [ "personal" "shared" ] (name: {
      target = "notes/${name}";

      settings = {
        # app.json is written whole, so anything omitted is dropped rather than
        # left alone. Declaring one key silently reset the other six.
        app = {
          alwaysUpdateLinks = true;
          attachmentFolderPath = "Attachments";
          defaultViewMode = "preview";
          newFileLocation = "current";
          newLinkFormat = "shortest";
          strictLineBreaks = true;
          useMarkdownLinks = false;
        };
        appearance = { };

        # Anything omitted is written as false, so this is the whole enabled set.
        corePlugins = [
          "backlink"
          "bases"
          "bookmarks"
          "canvas"
          "command-palette"
          "daily-notes"
          "editor-status"
          "file-explorer"
          "file-recovery"
          "global-search"
          "graph"
          "note-composer"
          "outgoing-link"
          "outline"
          "page-preview"
          "properties"
          "switcher"
          "sync"
          "tag-pane"
          "templates"
          "word-count"
        ];
      };
    });
  };
}
