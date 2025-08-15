const { STRING, UUIDV4, DOUBLE, TEXT } = require("sequelize")
const sequelize = require("../config/database")
const bcrypt = require("bcrypt")
const KecamatanModel = require("./kecamatan_model")

const UserModel = sequelize.define("user", {
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
  token: {
    type: STRING,
    allowNull: true,
  },
  gambar: {
    type: STRING,
    allowNull: true,
  },
  kodeOTP: {
    type: STRING,
    allowNull: true,
  },
  idKecamatan: {
    type: STRING,
    allowNull: false,
  },
  latitude: {
    type: DOUBLE,
    allowNull: true,
  },
  longitude: {
    type: DOUBLE,
    allowNull: true,
  },
  alamat: {
    type: TEXT,
    allowNull: false,
  },
}, {
  freezeTableName: true,
  hooks: {
    beforeCreate(user, options) {
      const saltRounds = parseInt(process.env.BCRYPT_SALT_ROUNDS)
      user.password = bcrypt.hashSync(user.password, saltRounds)
    }
  }
})

UserModel.belongsTo(KecamatanModel, { as: "kecamatan", foreignKey: "idKecamatan", onDelete: "RESTRICT" })

module.exports = UserModel