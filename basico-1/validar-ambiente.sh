#!/bin/bash

# Script de Validação do Ambiente - Laboratório Drone CI
# Execute este script antes da aula para verificar se tudo está pronto

echo "=========================================="
echo "  Validação do Ambiente - Drone CI Lab"
echo "=========================================="
echo ""

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Contador de erros
ERRORS=0

# Função para verificar comando
check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 está instalado"
        return 0
    else
        echo -e "${RED}✗${NC} $1 NÃO está instalado"
        return 1
    fi
}

# Função para verificar imagem Docker
check_docker_image() {
    if docker images | grep -q "$1"; then
        echo -e "${GREEN}✓${NC} Imagem Docker '$1' encontrada"
        return 0
    else
        echo -e "${RED}✗${NC} Imagem Docker '$1' NÃO encontrada"
        return 1
    fi
}

# Função para verificar arquivo
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} Arquivo '$1' existe"
        return 0
    else
        echo -e "${RED}✗${NC} Arquivo '$1' NÃO existe"
        return 1
    fi
}

# Função para verificar diretório
check_directory() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} Diretório '$1' existe"
        return 0
    else
        echo -e "${RED}✗${NC} Diretório '$1' NÃO existe"
        return 1
    fi
}

echo "1. Verificando Docker..."
if ! check_command docker; then
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "2. Verificando se Docker está rodando..."
if docker ps &> /dev/null; then
    echo -e "${GREEN}✓${NC} Docker está rodando"
else
    echo -e "${RED}✗${NC} Docker NÃO está rodando"
    echo -e "${YELLOW}  Dica:${NC} Execute 'sudo systemctl start docker'"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "3. Verificando permissões do Docker..."
if docker ps &> /dev/null; then
    echo -e "${GREEN}✓${NC} Você tem permissão para usar Docker"
else
    echo -e "${RED}✗${NC} Você NÃO tem permissão para usar Docker"
    echo -e "${YELLOW}  Dica:${NC} Execute 'sudo usermod -aG docker \$USER' e faça logout/login"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "4. Verificando imagens Docker necessárias..."
if ! check_docker_image "playwright-clicks"; then
    ERRORS=$((ERRORS + 1))
fi
if ! check_docker_image "drone/drone.*2"; then
    ERRORS=$((ERRORS + 1))
fi
if ! check_docker_image "drone-runner-docker.*1"; then
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "5. Verificando estrutura do projeto..."
if ! check_file "../.drone.yml"; then
    ERRORS=$((ERRORS + 1))
fi
if ! check_directory "."; then
    ERRORS=$((ERRORS + 1))
fi
if ! check_file "README.md"; then
    ERRORS=$((ERRORS + 1))
fi
if ! check_file "PREPARACAO.md"; then
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "6. Verificando conteúdo do .drone.yml..."
if grep -q "playwright-clicks:latest" ../.drone.yml 2>/dev/null; then
    echo -e "${GREEN}✓${NC} .drone.yml está usando a imagem correta (playwright-clicks:latest)"
else
    echo -e "${RED}✗${NC} .drone.yml NÃO está usando a imagem correta"
    echo -e "${YELLOW}  Esperado:${NC} playwright-clicks:latest"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "7. Testando imagem playwright-clicks..."
if docker run --rm playwright-clicks:latest npx playwright --version &> /dev/null; then
    VERSION=$(docker run --rm playwright-clicks:latest npx playwright --version 2>/dev/null | head -n1)
    echo -e "${GREEN}✓${NC} Imagem playwright-clicks funciona corretamente ($VERSION)"
else
    echo -e "${RED}✗${NC} Imagem playwright-clicks NÃO está funcionando"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "=========================================="
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ Ambiente está PRONTO para a aula!${NC}"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Ambiente NÃO está pronto. Encontrados $ERRORS problema(s).${NC}"
    echo ""
    echo -e "${YELLOW}Consulte o arquivo PREPARACAO.md para mais detalhes sobre como resolver os problemas.${NC}"
    echo ""
    exit 1
fi

