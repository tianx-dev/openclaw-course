# OpenClaw Codebase Analysis

## What is OpenClaw?
OpenClaw is a personal AI assistant that runs on your own devices. It connects to multiple messaging channels (WhatsApp, Telegram, Slack, Discord, etc.) and provides an AI assistant that can help with various tasks through natural language interaction.

## Key Components Identified:

### 1. **Gateway** (`src/gateway/`)
The core server that handles:
- Authentication and authorization
- WebSocket connections for real-time communication
- HTTP API endpoints
- Session management
- Plugin and skill loading

### 2. **Agents** (`src/agents/`)
The AI assistant logic:
- Model configuration and fallback handling
- Tool definitions and execution
- Session management
- Sub-agent orchestration
- Memory and context management

### 3. **Channels** (`src/channels/`)
Messaging platform integrations:
- Plugin system for different platforms (Telegram, WhatsApp, Discord, etc.)
- Message routing and delivery
- Channel-specific features and configurations

### 4. **CLI** (`src/cli/`)
Command-line interface:
- User commands and interactions
- Gateway management
- Configuration and setup

### 5. **Skills** (`skills/` directory)
Extensible functionality:
- Pre-built skills for common tasks
- Skill installation and management
- Workspace integration

### 6. **Plugin SDK** (`src/plugin-sdk/`)
Extension system:
- Plugin development framework
- Tool integration
- Runtime environment

## Architecture Flow:
1. User sends message via messaging platform (Telegram, WhatsApp, etc.)
2. Channel plugin receives message and forwards to Gateway
3. Gateway authenticates and routes to appropriate agent session
4. Agent processes message using AI model and available tools
5. Agent executes tools (read files, run commands, search web, etc.)
6. Response is sent back through Gateway to Channel plugin
7. Channel plugin delivers response to user

## Technical Stack:
- **Language**: TypeScript/JavaScript
- **Runtime**: Node.js (v22.16+)
- **Package Manager**: pnpm (primary), npm, bun supported
- **Build System**: TypeScript compilation
- **Testing**: Vitest
- **Deployment**: Docker, systemd/launchd services

## Key Design Patterns:
- Plugin architecture for extensibility
- WebSocket-based real-time communication
- Tool-based AI interaction (similar to OpenAI function calling)
- Skill system for modular functionality
- Workspace-based file operations
- Sandboxed execution for security

## User Journey:
1. Install OpenClaw via npm/pnpm
2. Run `openclaw onboard` for setup
3. Configure messaging channels
4. Start interacting with AI assistant via connected platforms
5. Extend functionality with skills

This analysis will form the basis for creating an interactive course that teaches non-technical users how OpenClaw works under the hood.