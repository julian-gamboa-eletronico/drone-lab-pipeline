# Troubleshooting - Problemas Comuns do Drone CI

## ⚠️ Erro: "Validation Failed" na Página de Settings

### Sintomas

- Ao acessar `http://localhost:8080/[usuario]/[repositorio]/settings`
- Aparece um alerta vermelho com "Validation Failed"
- O repositório aparece como "not Active"

### Causas Comuns

#### 1. Arquivo `.drone.yml` não está no repositório GitHub

**Problema**: O Drone CI precisa que o arquivo `.drone.yml` esteja commitado e pushado para o repositório GitHub.

**Solução**:
```bash
# Verificar se o arquivo existe localmente
ls -la .drone.yml

# Verificar se está commitado
git status

# Se não estiver commitado, fazer commit e push
git add .drone.yml
git commit -m "Add Drone CI pipeline configuration"
git push origin main  # ou git push origin master
```

#### 2. Arquivo `.drone.yml` está em branch diferente

**Problema**: O arquivo `.drone.yml` precisa estar na branch padrão (main/master) ou na branch que você está visualizando.

**Solução**:
```bash
# Verificar em qual branch você está
git branch

# Verificar se o arquivo existe na branch atual
git ls-files | grep .drone.yml

# Se não existir, fazer merge ou criar na branch correta
git checkout main
git merge sua-branch
# ou
git checkout sua-branch
git checkout main -- .drone.yml
git commit -m "Add .drone.yml to branch"
git push
```

#### 3. Sintaxe inválida no `.drone.yml`

**Problema**: O arquivo `.drone.yml` pode ter erros de sintaxe YAML.

**Solução**:
```bash
# Validar sintaxe YAML (se tiver yamllint instalado)
yamllint .drone.yml

# Ou usar um validador online: https://www.yamllint.com/

# Verificar estrutura básica:
# - Deve começar com "kind: pipeline"
# - Deve ter "type: docker"
# - Deve ter "steps:" com pelo menos um step
```

#### 4. Webhook do GitHub não configurado ou com erro

**Problema**: O Drone CI precisa receber webhooks do GitHub para funcionar.

**Solução**:
1. Acesse: https://github.com/[seu-usuario]/[seu-repositorio]/settings/hooks
2. Verifique se há um webhook apontando para `http://localhost:8080/hook`
3. Se não houver, o Drone deve criar automaticamente quando você ativar o repositório
4. Se houver erro, verifique:
   - URL do webhook está correta
   - Content type está como `application/json`
   - Secret está configurado (se necessário)

#### 5. Repositório não sincronizado

**Problema**: O Drone pode não ter sincronizado com o GitHub recentemente.

**Solução**:
1. Na interface do Drone, vá para a lista de repositórios
2. Clique no botão de sincronização (ícone de refresh)
3. Ou faça logout e login novamente

#### 6. Permissões insuficientes no GitHub

**Problema**: Sua conta do GitHub pode não ter permissão para acessar o repositório.

**Solução**:
1. Verifique se você tem acesso ao repositório no GitHub
2. Verifique se o OAuth App do Drone tem as permissões corretas:
   - Acesse: https://github.com/settings/developers
   - Clique no seu OAuth App
   - Verifique as permissões: `repo`, `admin:repo_hook`, `read:org` (se necessário)

### Passo a Passo para Resolver

1. **Verificar arquivo local**:
   ```bash
   cat .drone.yml
   ```

2. **Verificar se está no Git**:
   ```bash
   git ls-files | grep .drone.yml
   ```

3. **Fazer commit e push**:
   ```bash
   git add .drone.yml
   git commit -m "Add Drone CI configuration"
   git push
   ```

4. **Na interface do Drone**:
   - Vá para Settings do repositório
   - Clique em "ACTIVATE REPOSITORY" (se aparecer)
   - Aguarde alguns segundos
   - Recarregue a página (F5)

5. **Verificar logs do Drone**:
   ```bash
   cd local-execution
   docker-compose logs drone-server | tail -50
   ```

### Validação do .drone.yml

Certifique-se de que seu `.drone.yml` tem pelo menos esta estrutura mínima:

```yaml
kind: pipeline
type: docker
name: default

steps:
  - name: test
    image: alpine
    commands:
      - echo "Hello World"
```

### Verificação Rápida

Execute este script para verificar o básico:

```bash
# Verificar se .drone.yml existe
if [ -f .drone.yml ]; then
  echo "✓ .drone.yml existe localmente"
else
  echo "✗ .drone.yml NÃO existe"
fi

# Verificar se está no Git
if git ls-files | grep -q .drone.yml; then
  echo "✓ .drone.yml está no Git"
else
  echo "✗ .drone.yml NÃO está no Git"
fi

# Verificar sintaxe básica
if grep -q "kind: pipeline" .drone.yml 2>/dev/null; then
  echo "✓ .drone.yml tem estrutura básica"
else
  echo "✗ .drone.yml pode ter problemas de sintaxe"
fi
```

## Outros Problemas Comuns

### Repositório não aparece na lista

**Causa**: O repositório pode não estar sincronizado ou você não tem acesso.

**Solução**:
1. Faça logout e login novamente no Drone
2. Verifique se o repositório existe no GitHub
3. Verifique se você tem acesso ao repositório

### Runner não executa pipelines

**Causa**: O runner pode não estar conectado ao server.

**Solução**:
```bash
cd local-execution
docker-compose logs drone-runner | tail -50
```

Verifique se aparece:
- `successfully pinged the remote server`
- `polling the remote server`

### Erro de autenticação

**Causa**: Credenciais OAuth incorretas ou expiradas.

**Solução**:
1. Verifique o arquivo `.env` em `local-execution/`
2. Verifique se `DRONE_GITHUB_CLIENT_ID` e `DRONE_GITHUB_CLIENT_SECRET` estão corretos
3. Gere novas credenciais se necessário

