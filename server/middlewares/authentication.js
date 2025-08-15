const UserModel = require("../models/user_model")
const jwt = require("jsonwebtoken")

const auth = async (req, res, next) => {
  try {
    const bearerToken = req.headers.authorization
    if (!bearerToken) {
      return res.status(400).json({
        status: false,
        message: "Authentikasi tidak boleh kosong",
        data: {}
      })
    }
    
    const token = bearerToken.slice(7)
    const user = await UserModel.findOne({
      where: { token: token }
    })
    if (!user) {
      return res.status(401).json({
        status: false,
        message: "Token Anda telah kadaluarsa",
        data: {}
      })
    }
  
    const secret = process.env.BCRYPT_SECRET
    const dataToken = jwt.decode(token, secret)
    const id = dataToken.id
  
    req.idUser = id
    next()
  } catch (error) {
    console.log(error)
    res.status(500).json({
      status: false,
      message: "Terjadi kesalahan",
      data: {}
    })
  }
}

module.exports = auth