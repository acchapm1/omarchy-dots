# GitHub Repository Checklist

Use this checklist before pushing to GitHub and when setting up on a fresh Arch installation.

## Pre-Push Checklist

### Required Files
- [x] `.gitignore` - Created
- [x] `bootstrap.sh` - Created and executable
- [x] `install.sh` - Exists and executable
- [x] `install-from-list.sh` - Created and executable
- [x] `smart-install.sh` - Created and executable
- [x] `software-list.txt` - Created with sample packages
- [x] `TODO.md` - Created with improvement suggestions
- [x] `INSTALLATION.md` - Created with usage instructions
- [x] `SUMMARY.md` - Created with project overview

### Files to Create/Update Before Push
- [ ] Choose one README:
  - Option 1: Rename `GITHUB-README.md` to `README.md` (recommended)
  - Option 2: Update existing `README.md` with content from `GITHUB-README.md`
- [ ] Add `LICENSE` file (choose license: MIT, GPL, etc.)
- [ ] Update repository URL in `GITHUB-README.md` (replace `yourusername`)
- [ ] Update `software-list.txt` with YOUR actual preferred packages
- [ ] Test all scripts on a VM or test system

### Optional But Recommended
- [ ] Create `CONTRIBUTING.md` with contribution guidelines
- [ ] Create `.github/` directory with:
  - [ ] `ISSUE_TEMPLATE.md`
  - [ ] `PULL_REQUEST_TEMPLATE.md`
- [ ] Add a screenshot or demo GIF
- [ ] Create example package lists in `examples/` directory

## Testing Checklist

Before pushing to GitHub, test these scenarios:

### On a Test System
- [ ] Clone the repository
- [ ] Run `./bootstrap.sh` - Does it complete successfully?
- [ ] Check if all packages from `software-list.txt` are installed
- [ ] Test `./smart-install.sh` with a custom package
- [ ] Test `./install-from-list.sh -m yay` with AUR package
- [ ] Test error handling (try with non-existent package)

### Edge Cases
- [ ] Test with empty `software-list.txt`
- [ ] Test with package that doesn't exist
- [ ] Test with comments in `software-list.txt`
- [ ] Test without yay installed
- [ ] Test with insufficient permissions

## Git Setup Commands

```bash
# Initialize repository (if not already done)
git init

# Add all files
git add .

# Review what will be committed
git status

# Create first commit
git commit -m "Initial commit: Omarchy Arch Linux installation scripts"

# Create GitHub repository (via web interface or gh CLI)
# Then connect and push:
git remote add origin https://github.com/yourusername/omarchy.git
git branch -M main
git push -u origin main
```

## Fresh Installation Test

Once pushed to GitHub, test the full workflow:

### On a Fresh Arch VM/System
```bash
# 1. Clone repository
git clone https://github.com/yourusername/omarchy.git
cd omarchy

# 2. Verify all scripts are executable
ls -la *.sh

# 3. Run bootstrap
./bootstrap.sh

# 4. Verify installations
# Check that all packages from software-list.txt are installed
for pkg in $(cat software-list.txt | grep -v '^#' | grep -v '^$'); do
  echo -n "Checking $pkg... "
  if pacman -Qi $pkg &>/dev/null || yay -Qi $pkg &>/dev/null; then
    echo "✓ installed"
  else
    echo "✗ NOT installed"
  fi
done
```

## Post-Push Tasks

- [ ] Add repository description on GitHub
- [ ] Add topics/tags: `arch-linux`, `automation`, `bash`, `package-manager`
- [ ] Enable GitHub Issues
- [ ] Create initial GitHub Release (v1.0.0)
- [ ] Share with Arch Linux community (optional)
- [ ] Star your own repo (everyone does it!)

## Documentation Updates Needed

Before considering this "production ready":

1. **README.md**: Replace `yourusername` with actual GitHub username
2. **LICENSE**: Add appropriate license file
3. **software-list.txt**: Update with your actual packages
4. **INSTALLATION.md**: Add troubleshooting section based on testing

## Quick Command Reference

```bash
# Make all scripts executable
chmod +x *.sh

# Test bootstrap without system update
./bootstrap.sh -s

# Test smart install with verbose output
./smart-install.sh -v

# Verify all files
ls -la
```

## Success Criteria

Your repository is ready when:
- ✅ Fresh clone works on fresh Arch installation
- ✅ All documentation is accurate
- ✅ All scripts are executable
- ✅ LICENSE file exists
- ✅ README has correct repository URLs
- ✅ All links in documentation work
- ✅ No sensitive information committed

---

**Remember**: Test on a VM or non-critical system first!