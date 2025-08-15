const { STRING, UUIDV4, TEXT } = require("sequelize")
const sequelize = require("../config/database")
const KecamatanModel = require("./kecamatan_model")
const bcrypt = require("bcrypt")

const RequestBidanModel = sequelize.define("request_bidan", {
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
  email: {
    type: STRING,
    allowNull: false,
  },
  noHp: {
    type: STRING,
    allowNull: false,
  },
  password: {
    type: STRING,
    allowNull: false,
  },
  idKecamatan: {
    type: STRING,
    allowNull: false,
  },
  alamat: {
    type: TEXT,
    allowNull: false,
  },
  keterangan: {
    type: TEXT,
    allowNull: false,
  },
}, {
  freezeTableName: true,
  hooks: {
    beforeCreate(bidan, options) {
      const saltRounds = parseInt(process.env.BCRYPT_SALT_ROUNDS)
      bidan.password = bcrypt.hashSync(bidan.password, saltRounds)
    }
  }
})

RequestBidanModel.belongsTo(KecamatanModel, { as: "kecamatan", foreignKey: "idKecamatan", onDelete: "RESTRICT" })

module.exports = RequestBidanModel