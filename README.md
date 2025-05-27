# 🤖 Magic Eden Monad Bot - Terminal Linux

Bot automatizado para comprar NFTs no Magic Eden Monad Testnet via terminal Linux.

## 🚀 Instalação Rápida

```bash
# 1. Baixar e executar o script de instalação
curl -sSL https://raw.githubusercontent.com/tero22/monad-bot/main/install.sh | bash

# 2. Recarregar o shell
source ~/.bashrc

# 3. Configurar o bot
monad-config
```

## 📋 Pré-requisitos

- **SO**: Ubuntu 18.04+, Debian 10+, CentOS 7+, ou similar
- **Python**: 3.7 ou superior
- **Memória**: Mínimo 512MB disponível
- **Conexão**: Internet estável
- **Wallet**: Endereço e chave privada da Monad Testnet

## 🔧 Instalação Manual

### 1. Instalar dependências

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install python3 python3-pip python3-venv git

# CentOS/RHEL
sudo yum install python3 python3-pip git
```

### 2. Clonar e configurar

```bash
# Criar diretório
mkdir ~/monad_bot && cd ~/monad_bot

# Criar ambiente virtual
python3 -m venv monad_bot_env
source monad_bot_env/bin/activate

# Instalar pacotes
pip install requests asyncio colorama web3 python-dotenv

# Baixar o bot (substitua pelo código Python do artifact anterior)
# Cole o código Python completo em monad_bot.py
```

### 3. Configurar

```bash
# Executar configuração interativa
python3 monad_bot.py --config
```

## ⚙️ Configuração

### Arquivo de configuração (monad_config.json)

```json
{
  "wallet_address": "0xSeuEnderecoAqui",
  "private_key": "SuaChavePrivadaAqui",
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
```

### Parâmetros explicados

- **wallet_address**: Seu endereço de wallet Monad
- **private_key**: Chave privada (APENAS TESTNET!)
- **max_price**: Preço máximo em MON para comprar
- **target_collections**: Coleções alvo para monitorar
- **buy_strategy**: Estratégia de compra (`floor`, `specific`, `bulk`, `snipe`)
- **auto_buy**: Comprar automaticamente quando encontrar
- **min_delay/max_delay**: Intervalo entre verificações (segundos)

## 🎯 Como Usar

### Comandos básicos

```bash
# Iniciar o bot
monad-bot

# Configurar settings
monad-config

# Ver estatísticas
monad-stats

# Ver logs em tempo real
monad-logs

# Ajuda
monad-bot --help
```

### Opções de linha de comando

```bash
# Definir preço máximo
monad-bot --max-price 0.5

# Ativar compra automática
monad-bot --auto-buy

# Especificar coleções
monad-bot --collections monad-punks monad-apes

# Configuração completa
monad-bot --max-price 1.0 --auto-buy --collections monad-punks
```

## 📊 Interface do Terminal

### Exemplo de saída

```
╔══════════════════════════════════════════════════════════════╗
║                    MAGIC EDEN MONAD BOT                      ║
║                     Terminal Version 1.0                    ║
║                    Testnet Trading Bot                      ║
╚══════════════════════════════════════════════════════════════╝

📋 Current Configuration:
   Wallet: 0x1234567890...0987654321
   Max Price: 1.0 MON
   Collections: monad-punks, monad-apes
   Strategy: floor
   Auto Buy: ✅ Enabled
   Delay: 2-8s

[14:30:15] [INFO] 🚀 Starting monitoring loop...
[14:30:16] [INFO] 📋 Found 3 suitable listings
   • Monad Punk #1337 - 0.8 MON (Rare)
   • Monad Ape #420 - 1.0 MON (Common)
   • Monad Creature #69 - 0.5 MON (Rare)
[14:30:17] [PURCHASE] 🎯 Attempting to purchase Monad Creature #69 for 0.5 MON
[14:30:18] [SUCCESS] ✅ Successfully purchased Monad Creature #69!

📊 Session Statistics:
   Runtime: 0:05:42
   Total Attempts: 12
   Successful: 8
   Failed: 4
   Success Rate: 66.7%
   Total Spent: 4.200 MON
```

## 🔄 Execução como Serviço

### Systemd (recomendado)

```bash
# Criar arquivo de serviço
sudo nano /etc/systemd/system/monad-bot.service

# Conteúdo do arquivo:
[Unit]
Description=Magic Eden Monad Bot
After=network.target

[Service]
Type=simple
User=seu_usuario
WorkingDirectory=/home/seu_usuario/monad_bot
Environment=PATH=/home/seu_usuario/monad_bot/monad_bot_env/bin
ExecStart=/home/seu_usuario/monad_bot/monad_bot_env/bin/python /home/seu_usuario/monad_bot/monad_bot.py --auto-buy
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target

# Ativar serviço
sudo systemctl daemon-reload
sudo systemctl enable monad-bot
sudo systemctl start monad-bot

# Verificar status
sudo systemctl status monad-bot
```

### Screen/Tmux (alternativa)

```bash
# Usando screen
screen -S monad-bot
monad-bot --auto-buy
# Ctrl+A+D para desanexar

# Usando tmux
tmux new-session -s monad-bot
monad-bot --auto-buy
# Ctrl+B+D para desanexar
```

## 📁 Estrutura de Arquivos

```
~/monad_bot/
├── monad_bot.py          # Script principal
├── monad_config.json     # Configuração
├── monad_bot_env/        # Ambiente virtual Python
├── start_bot.sh          # Script de inicialização
├── monad-bot.service     # Arquivo systemd
├── logs/                 # Logs do bot
└── stats/                # Estatísticas salvas
```

## 📈 Estratégias de Compra

### 1. Floor Price (`floor`)
- Compra NFTs pelo menor preço disponível
- Ideal para acumular volume

### 2. Specific Traits (`specific`)
- Foca em características específicas
- Maior seletividade

### 3. Bulk Purchase (`bulk`)
- Compra múltiplos NFTs de uma vez
- Eficiente para grandes volumes

### 4. Snipe Listings (`snipe`)
- Compra imediatamente quando aparecem
- Maior velocidade de execução

## 🛡️ Segurança

### ⚠️ IMPORTANTE - APENAS TESTNET

- **NUNCA** use este bot em mainnet
- **NUNCA** compartilhe suas chaves privadas
- Use apenas endereços de teste
- Mantenha suas chaves seguras

### Medidas de segurança

```bash
# Permissões restritas no arquivo de config
chmod 600 monad_config.json

# Criptografar chave privada (opcional)
echo "sua_chave_privada" | gpg --symmetric --armor > private_key.gpg
```

## 🚨 Solução de Problemas

###
