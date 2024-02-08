/*
    URL: touching-special-molly.ngrok-free.app
    NGROK: ngrok http --domain=touching-special-molly.ngrok-free.app 80
    Command: lsof -i tcp:80 kill -9 PID 28476
*/

const mysql = require("mysql");
const dbconfig = require("./config/database.js");
const connection = mysql.createConnection(dbconfig);

const express = require("express");
const app = express();
const port = 80;

const areaRoutes = require("./routes/areaRoutes");

app.set('port', process.env.PORT || port);

app.get("/", (req, res) => {
  res.json({ name: "김두한", talk: "술끊어라" });
});

app.use('/', areaRoutes);

app.get('/users', (req, res) => {
  connection.query('SELECT * from TODO', (error, rows) => {
    if (error) throw error;
    console.log('Todos is: ', rows);
    res.send(rows)
  });
});

app.listen(app.get('port'), () => {
  console.log(`Server is running on http://localhost:${app.get('port')}`);
});
