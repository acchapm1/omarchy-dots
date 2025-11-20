# 🏛️ Omarchy

> Automated software installation for Arch Linux - Set up your system in one command

Omarchy is a collection of bash scripts that automate software installation on Arch Linux. Perfect for fresh installations or maintaining consistent packages across multiple systems.

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/omarchy.git
cd omarchy

# Run bootstrap to set everything up
./bootstrap.sh
```

That's it! Your system will be configured with all your preferred software.

## ✨ Features

- **🎯 One-Command Setup**: Fresh install to fully configured in minutes
- **🧠 Smart Detection**: Automatically chooses the best installation method
- **📦 Multiple Methods**: Supports pacman, yay (AUR), and Git repositories
- **📝 Simple Configuration**: Just edit a text file to add/remove packages
- **🎨 Beautiful Output**: Color-coded feedback and progress indicators
- **🔒 Safe**: Comprehensive error handling and validation

## 📋 What Gets Installed

Edit `software-list.txt` to customize your package list. Default packages:
- git - Version control
- curl - Data transfer tool
- nvim - Modern Vim-based editor
- bat - Cat clone with syntax highlighting
- fzf - Fuzzy finder
- zoxide - Smarter cd command
- zellij - Terminal multiplexer

## 📖 Usage

### Bootstrap (Recommended)
```bash
./bootstrap.sh              # Full setup
./bootstrap.sh -s           # Skip system update
./bootstrap.sh -n           # Skip yay installation
```

### Manual Installation
```bash
./smart-install.sh          # Auto-detect best method for each package
./install-from-list.sh      # Install all with pacman
./install-from-list.sh -m yay  # Install all with yay
```

### Install Individual Packages
```bash
./install.sh package1 package2    # Install with pacman
./install.sh -y aur-package       # Install from AUR
./install.sh -g https://github.com/user/repo.git  # Install from Git
```

## 📂 Project Structure

```
omarchy/
├── bootstrap.sh           # One-command setup script
├── install.sh            # Core installation script
├── smart-install.sh      # Auto-detecting installer
├── install-from-list.sh  # Batch installer
├── software-list.txt     # Your package list
└── docs/                 # Documentation
```

## 🛠️ Requirements

- Arch Linux (or Arch-based: Manjaro, EndeavourOS, etc.)
- Internet connection
- `sudo` privileges

That's it! The bootstrap script will install everything else you need.

## 📝 Customization

### Adding Packages

Edit `software-list.txt`:
```
# Development tools
git
vim
nodejs

# Utilities
htop
tmux
```

Lines starting with `#` are comments and will be ignored.

### Creating Multiple Lists

Create different lists for different purposes:
```bash
./smart-install.sh -f development.txt
./smart-install.sh -f desktop.txt
./smart-install.sh -f gaming.txt
```

## 🗺️ Roadmap

See [TODO.md](TODO.md) for planned features:
- [ ] Dry-run mode
- [ ] Package verification
- [ ] Category-based installation
- [ ] Post-install script hooks
- [ ] Configuration file support
- [ ] And much more...

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Submit pull requests

## 📄 License

[Your License Here - e.g., MIT]

## 🙏 Acknowledgments

Built for the Arch Linux community, by an Arch Linux user.

---

**Made with ❤️ for Arch Linux users**

*"I use Arch, btw"* - Now with automated setup!