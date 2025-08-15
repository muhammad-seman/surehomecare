const { STRING, UUIDV4, INTEGER } = require("sequelize")
const sequelize = require("../config/database")
const LayananModel = require("./layanan_model")

const DetailOrderModel = sequelize.define("detail_order", {
  id: {
    type: STRING,
    defaultValue: UUIDV4,
    allowNull: false,
    primaryKey: true,
  },
  idOrder: {
    type: STRING,
    allowNull: false,
  },
  namaLayanan: {
    type: STRING,
    allowNull: false,
  },
  idLayanan: {
    type: STRING,
    allowNull: true,
  },
  jlhBayar: {
    type: INTEGER,
    allowNull: false,
  },
}, {
  freezeTableName: true,
})

DetailOrderModel.belongsTo(LayananModel, { as: "layanan", foreignKey: "idLayanan", onDelete: "SET NULL" })

module.exports = DetailOrderModel