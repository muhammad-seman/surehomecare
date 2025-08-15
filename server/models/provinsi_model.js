const { STRING, UUIDV4 } = require("sequelize")
const sequelize = require("../config/database")
const KecamatanModel = require("./kecamatan_model")

const ProvinsiModel = sequelize.define("provinsi", {
  id: {
    type: STRING,
    defaultValue: UUIDV4,
    allowNull: false,
    primaryKey: true,
  },
  nama: {
    type: STRING,
    allowNull: false,
  },
}, {
  freezeTableName: true,
})

module.exports = ProvinsiModel