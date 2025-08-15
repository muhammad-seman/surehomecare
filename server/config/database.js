const { Sequelize } = require("sequelize")

const dbName = process.env.DB_NAME
const username = process.env.DB_USERNAME
const password = process.env.DB_PASSWORD
const hostname = process.env.DB_HOSTNAME

const db = new Sequelize(dbName, username, password, {
  host: hostname,
  dialect: "mysql",
  // TODO: custom logging
  logging: false,
  define: {
    charset: "utf8",
    collate: "utf8_general_ci",
  },
})

module.exports = db
