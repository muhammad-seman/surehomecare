const KecamatanModel = require("../models/kecamatan_model");
const ProvinsiModel = require("../models/provinsi_model");

class DaerahController {
  static getProvinsi(req, res) {
    ProvinsiModel.findAll({
      order: [["nama", "ASC"]],
    })
      .then((data) => {
        res.status(200).json({
          status: true,
          message: "Berhasil mengambil data provinsi",
          data,
        })
      })
      .catch((err) => {
        console.log(err)
        res.status(500).json({
          status: false,
          message: "Terjadi kesalahan, silahkan coba lagi",
          data: {},
        })
      })
  }
  
  static getKecamatan(req, res) {
    const { idProvinsi } = req.params
    const where = idProvinsi ? { idProvinsi } : {}

    KecamatanModel.findAll({
      where,
      order: [["nama", "ASC"]],
    })
      .then((data) => {
        res.status(200).json({
          status: true,
          message: "Berhasil mengambil data kecamatan",
          data,
        })
      })
      .catch((err) => {
        console.log(err)
        res.status(500).json({
          status: false,
          message: "Terjadi kesalahan, silahkan coba lagi",
          data: {},
        })
      })
  }
}

module.exports = DaerahController