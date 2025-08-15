const { Op } = require("sequelize")
const BidanModel = require("../models/bidan_model")
const FavoriteBidanModel = require("../models/favorite_bidan_model")
const OrderModel = require("../models/order_model")
const UserModel = require("../models/user_model")
const LayananModel = require("../models/layanan_model")
const fs = require('fs')

class BidanController {
  static getBidanByKota = async (req, res) => {
    try {
      const { idUser } = req
      const { idKecamatan } = await UserModel.findByPk(idUser)
      
      let listBidan = await BidanModel.findAll({
        include: [
          "layanan",
          {
            association: "user",
            attributes: ["nama", "gambar", "id", "idKecamatan"],
          },
        ],
        attributes: ["id", "keterangan", "bersedia"],
        // // IDEA: remove
        order: [["user", "nama", "ASC"]],
      })
      
      listBidan = await this.parseListBidan(listBidan)


      const data = listBidan.filter((bidan) => {
        return bidan.idKecamatan === idKecamatan
      })

      res.status(200).json({
        status: true,
        message: "Berhasil mengambil data bidan",
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

  static async getBidanDetails(req, res) {
    try {
      const { idUser } = req
      const { idBidan } = req.params

      const favorite = await FavoriteBidanModel.findOne({
        where: { idUser, idBidan }
      })
      const isFavorite = favorite !== null
      const listLayanan = await LayananModel.findAll({
        where: { idBidan },
        order: [["nama", "ASC"]]
      })

      res.status(200).json({
        status: true,
        message: "Berhasil mengambil data detail bidan",
        data: { isFavorite, listLayanan },
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

  static searchBidan = async (req, res) => {
    try {
      const { search } = req.params
      let listBidan = await BidanModel.findAll({
        attributes: ["id", "keterangan", "bersedia"],
        include: [
          {
            association: "layanan",
            attributes: ["id"],
          },
          {
            association: "user",
            where: {
              nama: { [Op.like]: `%${search}%` },
            },
            attributes: ["id", "nama", "gambar"],
            order: [["bersedia", "DESC"]]
          }
        ],
      })
      const data = await this.parseListBidan(listBidan)

      res.status(200).json({
        status: true,
        message: "Berhasil mengambil data pencarian bidan",
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

  static recentBidan = async (req, res) => {
    try {
      const { idUser } = req
  
      const rawId = await OrderModel.findAll({
        where: { idUser },
        attributes: ["idBidan"],
        raw: true, nest: true,
      })

      const listId = rawId.map((idObject) => {
        return idObject.idBidan
      })

      // IDEA: order from most recent
      
      let listBidan = await BidanModel.findAll({
        limit: 4,
        attributes: ["id", "keterangan", "bersedia"],
        include: [
          {
            association: "layanan",
            attributes: ["id"],
          },
          {
            association: "user",
            where: { id: listId },
            attributes: ["id", "nama", "gambar"],
          }
        ],
      })
      const data = await this.parseListBidan(listBidan)
      
      res.status(200).json({
        status: true,
        message: "Berhasil mengambil data bidan terakhir",
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

  static updateProfilBidan(req, res) {
    const { idBidan, idUser } = req
    const { nama, keterangan, idKecamatan } = req.body

    Promise.allSettled([
      UserModel.update({ nama, idKecamatan }, { where: { id: idUser } }),
      BidanModel.update({ keterangan }, { where: { id: idBidan } })
    ])
      .then((rows) => {
        res.status(200).json({
          status: true,
          message: "Berhasil mengupdate profil bidan",
          data: {},
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

  static updateKesediaan(req, res) {
    const { idBidan } = req
    const { bersedia: bersediaRaw } = req.params
    const bersedia = JSON.parse(bersediaRaw)

    BidanModel.update({ bersedia }, { where: { id: idBidan } })
      .then((_) => {
        res.status(200).json({
          status: true,
          message: "Berhasil mengupdate kesediaan bidan",
          data: { bersedia },
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

  static async getStatistics(req, res) {
    try {
      const { idUser } = req

      const listOrder = await OrderModel.findAll({
        where: {
          idBidan: idUser,
          status: "selesai",
        },
        include: [{
          association: "detailOrder",
          attributes: ["jlhBayar"],
        }],
        attributes: [],
        raw: true, nest: true,
      })

      const jlhPelayanan = listOrder.length
      const listTotal = listOrder.map((order) => order.detailOrder.jlhBayar)
      const pendapatan =
        listTotal.length !== 0
          ? listTotal.reduce((v, e) => v + e)
          : 0

      res.status(200).json({
        status: true,
        message: "Berhasil mengambil statistik",
        data: {
          jlhPelayanan,
          pendapatan,
        },
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

  static async setFavoriteBidan(req, res) {
    try {
      const { idUser } = req
      const { idBidan } = req.params
      const { status } = req.body

      const data = { idUser, idBidan }

      if (status) {
        await FavoriteBidanModel.create(data)
      } else {
        await FavoriteBidanModel.destroy({ where: data })
      }

      res.status(200).json({
        status: true,
        message: "Berhasil update favorite bidan",
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

  static allFavoriteBidan = async (req, res) => {
    try {
      const { idUser } = req

      const listFavorite = await FavoriteBidanModel.findAll({
        where: { idUser },
        include: [{
          association: "bidan",
          attributes: ["id", "keterangan", "bersedia"],
          include: [
            {
              association: "layanan",
              attributes: ["id"],
            },
            {
              association: "user",
              attributes: ["id", "nama", "gambar"],
            }
          ],
        }]
      })

      const bidanRaw = listFavorite.map((favorite) => favorite.bidan)
      const data = await this.parseListBidan(bidanRaw)
      
      res.status(200).json({
        status: true,
        message: "Berhasil mengambil data favorite bidan",
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

  static parseListBidan = async (listRaw) => {
    const listBidan = listRaw.map(this.parseBidan)
    const promises = listBidan.map(async (bidan) => {
      const ongoing = await OrderModel.findOne({
        where: {
          idBidan: bidan.id,
          status: ["ongoing", "diajukan"],
        }
      })
      if (ongoing) bidan.bersedia = false
      return bidan
    })
    const results = await Promise.allSettled(promises)
    return results.map((result) => result.value)
  }

  static parseBidan(bidan) {
    let newBidan = bidan.get({ plain: true })
      
      newBidan.idDetails = newBidan.id
      newBidan.jlhLayanan = newBidan.layanan.length
      delete newBidan.layanan
      newBidan = { ...newBidan, ...newBidan.user }
      delete newBidan.user

      return newBidan
  }
}

module.exports = BidanController