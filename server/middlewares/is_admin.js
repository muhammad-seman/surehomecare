const AdminModel = require("../models/admin_model")
const BidanModel = require("../models/bidan_model")

const isAdmin = async (req, res, next) => {
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
    const admin = await AdminModel.findOne({
      where: { token: token },
      attributes: ["id"]
    })
    let bidan = await BidanModel.findOne({
      where: { token },
      include: [{
        association: "user",
        attributes: ["id"]
      }]
    })

    if (bidan === null) bidan = admin
    
    if (!bidan) {
      return res.status(401).json({
        status: false,
        message: "Token Anda telah kadaluarsa",
        data: {}
      })
    }
  
    const id = admin ? admin.id : bidan.user.id
    const role = admin ? "admin" : "bidan"

    req.idAdmin = id
    req.role = role
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

module.exports = isAdmin