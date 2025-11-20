# TODO: Improvements for Arch Linux Installation Scripts

## High Priority

### 1. Add Dry-Run Mode
- [ ] Add `--dry-run` or `-n` flag to all scripts
- [ ] Show what would be installed without actually installing
- [ ] Useful for testing and verification before running on fresh install
- **Files to modify**: `install.sh`, `install-from-list.sh`, `smart-install.sh`

### 2. Add Package Verification
- [ ] Check if packages are already installed before attempting installation
- [ ] Skip already installed packages or provide option to reinstall
- [ ] Add `--force-reinstall` flag to override skip behavior
- **Files to modify**: All installation scripts

### 3. Create Bootstrap Script
- [ ] Create `bootstrap.sh` - one command to set up everything
- [ ] Auto-install `yay` if not present (from AUR)
- [ ] Make `install.sh` executable automatically
- [ ] Run system update before installing packages
- **New file**: `bootstrap.sh`

### 4. Improve Error Handling
- [ ] Add `set -u` (error on undefined variables) to all scripts
- [ ] Add `set -o pipefail` to catch errors in pipes
- [ ] Continue installing other packages even if one fails (configurable)
- [ ] Add rollback capability on failure
- **Files to modify**: All scripts

### 5. Add Logging to File
- [ ] Add option to log all output to a file (e.g., `install.log`)
- [ ] Include timestamps in log entries
- [ ] Separate successful and failed installations in log
- **Files to modify**: All scripts

## Medium Priority

### 6. Expand software-list.txt Format
- [ ] Support inline comments (e.g., `git # Version control system`)
- [ ] Support package groups (e.g., `[development]`, `[utilities]`)
- [ ] Support specifying installation method per package
- [ ] Example format: `nvim:pacman # Neovim editor` or `discord:yay # Discord client`
- **Files to modify**: `software-list.txt`, `install-from-list.sh`, `smart-install.sh`

### 7. Add Configuration File Support
- [ ] Create `config.conf` or `.omarchy.conf` file
- [ ] Store default preferences (method, verbosity, etc.)
- [ ] Support XDG Base Directory specification (`~/.config/omarchy/`)
- **New file**: `config.conf` or `.omarchyrc`

### 8. Improve smart-install.sh Efficiency
- [ ] Batch packages by installation method instead of installing one at a time
- [ ] Group pacman packages together, yay packages together
- [ ] Reduces sudo prompts and speeds up installation
- **File to modify**: `smart-install.sh`

### 9. Add Progress Indicators
- [ ] Show progress bar or percentage during installations
- [ ] Display current package number (e.g., "Installing 3 of 7: nvim")
- [ ] Estimate time remaining based on average install time
- **Files to modify**: All installation scripts

### 10. Create Uninstall Functionality
- [ ] Add `uninstall.sh` script to remove packages from list
- [ ] Track installed packages in a state file
- [ ] Option to remove dependencies that are no longer needed
- **New file**: `uninstall.sh`

## Low Priority / Nice to Have

### 11. Add Package Categories
- [ ] Create multiple list files: `essential.txt`, `development.txt`, `desktop.txt`
- [ ] Allow installing by category: `./install-from-list.sh -c development`
- [ ] Create `lists/` directory to organize category files
- **New files**: Category-specific list files

### 12. Support for Other Package Managers
- [ ] Add support for `paru` (alternative to yay)
- [ ] Add support for `flatpak` packages
- [ ] Add support for `snap` packages (if needed)
- [ ] Auto-detect best available AUR helper
- **Files to modify**: `install.sh`, related scripts

### 13. Add Post-Install Scripts
- [ ] Support running custom commands after package installation
- [ ] Example: Configure zsh after installing it, setup dotfiles, etc.
- [ ] Create `post-install/` directory with package-specific scripts
- **New directory**: `post-install/`

### 14. Add Pre-Install Checks
- [ ] Check available disk space before installation
- [ ] Verify internet connectivity
- [ ] Check for system updates needed
- [ ] Warn about conflicting packages
- **New file**: `pre-flight-check.sh`

