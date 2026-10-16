import ballerina/ai;
import ballerina/uuid;

type Product record {|
    readonly string id;
    string name;
    decimal price;
    int stock;
|};

type Order record {|
    string orderId;
    string productId;
    string productName;
    int quantity;
    decimal total;
|};

isolated table<Product> key(id) products = table [
    {id: "P001", name: "Wireless Mouse", price: 25.99, stock: 40},
    {id: "P002", name: "Mechanical Keyboard", price: 89.50, stock: 12},
    {id: "P003", name: "27-inch Monitor", price: 249.00, stock: 5},
    {id: "P004", name: "USB-C Hub", price: 39.99, stock: 0}
];

# Lists all products available in the store with their prices and stock levels.
# + return - The list of products
@ai:AgentTool
isolated function listProducts() returns Product[] {
    lock {
        return products.toArray().clone();
    }
}

# Checks how many units of a product are currently in stock.
# + productId - The ID of the product (e.g. P001)
# + return - The available stock count, or an error if the product does not exist
@ai:AgentTool
isolated function checkStock(string productId) returns int|error {
    lock {
        Product? product = products[productId];
        if product is () {
            return error(string `Product '${productId}' not found`);
        }
        return product.stock;
    }
}

# Places an order for a product and reduces the stock accordingly.
# + productId - The ID of the product to order
# + quantity - The number of units to order
# + return - The created order, or an error if the order cannot be placed
@ai:AgentTool
isolated function placeOrder(string productId, int quantity) returns Order|error {
    if quantity <= 0 {
        return error("Quantity must be greater than zero");
    }
    lock {
        Product? product = products[productId];
        if product is () {
            return error(string `Product '${productId}' not found`);
        }
        if product.stock < quantity {
            return error(string `Only ${product.stock} unit(s) of '${product.name}' in stock`);
        }
        product.stock -= quantity;
        return {
            orderId: uuid:createType4AsString(),
            productId,
            productName: product.name,
            quantity,
            total: product.price * <decimal>quantity
        };
    }
}
