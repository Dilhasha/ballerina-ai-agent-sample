import ballerina/ai;

// Uses the default WSO2 model provider. When deployed on WSO2 Integration Cloud (Devant),
// the provider configuration is injected automatically. For local runs, generate it with
// the "Configure default WSO2 Model Provider" command in the WSO2 Integrator (BI) VS Code extension.
final ai:Wso2ModelProvider model = check ai:getDefaultModelProvider();

final ai:Agent shoppingAgent = check new (
    systemPrompt = {
        role: "Shopping Assistant",
        instructions: string `You are a helpful shopping assistant for an online electronics store.
            - Use the available tools to look up products, check stock and place orders.
            - Never invent product IDs, prices or stock levels; always use the tools.
            - Confirm the product and quantity with the user before placing an order.
            - Keep answers short and friendly.`
    },
    model = model,
    tools = [listProducts, checkStock, placeOrder],
    memory = check new ai:ShortTermMemory(check new ai:InMemoryShortTermMemoryStore(10))
);