### 15. Create Update Script
- [ ] Script to update all installed packages from the list
- [ ] Check for newer versions and update
- [ ] Generate report of outdated packages
- **New file**: `update-packages.sh`

### 16. Add Interactive Mode
- [ ] Prompt user to confirm each package before installation
- [ ] Allow skipping packages interactively
- [ ] Show package description and size before installing
- **Files to modify**: All installation scripts

### 17. Improve Portability
- [ ] Test on different Arch-based distros (Manjaro, EndeavourOS, etc.)
- [ ] Add OS detection and compatibility warnings
- [ ] Document tested distributions in README
- **Files to modify**: All scripts, documentation

### 18. Add Shell Completion
- [ ] Create bash completion script for commands
- [ ] Support zsh completion
- [ ] Auto-complete package names from software-list.txt
- **New files**: `completion/omarchy.bash`, `completion/omarchy.zsh`

### 19. Repository Structure Improvements
- [ ] Add `.gitignore` file (ignore logs, temp files)
- [ ] Add `LICENSE` file
- [ ] Add `CONTRIBUTING.md` guidelines
- [ ] Create GitHub Actions for testing
- [ ] Add example software lists in `examples/` directory
- **New files**: `.gitignore`, `LICENSE`, `CONTRIBUTING.md`, `.github/workflows/`

### 20. Add Package Metadata
- [ ] Track when packages were installed
- [ ] Track why packages were installed (dependency or explicit)
- [ ] Generate reports of installed packages
- **New file**: `.omarchy-state.json` or similar

## Code Quality Improvements

### 21. Code Reuse
- [ ] Extract common functions into `lib/common.sh`
- [ ] Source common library in all scripts
- [ ] Reduce code duplication across scripts
- **New file**: `lib/common.sh`

### 22. Add Unit Tests
- [ ] Use `bats` (Bash Automated Testing System) or similar
- [ ] Test individual functions
- [ ] Test edge cases and error conditions
- **New directory**: `tests/`

### 23. Improve Documentation
- [ ] Add inline comments for complex logic
- [ ] Create man pages for each script
- [ ] Add troubleshooting section to README
- [ ] Document all environment variables used
- **Files to modify**: All scripts, `INSTALLATION.md`

### 24. Security Improvements
- [ ] Validate package names to prevent injection attacks
- [ ] Use secure temporary directories
- [ ] Add checksum verification for Git installations
- [ ] Sanitize all user inputs
- **Files to modify**: All scripts

## Performance Optimizations

### 25. Parallel Installation Support
- [ ] Install multiple packages in parallel (with caution)
- [ ] Add `--jobs` or `-j` flag to control parallelism
- [ ] Only for packages without dependencies on each other
- **Files to modify**: Installation scripts

### 26. Cache Package Queries
- [ ] Cache results of `pacman -Si` and `yay -Si` queries
- [ ] Reduce redundant repository queries
- [ ] Add cache expiration time
- **Files to modify**: `smart-install.sh`

## Documentation Improvements

### 27. Create Quick Start Guide
- [ ] Add one-liner installation command in README
- [ ] Create step-by-step tutorial for first-time users
- [ ] Add screenshots or terminal recordings
- **Files to modify**: `README.md`, `INSTALLATION.md`

### 28. Add Examples
- [ ] Create example use cases
- [ ] Document common workflows
- [ ] Add troubleshooting examples
- **New file**: `EXAMPLES.md`

---

## Implementation Priority

### Phase 1 (Essential for GitHub Repo)
- Items 1, 3, 5, 19 (High priority for reliability and usability)

### Phase 2 (Improve User Experience)
- Items 2, 6, 8, 27 (Make it easier and faster to use)

### Phase 3 (Feature Complete)
- Items 9, 11, 13, 15, 21 (Add advanced features)

### Phase 4 (Polish)
- Items 16, 18, 22, 23 (Refinement and professional polish)