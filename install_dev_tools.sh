#!/bin/bash

set -e

echo "🔍 Checking and installing DevOps tools..."

# 1. Docker
if ! command -v docker &> /dev/null; then
    echo "🚀 Installing Docker..."
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg
    sudo add-apt-repository \
       "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) stable"
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker "$USER"
else
    echo "✅ Docker is already installed."
fi

# 2. Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "🚀 Installing Docker Compose..."
    DOCKER_COMPOSE_VERSION="1.29.2"
    sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
else
    echo "✅ Docker Compose is already installed."
fi

# 3. Python
PYTHON_VERSION=$(python3 -V 2>&1 | awk '{print $2}')
REQUIRED_PYTHON_VERSION="3.9"
if [[ "$(printf '%s\n' "$REQUIRED_PYTHON_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" != "$REQUIRED_PYTHON_VERSION" ]]; then
    echo "🚀 Installing Python 3.9+..."
    sudo apt update
    sudo apt install -y python3 python3-pip
else
    echo "✅ Python $PYTHON_VERSION is already installed."
fi

# 4. Django
if ! python3 -m django --version &> /dev/null; then
    echo "🚀 Installing Django via pip..."
    pip3 install --user django
else
    echo "✅ Django is already installed."
fi

echo "✅ All tools are installed and ready to use."
echo "⚠️ You might need to restart your terminal or log out/in to use Docker without sudo."