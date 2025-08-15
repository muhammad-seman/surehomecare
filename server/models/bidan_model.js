const { STRING, UUIDV4, TEXT, BOOLEAN } = require("sequelize")
const sequelize = require("../config/database")
const UserModel = require("./user_model")
const LayananModel = require("./layanan_model")

const BidanModel = sequelize.define("bidan", {
  id: {
    type: STRING,
    defaultValue: UUIDV4,
    allowNull: false,
    primaryKey: true,
  },
  idBidan: {
    type: STRING,
    allowNull: false,
  },
  keterangan: {
    type: TEXT,
    allowNull: false,
  },
  bersedia: {
    type: BOOLEAN,
    allowNull: false,
    defaultValue: true,
  },
  token: {
    type: STRING,
    allowNull: true,
  },
}, {
  freezeTableName: true,
})

BidanModel.belongsTo(UserModel, { as: "user", foreignKey: "idBidan", onDelete: "CASCADE" })
BidanModel.hasMany(LayananModel, { as: "layanan", foreignKey: "idBidan", onDelete: "CASCADE" })

module.exports = BidanModel