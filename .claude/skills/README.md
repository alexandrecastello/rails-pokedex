# Skills do projeto

Esta pasta é a **fonte única** das skills partilhadas entre **Claude Code** (Anthropic) e **Cursor**.

## Estrutura

Cada skill fica num subdiretório com `SKILL.md`:

```
.claude/skills/
├── README.md
└── nome-da-skill/
    ├── SKILL.md          # obrigatório (frontmatter YAML + corpo em Markdown)
    ├── reference.md      # opcional
    ├── scripts/          # opcional
    └── ...
```

### `SKILL.md` (mínimo)

```markdown
---
name: nome-da-skill
description: O que faz e quando usar (termos de ativação ajudam o agente).
---

# Título

Instruções claras para o agente.
```

## Claude Code

- Coloca ou edita skills **aqui** em `.claude/skills/<nome>/SKILL.md`.
- Para ativação avançada (regras, gatilhos), o Claude Code pode usar `skill-rules.json` na mesma pasta — consulta a [documentação do Claude Code](https://docs.anthropic.com) para o formato actual.

## Cursor

- O Cursor lê skills de **`.cursor/skills/`**, que neste repositório é um **link simbólico** para `.claude/skills/`.
- Não dupliques ficheiros: edita sempre em `.claude/skills/`.

## Adicionar uma skill nova

1. Cria `.claude/skills/minha-skill/SKILL.md` com o frontmatter acima.
2. Faz commit — fica disponível para toda a equipa em ambos os ambientes (desde que o symlink exista após clone).

### Clone em Windows

Se o symlink não for criado automaticamente, recria manualmente:

```powershell
# na raiz do repo
New-Item -ItemType SymbolicLink -Path .cursor/skills -Target .claude/skills
```

Ou em Git Bash / WSL:

```bash
ln -sfn ../.claude/skills .cursor/skills
```

(executar com `.cursor` já criado; apagar `.cursor/skills` se for uma pasta vazia criada por engano.)
