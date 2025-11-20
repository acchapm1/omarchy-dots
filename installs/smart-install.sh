#!/bin/bash

# Script to intelligently install software packages using the appropriate method

set -e

# Default configuration
SOFTWARE_LIST="software-list.txt"
INSTALL_SCRIPT="./install.sh"
VERBOSE=false

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

# Print usage information
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  -h, --help              Show this help message"
  echo "  -f, --file FILE         Specify software list file (default: software-list.txt)"
  echo "  -v, --verbose           Enable verbose output"
  echo ""
  echo "Examples:"
  echo "  $0"
  echo "  $0 -f my-software.txt"
  echo ""
}

# Parse command line arguments
parse_args() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      -h | --help)
        usage
        exit 0
        ;;
      -f | --file)
        SOFTWARE_LIST="$2"
        shift 2
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

# Check if required files exist
check_files() {
  if [[ ! -f "$SOFTWARE_LIST" ]]; then
    error "Software list file not found: $SOFTWARE_LIST"
    exit 1
  fi

  if [[ ! -f "$INSTALL_SCRIPT" ]]; then
    error "Install script not found: $INSTALL_SCRIPT"
    exit 1
  fi

  if [[ ! -x "$INSTALL_SCRIPT" ]]; then
    error "Install script is not executable: $INSTALL_SCRIPT"
    exit 1
  fi
}

# Check if a package is available in pacman repositories
is_in_pacman() {
  local package="$1"
  if pacman -Si "$package" &>/dev/null; then
    return 0
  else
    return 1
  fi
}

# Check if a package is available in AUR (using yay)
is_in_aur() {
  local package="$1"
  if command -v yay &>/dev/null && yay -Si "$package" &>/dev/null; then
    return 0
  else
    return 1
  fi
}

# Determine the best installation method for a package
get_install_method() {
  local package="$1"
  
  log "Determining best installation method for: $package"
  
  if is_in_pacman "$package"; then
    echo "pacman"
  elif is_in_aur "$package"; then
    echo "yay"
  else
    echo "not_found"
  fi
}

# Install a single package with the appropriate method
install_package() {
  local package="$1"
  local method
  
  method=$(get_install_method "$package")
  
  case "$method" in
    pacman)
      log "Installing $package using pacman"
      "$INSTALL_SCRIPT" "$package"
      ;;
    yay)
      log "Installing $package using yay"
      "$INSTALL_SCRIPT" -y "$package"
      ;;
    not_found)
      warning "Package not found in repositories: $package"
      return 1
      ;;
    *)
      error "Unknown installation method: $method"
      return 1
      ;;
  esac
}

# Read software list and install packages
install_software() {
  log "Reading software list from: $SOFTWARE_LIST"
  
  # Read packages into array
  mapfile -t packages < <(grep -v '^#' "$SOFTWARE_LIST" | grep -v '^$')
  
  if [[ ${#packages[@]} -eq 0 ]]; then
    warning "No packages found in the software list"
    return
  fi
  
  log "Found ${#packages[@]} packages to install"
  
  # Install each package with its appropriate method
  local success_count=0
  local fail_count=0
  
  for package in "${packages[@]}"; do
    if install_package "$package"; then
      ((success_count++))
    else
      ((fail_count++))
    fi
  done
  
  log "Installation summary: $success_count successful, $fail_count failed"
}

# Main execution
main() {
  parse_args "$@"
  check_files
  install_software
  success "Smart installation completed!"
}

# Run main function with all arguments
main "$@"