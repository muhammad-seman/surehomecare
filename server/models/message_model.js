const { STRING, UUIDV4, TEXT, DATE } = require("sequelize")
const sequelize = require("../config/database")
const UserModel = require("./user_model")

const MessageModel = sequelize.define("message", {
  id: {
    type: STRING,
    defaultValue: UUIDV4,
    primaryKey: true,
  },
  pengirim: {
    type: STRING,
    allowNull: true,
  },
  penerima: {
    type: STRING,
    allowNull: true,
  },
  isi: {
    type: TEXT,
    allowNull: false,
  },
  tglBaca: {
    type: DATE,
    allowNull: true,
  },
  tglTerkirim: {
    type: DATE,
    allowNull: true,
  },
}, {
  freezeTableName: true,
})

MessageModel.belongsTo(UserModel, { as: "pengirimData", foreignKey: "pengirim", onDelete: "SET NULL" })
MessageModel.belongsTo(UserModel, { as: "penerimaData", foreignKey: "penerima", onDelete: "SET NULL" })


module.exports = MessageModel