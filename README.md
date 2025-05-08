# Terminal Util
This is more or less my own personal custom script for my terminal, which means that it will contain a lot of bad ad hoc code.
## Overview
Terminal Util is structured as a set of standalone utility scripts. You can include them in your terminal configuration as needed.

> **Note:** Currently, only one utility (`rclone-util`) is available, but more will likely be added over time.

## Getting Started
To use a utility script, source it in your terminal configuration file (e.g., `~/.bashrc` or `~/.zshrc`). Example:
```
if [ -f /path/to/terminal-utils/<utility>/<script>.sh ]; then
  . /path/to/terminal-utils/<utility>/<script>.sh
fi
```
Replace `<utility>` and `<script>` with the appropriate names.
## rclone-util
### Dependencies
- [rclone](https://rclone.org/)
### Setup
1. Create two directories (rename as needed):
```
.
├── local-drive
└── online-drive
```
2. Configure your rclone remote, and mount it to the `online-drive` directory.
3. Add the following line to your `.bashrc` (or equivalent):
```
if [ -f /path/to/terminal-utils/rclone-util/rclone-util.sh ]; then
  . /path/to/terminal-utils/rclone-util/rclone-util.sh
fi
```
4. Edit `ignore-list.txt` to specify which files or directories should be excluded when syncing **from online to local**.
> The provided `ignore-list.txt` includes an example entry. You can remove or replace its contents to fit your needs.

At the top of `rclone-util.sh`, configure the following variables:

| Variable           | Description                                           |
| ------------------ | ----------------------------------------------------- |
| `drive_path`       | Path to the mounted rclone drive (```online-drive```) |
| `local_drive_path` | Path to your local folder (```local-drive```)         |
| `remote_name`      | rclone remote name (as configured in step 2)          |
| `ignore_file_path` | Path to your `ignore-list.txt` file                   |
### Usage
Run the `rdrive` command followed by a subcommand:
```
rdrive <subcommand>
```
For example, to push updates from local to the mounted drive:
```
rdrive synconline
```
or
```
rdrive so
```
#### Available Subcommands

| Subcommand     | Alias | Description                                                            |
| -------------- | ----- | ---------------------------------------------------------------------- |
| `checkmounted` | `cm`  | Check if the rclone drive is currently mounted                         |
| `mount`        | `m`   | Mount the rclone drive                                                 |
| `unmount`      | `um`  | Unmount the rclone drive                                               |
| `refresh`      | `rf`  | Refresh the mount (unmounts and remounts)                              |
| `synconline`   | `so`  | Sync **local → online** (push updates from local to the mounted drive) |
| `synclocal`    | `sl`  | Sync **online → local** (pull updates from the mounted drive to local) |

**Important Notes:**
- `ignore-list.txt` is only used when syncing **from online to local**.
- Files and folders listed in `ignore-list.txt` (e.g., `venv/`) will not be copied **from online to local**.
- However, all contents (including ignored ones) will be copied **from local to online**.
- The default `ignore-list.txt` includes an example for convenience, which you can modify or replace entirely.
