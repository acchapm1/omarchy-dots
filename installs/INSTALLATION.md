# Batch Software Installation Scripts

This repository contains scripts to automate software installation on fresh Arch Linux installations using the main `install.sh` script.

## Quick Start

For a fresh Arch Linux installation, simply clone this repo and run:

```bash
git clone <your-repo-url> omarchy
cd omarchy
./bootstrap.sh
```

This will set up everything automatically!

## Files

- `bootstrap.sh` - One-command setup script for fresh installations
- `install.sh` - The main installation script (supports pacman, yay, and git)
- `software-list.txt` - List of software packages to install (one per line)
- `install-from-list.sh` - Script to install packages from the list using a specific method
- `smart-install.sh` - Script that automatically detects the best installation method for each package

## Usage

### Bootstrap (Recommended for Fresh Installs)

The bootstrap script handles everything for you:

```bash
./bootstrap.sh
```

Options:
- `-s, --skip-update` - Skip system update
- `-n, --no-yay` - Skip yay AUR helper installation
- `-v, --verbose` - Enable verbose output

The bootstrap script will:
1. Update your system (optional)
2. Install yay AUR helper if not present (optional)
3. Make all scripts executable
4. Install all packages from software-list.txt

### Manual Installation

If you prefer more control, you can run the scripts individually:

1. Edit `software-list.txt` to include the software packages you want to install (one per line)
2. Run one of the installation scripts:

```bash
# Install all packages using pacman (default)
./install-from-list.sh

# Install all packages using yay
./install-from-list.sh -m yay

# Install packages from a custom list
./install-from-list.sh -f my-software.txt

# Smart install (automatically chooses best method for each package)
./smart-install.sh
```

### Script Options

#### install-from-list.sh

```
Usage: ./install-from-list.sh [OPTIONS]

Options:
  -h, --help              Show this help message
  -f, --file FILE         Specify software list file (default: software-list.txt)
  -m, --method METHOD     Installation method: pacman, yay, or git (default: pacman)
  -v, --verbose           Enable verbose output

Examples:
  ./install-from-list.sh
  ./install-from-list.sh -f my-software.txt
  ./install-from-list.sh -m yay
```

#### smart-install.sh

```
Usage: ./smart-install.sh [OPTIONS]

Options:
  -h, --help              Show this help message
  -f, --file FILE         Specify software list file (default: software-list.txt)
  -v, --verbose           Enable verbose output

Examples:
  ./smart-install.sh
  ./smart-install.sh -f my-software.txt
```

## How It Works

### install-from-list.sh

This script reads package names from a text file and installs them using the specified method (pacman or yay). It's a simple batch installer that treats all packages the same way.

### smart-install.sh

This script intelligently determines the best installation method for each package:

1. Checks if the package is available in the official pacman repositories
2. If not found, checks if it's available in the AUR (requires yay)
3. Installs using the appropriate method automatically

## Adding Software

To add software to be installed:

1. Open `software-list.txt`
2. Add one package name per line
3. Run the installation script

Example `software-list.txt`:
```
git
curl
nvim
bat
fzf
zoxide
zellij
```

## Notes

- Comments can be added in the software list file using `#` at the beginning of a line
- Empty lines in the software list file are ignored
- The smart installer requires an active internet connection to check package availability
- For Git installations, packages must be installed individually using the main `install.sh` script with the `-g` flag