# Obsidian reference

## Base views

In a base view `order:` sets the **columns**, not the rows. Sorting needs a separate `sort:` key,
which the published docs omit but the app supports:

```yaml
    order:            # columns, left to right
      - order
      - file.name
      - status
    sort:             # actual row order
      - property: order
        direction: ASC
```

## Querying a base

`obsidian vault="<vault>" base:query path=<name>.base view="<view>" format=paths`. Use `path=`, not `file=`: a folder with the same name (`Archive/` beside `Archive.base`) shadows `file=` and fails with "Base file not found".

## CLI inside VS Code

Run it as `env -u ELECTRON_RUN_AS_NODE obsidian …`. VS Code exports that variable, which makes
Obsidian start as plain Node and fail with `Cannot find module 'electron'`.

## `.obsidian/*.json`

The running app holds config in memory and overwrites these files on exit, so edit them only with
Obsidian closed. Anything needed while it runs goes through Settings.
