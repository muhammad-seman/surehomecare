const { STRING, UUIDV4 } = require("sequelize")
const sequelize = require("../config/database")

const KategoriLayananModel = sequelize.define("kategori_layanan", {
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

module.exports = KategoriLayananModel