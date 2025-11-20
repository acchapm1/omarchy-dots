#!/bin/bash

# Bootstrap script for setting up omarchy on a fresh Arch Linux installation
# This script prepares the system and installs all required software

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Print banner
print_banner() {
  echo ""
  echo "╔═══════════════════════════════════════╗"
  echo "║   Omarchy Bootstrap Installation      ║"
  echo "║   Arch Linux Package Setup            ║"
  echo "╚═══════════════════════════════════════╝"
  echo ""
}

# Print usage information
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  -h, --help              Show this help message"
  echo "  -s, --skip-update       Skip system update"
  echo "  -n, --no-yay            Skip yay installation"
  echo "  -v, --verbose           Enable verbose output"
  echo ""
  echo "This script will:"
  echo "  1. Update the system (optional)"
  echo "  2. Install yay AUR helper (optional)"
  echo "  3. Make all scripts executable"
  echo "  4. Run smart-install.sh to install all packages"
  echo ""
}

# Default configuration
SKIP_UPDATE=false
SKIP_YAY=false
VERBOSE=false

# Parse command line arguments
parse_args() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      -h | --help)
        usage
        exit 0
        ;;
      -s | --skip-update)
        SKIP_UPDATE=true
        shift
        ;;
      -n | --no-yay)
        SKIP_YAY=true
        shift
        ;;
      -v | --verbose)
        VERBOSE=true
        set -x
        shift
        ;;
      -*)
        error "Unknown option: $1"
        usage
        exit 1
        ;;
      *)
        shift
        ;;
    esac
  done
}

# Check if we're on Arch Linux
check_arch_linux() {
  log "Checking if running on Arch Linux..."
  
  if [[ ! -f /etc/arch-release ]]; then
    warning "This system does not appear to be Arch Linux"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      exit 1
    fi
  else
    success "Running on Arch Linux"
  fi
}

# Update system
update_system() {
  if [[ "$SKIP_UPDATE" == true ]]; then
    log "Skipping system update"
    return
  fi
  
  log "Updating system packages..."
  
  if sudo pacman -Syu --noconfirm; then
    success "System updated successfully"
  else
    error "Failed to update system"
    exit 1
  fi
}

# Install yay AUR helper
install_yay() {
  if [[ "$SKIP_YAY" == true ]]; then
    log "Skipping yay installation"
    return
  fi
  
  # Check if yay is already installed
  if command -v yay &>/dev/null; then
    success "yay is already installed"
    return
  fi
  
  log "Installing yay AUR helper..."
  
  # Install base-devel and git if not present
  sudo pacman -S --needed --noconfirm base-devel git
  
  # Clone yay repository
  local temp_dir
  temp_dir=$(mktemp -d)
  
  if git clone https://aur.archlinux.org/yay.git "$temp_dir/yay"; then
    cd "$temp_dir/yay" || exit 1
    
    if makepkg -si --noconfirm; then
      success "yay installed successfully"
    else
      error "Failed to install yay"
      cd - >/dev/null || exit 1
      rm -rf "$temp_dir"
      exit 1
    fi
    
    cd - >/dev/null || exit 1
    rm -rf "$temp_dir"
  else
    error "Failed to clone yay repository"
    rm -rf "$temp_dir"
    exit 1
  fi
}

# Make scripts executable
make_scripts_executable() {
  log "Making scripts executable..."
  
  chmod +x install.sh
  chmod +x install-from-list.sh
  chmod +x smart-install.sh
  
  success "Scripts are now executable"
}

# Verify required files exist
verify_files() {
  log "Verifying required files..."
  
  local missing_files=()
  
  [[ ! -f "install.sh" ]] && missing_files+=("install.sh")
  [[ ! -f "install-from-list.sh" ]] && missing_files+=("install-from-list.sh")
  [[ ! -f "smart-install.sh" ]] && missing_files+=("smart-install.sh")
  [[ ! -f "software-list.txt" ]] && missing_files+=("software-list.txt")
  
  if [[ ${#missing_files[@]} -gt 0 ]]; then
    error "Missing required files: ${missing_files[*]}"
    exit 1
  fi
  
  success "All required files present"
}

# Install packages from software list
install_packages() {
  log "Installing packages from software-list.txt..."
  
  if ./smart-install.sh; then
    success "Package installation completed"
  else
    warning "Some packages may have failed to install"
    log "Check the output above for details"
  fi
}

# Main execution
main() {
  print_banner
  parse_args "$@"
  
  log "Starting omarchy bootstrap process..."
  
  check_arch_linux
  verify_files
  update_system
  install_yay
  make_scripts_executable
  install_packages
  
  echo ""
  success "╔═══════════════════════════════════════╗"
  success "║  Bootstrap completed successfully!    ║"
  success "╚═══════════════════════════════════════╝"
  echo ""
  log "Your system is now configured with all packages from software-list.txt"
  log "To install additional packages, edit software-list.txt and run:"
  log "  ./smart-install.sh"
  echo ""
}

# Run main function with all arguments
main "$@"