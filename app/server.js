const http = require("http");

const PORT = process.env.PORT || 3000;
const VERSION = process.env.APP_VERSION || "1.0.0";
const startedAt = new Date().toISOString();

const server = http.createServer((req, res) => {
  if (req.url === "/healthz" || req.url === "/readyz") {
    res.writeHead(200, { "Content-Type": "application/json" });
    return res.end(JSON.stringify({ status: "ok", version: VERSION }));
  }

  if (req.url === "/api/products") {
    res.writeHead(200, { "Content-Type": "application/json" });
    return res.end(JSON.stringify([
      { id: 1, name: "Laptop", category: "Electronics", price: 749.99 },
      { id: 2, name: "Desk Lamp", category: "Home", price: 29.99 },
      { id: 3, name: "Notebook", category: "Stationery", price: 4.99 }
    ]));
  }

  if (req.url === "/") {
    res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
    return res.end(`<h1>Product Catalog</h1><p>Version: ${VERSION}</p><p>Started: ${startedAt}</p><p><a href="/api/products">View products</a></p>`);
  }

  res.writeHead(404, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ error: "Not found", path: req.url }));
});

server.listen(PORT, "0.0.0.0", () => {
  console.log(JSON.stringify({ level: "info", message: "server_started", port: PORT, version: VERSION }));
});

process.on("SIGTERM", () => {
  console.log(JSON.stringify({ level: "info", message: "shutdown_requested" }));
  server.close(() => process.exit(0));
});
