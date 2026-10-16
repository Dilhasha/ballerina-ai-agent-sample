# Ballerina AI Agent Sample

A simple AI chat agent built with the [`ballerina/ai`](https://central.ballerina.io/ballerina/ai) module, ready to deploy on **WSO2 Integration Cloud (Devant)**.

The agent is a *shopping assistant* for a small electronics store. It uses tool calling to:

| Tool | Description |
|------|-------------|
| `listProducts` | Lists products with price and stock |
| `checkStock` | Returns stock for a product ID |
| `placeOrder` | Places an order and reduces stock |

It keeps per-session conversation history using `ai:ShortTermMemory`.

## Project layout

```
agents.bal   # Model provider + agent definition (system prompt, tools, memory)
tools.bal    # @ai:AgentTool functions backed by an in-memory product table
main.bal     # ai:Listener chat service exposing POST /shoppingAgent/chat
```

## Model provider

The agent uses `ai:getDefaultModelProvider()` (the WSO2 default model provider).

- **On Devant:** the provider configuration is injected automatically — no API keys needed.
- **Locally:** open the project in VS Code with the WSO2 Integrator (BI) extension and run
  the command **"Configure default WSO2 Model Provider"**. It writes the required entries to `Config.toml`
  (git-ignored).

## Run locally

```bash
bal run
```

```bash
curl -X POST http://localhost:8090/shoppingAgent/chat \
  -H "Content-Type: application/json" \
  -d '{"sessionId": "s1", "message": "What products do you have in stock?"}'

curl -X POST http://localhost:8090/shoppingAgent/chat \
  -H "Content-Type: application/json" \
  -d '{"sessionId": "s1", "message": "Order 2 wireless mice please"}'
```

## Deploy on WSO2 Integration Cloud (Devant)

1. In the Devant console, create a new integration and choose **AI Agent** (or *Integration as API*).
2. Connect this GitHub repository; set the project directory to the repository root and the
   build preset to **Ballerina**.
3. Build and deploy. Use the built-in **Test → Chat** console (or the generated endpoint) to talk to the agent.

| Configurable | Default | Description |
|--------------|---------|-------------|
| `port` | `8090` | Port the chat listener binds to |
