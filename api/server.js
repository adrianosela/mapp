const express = require("express");
const routes = require("./routes/mux");

// define http endpoints
const app = express();
app.use("/", routes);

module.exports = app;
