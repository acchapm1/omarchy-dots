#!/bin/bash

# Script to install software packages from a list using install.sh

set -e

# Default configuration
SOFTWARE_LIST="software-list.txt"
INSTALL_SCRIPT="./install.sh"
METHOD="pacman"  # Default installation method
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
  echo "  -m, --method METHOD     Installation method: pacman, yay, or git (default: pacman)"
  echo "  -v, --verbose           Enable verbose output"
  echo ""
  echo "Examples:"
  echo "  $0"
  echo "  $0 -f my-software.txt"
  echo "  $0 -m yay"
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
      -m | --method)
        METHOD="$2"
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
  
  # Install packages based on method
  case "$METHOD" in
    pacman)
      log "Installing packages using pacman method"
      "$INSTALL_SCRIPT" "${packages[@]}"
      ;;
    yay)
      log "Installing packages using yay method"
      "$INSTALL_SCRIPT" -y "${packages[@]}"
      ;;
    git)
      error "Git method not supported for batch installation. Please install Git repositories individually."
      exit 1
      ;;
    *)
      error "Unknown installation method: $METHOD"
      exit 1
      ;;
  esac
}

# Main execution
main() {
  parse_args "$@"
  check_files
  install_software
  success "Batch installation completed successfully!"
}

# Run main function with all arguments
main "$@"