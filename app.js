const express = require("express");

function createServer() {
  const app = express();
  const port = process.env.PORT || 3000;

  app.get("/", (req, res) => {
    res.json({
      message: "Hello from Secure Docker App!",
      timestamp: new Date().toISOString(),
      version: "1.0.0",
    });
  });

  app.get("/health", (req, res) => {
    res.json({ status: "healthy" });
  });

  app.listen(port, () => {
    console.log(`Server running on port ${port}`);
  });

  return app;
}

// Initialize the server
createServer();
