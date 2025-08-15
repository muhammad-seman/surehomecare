const { STRING, UUIDV4, INTEGER, TEXT } = require("sequelize")
const sequelize = require("../config/database")
const KategoriLayananModel = require("./kategori_layanan_model")

const LayananModel = sequelize.define("layanan", {
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
  harga: {
    type: INTEGER,
    allowNull: false,
  },
  idKategori: {
    type: STRING,
    allowNull: false,
  },
  idBidan: {
    type: STRING,
    allowNull: false,
  },
  gambar: {
    type: STRING,
    allowNull: true,
  },
  keterangan: {
    type: TEXT,
    allowNull: false,
  },
}, {
  freezeTableName: true,
})

LayananModel.belongsTo(KategoriLayananModel, { as: "kategori", foreignKey: "idKategori", onDelete: "RESTRICT" })

module.exports = LayananModel