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

### Problemas Comuns

#### 1. Erro de conexão
```bash
# Verificar conectividade
ping testnet-rpc.monad.xyz

# Testar conexão do bot
monad-bot --test-connection
```

#### 2. Problemas de instalação Python
```bash
# Ubuntu/Debian
sudo apt install python3-dev python3-setuptools

# CentOS/RHEL
sudo yum install python3-devel gcc
```

#### 3. Erro de permissões
```bash
# Corrigir permissões
chmod +x ~/monad_bot/monad_bot.py
chmod +x ~/monad_bot/start_bot.sh
```

#### 4. Problemas de memória
```bash
# Verificar uso de memória
free -h
ps aux | grep python

# Limitar uso de memória
ulimit -v 524288  # 512MB
```

#### 5. Bot não encontra NFTs
- Verificar se as coleções existem na testnet
- Ajustar `max_price` para valor mais alto
- Verificar se há listings disponíveis manualmente

### Logs e Debugging

```bash
# Ver logs detalhados
tail -f ~/monad_bot/logs/bot.log

# Debug mode
monad-bot --debug

# Verificar configuração
monad-bot --validate-config
```

## 📊 Monitoramento e Logs

### Arquivos de log

```bash
# Log principal
~/monad_bot/logs/bot.log

# Log de transações
~/monad_bot/logs/transactions.log

# Log de erros
~/monad_bot/logs/errors.log

# Estatísticas
~/monad_bot/stats/session_*.json
```

### Comandos de monitoramento

```bash
# Ver logs em tempo real
tail -f ~/monad_bot/logs/bot.log

# Filtrar apenas sucessos
grep "SUCCESS" ~/monad_bot/logs/bot.log

# Ver estatísticas do dia
cat ~/monad_bot/stats/session_$(date +%Y%m%d)*.json
```

## ⚡ Otimização de Performance

### Configurações recomendadas

```json
{
  "min_delay": 1,
  "max_delay": 3,
  "max_concurrent_requests": 5,
  "timeout": 30,
  "retry_attempts": 3,
  "batch_size": 10
}
```

### Monitoramento de recursos

```bash
# CPU e memória
htop

# Uso de rede
iftop

# Processos Python
ps aux | grep python | grep monad
```

## 🔄 Backup e Recuperação

### Backup automático

```bash
# Criar script de backup
cat > ~/monad_bot/backup.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="~/monad_bot_backup_$DATE"

mkdir -p $BACKUP_DIR
cp ~/monad_bot/monad_config.json $BACKUP_DIR/
cp -r ~/monad_bot/stats/ $BACKUP_DIR/
cp -r ~/monad_bot/logs/ $BACKUP_DIR/

tar -czf "monad_bot_backup_$DATE.tar.gz" $BACKUP_DIR
rm -rf $BACKUP_DIR

echo "Backup criado: monad_bot_backup_$DATE.tar.gz"
EOF

chmod +x ~/monad_bot/backup.sh
```

### Restaurar backup

```bash
# Extrair backup
tar -xzf monad_bot_backup_YYYYMMDD_HHMMSS.tar.gz

# Restaurar configuração
cp monad_bot_backup_*/monad_config.json ~/monad_bot/
```

## 🔧 Personalização Avançada

### Webhooks e notificações

```python
# Adicionar ao arquivo monad_bot.py
import requests

def send_notification(message):
    webhook_url = "https://discord.com/api/webhooks/seu_webhook"
    data = {"content": f"🤖 Monad Bot: {message}"}
    requests.post(webhook_url, json=data)

# Usar nas compras bem-sucedidas
send_notification(f"Compra realizada: {nft_name} por {price} MON")
```

### Filtros personalizados

```python
def custom_filter(listing):
    # Exemplo: apenas NFTs com número par
    if "Punk" in listing.name:
        number = int(listing.name.split("#")[1])
        return number % 2 == 0
    return True
```

### Estratégias customizadas

```python
def custom_strategy(listings):
    # Exemplo: priorizar por raridade
    rare_listings = [l for l in listings if l.rarity == "Rare"]
    if rare_listings:
        return min(rare_listings, key=lambda x: x.price)
    return min(listings, key=lambda x: x.price)
```

## 📱 Integração com APIs

### Magic Eden API

```python
# Configurar headers da API
headers = {
    "User-Agent": "MonadBot/1.0",
    "Accept": "application/json",
    "X-API-Key": "sua_api_key"  # Se disponível
}

# Endpoints úteis
endpoints = {
    "collections": "/collections",
    "listings": "/collections/{collection}/listings",
    "stats": "/collections/{collection}/stats"
}
```

### Integração com carteiras

```python
from web3 import Web3

# Conectar à rede Monad
w3 = Web3(Web3.HTTPProvider("https://testnet-rpc.monad.xyz"))

# Verificar saldo
balance = w3.eth.get_balance(wallet_address)
balance_mon = w3.from_wei(balance, 'ether')
```

## 🎯 Casos de Uso

### 1. Colecionador
```bash
# Foco em qualidade
monad-bot --max-price 5.0 --collections monad-punks --strategy specific
```

### 2. Trader
```bash
# Volume alto, preço baixo
monad-bot --max-price 0.5 --auto-buy --strategy floor
```

### 3. Investidor
```bash
# Seletivo com raridade
monad-bot --max-price 10.0 --strategy specific --min-rarity rare
```

## 📈 Analytics e Relatórios

### Script de relatório

```bash
cat > ~/monad_bot/report.py << 'EOF'
#!/usr/bin/env python3
import json
import glob
from datetime import datetime

def generate_report():
    stats_files = glob.glob("stats/session_*.json")
    
    total_purchases = 0
    total_spent = 0
    success_rate = 0
    
    for file in stats_files:
        with open(file, 'r') as f:
            data = json.load(f)
            total_purchases += data.get('total_purchases', 0)
            total_spent += data.get('total_spent', 0)
    
    print(f"📊 Relatório Geral")
    print(f"Total de compras: {total_purchases}")
    print(f"Total gasto: {total_spent:.3f} MON")
    print(f"Média por NFT: {total_spent/total_purchases:.3f} MON" if total_purchases > 0 else "N/A")

if __name__ == "__main__":
    generate_report()
EOF

chmod +x ~/monad_bot/report.py
```

## 🚀 Atualizações

### Verificar versão

```bash
monad-bot --version
```

### Atualizar bot

```bash
# Backup antes de atualizar
~/monad_bot/backup.sh

# Download nova versão
curl -sSL https://raw.githubusercontent.com/seu-repo/monad-bot/main/monad_bot.py > ~/monad_bot/monad_bot.py

# Verificar funcionamento
monad-bot --test
```

## 📞 Suporte

### Comunidade
- **Discord**: [Link do Discord]
- **Telegram**: [Link do Telegram]
- **GitHub**: [Link do GitHub]

### Reportar bugs
1. Criar issue no GitHub
2. Incluir logs relevantes
3. Descrever passos para reproduzir

### Contribuir
1. Fork do repositório
2. Criar branch para feature
3. Submeter pull request

## ⚖️ Disclaimer

**AVISO IMPORTANTE:**

- Este bot é apenas para fins educacionais e de teste
- Use apenas na testnet do Monad
- Os desenvolvedores não se responsabilizam por perdas
- Trading de NFTs envolve riscos
- Sempre faça sua própria pesquisa (DYOR)

## 📄 Licença

MIT License - Veja arquivo LICENSE para detalhes.

---

**🎉 Bot criado com ❤️ para a comunidade Monad**

*Última atualização: $(date)*
