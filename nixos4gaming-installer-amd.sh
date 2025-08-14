#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script configuration
REPO_URL="https://github.com/Xarianne/NixOS4Gaming.git"
CONFIG_DIR="/etc/nixos"
BACKUP_DIR="/etc/nixos/backup-$(date +%Y%m%d-%H%M%S)"

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}    NixOS4Gaming Installer (AMD)      ${NC}"
echo -e "${BLUE}======================================${NC}"
echo

# Check if running on NixOS
if [[ ! -f /etc/NIXOS ]]; then
    echo -e "${RED}Error: This script requires NixOS${NC}"
    echo "Please run this on a NixOS system."
    exit 1
fi

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    echo -e "${RED}Error: Don't run this script as root${NC}"
    echo "Run as a regular user with sudo access."
    exit 1
fi

# Check sudo access
if ! sudo -n true 2>/dev/null; then
    echo -e "${YELLOW}This script requires sudo access. You may be prompted for your password.${NC}"
    echo
fi

echo -e "${GREEN}Step 1: Gathering system information${NC}"

# Get current user and hostname
CURRENT_USER=$(whoami)
CURRENT_HOSTNAME=$(hostname)

echo "Current user: $CURRENT_USER"
echo "Current hostname: $CURRENT_HOSTNAME"
echo

echo -e "${GREEN}Step 2: Configuration${NC}"

# Initialize variables to avoid unbound variable errors
USERNAME=""
HOSTNAME=""
KERNEL_CHOICE=""
CUSTOM_DNS=""
VIRTUALIZATION=""
DAVINCI_RESOLVE=""

read -p "Enter username for the gaming setup [detected: $CURRENT_USER]: " INPUT_USERNAME < /dev/tty
USERNAME=${INPUT_USERNAME:-$CURRENT_USER}

read -p "Enter hostname for the gaming setup [detected: $CURRENT_HOSTNAME]: " INPUT_HOSTNAME < /dev/tty
HOSTNAME=${INPUT_HOSTNAME:-$CURRENT_HOSTNAME}

echo -e "${BLUE}This installer configures NixOS for AMD GPU gaming.${NC}"

# Kernel selection
echo
echo -e "${GREEN}Kernel selection:${NC}"
echo "1) Latest NixOS kernel (faster build)"
echo "2) CachyOS kernel (gaming optimized, longer build time)"

while true; do
    read -p "Choose kernel (1-2) [default: 1]: " KERNEL_CHOICE < /dev/tty
    KERNEL_CHOICE=${KERNEL_CHOICE:-1}
    case $KERNEL_CHOICE in
        1|2) break;;
        *) echo "Please enter 1 or 2";;
    esac
done

if [[ $KERNEL_CHOICE == "2" ]]; then
    echo -e "${YELLOW}Warning: CachyOS kernel may take significantly longer to compile.${NC}"
    echo "This kernel includes gaming-specific optimizations but requires building from source."
fi

# Optional features
echo
echo -e "${GREEN}Optional features:${NC}"

read -p "Enable custom DNS configuration? (y/N): " CUSTOM_DNS < /dev/tty
CUSTOM_DNS=${CUSTOM_DNS:-n}

read -p "Enable virtualization (QEMU/KVM)? (Y/n): " VIRTUALIZATION < /dev/tty
VIRTUALIZATION=${VIRTUALIZATION:-y}

read -p "Install DaVinci Resolve? (y/N): " DAVINCI_RESOLVE < /dev/tty
DAVINCI_RESOLVE=${DAVINCI_RESOLVE:-n}

echo
echo -e "${YELLOW}Configuration Summary:${NC}"
echo "Username: $USERNAME"
echo "Hostname: $HOSTNAME"
echo "GPU: AMD Radeon"
echo "Kernel: $(if [[ $KERNEL_CHOICE == "2" ]]; then echo "CachyOS (gaming optimized)"; else echo "Latest NixOS"; fi)"
echo "Custom DNS: $(echo $CUSTOM_DNS | tr '[:lower:]' '[:upper:]')"
echo "Virtualization: $(echo $VIRTUALIZATION | tr '[:lower:]' '[:upper:]')"
echo "DaVinci Resolve: $(echo $DAVINCI_RESOLVE | tr '[:lower:]' '[:upper:]')"
echo

