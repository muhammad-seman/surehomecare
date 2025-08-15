const BidanModel = require("../models/bidan_model")

const isBidan = async (req, res, next) => {
  try {
    const { idUser } = req
    const bidan = await BidanModel.findOne({
      where: { idBidan: idUser },
      raw: true, nest: true,
    })
  
    if (!bidan) {
      return res.status(401).json({
        status: false,
        message: "Anda bukan terdaftar sebagai bidan",
        data: {},
      })
    }
  
    req.idBidan = bidan.id
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

module.exports = isBidan