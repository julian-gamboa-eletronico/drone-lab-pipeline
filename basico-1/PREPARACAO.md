# Preparação Pré-Aula - Laboratório Drone CI

Este guia deve ser seguido **antes** da aula para garantir que o ambiente esteja pronto e não percamos tempo com configurações durante o laboratório.

## ✅ Checklist de Preparação

### 1. Verificar Imagens Docker Disponíveis

Execute o comando para verificar se todas as imagens necessárias estão disponíveis:

```bash
docker images
```

Você deve ver as seguintes imagens:

```
REPOSITORY                  TAG       IMAGE ID       CREATED        SIZE
playwright-clicks           latest    [ID]           [DATA]         [TAMANHO]
drone/drone                 2         [ID]           [DATA]         [TAMANHO]
drone/drone-runner-docker   1         [ID]           [DATA]         [TAMANHO]
```

### 2. Verificar Docker em Execução

Certifique-se de que o Docker está rodando:

```bash
docker ps
```

Se o Docker não estiver rodando, inicie-o:

```bash
sudo systemctl start docker
# ou
sudo service docker start
```

### 3. Verificar Acesso ao Docker Socket

O Drone Runner precisa acessar o Docker socket. Verifique as permissões:

```bash
ls -la /var/run/docker.sock
```

Se necessário, adicione seu usuário ao grupo docker:

```bash
sudo usermod -aG docker $USER
# Faça logout e login novamente para aplicar as mudanças
```

### 4. Testar a Imagem Playwright

Teste se a imagem `playwright-clicks:latest` está funcionando corretamente:

```bash
docker run --rm playwright-clicks:latest npx playwright --version
```

Você deve ver a versão do Playwright instalada.

### 5. Verificar Estrutura do Projeto

Certifique-se de que o projeto está estruturado corretamente:

```bash
cd /home/julian/NOVEMBRO-testes/drone-lab-pipeline
ls -la
```

Você deve ver:
- `.drone.yml` (arquivo de configuração do pipeline)
- `basico-1/` (pasta com a documentação)
- `README.md`

### 6. Verificar Conteúdo do .drone.yml

Confirme que o arquivo `.drone.yml` está usando a imagem correta:

```bash
cat .drone.yml
```

A imagem deve ser `playwright-clicks:latest`, não `mcr.microsoft.com/playwright:v1.44.0-jammy`.

## 🚀 Início Rápido (Para Teste)

Se quiser testar o pipeline localmente antes da aula:

### Opção 1: Usando Drone CLI (se instalado)

```bash
# Verificar se o drone CLI está instalado
drone --version

# Executar o pipeline localmente
drone exec
```

### Opção 2: Simular o Step Manualmente

Você pode simular o que o pipeline fará executando manualmente:

```bash
# Criar um diretório temporário
mkdir -p /tmp/drone-test
cd /tmp/drone-test

# Executar os comandos do pipeline
docker run --rm -v $(pwd):/workspace -w /workspace \
  playwright-clicks:latest \
  sh -c "npm install && npx playwright test"
```

## ⚠️ Problemas Comuns

### Imagem não encontrada

Se receber erro `Error: image not found`:

```bash
# Verificar se a imagem existe
docker images | grep playwright-clicks

# Se não existir, você precisará importá-la ou construí-la
```

### Permissão negada no Docker

Se receber erro de permissão:

```bash
# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER

# Fazer logout e login novamente
# Ou usar sudo (não recomendado para produção)
```

### Docker não está rodando

```bash
# Verificar status
sudo systemctl status docker

# Iniciar Docker
sudo systemctl start docker

# Habilitar para iniciar automaticamente
sudo systemctl enable docker
```

## 📝 Notas para o Instrutor

- **Tempo estimado de preparação**: 5-10 minutos
- **Dependências críticas**: Docker instalado e rodando
- **Imagens necessárias**: playwright-clicks:latest, drone/drone:2, drone/drone-runner-docker:1
- **Verificação rápida**: Executar `docker images` e `docker ps` antes de começar

## ✅ Validação Final

### Opção 1: Script Automatizado (Recomendado)

Execute o script de validação que verifica tudo automaticamente:

```bash
cd basico-1
./validar-ambiente.sh
```

O script irá verificar:
- ✅ Docker instalado e rodando
- ✅ Permissões do Docker
- ✅ Todas as imagens necessárias
- ✅ Estrutura do projeto
- ✅ Configuração do .drone.yml
- ✅ Funcionamento da imagem playwright-clicks

### Opção 2: Validação Manual

Se preferir validar manualmente, execute:

```bash
echo "=== Verificando Docker ===" && \
docker ps > /dev/null && echo "✓ Docker está rodando" || echo "✗ Docker não está rodando" && \
echo "" && \
echo "=== Verificando Imagens ===" && \
docker images | grep -q "playwright-clicks" && echo "✓ playwright-clicks encontrada" || echo "✗ playwright-clicks não encontrada" && \
docker images | grep -q "drone/drone" && echo "✓ drone/drone encontrada" || echo "✗ drone/drone não encontrada" && \
docker images | grep -q "drone-runner-docker" && echo "✓ drone-runner-docker encontrada" || echo "✗ drone-runner-docker não encontrada" && \
echo "" && \
echo "=== Verificando Arquivos ===" && \
test -f .drone.yml && echo "✓ .drone.yml existe" || echo "✗ .drone.yml não existe" && \
test -d basico-1 && echo "✓ basico-1/ existe" || echo "✗ basico-1/ não existe"
```

Se todos os itens mostrarem ✓, o ambiente está pronto!

