#!/bin/bash

# Magic Eden Monad Bot - Installation Script
# For Ubuntu/Debian and CentOS/RHEL systems

set -e

echo "🚀 Magic Eden Monad Bot - Installation Script"
echo "============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS
detect_os() {
    if [[ -f /etc/debian_version ]]; then
        OS="debian"
        print_status "Detected Debian/Ubuntu system"
    elif [[ -f /etc/redhat-release ]]; then
        OS="redhat"
        print_status "Detected RedHat/CentOS system"
    else
        print_error "Unsupported operating system"
        exit 1
    fi
}

# Install Python 3 and pip
install_python() {
    print_status "Installing Python 3 and pip..."
    
    if [[ $OS == "debian" ]]; then
        sudo apt update
        sudo apt install -y python3 python3-pip python3-venv
    elif [[ $OS == "redhat" ]]; then
        sudo yum install -y python3 python3-pip
    fi
    
    # Verify installation
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version)
        print_success "Python installed: $PYTHON_VERSION"
    else
        print_error "Failed to install Python 3"
        exit 1
    fi
}

# Install required Python packages
install_packages() {
    print_status "Installing required Python packages..."
    
    # Create virtual environment
    python3 -m venv monad_bot_env
    source monad_bot_env/bin/activate
    
    # Upgrade pip
    pip install --upgrade pip
    
    # Install required packages
    pip install requests asyncio colorama web3 python-dotenv
    
    print_success "Python packages installed successfully"
}

# Create bot directory and files
setup_bot() {
    print_status "Setting up bot directory..."
    
    # Create bot directory
    mkdir -p ~/monad_bot
    cd ~/monad_bot
    
    # Copy virtual environment
    cp -r ../monad_bot_env .
    
    # Create the main bot script (this would contain the Python code from the previous artifact)
    cat > monad_bot.py << 'EOF'
#!/usr/bin/env python3
"""
Magic Eden Monad Testnet Bot
Automated NFT purchasing bot for Linux terminal
"""

# The complete Python code would go here
# (This is a placeholder - you would paste the full Python code from the previous artifact)

print("🤖 Monad Bot is ready! Run with: python3 monad_bot.py")
EOF
    
    # Make executable
    chmod +x monad_bot.py
    
    # Create configuration template
    cat > monad_config.json << 'EOF'
{
  "wallet_address": "",
  "private_key": "",
  "max_price": 1.0,
  "target_collections": ["monad-punks", "monad-apes", "monad-creatures"],
  "buy_strategy": "floor",
  "min_delay": 2,
  "max_delay": 8,
  "auto_buy": false,
  "rpc_url": "https://testnet-rpc.monad.xyz",
  "gas_limit": 21000,
  "gas_price": 20
}
EOF
    
    # Create systemd service file
    cat > monad-bot.service << 'EOF'
[Unit]
Description=Magic Eden Monad Bot
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=/home/$USER/monad_bot
Environment=PATH=/home/$USER/monad_bot/monad_bot_env/bin
ExecStart=/home/$USER/monad_bot/monad_bot_env/bin/python /home/$USER/monad_bot/monad_bot.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
    
    # Create launcher script
    cat > start_bot.sh << 'EOF'
#!/bin/bash
cd ~/monad_bot
source monad_bot_env/bin/activate
python3 monad_bot.py "$@"
EOF
    
    chmod +x start_bot.sh
    
    print_success "Bot directory created at ~/monad_bot"
}

# Create useful aliases and shortcuts
create_shortcuts() {
    print_status "Creating command shortcuts..."
    
    # Add aliases to bashrc
    cat >> ~/.bashrc << 'EOF'

# Magic Eden Monad Bot aliases
alias monad-bot='cd ~/monad_bot && source monad_bot_env/bin/activate && python3 monad_bot.py'
alias monad-config='cd ~/monad_bot && source monad_bot_env/bin/activate && python3 monad_bot.py --config'
alias monad-stats='cd ~/monad_bot && source monad_bot_env/bin/activate && python3 monad_bot.py --stats'
alias monad-logs='cd ~/monad_bot && tail -f *.log'
EOF
    
    print_success "Command shortcuts created"
    print_status "Reload your shell or run: source ~/.bashrc"
}

# Main installation flow
main() {
    echo
    print_status "Starting installation process..."
    
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        print_error "Don't run this script as root!"
        exit 1
    fi
    
    detect_os
    install_python
    install_packages
    setup_bot
    create_shortcuts
    
    echo
    print_success "Installation completed successfully! 🎉"
    echo
    echo "Usage:"
    echo "  monad-bot                 # Start the bot"
    echo "  monad-config              # Configure settings"
    echo "  monad-stats               # View statistics"
    echo "  monad-logs                # View logs"
    echo
    echo "Next steps:"
    echo "1. Run 'monad-config' to set up your wallet"
    echo "2. Run 'monad-bot' to start trading"
    echo
    print_warning "⚠️  This bot is for TESTNET only!"
    print_warning "⚠️  Never share your private keys!"
    echo
}

# Run main function
main "$@"
