---
title: "Claude Code + Servidor MCP Supabase Guia Completo: Da Instalação à Utilização para Iniciantes"
date: 2025-12-22T07:30:20+09:00
lastmod: 2025-12-22T07:45:22+09:00
draft: false
description: "Aprenda como conectar o Claude Code com Supabase como um servidor MCP para gerenciar bancos de dados usando linguagem natural da perspectiva de um iniciante. Explicação passo a passo desde a instalação até o uso prático e considerações de segurança."
tags: ["Claude Code", "Supabase", "MCP", "Model Context Protocol", "데이터베이스", "AI 개발도구", "자연어 쿼리", "개발 생산성"]
categories: ["DevOps"]
image: "https://urinfo24.com/cdn-cgi/image/width=1200,format=auto,quality=85/https://images.urinfo24.com/featured/claude-code-supabase-mcp-setup-featured.jpg"
lightgallery: true
---

<!--
Image Prompt: /Users/freein/Work/blog/images/image-prompt/claude-code-supabase-mcp-setup-prompt.txt
Featured Image: https://images.urinfo24.com/featured/claude-code-supabase-mcp-setup-featured.jpg
-->

Ao usar o Claude Code, há momentos em que você quer acessar dados externos.
Operações de banco de dados, em particular, podem ser trabalhosas, pois você precisa abrir o painel e escrever SQL toda vez.
Nestes casos, usar servidores MCP permite manipular bancos de dados usando linguagem natural no Claude Code.

Este artigo aborda como conectar o Claude Code com Supabase como um servidor MCP da perspectiva de um iniciante.
Vamos proceder passo a passo desde a instalação até o uso prático.

## 1. O que é MCP

### 1.1 O Conceito de MCP

MCP (Model Context Protocol) é um protocolo padrão para modelos de IA interagirem com ferramentas e dados externos.
Simplesmente falando, pense nele como uma ponte conectando IA com sistemas externos.

Anteriormente, se a IA quisesse acessar dados externos, você tinha que criar APIs customizadas toda vez.
Isso resultava em altos custos de desenvolvimento e manutenção difícil.
MCP é uma abordagem padronizada criada pela Anthropic para resolver esses problemas.

### 1.2 Por que é Necessário

O Claude Code é excelente em escrever código, mas não tinha como acessar dados externos.
Para consultas de banco de dados, acesso ao sistema de arquivos, chamadas de API, etc., você tinha que fazer tudo manualmente.

Usando servidores MCP permite que você execute essas tarefas com linguagem natural.
Por exemplo, se você solicitar "Mostre-me os 10 usuários mais recentemente registrados da tabela users", Claude automaticamente escreve e executa o SQL.
Isso melhora significativamente a produtividade de desenvolvimento.

## 2. Guia de Instalação do Servidor MCP Supabase

### 2.1 Pré-requisitos

Primeiro, vamos verificar o que é necessário.

**Requisitos essenciais**:
- Node.js (v16 ou superior)
- Claude Code instalado
- Conta Supabase

Vamos verificar a versão do Node.js.

```bash
node --version
```

v16 ou superior está bom.

### 2.2 Configuração do Projeto Supabase

