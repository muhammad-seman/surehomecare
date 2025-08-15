const { STRING, UUIDV4 } = require("sequelize")
const sequelize = require("../config/database")
const ProvinsiModel = require("./provinsi_model")

const KecamatanModel = sequelize.define("kecamatan", {
  id: {
    type: STRING,
    defaultValue: UUIDV4,
    allowNull: false,
    primaryKey: true,
  },
  idProvinsi: {
    type: STRING,
    allowNull: false,
  },
  nama: {
    type: STRING,
    allowNull: false,
  },
}, {
  freezeTableName: true,
})

KecamatanModel.belongsTo(ProvinsiModel, { as: "provinsi", foreignKey: "idProvinsi", onDelete: "CASCADE" })

module.exports = KecamatanModel