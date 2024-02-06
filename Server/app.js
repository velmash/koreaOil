/*
    URL: touching-special-molly.ngrok-free.app
    NGROK: ngrok http --domain=touching-special-molly.ngrok-free.app 80
    Command: lsof -i tcp:80 kill -9 PID 28476
*/

const express = require("express");
const app = express();
const port = 80;

app.get("/", (req, res) => {
  res.json({ name: "김두한", talk: "술끊어라" });
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
