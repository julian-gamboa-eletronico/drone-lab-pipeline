# Execução Local do Drone CI

## ⚠️ ESSENCIAL: Este Diretório é OBRIGATÓRIO

Este diretório contém o arquivo `docker-compose.yml` que é **ESSENCIAL** e **OBRIGATÓRIO** para executar o Drone CI localmente.

**SEM este arquivo, o Drone CI NÃO funcionará!**

## O que este docker-compose.yml faz?

O arquivo `docker-compose.yml` configura toda a infraestrutura necessária do Drone CI:

1. **drone-server** - Servidor principal que:
   - Fornece a interface web (http://localhost:8080)
   - Gerencia pipelines e builds
   - Processa webhooks do GitHub/GitLab
   - Armazena dados de execuções

2. **drone-runner** - Executor que:
   - Recebe tarefas do server
   - Executa os pipelines em containers Docker
   - Gerencia o ciclo de vida dos containers
   - Reporta resultados de volta ao server

## Como usar

### 0. ⚠️ Configurar Variáveis de Ambiente (OBRIGATÓRIO)

**IMPORTANTE**: Antes de iniciar, você precisa criar o arquivo `.env` com suas credenciais:

```bash
cd local-execution

# Copiar o template
cp .env.example .env

# Editar o arquivo .env com suas credenciais reais
nano .env  # ou use seu editor preferido
```

**Preencha especialmente:**
- `DRONE_GITHUB_CLIENT_ID` - Seu Client ID do GitHub OAuth
- `DRONE_GITHUB_CLIENT_SECRET` - Seu Client Secret do GitHub OAuth

**⚠️ SEGURANÇA**: O arquivo `.env` está no `.gitignore` e NÃO será commitado. 
Nunca commite credenciais no repositório!

### 1. Iniciar o ambiente

```bash
cd local-execution
docker-compose up -d
```

Isso irá iniciar:
- ✅ drone-server na porta 8080
- ✅ drone-runner conectado ao server

### 2. Verificar se está rodando

```bash
docker-compose ps
```

Você deve ver ambos os containers com status "Up".

### 3. Acessar a interface web

Abra seu navegador em: **http://localhost:8080**

### 4. Parar o ambiente

```bash
docker-compose down
```

Para remover também os volumes (dados):

```bash
docker-compose down -v
```

## Verificação Rápida

Execute para verificar se tudo está funcionando:

```bash
# Verificar containers
docker-compose ps

# Ver logs do server
docker-compose logs drone-server

# Ver logs do runner
docker-compose logs drone-runner
```

## Importante

- ⚠️ O `docker-compose.yml` **DEVE** estar presente para o Drone CI funcionar
- ⚠️ **OBRIGATÓRIO**: Crie o arquivo `.env` baseado no `.env.example` antes de iniciar
- ⚠️ **NUNCA** commite o arquivo `.env` - ele contém credenciais sensíveis
- ⚠️ O runner precisa acessar o Docker socket (`/var/run/docker.sock`)
- ⚠️ O `DRONE_RPC_SECRET` deve ser o mesmo em server e runner
- ⚠️ Certifique-se de que as imagens `drone/drone:2` e `drone/drone-runner-docker:1` estão disponíveis

## Troubleshooting

### ⚠️ Erro: "Validation Failed" na página de Settings

Este é um problema comum! Consulte o guia completo em [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md).

**Solução rápida**:
1. Certifique-se de que o arquivo `.drone.yml` está commitado e pushado para o GitHub:
   ```bash
   git add .drone.yml
   git commit -m "Add Drone CI configuration"
   git push
   ```
2. Na interface do Drone, clique em "ACTIVATE REPOSITORY"
3. Aguarde alguns segundos e recarregue a página

**Verificação rápida**:
```bash
# Na raiz do projeto
./verificar-drone.sh
```

### Runner não conecta ao server

Verifique se:
- O `DRONE_RPC_SECRET` é o mesmo em ambos os serviços
- O `DRONE_RPC_HOST` aponta para `drone-server`
- Ambos os containers estão rodando: `docker-compose ps`

### Runner não executa pipelines

Verifique se:
- O volume `/var/run/docker.sock` está montado corretamente
- Você tem permissão para acessar o Docker socket
- O Docker está rodando no host

### Erro de permissão

```bash
# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER
# Fazer logout e login novamente
```

## Estrutura

```
local-execution/
├── docker-compose.yml  ← ESSENCIAL: Arquivo de configuração
├── .env.example       ← Template de variáveis de ambiente
├── .env               ← Arquivo de credenciais (NÃO commitar - criar manualmente)
├── drone-data/        ← Dados persistentes (criado automaticamente)
└── README.md          ← Este arquivo
```

## 🔐 Segurança

### Por que usar .env?

O arquivo `docker-compose.yml` agora usa variáveis de ambiente do arquivo `.env` para:
- ✅ **Proteger credenciais**: Credenciais não ficam no código versionado
- ✅ **Facilidade**: Cada desenvolvedor pode ter suas próprias credenciais
- ✅ **Segurança**: O arquivo `.env` está no `.gitignore` e nunca será commitado

### Como obter credenciais do GitHub OAuth?

1. Acesse: https://github.com/settings/developers
2. Clique em "New OAuth App"
3. Preencha:
   - **Application name**: Drone CI (ou qualquer nome)
   - **Homepage URL**: `http://localhost:8080`
   - **Authorization callback URL**: `http://localhost:8080/login`
4. Clique em "Register application"
5. Copie o **Client ID**
6. Clique em "Generate a new client secret" e copie o **Client Secret**
7. Cole esses valores no arquivo `.env`

