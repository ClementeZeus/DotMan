# dotman

A lightweight, modular, configuration-driven Bash tool designed to manage, deploy, and inspect cross-platform dotfile symlinks across Linux, macOS, and Windows (via Git Bash).

## Features

- **Configuration-Driven Mappings:** Centralized mapping of source files inside the repository to target destination paths.
- **Cross-Platform Path Routing:** Compatible with native POSIX environments and Windows filesystem bridges (`/c/...`).
- **Conflict Handling & Timestamped Backups:** Prevents accidental overwrites by warning on non-symlink target conflicts, creating automatic timestamped backups (`.bak.YYYYMMDD_HHMMSS`) when using the force option.
- **Dry-Run Mode:** Test operations safely before executing file operations.
- **Status Inspection:** Interrogate target file states (`[LINKED]`, `[CONFLICT]`, `[MISSING]`) without altering the system.

---

## Directory Structure

```text
.
├── bin/
│   └── dotman            # Main CLI entrypoint and subcommand dispatcher
├── lib/
│   ├── logger.sh         # Color-coded logging utilities
│   └── link.sh           # Core symlink, validation, and backup logic
├── configs/
│   ├── dotfiles.conf     # Mapping rules (Source:Destination)
│   ├── .zshrc            # Source configuration file
│   └── .gitconfig        # Source configuration file
└── README.md
```

---

## Configuration (`configs/dotfiles.conf`)

Mappings are defined using simple `source_relative_path : destination_relative_path` key-value pairs per line. Empty lines and lines starting with `#` are ignored.

```ini
# Relative to repo root : Relative to home/target path
configs/.zshrc:.zshrc
configs/.gitconfig:.gitconfig
```

---

## Usage

### Prerequisites
- Bash 4.0+ environment.
- On Windows: Execute via **Git Bash** (`"C:\Program Files\Git\bin\bash.exe"`) or a Git Bash terminal window. Ensure Developer Mode is active or run with appropriate permissions to permit native symlink creation.

### Syntax

```bash
./bin/dotman [-d] [-f] [command]
```

### Options

| Flag | Description |
| :--- | :--- |
| `-d` | **Dry-Run**: Preview file operations without modifying the disk. |
| `-f` | **Force**: Overwrite existing target files by creating a timestamped backup before linking. |
| `-h` | Display basic usage information. |

### Commands

| Subcommand | Description |
| :--- | :--- |
| `status` | Checks and reports current status of mapped target paths (`[LINKED]`, `[CONFLICT]`, `[MISSING]`). |
| `deploy` | *(Default)* Creates symlinks from repository source files to target destination paths. |

---

## Examples (PowerShell Execution)

Run status check across configured dotfiles:
```powershell
& "C:\Program Files\Git\bin\bash.exe" ./bin/dotman status
```

Simulate deployment with dry-run mode:
```powershell
& "C:\Program Files\Git\bin\bash.exe" ./bin/dotman -d deploy
```

Force deployment and resolve target conflicts with backups:
```powershell
& "C:\Program Files\Git\bin\bash.exe" ./bin/dotman -f deploy
```

---

## Line Ending Portability Notice

When editing or generating Bash scripts within Windows environments, ensure files use Unix line endings (`LF`). If CRLF line endings are introduced by PowerShell or Windows text editors, normalize line endings using `sed`:

```powershell
& "C:\Program Files\Git\bin\bash.exe" -c "sed -i 's/\r$//' ./bin/dotman ./lib/*.sh"
```