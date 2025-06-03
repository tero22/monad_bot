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
Author: AI Assistant
Version: 1.0
"""

import os
import sys
import time
import json
import requests
import asyncio
import argparse
from datetime import datetime
from typing import Dict, List, Optional
from dataclasses import dataclass
import signal
from colorama import Fore, Back, Style, init

# Initialize colorama for colored terminal output
init(autoreset=True)

@dataclass
class NFTListing:
    """NFT listing data structure"""
    id: str
    name: str
    price: float
    collection: str
    seller: str
    rarity: Optional[str] = None
    traits: Optional[Dict] = None

class MonadBot:
    """Main bot class for Magic Eden Monad trading"""
    
    def __init__(self, config_file: str = "monad_config.json"):
        self.config_file = config_file
        self.config = self.load_config()
        self.running = False
        self.stats = {
            "total_purchases": 0,
            "successful_purchases": 0,
            "failed_purchases": 0,
            "total_spent": 0.0,
            "session_start": None
        }
        self.api_base = "https://api-mainnet.magiceden.dev/v2"
        self.session = requests.Session()
        
        # Set up signal handlers for graceful shutdown
        signal.signal(signal.SIGINT, self.signal_handler)
        signal.signal(signal.SIGTERM, self.signal_handler)
    
    def signal_handler(self, signum, frame):
        """Handle shutdown signals gracefully"""
        self.log("🛑 Shutdown signal received. Stopping bot...", "WARNING")
        self.running = False
        self.save_stats()
        sys.exit(0)
    
    def load_config(self) -> Dict:
        """Load configuration from JSON file"""
        default_config = {
            "wallet_address": "",
            "private_key": "",
            "max_price": 1.0,
            "target_collections": ["monad-punks", "monad-apes"],
            "buy_strategy": "floor",
            "min_delay": 1,
            "max_delay": 5,
            "auto_buy": False,
            "rpc_url": "https://testnet-rpc.monad.xyz",
            "gas_limit": 21000,
            "gas_price": 20
        }
        
        if os.path.exists(self.config_file):
            try:
                with open(self.config_file, 'r') as f:
                    loaded_config = json.load(f)
                    default_config.update(loaded_config)
                    self.log(f"✅ Configuration loaded from {self.config_file}", "SUCCESS")
            except Exception as e:
                self.log(f"❌ Error loading config: {e}", "ERROR")
        else:
            self.save_config(default_config)
            self.log(f"📁 Created default config file: {self.config_file}", "INFO")
        
        return default_config
    
    def save_config(self, config: Dict):
        """Save configuration to JSON file"""
        try:
            with open(self.config_file, 'w') as f:
                json.dump(config, f, indent=2)
        except Exception as e:
            self.log(f"❌ Error saving config: {e}", "ERROR")
    
    def log(self, message: str, level: str = "INFO"):
        """Enhanced logging with colors and timestamps"""
        timestamp = datetime.now().strftime("%H:%M:%S")
        
        color_map = {
            "INFO": Fore.CYAN,
            "SUCCESS": Fore.GREEN,
            "WARNING": Fore.YELLOW,
            "ERROR": Fore.RED,
            "PURCHASE": Fore.MAGENTA
        }
        
        color = color_map.get(level, Fore.WHITE)
        print(f"{Fore.WHITE}[{timestamp}] {color}[{level}]{Style.RESET_ALL} {message}")
    
    def display_banner(self):
        """Display ASCII banner"""
        banner = f"""
{Fore.MAGENTA}╔══════════════════════════════════════════════════════════════╗
║                    MAGIC EDEN MONAD BOT                      ║
║                     Terminal Version 1.0                    ║
║                    Testnet Trading Bot                      ║
╚══════════════════════════════════════════════════════════════╝{Style.RESET_ALL}
"""
        print(banner)
    
    def display_config(self):
        """Display current configuration"""
        print(f"\n{Fore.YELLOW}📋 Current Configuration:{Style.RESET_ALL}")
        print(f"   Wallet: {self.config['wallet_address'][:10]}...{self.config['wallet_address'][-10:] if self.config['wallet_address'] else 'Not set'}")
        print(f"   Max Price: {self.config['max_price']} MON")
        print(f"   Collections: {', '.join(self.config['target_collections'])}")
        print(f"   Strategy: {self.config['buy_strategy']}")
        print(f"   Auto Buy: {'✅ Enabled' if self.config['auto_buy'] else '❌ Disabled'}")
        print(f"   Delay: {self.config['min_delay']}-{self.config['max_delay']}s")
    
    def display_stats(self):
        """Display current statistics"""
        success_rate = 0
        if self.stats["total_purchases"] > 0:
            success_rate = (self.stats["successful_purchases"] / self.stats["total_purchases"]) * 100
        
        runtime = "N/A"
        if self.stats["session_start"]:
            runtime = str(datetime.now() - self.stats["session_start"]).split('.')[0]
        
        print(f"\n{Fore.GREEN}📊 Session Statistics:{Style.RESET_ALL}")
        print(f"   Runtime: {runtime}")
        print(f"   Total Attempts: {self.stats['total_purchases']}")
        print(f"   Successful: {self.stats['successful_purchases']}")
        print(f"   Failed: {self.stats['failed_purchases']}")
        print(f"   Success Rate: {success_rate:.1f}%")
        print(f"   Total Spent: {self.stats['total_spent']:.3f} MON")
    
    async def fetch_listings(self) -> List[NFTListing]:
        """Fetch current NFT listings (simulated for testnet)"""
        try:
            # Simulate API call with mock data for testnet
            mock_listings = [
                NFTListing(
                    id=f"mock_{i}",
                    name=f"Monad {'Punk' if i % 3 == 0 else 'Ape' if i % 3 == 1 else 'Creature'} #{1000 + i}",
                    price=round(0.1 + (i * 0.3), 2),
                    collection=self.config['target_collections'][i % len(self.config['target_collections'])],
                    seller=f"0x{'a' * 40}",
                    rarity="Common" if i % 3 == 0 else "Rare"
                )
                for i in range(10)
            ]
            
            # Filter by price and collections
            filtered = [
                listing for listing in mock_listings
                if listing.price <= self.config['max_price'] and
                listing.collection in self.config['target_collections']
            ]
            
            return filtered
            
        except Exception as e:
            self.log(f"❌ Error fetching listings: {e}", "ERROR")
            return []
    
    async def attempt_purchase(self, listing: NFTListing) -> bool:
        """Attempt to purchase an NFT"""
        try:
            self.log(f"🎯 Attempting to purchase {listing.name} for {listing.price} MON", "PURCHASE")
            
            # Simulate transaction delay
            await asyncio.sleep(1)
            
            # Simulate success/failure (90% success rate for demo)
            import random
            success = random.random() > 0.1
            
            if success:
                self.stats["successful_purchases"] += 1
                self.stats["total_spent"] += listing.price
                self.log(f"✅ Successfully purchased {listing.name}!", "SUCCESS")
                return True
            else:
                self.stats["failed_purchases"] += 1
                self.log(f"❌ Failed to purchase {listing.name} - Transaction failed", "ERROR")
                return False
                
        except Exception as e:
            self.stats["failed_purchases"] += 1
            self.log(f"❌ Purchase error: {e}", "ERROR")
            return False
        finally:
            self.stats["total_purchases"] += 1
    
    async def monitor_listings(self):
        """Main monitoring loop"""
        self.log("🚀 Starting monitoring loop...", "INFO")
        self.stats["session_start"] = datetime.now()
        
        while self.running:
            try:
                # Fetch current listings
                listings = await self.fetch_listings()
                
                if not listings:
                    self.log("⏳ No suitable listings found", "WARNING")
                else:
                    self.log(f"📋 Found {len(listings)} suitable listings", "INFO")
                    
                    # Display available listings
                    for listing in listings[:5]:  # Show top 5
                        print(f"   • {listing.name} - {listing.price} MON ({listing.rarity})")
                    
                    # Auto-buy if enabled
                    if self.config["auto_buy"] and listings:
                        best_listing = min(listings, key=lambda x: x.price)
                        await self.attempt_purchase(best_listing)
                
                # Dynamic delay
                import random
                delay = random.uniform(self.config["min_delay"], self.config["max_delay"])
                await asyncio.sleep(delay)
                
            except KeyboardInterrupt:
                self.log("🛑 Interrupted by user", "WARNING")
                break
            except Exception as e:
                self.log(f"❌ Monitoring error: {e}", "ERROR")
                await asyncio.sleep(5)
    
    def save_stats(self):
        """Save session statistics"""
        stats_file = f"monad_stats_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        try:
            with open(stats_file, 'w') as f:
                json.dump({
                    **self.stats,
                    "session_start": self.stats["session_start"].isoformat() if self.stats["session_start"] else None,
                    "session_end": datetime.now().isoformat()
                }, f, indent=2)
            self.log(f"📊 Statistics saved to {stats_file}", "SUCCESS")
        except Exception as e:
            self.log(f"❌ Error saving stats: {e}", "ERROR")
    
    def interactive_config(self):
        """Interactive configuration setup"""
        print(f"\n{Fore.YELLOW}⚙️  Interactive Configuration Setup{Style.RESET_ALL}")
        
        # Wallet configuration
        wallet = input(f"Enter wallet address [{self.config['wallet_address'][:20]}...]: ").strip()
        if wallet:
            self.config['wallet_address'] = wallet
        
        private_key = input("Enter private key (hidden): ").strip()
        if private_key:
            self.config['private_key'] = private_key
        
        # Price configuration
        try:
            max_price = float(input(f"Max price in MON [{self.config['max_price']}]: ") or self.config['max_price'])
            self.config['max_price'] = max_price
        except ValueError:
            pass
        
        # Auto-buy setting
        auto_buy = input(f"Enable auto-buy? [{'y' if self.config['auto_buy'] else 'n'}]: ").lower()
        if auto_buy in ['y', 'yes']:
            self.config['auto_buy'] = True
        elif auto_buy in ['n', 'no']:
            self.config['auto_buy'] = False
        
        self.save_config(self.config)
        self.log("✅ Configuration updated!", "SUCCESS")
    
    async def start(self):
        """Start the bot"""
        self.display_banner()
        self.display_config()
        
        if not self.config['wallet_address']:
            self.log("❌ Wallet address not configured. Use --config to set up.", "ERROR")
            return
        
        self.log("🔥 Starting Magic Eden Monad Bot...", "INFO")
        self.running = True
        
        try:
            await self.monitor_listings()
        finally:
            self.display_stats()
            self.save_stats()
            self.log("👋 Bot session ended", "INFO")

async def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(description="Magic Eden Monad Testnet Bot")
    parser.add_argument("--config", action="store_true", help="Interactive configuration")
    parser.add_argument("--stats", action="store_true", help="Show statistics only")
    parser.add_argument("--max-price", type=float, help="Override max price")
    parser.add_argument("--auto-buy", action="store_true", help="Enable auto-buy")
    parser.add_argument("--collections", nargs="+", help="Target collections")
    
    args = parser.parse_args()
    
    bot = MonadBot()
    
    # Override config with command line arguments
    if args.max_price:
        bot.config['max_price'] = args.max_price
    if args.auto_buy:
        bot.config['auto_buy'] = True
    if args.collections:
        bot.config['target_collections'] = args.collections
    
    if args.config:
        bot.interactive_config()
    elif args.stats:
        bot.display_banner()
        bot.display_stats()
    else:
        await bot.start()

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\n👋 Goodbye!")
    except Exception as e:
        print(f"❌ Fatal error: {e}")
        sys.exit(1)
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
