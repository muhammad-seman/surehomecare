const AdminModel = require("../models/admin_model");
const BidanModel = require("../models/bidan_model");
const LayananModel = require("../models/layanan_model");
const OrderModel = require("../models/order_model");
const RequestBidanModel = require("../models/request_bidan_model");
const UserModel = require("../models/user_model");
const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const secret = process.env.BCRYPT_SECRET

class AdminController {
  static async loginAdmin(req, res) {
    try {
      const { email, password } = req.body

      const admin = await AdminModel.findOne({
        where: { username: email }
      })
      let bidan = await UserModel.findOne({
        where: { email },
      })

      let bidanPassword = bidan?.password ?? null

      if (bidan !== null) {
        bidan = await BidanModel.findOne({
          where: { idBidan: bidan.id }
        })
      }
      
      if (bidan === null) {
        bidan = admin
        bidanPassword = admin?.password ?? null
      }
      if (bidan === null) {
        return res.status(401).json({
          status: false,
          message: "Email atau username belum terdaftar",
          data: {},
        })
      }
      
      const validation = bcrypt.compareSync(password, bidanPassword)
      if (!validation) {
        res.status(401).json({
          status: false,
          message: "Password yang Anda masukkan salah",
          data: {},
        })
        return
      }
  
      const id = admin ? admin.id : bidan.id
      const token = jwt.sign({ id }, secret)
      const role = admin ? "admin" : "bidan"

      if (role === "bidan") {
        await BidanModel.update({ token }, {
          where: { id }
        })
      } else {
        await AdminModel.update({ token }, {
          where: { id }
        })
      }

      res.status(200).json({
        status: true,
        message: "Berhasil login",
        data: { token, role },
      })
    } catch (error) {
      console.log(error)
      res.status(500).json({
        status: false,
        message: "Terjadi kesalahan, silahkan coba lagi",
        data: {},
      })
    }
  }

