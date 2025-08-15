const { STRING, UUIDV4, DATE } = require("sequelize")
const sequelize = require("../config/database")
const DetailOrderModel = require("./detail_order_model")
const UserModel = require("./user_model")

const OrderModel = sequelize.define("order", {
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
    allowNull: true,
  },
  status: {
    type: STRING,
    allowNull: false,
    defaultValue: "diajukan",
  },
  tglSelesai: {
    type: DATE,
    allowNull: true,
  },
}, {
  freezeTableName: true,
})

OrderModel.hasMany(DetailOrderModel, { as: "detailOrder", foreignKey: "idOrder", onDelete: "CASCADE" })
OrderModel.belongsTo(UserModel, { as: "user", foreignKey: "idUser", onDelete: "CASCADE" })
OrderModel.belongsTo(UserModel, { as: "bidan", foreignKey: "idBidan", onDelete: "SET NULL" })

module.exports = OrderModel