Faça login no painel Supabase (https://supabase.com).
Crie um novo projeto ou use um existente.

Verifique as seguintes informações nas configurações do projeto:
- URL do Projeto (ex.: `https://xxxxx.supabase.co`)
- API Keys → chave pública `anon`

Esta informação será usada posteriormente na configuração do servidor MCP.

**Importante**: A chave `service_role` tem permissões completas, então use-a com cuidado.
Use-a apenas em ambientes de desenvolvimento e nunca a carregue em repositórios públicos.

### 2.3 Gerando URL do Servidor MCP Supabase

O Supabase fornece um servidor MCP oficial.
Você pode gerar uma URL MCP personalizada na aba 'Connect' → 'MCP' do painel.

O formato da URL é o seguinte:

```
https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=true
```

**Explicação dos parâmetros de consulta**:
- `project_ref`: Restringir a projeto específico (recomendado)
- `read_only`: Habilitar modo somente leitura (recomendado)

O modo somente leitura previne modificação acidental de dados.
É seguro habilitar esta opção durante o desenvolvimento inicial.

### 2.4 Configuração do Claude Code

Agora vamos configurar o servidor MCP no Claude Code.

#### Configuração macOS

O caminho do arquivo de configuração é o seguinte:

```
~/Library/Application Support/Claude/claude_desktop_config.json
```

Crie o arquivo se ele não existir.

```bash
mkdir -p ~/Library/Application\ Support/Claude
touch ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

#### Configuração Windows

No Windows, use o seguinte caminho:

```
%APPDATA%\Claude\claude_desktop_config.json
```

Digite `%APPDATA%\Claude` na barra de endereços do Explorer.

## 3. Verificação de Conexão

### 3.1 Escrevendo Arquivo de Configuração

Abra o arquivo `claude_desktop_config.json` e adicione o seguinte conteúdo.

```json
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-supabase",
        "https://xxxxx.supabase.co",
        "your-anon-key-here"
      ]
    }
  }
}
```

**Explicação dos parâmetros**:
- `command`: Use `npx` (execução direta do pacote npm)
- `args`: Pacote do servidor MCP e informações de autenticação

**Ou use servidor MCP hospedado**:

```json
{
  "mcpServers": {
    "supabase": {
      "url": "https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=true"
    }
  }
}
```

A abordagem de hospedagem é mais simples.
Ela automaticamente manipula a autenticação OAuth 2.1.

### 3.2 Teste de Conexão

Reinicie o Claude Code.
Clique no ícone Tools no menu para ver a lista de servidores MCP conectados.

Se você ver o servidor "supabase", foi bem-sucedido.

Vamos fazer um teste simples.

```
Para Claude: "Qual é a chave anon do Supabase?"
```

Claude consulta as informações do projeto e te informa.
Se isso funcionar, o servidor MCP está conectado corretamente.

## 4. Exemplos de Uso Prático

Agora vamos realmente executar operações de banco de dados.

### 4.1 Consultas de Tabela

A operação mais básica é consultar tabelas.

```
Para Claude: "Mostre-me todos os dados da tabela users"
```

Claude automaticamente escreve e executa uma consulta SELECT.
Ele organiza os resultados em uma tabela bem formatada.

**Solicitações mais específicas também são possíveis**:

```
"Mostre-me apenas usuários com emails do Gmail da tabela users"
```

```
"Me diga quantos usuários se cadastraram nos últimos 7 dias"
```

Quando você solicita em linguagem natural, Claude automaticamente gera SQL apropriado.

### 4.2 Inserção de Dados

Inserção de dados também é possível quando o modo read_only está desabilitado.

Primeiro, mude `read_only=false` no arquivo de configuração.

```json
{
  "mcpServers": {
    "supabase": {
      "url": "https://mcp.supabase.com/mcp?project_ref=YOUR_PROJECT_ID&read_only=false"
    }
  }
}
```

Após reiniciar o Claude Code, faça uma solicitação assim.

```
"Adicione um novo usuário à tabela users. 
O nome deve ser 'John', email deve ser 'john@example.com'"
```

Claude gera uma consulta INSERT e solicita execução.
Quando o usuário aprova, os dados são adicionados.

### 4.3 Criação de Tabela

Você também pode criar novas tabelas.

```
"Crie uma tabela comments. 
Colunas devem ser id, user_id, content, created_at"
```

Claude gera uma consulta CREATE TABLE.
Após revisar o esquema e aprovar, a tabela é criada.

### 4.4 Consultas Complexas

Consultas JOIN ou agregadas também podem ser solicitadas em linguagem natural.

```
"Mostre o número de comentários escritos por cada usuário"
```

```
"Quantos usuários que se cadastraram este mês escreveram pelo menos 1 comentário?"
```

Claude automaticamente escreve SQL complexo também.
Isso torna operações de banco de dados possíveis mesmo sem conhecimento perfeito de SQL.

## 5. Segurança e Dicas

### 5.1 Considerações de Segurança

Segurança deve ser considerada ao usar servidores MCP.

**Proibir conexões de dados de produção**:
- Use MCP apenas em ambientes de desenvolvimento/teste
- Nunca conecte a bancos de dados de serviços reais
- IA pode acidentalmente deletar dados importantes

**Utilizar modo somente leitura**:
- Defina read_only=true por padrão
- Desabilite temporariamente apenas quando operações de escrita forem necessárias
- Reabilite após completar o trabalho

**Escopo do projeto**:
- Restrinja acesso apenas a projetos específicos usando o parâmetro project_ref
- Não dê permissões de acesso a múltiplos projetos

**Gerenciamento de chaves API**:
- Não coloque chaves API diretamente em arquivos de configuração
- Gerenciar com variáveis de ambiente é mais seguro
- Nunca carregue para repositórios públicos

### 5.2 Dicas de Uso Efetivo

**Faça solicitações específicas**:
- "Mostre dados" ❌
- "Mostre emails e datas de registro dos 10 usuários mais recentes da tabela users" ✅

**Proceda passo a passo**:
- Não faça operações complexas de uma vez
- Primeiro consulte para verificar, depois modifique

**Revise consultas**:
- Sempre verifique o SQL gerado pelo Claude
- Solicite modificações se houver partes suspeitas

**Especifique ferramentas**:
- "Use a ferramenta Supabase MCP para consultar a tabela users"
- Especificar assim pode economizar tokens

## 6. Resumo

Aprendemos como conectar o Claude Code com servidor MCP Supabase.

**Resumo do conteúdo principal**:
- MCP é um protocolo padrão conectando IA com sistemas externos
- Supabase fornece um servidor MCP oficial
- Adicione informações do servidor MCP ao arquivo de configuração
- Operações de banco de dados podem ser executadas usando linguagem natural
- Use modo read_only para segurança

**Próximos passos**:
- Tente adicionar outros servidores MCP (GitHub, Notion, etc.)
- Crie fluxos de trabalho complexos combinando múltiplos servidores MCP
- Desenvolva servidores MCP customizados adequados para seus projetos

Boa utilização de servidores MCP melhora significativamente a produtividade do Claude Code.
Você pode integrar com várias ferramentas externas além de apenas operações de banco de dados.
Isso torna fluxos de trabalho de desenvolvimento muito mais convenientes.