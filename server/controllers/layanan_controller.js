const KategoriLayananModel = require("../models/kategori_layanan_model");
const LayananModel = require("../models/layanan_model");
const fs = require("fs")

class LayananController {
  // static allLayanan(req, res) {
  //   LayananModel.findAll({
  //     where: { idBidan: null },
  //     order: [["nama", "ASC"]]
  //   })
  //     .then((data) => {
  //       res.status(200).json({
  //         status: true,
  //         message: "Berhasil mengambil data top layanan",
  //         data,
  //       })
  //     })
  //     .catch((err) => {
  //       console.log(err)
  //       res.status(500).json({
  //         status: false,
  //         message: "Terjadi kesalahan, silahkan coba lagi",
  //         data: {},
  //       })
  //     })
  // }

  static async syncLayanan(req, res) {
    try {
      const { idBidan } = req
      const listLayanan = req.body
  
      const listExisting = await LayananModel.findAll({
        where: { idBidan },
        attributes: ["id"],
        raw: true, nest: true,
      })
      const listExistingId = listExisting.map((layanan) => layanan.id)

      const listRemaining = listLayanan.filter((layanan) => layanan.id !== null)
      const listRemainingIds = listRemaining.map((layanan) => layanan.id)
      const listDeletedIds = listExistingId.filter((oldId) => {
        return !listRemainingIds.includes(oldId)
      })

      const listNew = listLayanan.filter((layanan) => layanan.id === undefined)
      const listNewLayanan = listNew.map((layananRaw) => {
        return { idBidan, ...layananRaw }
      })

      const updatePromises = listRemaining.map((layananRaw) => {
        const data = layananRaw
        delete layananRaw.id
        return LayananModel.update(data, {
          where: { id: layananRaw.id }
        })
      })

      await Promise.allSettled([
        ...updatePromises,
        LayananModel.bulkCreate(listNewLayanan),
        LayananModel.destroy({
          where: { idBidan, id: listDeletedIds }
        })
      ])

      res.status(200).json({
        status: true,
        message: "Berhasil mengupdate layanan",
        data: {},
      })
    } catch (err) {
      console.log(err)
      res.status(500).json({
        status: false,
        message: "Terjadi kesalahan, silahkan coba lagi",
        data: {},
      })
    }
  }

  static async getLayanan(req, res) {
    try {
      const { idBidan } = req

      const data = await LayananModel.findAll({
        where: { idBidan },
        order: [["nama", "ASC"]]
      })

      res.status(200).json({
        status: true,
        message: "Berhasil mengambil data layanan Anda",
        data,
      })
    } catch (err) {
      console.log(err)
      res.status(500).json({
        status: false,
        message: "Terjadi kesalahan, silahkan coba lagi",
        data: {},
      })
    }
  }

  static createLayanan(req, res) {
    const { idBidan } = req
    const layanan = req.body

    LayananModel.create({ idBidan, ...layanan })
      .then((data) => {
        res.status(201).json({
          status: true,
          message: "Berhasil menambah layanan",
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

  static async updateGambarLayanan(req, res) {
    const { id } = req.params
    const file = req.file
    const gambar = file.filename
    
    try {
      const layanan = await LayananModel.findByPk(id)
      const gambarLama = layanan.gambar
      await layanan.update({ gambar })

      if (gambarLama) {
        fs.unlink(`images/${gambarLama}`, (error) => {
          if (error && error.errno !== -4058) console.log(error)
        })
      }

      res.status(200).json({
        status: true,
        message: "Berhasil update gambar layanan",
        data: {},
      })
    } catch (err) {
      console.log(err)
      fs.unlink(file.path, (error) => {
        if (error && error.errno !== -4058) console.log(error)
      })
      res.status(500).json({
        status: false,
        message: "Terjadi kesalahan, silahkan coba lagi",
        data: {},
      })
    }
  }

  static async updateLayanan(req, res) {
    try {
      const { idBidan } = req
      const { id } = req.params
      const layanan = req.body

      await LayananModel.update(layanan, {
        where: { idBidan, id }
      })
      res.status(200).json({
        status: true,
        message: "Berhasil mengupdate layanan",
        data: {},
      })
    } catch (err) {
      console.log(err)
      res.status(500).json({
        status: false,
        message: "Terjadi kesalahan, silahkan coba lagi",
        data: {},
      })
    }
  }

  static async deleteLayanan(req, res) {
    try {
      const { idBidan } = req
      const { id } = req.params

      const gambar = (await LayananModel.findByPk(id)).gambar
      fs.unlink(`images/${gambar}`, (error) => {
        if (error) throw error
      })

      await LayananModel.destroy({ where: { id, idBidan } })
      res.status(200).json({
        status: true,
        message: "Berhasil menghapus layanan",
        data: {},
      })
    } catch (err) {
      console.log(err)
      res.status(500).json({
        status: false,
        message: "Terjadi kesalahan, silahkan coba lagi",
        data: {},
      })
    }
  }

  static getKategoriLayanan(req, res) {
    KategoriLayananModel.findAll({
      order: [["nama", "ASC"]]
    })
      .then((data) => {
        res.status(200).json({
          status: true,
          message: "Berhasil mengambil kategori layanan",
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

module.exports = LayananController