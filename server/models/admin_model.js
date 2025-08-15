const { STRING, UUIDV4 } = require("sequelize")
const sequelize = require("../config/database")

const AdminModel = sequelize.define("admin", {
  id: {
    type: STRING,
    defaultValue: UUIDV4,
    allowNull: false,
    primaryKey: true,
  },
  username: {
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
}, {
  freezeTableName: true,
  // hooks: {
  //   beforeCreate(user, options) {
  //     const saltRounds = parseInt(process.env.BCRYPT_SALT_ROUNDS)
  //     user.password = bcrypt.hashSync(user.password, saltRounds)
  //   }
  // }
})

module.exports = AdminModel