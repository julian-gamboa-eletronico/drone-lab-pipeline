# Laboratório Drone CI - Básico 1

> ⚠️ **IMPORTANTE**: Antes de começar, certifique-se de ter seguido o guia de preparação em [`PREPARACAO.md`](PREPARACAO.md)

## Introdução ao Drone CI

O Drone CI é uma plataforma de CI/CD (Continuous Integration / Continuous Delivery) moderna e nativa para containers. Ele utiliza pipelines declarativos em formato YAML para automatizar processos de build, teste e deploy.

## Estrutura do Pipeline Básico

Vamos analisar o arquivo `.drone.yml` que está na raiz do projeto:

```yaml
kind: pipeline
type: docker
name: playwright

trigger:
  event:
    - promote

steps:
  - name: test-e2e
    image: playwright-clicks:latest
    commands:
      - npm install
      - npx playwright test
```

## Componentes do Pipeline

### 1. Cabeçalho do Pipeline

```yaml
kind: pipeline
type: docker
name: playwright
```

- **`kind: pipeline`**: Define que este é um pipeline do Drone CI
- **`type: docker`**: Especifica que o pipeline será executado em containers Docker
- **`name: playwright`**: Nome identificador do pipeline (usado para referenciar em outros pipelines ou na interface)

### 2. Trigger (Gatilho)

```yaml
trigger:
  event:
    - promote
```

O **trigger** define **quando** o pipeline será executado:

- **`event: promote`**: O pipeline será executado quando um ambiente for promovido (promote). 
  - No Drone CI, o evento `promote` é acionado quando você promove uma build de um ambiente para outro (ex: de staging para production)
  - Outros eventos comuns incluem: `push`, `pull_request`, `tag`, `deployment`

### 3. Steps (Passos)

```yaml
steps:
  - name: test-e2e
    image: playwright-clicks:latest
    commands:
      - npm install
      - npx playwright test
```

Os **steps** definem **o que** será executado no pipeline:

- **`name: test-e2e`**: Nome descritivo do step (aparece nos logs e na interface)
- **`image: playwright-clicks:latest`**: 
  - Imagem Docker que será usada para executar este step
  - Cada step roda em um container isolado
  - Esta imagem já contém o Playwright e todas as dependências pré-instaladas
  - **Nota**: Esta é uma imagem customizada preparada para o laboratório
- **`commands`**: Lista de comandos que serão executados sequencialmente no container:
  1. `npm install` - Instala as dependências do projeto Node.js
  2. `npx playwright test` - Executa os testes E2E com Playwright
  - **Nota**: Como a imagem já tem o Playwright instalado, não precisamos executar `playwright install`

## Fluxo de Execução

1. **Trigger**: Quando um evento `promote` ocorre, o Drone CI detecta e inicia o pipeline
2. **Container**: O Drone cria um container Docker usando a imagem especificada
3. **Checkout**: O código do repositório é clonado no container (automático)
4. **Execução**: Os comandos são executados sequencialmente no container
5. **Resultado**: O pipeline retorna sucesso ou falha baseado no código de saída dos comandos

## Conceitos Importantes

### Containers Isolados
- Cada step roda em um container Docker separado
- Mudanças em um step não afetam os outros (a menos que você use volumes compartilhados)
- Cada step começa do zero com a imagem especificada

### Ordem de Execução
- Os steps são executados **sequencialmente** por padrão
- Se um step falhar, os próximos não serão executados (a menos que você configure `when`)

### Workspace
- Por padrão, o código é clonado em `/drone/src` dentro do container
- Todos os steps compartilham o mesmo workspace (diretório de trabalho)

## Exemplo de Uso

Para executar este pipeline:

1. Configure o Drone CI no seu repositório
2. Promova um ambiente usando a interface do Drone ou API:
   ```bash
   drone build promote <repo> <build-number> <environment>
   ```
3. O pipeline será executado automaticamente

## Próximos Passos

- Adicionar mais steps ao pipeline
- Configurar variáveis de ambiente
- Adicionar condições aos steps (`when`)
- Configurar serviços (services) como bancos de dados
- Trabalhar com secrets e credenciais

