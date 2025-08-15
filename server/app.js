const express = require("express")
const cors = require("cors");
const routes = require("./routes/index")
const sequelize = require("./config/database")

const PORT = process.env.PORT
const app = express()

app.use(express.json())
app.use(cors({ origin: "*" }))
app.use("/api", routes)
app.use("/images", express.static("./images/"))

sequelize.sync({ alter: true }).then(() => {
  app.listen(PORT, () => {
    console.log(`Listening on port ${PORT}...`)
  })
})

module.exports = app