const { Sequelize } = require("sequelize")
const OrderModel = require("../models/order_model")
const BidanModel = require("../models/bidan_model")

class OrderController {
  static getRiwayat(req, res) {
    const { idUser } = req

    OrderModel.findAll({
      where: { idUser },
      include: [
        {
          association: "detailOrder",
          attributes: ["namaLayanan", "jlhBayar"],
          include: [{
            association: "layanan",
            attributes: ["gambar"],
          }],
        },
        "bidan"
      ],
      order: [
        [Sequelize.literal("CASE WHEN tglSelesai IS NULL THEN 1 ELSE 2 END ASC")],
        ["tglSelesai", "DESC"],
      ]
    })
      .then((raw) => {
        const data = raw.map((riwayat) => {
          const riwayatPlain = riwayat.get({ plain: true })
          const bidan = {
            nama: riwayat.bidan.nama,
            thumbnail: riwayat.bidan.gambar,
          }
          riwayatPlain.bidan = bidan
          return riwayatPlain
        })

        res.status(200).json({
          status: true,
          message: "Berhasil mengambil data riwayat",
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

  static createOrder = async (req, res) => {
    try {
      const { idUser } = req
      const order = req.body
      order.idUser = idUser

      const ongoing = await OrderModel.findOne({
        where: {
          idUser,
          status: ["ongoing", "diajukan"],
        }
      })
      if (ongoing) {
        return res.status(403).json({
          status: false,
          message: "Pesanan terakhir belum selesai",
          data: { ongoing: "user" },
        })
      }

      const bidanOngoing = await OrderModel.findOne({
        where: {
          idBidan: order.idBidan,
          status: ["ongoing", "diajukan"],
        }
      })
      if (bidanOngoing) {
        return res.status(403).json({
          status: false,
          message: "Bidan ini tidak lagi bersedia",
          data: { ongoing: "bidan" },
        })
      }
  
      await OrderModel.create(order, {
        include: ["detailOrder"]
      })
      res.status(201).json({
        status: true,
        message: "Berhasil membuat order",
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

  static async riwayatPelayanan(req, res) {
    try {
      const { idUser: idBidan } = req
      
      const data = await OrderModel.findAll({
        where: { idBidan },
        order: [["tglSelesai", "DESC"]],
        include: [
          {
            association: "detailOrder",
            attributes: ["namaLayanan", "jlhBayar"],
          },
          {
            association: "user",
            attributes: ["nama", "gambar", "alamat", "latitude", "longitude"],
          },
        ],
      })

      res.status(200).json({
        status: true,
        message: "Berhasil mengambil riwayat pelayanan",
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

  static updateStatus(req, res) {
    const { id } = req.params
    const { status } = req.body
    const tglSelesai = status === "selesai" ? new Date() : null

    OrderModel.update({ status, tglSelesai }, {
      where: { id }
    })
      .then((_) => {
        res.status(200).json({
          status: true,
          message: "Berhasil mengupdate status",
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

  static async checkBidanOrder(idUser) {
    const bidan = await BidanModel.findOne({
      where: { idBidan: idUser },
      attributes: ["id"],
    })
    if (!bidan) return null
    let order = await OrderModel.findOne({
      where: {
        idBidan: idUser,
        status: "diajukan",
      },
      attributes: ["id"],
      include: [
        {
          association: "user",
          attributes: ["nama", "gambar", "latitude", "longitude", "alamat"],
        },
        {
          association: "detailOrder",
          attributes: ["namaLayanan"],
        }
      ],
    })

    if (!order) return null
    order = order.get({ plain: true })
    const detailOrder = order.detailOrder.map((order) => order.namaLayanan);

    return {
      id: order.id,
      ...order.user,
      detailOrder,
    }
  }
}

module.exports = OrderController