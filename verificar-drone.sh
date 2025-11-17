#!/bin/bash

# Script de Verificação do Drone CI
# Verifica problemas comuns que causam "Validation Failed"

echo "=========================================="
echo "  Verificação do Drone CI"
echo "=========================================="
echo ""

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

ERRORS=0

echo "1. Verificando arquivo .drone.yml..."
if [ -f .drone.yml ]; then
    echo -e "${GREEN}✓${NC} .drone.yml existe localmente"
    
    # Verificar estrutura básica
    if grep -q "kind: pipeline" .drone.yml && grep -q "steps:" .drone.yml; then
        echo -e "${GREEN}✓${NC} .drone.yml tem estrutura válida"
    else
        echo -e "${RED}✗${NC} .drone.yml pode ter problemas de estrutura"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo -e "${RED}✗${NC} .drone.yml NÃO existe"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "2. Verificando se .drone.yml está no Git..."
if git ls-files 2>/dev/null | grep -q .drone.yml; then
    echo -e "${GREEN}✓${NC} .drone.yml está versionado no Git"
    
    # Verificar se há mudanças não commitadas
    if git diff --quiet .drone.yml 2>/dev/null; then
        echo -e "${GREEN}✓${NC} .drone.yml está commitado (sem mudanças pendentes)"
    else
        echo -e "${YELLOW}⚠${NC} .drone.yml tem mudanças não commitadas"
        echo "  Execute: git add .drone.yml && git commit -m 'Update .drone.yml'"
    fi
else
    echo -e "${RED}✗${NC} .drone.yml NÃO está versionado no Git"
    echo -e "${YELLOW}  Solução:${NC} git add .drone.yml && git commit -m 'Add .drone.yml' && git push"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "3. Verificando containers do Drone..."
if docker ps 2>/dev/null | grep -q drone-server; then
    echo -e "${GREEN}✓${NC} drone-server está rodando"
else
    echo -e "${RED}✗${NC} drone-server NÃO está rodando"
    echo -e "${YELLOW}  Solução:${NC} cd local-execution && docker-compose up -d"
    ERRORS=$((ERRORS + 1))
fi

if docker ps 2>/dev/null | grep -q drone-runner; then
    echo -e "${GREEN}✓${NC} drone-runner está rodando"
else
    echo -e "${RED}✗${NC} drone-runner NÃO está rodando"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "4. Verificando arquivo .env..."
if [ -f local-execution/.env ]; then
    echo -e "${GREEN}✓${NC} Arquivo .env existe"
    
    # Verificar se tem as variáveis necessárias
    if grep -q "DRONE_GITHUB_CLIENT_ID" local-execution/.env && grep -q "DRONE_GITHUB_CLIENT_SECRET" local-execution/.env; then
        CLIENT_ID=$(grep "DRONE_GITHUB_CLIENT_ID" local-execution/.env | cut -d'=' -f2)
        if [ -n "$CLIENT_ID" ] && [ "$CLIENT_ID" != "seu_client_id_aqui" ]; then
            echo -e "${GREEN}✓${NC} DRONE_GITHUB_CLIENT_ID está configurado"
        else
            echo -e "${YELLOW}⚠${NC} DRONE_GITHUB_CLIENT_ID precisa ser configurado"
        fi
    else
        echo -e "${YELLOW}⚠${NC} Variáveis GitHub OAuth não encontradas no .env"
    fi
else
    echo -e "${YELLOW}⚠${NC} Arquivo .env não existe"
    echo -e "${YELLOW}  Solução:${NC} cd local-execution && cp .env.example .env && nano .env"
fi

echo ""
echo "=========================================="
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ Verificação concluída sem erros críticos${NC}"
    echo ""
    echo "Se ainda houver 'Validation Failed' na interface:"
    echo "1. Certifique-se de que fez push do .drone.yml para o GitHub"
    echo "2. Ative o repositório na interface do Drone (botão 'ACTIVATE REPOSITORY')"
    echo "3. Aguarde alguns segundos e recarregue a página"
    echo "4. Verifique os logs: cd local-execution && docker-compose logs drone-server | tail -50"
else
    echo -e "${RED}✗ Encontrados $ERRORS problema(s)${NC}"
    echo ""
    echo "Consulte o arquivo local-execution/TROUBLESHOOTING.md para soluções detalhadas"
fi
echo "=========================================="

