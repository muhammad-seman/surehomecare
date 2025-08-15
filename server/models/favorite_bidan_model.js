const { STRING, UUIDV4 } = require("sequelize")
const sequelize = require("../config/database")
const BidanModel = require("./bidan_model")
const UserModel = require("./user_model")

const FavoriteBidanModel = sequelize.define("favorite_bidan", {
  id: {
    type: STRING,
    defaultValue: UUIDV4,
    allowNull: false,
    primaryKey: true,
  },
  idUser: {
    type: STRING,
    allowNull: false,
  },
  idBidan: {
    type: STRING,
    allowNull: false,
  },
}, {
  freezeTableName: true,
})

FavoriteBidanModel.belongsTo(BidanModel, { as: "bidan", foreignKey: "idBidan", onDelete: "CASCADE" })
FavoriteBidanModel.belongsTo(UserModel, { as: "user", foreignKey: "idUser", onDelete: "CASCADE" })

module.exports = FavoriteBidanModel