read -p "Continue with installation? (Y/n): " CONFIRM < /dev/tty
CONFIRM=${CONFIRM:-y}

if [[ ! $CONFIRM =~ ^[Yy]$ ]] && [[ ! -z $CONFIRM ]]; then
    echo "Installation cancelled."
    exit 0
fi

echo
echo -e "${GREEN}Step 3: Backing up existing configuration${NC}"

# Create backup directory
sudo mkdir -p "$BACKUP_DIR"

# Backup existing files
if [[ -f "$CONFIG_DIR/configuration.nix" ]]; then
    echo "Backing up configuration.nix..."
    sudo cp "$CONFIG_DIR/configuration.nix" "$BACKUP_DIR/"
fi

if [[ -f "$CONFIG_DIR/hardware-configuration.nix" ]]; then
    echo "Backing up hardware-configuration.nix..."
    sudo cp "$CONFIG_DIR/hardware-configuration.nix" "$BACKUP_DIR/"
fi

if [[ -f "$CONFIG_DIR/flake.nix" ]]; then
    echo "Backing up existing flake.nix..."
    sudo cp "$CONFIG_DIR/flake.nix" "$BACKUP_DIR/"
fi

echo "Backup created at: $BACKUP_DIR"
echo

echo -e "${GREEN}Step 4: Downloading gaming configuration${NC}"

