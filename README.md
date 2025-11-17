# Laboratório Drone CI Pipeline

Este repositório contém materiais e exemplos para o laboratório sobre Drone CI.

## 📚 Estrutura do Laboratório

- **`basico-1/`** - Laboratório básico sobre pipelines do Drone CI
  - `README.md` - Documentação completa do laboratório
  - `PREPARACAO.md` - Guia de preparação pré-aula
  - `validar-ambiente.sh` - Script de validação do ambiente

- **`local-execution/`** - ⚠️ **ESSENCIAL**: Configuração do ambiente Drone CI
  - `docker-compose.yml` - **OBRIGATÓRIO**: Arquivo que configura server e runner do Drone CI
  - `README.md` - Instruções de uso do docker-compose
  - `TROUBLESHOOTING.md` - Guia de resolução de problemas (incluindo "Validation Failed")

## 🚀 Início Rápido

### Antes da Aula

**IMPORTANTE**: Leia o arquivo [`basico-1/PREPARACAO.md`](basico-1/PREPARACAO.md) para preparar o ambiente antes da aula.

### Durante a Aula

Siga o guia em [`basico-1/README.md`](basico-1/README.md) para entender os conceitos básicos do Drone CI.

## 📋 Requisitos

- Docker instalado e rodando
- Imagens Docker disponíveis:
  - `playwright-clicks:latest`
  - `drone/drone:2`
  - `drone/drone-runner-docker:1`

## 📝 Arquivos Principais

- `.drone.yml` - Configuração do pipeline básico
- `local-execution/docker-compose.yml` - ⚠️ **ESSENCIAL**: Infraestrutura do Drone CI (server + runner)

## ⚠️ Importante

**O arquivo `local-execution/docker-compose.yml` é OBRIGATÓRIO para executar o Drone CI localmente.**

Sem ele, o Drone CI não funcionará. Este arquivo configura:
- O servidor do Drone CI (interface web e API)
- O runner que executa os pipelines

Consulte [`local-execution/README.md`](local-execution/README.md) para mais detalhes.

## 🔧 Troubleshooting

### Erro "Validation Failed" na interface?

Este é um problema comum! Execute o script de verificação:

```bash
./verificar-drone.sh
```

Ou consulte o guia completo: [`local-execution/TROUBLESHOOTING.md`](local-execution/TROUBLESHOOTING.md)

**Solução rápida**: Certifique-se de que o `.drone.yml` está commitado e pushado para o GitHub, depois ative o repositório na interface do Drone.
