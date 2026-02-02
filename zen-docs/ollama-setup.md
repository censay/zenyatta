# Ollama Configuration Guide

## Location of .env

**IMPORTANT:** .env is in `~/ai-playground/.env` (NOT `~/zenyatta/`)

## Setup

```bash
# Copy template
cp ~/zenyatta/.env.example ~/ai-playground/.env

# Edit
nano ~/ai-playground/.env
```

## Scenarios

### Ollama on Same Machine
```
OLLAMA_HOST=localhost:11434
```

### Ollama on Different Machine
```
OLLAMA_HOST=192.168.1.100:11434
```

## Apply Changes

```bash
zen-rebuild
```

## Verify

```bash
# Test from host
curl http://localhost:11434/api/tags

# Inside container
playground
echo $OLLAMA_HOST
```

See main README for more details.