# Use nix-shell to get git temporarily and download the config
nix-shell -p git --run "
    cd '$CONFIG_DIR'
    echo 'Cloning repository...'
    sudo git clone '$REPO_URL' temp-gaming-config
    echo 'Copying configuration files...'
    sudo cp -r temp-gaming-config/* .
    sudo rm -rf temp-gaming-config
    echo 'Repository downloaded successfully'
"

echo
echo -e "${GREEN}Step 5: Customizing configuration${NC}"

# Customize flake.nix with user settings
echo "Updating flake.nix with your settings..."
sudo sed -i "s/your-username/$USERNAME/g" "$CONFIG_DIR/flake.nix"
sudo sed -i "s/your-hostname/$HOSTNAME/g" "$CONFIG_DIR/flake.nix"

echo "Configuring for AMD Radeon graphics..."
echo "✓ Mesa drivers (including mesa-git from Chaotic Nyx)"
echo "✓ Vulkan support"  
echo "✓ Hardware acceleration"
echo "✓ Gaming optimizations"

# Configure kernel choice
if [[ $KERNEL_CHOICE == "1" ]]; then
    echo "Configuring latest NixOS kernel..."
    sudo sed -i 's|^\s*boot.kernelPackages = pkgs.linuxPackages_cachyos;|# &|' "$CONFIG_DIR/modules/gaming/gaming-optimizations.nix"
    sudo sed -i 's|^\s*# boot.kernelPackages = pkgs.linuxPackages_latest;|boot.kernelPackages = pkgs.linuxPackages_latest;|' "$CONFIG_DIR/modules/gaming/gaming-optimizations.nix"
else
    echo "Keeping CachyOS kernel (default in config)..."
fi

echo
echo -e "${GREEN}Step 6: Configuring optional features${NC}"

# Handle optional features
if [[ $CUSTOM_DNS =~ ^[Yy]$ ]]; then
    echo "Enabling custom DNS configuration..."
    sudo sed -i 's|^\s*# ./modules/network/dns.nix|./modules/network/dns.nix|' "$CONFIG_DIR/configuration.nix"
fi

if [[ $VIRTUALIZATION =~ ^[Nn]$ ]]; then
    echo "Disabling virtualization..."
    sudo sed -i 's|^\s*./modules/virtualisation/virtualisation.nix|# &|' "$CONFIG_DIR/configuration.nix"
fi

if [[ $DAVINCI_RESOLVE =~ ^[Yy]$ ]]; then
    echo "Adding DaVinci Resolve to configuration..."
    # Add DaVinci Resolve to home.nix packages
    sudo sed -i '/home.packages = with pkgs; \[/a\    davinci-resolve' "$CONFIG_DIR/home.nix"
fi

# Preserve the original hardware-configuration.nix
if [[ -f "$BACKUP_DIR/hardware-configuration.nix" ]]; then
    echo "Restoring original hardware-configuration.nix..."
    sudo cp "$BACKUP_DIR/hardware-configuration.nix" "$CONFIG_DIR/"
fi

# Copy desktop icons to user application directory
echo "Installing desktop shortcuts..."
USER_APPS_DIR="/home/$USERNAME/.local/share/applications"
sudo mkdir -p "$USER_APPS_DIR"
if [[ -f "$CONFIG_DIR/NixOS Rebuild.desktop" ]]; then
    sudo cp "$CONFIG_DIR/NixOS Rebuild.desktop" "$USER_APPS_DIR/"
    sudo chown $USERNAME:users "$USER_APPS_DIR/NixOS Rebuild.desktop"
fi
if [[ -f "$CONFIG_DIR/NixOS Update.desktop" ]]; then
    sudo cp "$CONFIG_DIR/NixOS Update.desktop" "$USER_APPS_DIR/"
    sudo chown $USERNAME:users "$USER_APPS_DIR/NixOS Update.desktop"
fi

echo
echo -e "${GREEN}Step 7: First rebuild (enabling flakes)${NC}"
echo "This may take a while as it downloads packages..."
echo

# First rebuild to enable flakes
if sudo nixos-rebuild switch; then
    echo -e "${GREEN}✓ Flakes enabled successfully${NC}"
else
    echo -e "${RED}✗ Failed to enable flakes${NC}"
    if [[ $? -eq 130 ]]; then
        echo -e "${YELLOW}Sudo authentication timed out during build.${NC}"
        echo "This is normal for long builds. Just run the installer again - it will be much faster now!"
        echo "Most packages are already downloaded and the system is partially configured."
    fi
    echo "You can also try manually: sudo nixos-rebuild switch"
    exit 1
fi

echo
echo -e "${GREEN}Step 8: Final rebuild with gaming configuration${NC}"
echo "Applying full gaming configuration..."
echo

# Final rebuild with flake
cd "$CONFIG_DIR"
if sudo nixos-rebuild switch --flake ".#$HOSTNAME"; then
    echo -e "${GREEN}✓ Gaming configuration applied successfully!${NC}"
else
    echo -e "${RED}✗ Failed to apply gaming configuration${NC}"
    if [[ $? -eq 130 ]]; then
        echo -e "${YELLOW}Sudo authentication timed out during build.${NC}"
        echo "This is normal for long builds. Just run the installer again - it will be much faster now!"
        echo "Most packages are already downloaded and the system is partially configured."
    fi
    echo "You can try manually with: sudo nixos-rebuild switch --flake .#$HOSTNAME"
    echo "Or check for errors with: sudo nixos-rebuild switch --flake .#$HOSTNAME --show-trace"
    exit 1
fi

echo
echo -e "${BLUE}======================================${NC}"
echo -e "${GREEN}    Installation Complete!            ${NC}"
echo -e "${BLUE}======================================${NC}"
echo
echo "Your NixOS gaming system is ready!"
echo
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Reboot your system to ensure all changes take effect"
echo "2. Launch Steam and log in to your account"
echo "3. Enable Proton in Steam settings for Windows game compatibility"
echo "4. Install MangoHud overlay for performance monitoring"
echo
echo -e "${YELLOW}Useful commands:${NC}"
echo "• Update system: sudo nixos-rebuild switch --flake .#$HOSTNAME"
echo "• Update packages: nix flake update && sudo nixos-rebuild switch --flake .#$HOSTNAME"  
echo "• Rollback if needed: sudo nixos-rebuild switch --rollback"
echo
echo -e "${YELLOW}Configuration files location:${NC}"
echo "• Main config: $CONFIG_DIR"
echo "• Backup: $BACKUP_DIR"
echo
echo "Happy gaming! 🎮"
