#!/bin/bash

# Arch Linux Application Installer Template
# Supports: pacman, yay, and Git repositories

set -e # Exit on any error

# Default configuration
USE_PACMAN=true
USE_YAY=false
USE_GIT=false
CLEAN_BUILD=false
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
  echo "Usage: $0 [OPTIONS] [PACKAGES...]"
  echo ""
  echo "Options:"
  echo "  -h, --help          Show this help message"
  echo "  -y, --yay           Use yay instead of pacman"
  echo "  -g, --git           Install from Git repository"
  echo "  -c, --clean         Clean build directory after installation"
  echo "  -v, --verbose       Enable verbose output"
  echo ""
  echo "Examples:"
  echo "  $0 htop git vim"
  echo "  $0 -y code discord"
  echo "  $0 -g https://github.com/user/repo.git"
  echo ""
}

# Parse command line arguments
parse_args() {
  local args=()
  while [[ $# -gt 0 ]]; do
    case $1 in
    -h | --help)
      usage
      exit 0
      ;;
    -y | --yay)
      USE_PACMAN=false
      USE_YAY=true
      shift
      ;;
    -g | --git)
      USE_GIT=true
      shift
      ;;
    -c | --clean)
      CLEAN_BUILD=true
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
      args+=("$1")
      shift
      ;;
    esac
  done

  PACKAGES=("${args[@]}")

  # Validate arguments
  if [[ ${#PACKAGES[@]} -eq 0 ]] && [[ "$USE_GIT" != true ]]; then
    error "No packages specified"
    usage
    exit 1
  fi
}

# Check if required tools are installed
check_dependencies() {
  log "Checking dependencies..."

  if ! command -v pacman &>/dev/null; then
    error "pacman is not installed"
    exit 1
  fi

  if [[ "$USE_YAY" == true ]] && ! command -v yay &>/dev/null; then
    warning "yay is not installed, falling back to pacman"
    USE_YAY=false
    USE_PACMAN=true
  fi

  if [[ "$USE_GIT" == true ]]; then
    if ! command -v git &>/dev/null; then
      error "git is required for Git installations"
      exit 1
    fi

    if ! command -v makepkg &>/dev/null; then
      error "makepkg is required for Git installations"
      exit 1
    fi
  fi
}

# Install packages with pacman
install_with_pacman() {
  local packages=("$@")
  log "Installing packages with pacman: ${packages[*]}"

  if sudo pacman -S --noconfirm --needed "${packages[@]}"; then
    success "Successfully installed packages with pacman"
  else
    error "Failed to install packages with pacman"
    exit 1
  fi
}

# Install packages with yay
install_with_yay() {
  local packages=("$@")
  log "Installing packages with yay: ${packages[*]}"

  if yay -S --noconfirm --needed "${packages[@]}"; then
    success "Successfully installed packages with yay"
  else
    error "Failed to install packages with yay"
    exit 1
  fi
}

# Install from Git repository
install_from_git() {
  local repo_url="$1"
  local repo_name
  local temp_dir

  # Extract repository name from URL
  repo_name=$(basename "$repo_url" .git)
  temp_dir=$(mktemp -d)

  log "Installing from Git repository: $repo_url"
  log "Working in temporary directory: $temp_dir"

  # Clone repository
  if ! git clone "$repo_url" "$temp_dir/$repo_name"; then
    error "Failed to clone repository"
    rm -rf "$temp_dir"
    exit 1
  fi

  # Change to repository directory
  cd "$temp_dir/$repo_name" || exit 1

  # Build and install package
  log "Building package..."
  if makepkg -si --noconfirm; then
    success "Successfully installed package from Git repository"
  else
    error "Failed to build/install package from Git repository"
    cd - >/dev/null || exit 1
    rm -rf "$temp_dir"
    exit 1
  fi

  # Clean up
  cd - >/dev/null || exit 1
  if [[ "$CLEAN_BUILD" == true ]]; then
    log "Cleaning build directory"
    rm -rf "$temp_dir"
  fi
}

# Main installation function
install_packages() {
  if [[ "$USE_GIT" == true ]]; then
    for package in "${PACKAGES[@]}"; do
      install_from_git "$package"
    done
  elif [[ "$USE_YAY" == true ]]; then
    install_with_yay "${PACKAGES[@]}"
  else
    install_with_pacman "${PACKAGES[@]}"
  fi
}

# Main execution
main() {
  parse_args "$@"
  check_dependencies
  install_packages
  success "Installation completed successfully!"
}

# Run main function with all arguments
main "$@"
