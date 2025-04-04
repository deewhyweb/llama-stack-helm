import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport, } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import pg from "pg";

const { Client } = pg;

// PostgreSQL connection setup
const dbClient = new Client({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT ? parseInt(process.env.DB_PORT) : 5432,
});

dbClient.connect();
// Create server instance
const server = new McpServer({
    name: "orders",
    version: "1.0.0",
});



server.tool("findorder", "Find a customers orders details", {
    orderid: z.string().describe("The id of the order"),
}, async ({ orderid }) => {
    // Get grid point data
    console.log('looking up ' + orderid)
    try {
        console.log('in here')
        const query = `  SELECT orders.id AS order_id,
                            orders.status,
                            order_items.id AS item_id,
                            order_items.description,
                            order_items.amount,
                            order_items.year
                        FROM 
                            orders
                        LEFT JOIN 
                            order_items 
                            ON orders.id = order_items.orderid
                        WHERE 
                            orders.id = '` + orderid + `'`;
        const result = await dbClient.query(query);

        if (result.rows.length === 0) {
            return {
                content: [
                    { type: "text", text: `No order found with ID ${orderid}` },
                ],
            };
        }

        const order = result.rows[0];
        const orderText = `Order details for order ${orderid}: ` + JSON.stringify(result);
        return {
            content: [
                { type: "text", text: orderText },
            ],
        };
    } catch (error) {
        console.log(error);
        return {
            content: [
                { type: "text", text: `Error fetching order details: ${error.message}` },
            ],
        };
    }
});

server.tool("updateorder", "Update an order status", {
    orderid: z.string().describe("The id of the order"),
    status: z.string().describe("The status of the order"),
}, async ({ orderid, status }) => {
    // Get grid point data
    await dbClient.query("UPDATE orders SET status = $1 WHERE id = $2", [status, orderid]);
    const orderText = "Order updated" + orderid + ": it now has a status of " + status;
    return {
        content: [
            {
                type: "text",
                text: orderText,
            },
        ],
    };
});

async function main() {
    const transport = new StdioServerTransport();
    await server.connect(transport);
    console.error("Weather MCP Server running on stdio");
}
main().catch((error) => {
    console.error("Fatal error in main():", error);
    process.exit(1);
});
