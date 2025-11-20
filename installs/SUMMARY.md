# Omarchy - Arch Linux Package Installation System

## Project Summary

Omarchy is a collection of bash scripts designed to automate software installation on Arch Linux systems. It's particularly useful for setting up fresh installations with your preferred software packages.

## Current Features

### 1. Core Installation Script (`install.sh`)
- Install packages via pacman (official repositories)
- Install packages via yay (AUR)
- Install packages from Git repositories
- Color-coded output for better readability
- Comprehensive error handling
- Verbose mode for debugging

### 2. Batch Installation (`install-from-list.sh`)
- Install multiple packages from a text file
- Support for comments and empty lines in package lists
- Choose installation method (pacman or yay)
- Simple and straightforward

### 3. Smart Installation (`smart-install.sh`)
- Automatically detect the best installation method for each package
- Check official repositories first, then AUR
- Install packages one by one with appropriate method
- Summary report of successful/failed installations

### 4. Bootstrap Script (`bootstrap.sh`)
- One-command setup for fresh installations
- Automatic system update
- Automatic yay installation
- Makes all scripts executable
- Runs smart installation automatically

### 5. Package List (`software-list.txt`)
- Simple text file format (one package per line)
- Supports comments with `#`
- Easy to edit and maintain
- Currently includes: git, curl, nvim, bat, fzf, zoxide, zellij

## Project Structure

```
omarchy/
├── bootstrap.sh              # One-command setup script
├── install.sh                # Core installation script
├── install-from-list.sh      # Batch installer
├── smart-install.sh          # Smart installer with auto-detection
├── software-list.txt         # Package list
├── .gitignore               # Git ignore file
├── TODO.md                  # Future improvements
├── INSTALLATION.md          # Installation guide
├── README.md                # Original documentation
└── SUMMARY.md               # This file
```

## Use Cases

### Fresh Arch Linux Installation
1. Clone the repository
2. Run `./bootstrap.sh`
3. All your software is installed automatically

### Adding New Software
1. Edit `software-list.txt`
2. Add package names (one per line)
3. Run `./smart-install.sh`

### Installing Specific Packages
```bash
# Using the core script
./install.sh package1 package2 package3

# Using yay for AUR packages
./install.sh -y aur-package

# From Git repository
./install.sh -g https://github.com/user/repo.git
```

## Benefits

1. **Reproducible Installations**: Same packages on every installation
2. **Time Saving**: No manual package installation
3. **Documentation**: Package list serves as documentation
4. **Flexible**: Multiple installation methods
5. **Safe**: Checks before installing, clear error messages
6. **Portable**: Works on any Arch-based distribution

## Requirements

- Arch Linux or Arch-based distribution
- `pacman` (required)
- `yay` (optional, for AUR packages - bootstrap can install it)
- `git` (optional, for Git installations)
- `base-devel` (optional, for building AUR packages)

## Future Improvements

See `TODO.md` for a comprehensive list of planned improvements, including:
- Dry-run mode
- Package verification
- Improved error handling
- Configuration file support
- Category-based installation
- Post-install scripts
- And much more...

## Quick Reference

### Bootstrap Command
```bash
./bootstrap.sh              # Full setup
./bootstrap.sh -s           # Skip system update
./bootstrap.sh -n           # Don't install yay
```

### Install Commands
```bash
./smart-install.sh          # Auto-detect best method
./install-from-list.sh      # Use pacman for all
./install-from-list.sh -m yay  # Use yay for all
```

### Individual Package Installation
```bash
./install.sh package        # Install with pacman
./install.sh -y package     # Install with yay
./install.sh -g URL         # Install from Git
```

## Contributing

Future enhancements tracked in `TODO.md`. The project is designed to be modular and easy to extend.

## License

[Add your license here]

---

**Last Updated**: November 20, 2025
**Version**: 1.0.0