  static async requestDaftar(req, res) {
    try {
      const requestBidan = req.body
      const { email } = requestBidan

      const existingUser = await UserModel.findOne({
        where: { email }
      })
      if (existingUser) {
        res.status(409).json({
          status: false,
          message: "Email sudah terdaftar",
          data: {},
        })
        return
      }

      const existingRequest = await RequestBidanModel.findOne({
        where: { email }
      })
      if (existingRequest) {
        res.status(409).json({
          status: false,
          message: "Email sudah melakukan pengajuan",
          data: {},
        })
        return
      }

      const data = await RequestBidanModel.create(requestBidan)
      res.status(201).json({
        status: true,
        message: "Berhasil mengajukan pendaftaran",
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

  static async getDaftarRequests(req, res) {
    const { id } = req.params
    const where = id ? { id } : {}
    
    try {
      const listRequestsRaw = await RequestBidanModel.findAll({
        include: ["kecamatan"],
        where,
      })
      const listRequests = listRequestsRaw.map((requestBidan) => {
        const item = requestBidan.get({ plain: true })
        item.kecamatan = item.kecamatan.nama
        return item
      })
      const data = id ? listRequests[0] : listRequests

      res.status(200).json({
        status: true,
        message: "Berhasil mengambil pengajuan pendaftaran",
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

  static async approveDaftarRequest(req, res) {
    try {
      const { id } = req.params
  
      const requestBidan = (await RequestBidanModel.findByPk(id)).get({ plain: true })
      const user = (await UserModel.create(requestBidan))
      const bidan = await BidanModel.create({ idBidan: user.id, ...requestBidan })

      await user.update({ password: requestBidan.password })
      await RequestBidanModel.destroy({
        where: { id }
      })

      res.status(201).json({
        status: true,
        message: "Berhasil mendaftarkan bidan",
        data: bidan,
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

  static tolakDaftarRequest(req, res) {
    const { id } = req.params
    
    RequestBidanModel.destroy({ where: { id } })
      .then((_) => {
        res.status(200).json({
          status: true,
          message: "Berhasil menolak pendaftaran",
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

  static async dashboardData(req, res) {
    try {
      const results = await Promise.allSettled([
        OrderModel.count(),
        BidanModel.count(),
        UserModel.count(),
      ])
      const raw = results.map((result) => result.value)
      
      const data = []
      data.push({ title: "Transaksi", value: raw[0] })
      data.push({ title: "Bidan", value: raw[1] })
      data.push({ title: "User", value: raw[2] - raw [1] })

      res.status(200).json({
        status: true,
        message: "Berhasil mengambil data dashboard",
        data,
      })
    } catch (err) {
      console.log(err)
      res.status(500).json({
        status: false,
        message: "Terjadi kesalahan",
        data: {}
      })
    }
  }

  static async riwayatOrders(req, res) {
    try {
      const { idAdmin: idBidan, role } = req
      const where = role === "bidan" ? { idBidan } : {}

      const raw = await OrderModel.findAll({
        where,
        attributes: ["status", "createdAt"],
        order: [["createdAt", "DESC"]],
        include: [
          {
            association: "detailOrder",
            attributes: ["namaLayanan"],
          },
          {
            association: "user",
            attributes: ["nama"],
            include: [{ association: "kecamatan", attributes: ["nama"] }]
          },
          {
            association: "bidan",
            attributes: ["nama"],
          }
        ],
      })

      const data = raw.map((order) => {
        const newOrder = order.get()
        newOrder.kecamatanUser = newOrder.user.kecamatan.nama
        newOrder.user = newOrder.user.nama
        newOrder.bidan = newOrder.bidan.nama
        newOrder.layanan = newOrder.detailOrder.map((detail) => detail.namaLayanan)
        newOrder.tanggal = newOrder.createdAt
        delete newOrder.detailOrder
        delete newOrder.createdAt
        return newOrder
      })

      res.status(200).json({
        status: true,
        message: "Berhasil mengambil data transaksi",
        data,
      })
    } catch (err) {
      console.log(err)
      res.status(500).json({
        status: false,
        message: "Terjadi kesalahan",
        data: {}
      })
    }
  }

  static logout(req, res) {
    const id = req.idAdmin

    Promise.allSettled([
      UserModel.update({ token: null }, {
        where: { id }
      }),
      AdminModel.update({ token: null }, {
        where: { id }
      }),
    ])
      .then((_) => {
        res.status(200).json({
          status: true,
          message: "Berhasil logout",
          data: {},
        })
      })
      .catch((error) => {
        console.log(error)
        res.status(500).json({
          status: false,
          message: "Terjadi kesalahan, silahkan coba lagi",
          data: {},
        })
      })
  }

  static async dashboardDataBidan(req, res) {
    try {
      const { idAdmin } = req
      const { id: idBidan } = await BidanModel.findOne({
        where: { idBidan: idAdmin }
      })

      const listOrder = await OrderModel.findAll({
        where: {
          idBidan: idAdmin,
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
      const pendapatanString = `Rp ${pendapatan.toLocaleString()}`

      const jlhLayanan = await LayananModel.count({ where: { idBidan } })
      
      const data = [
        { title: "Jumlah Riwayat Pelayanan", value: jlhPelayanan },
        { title: "Jumlah Pendapatan", value: pendapatanString },
        { title: "Jumlah Layanan Anda", value: jlhLayanan },
      ]

      res.status(200).json({
        status: true,
        message: "Berhasil mengambil data dashboard",
        data,
      })
    } catch (err) {
      console.log(err)
      res.status(500).json({
        status: false,
        message: "Terjadi kesalahan",
        data: {}
      })
    }
  }

  static async getDaftarBidan(req, res) {
    try {
      const raw = await BidanModel.findAll({
        attributes: ["bersedia", "id"],
        order: [["createdAt", "DESC"]],
        include: [{
          association: "user",
          attributes: ["gambar", "nama", "email"],
          include: ["kecamatan"],
        }]
      })

      const data = raw.map((bidan) => {
        let bidanPlain = bidan.get({ plain: true })
        bidanPlain = { ...bidanPlain, ...bidanPlain.user }
        bidanPlain.kecamatan = bidanPlain.kecamatan.nama
        delete bidanPlain.user
        return bidanPlain
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
        message: "Terjadi kesalahan",
        data: {}
      })
    }
  }

  static async getDaftarUser(req, res) {
    try {
      const raw = await UserModel.findAll({
        attributes: ["gambar", "nama", "email", "id"],
        order: [["createdAt", "DESC"]],
        include: ["kecamatan"],
      })

      const data = raw.map((user) => {
        let userPlain = user.get({ plain: true })
        userPlain.kecamatan = userPlain.kecamatan.nama
        return userPlain
      })

      res.status(200).json({
        status: true,
        message: "Berhasil mengambil data user",
        data,
      })
    } catch (err) {
      console.log(err)
      res.status(500).json({
        status: false,
        message: "Terjadi kesalahan",
        data: {}
      })
    }
  }
}

module.exports = AdminController