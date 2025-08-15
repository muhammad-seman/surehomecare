const { Op } = require("sequelize")
const MessageModel = require("../models/message_model")
const OrderController = require("./order_controller")

class MessageController {
  static homeMessages = async (req, res) => {
    try {
      const { idUser } = req

      const listMessages = await MessageModel.findAll({
        where: {
          [Op.or]: [{ pengirim: idUser }, { penerima: idUser }]
        },
        include: ["pengirimData", "penerimaData"],
        order: [["createdAt", "DESC"]],
        raw: true, nest: true,
      })
      this.markTerkirim(listMessages, idUser)

      const listHomeMessages = listMessages.map((message) => this.parseMessage(message, idUser))

      const data = []
      listHomeMessages.forEach((homeMessage) => {
        const opposeExitsts = data.some((message) => message.oppose.id === homeMessage.oppose.id)
        if (!opposeExitsts) data.push(homeMessage)
      })

      res.status(200).json({
        status: true,
        message: "Berhasil mengambil semua pesanan",
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

  static checkMessages = async (req, res) => {
    try {
      const { idUser } = req
      const { idOppose } = req.params

      const listMessages = await MessageModel.findAll({
        where: {
          penerima: idUser,
          tglTerkirim: null,
        },
        order: [["createdAt", "ASC"]],
        raw: true, nest: true,
      })
      this.markTerkirim(listMessages, idUser)

      const hasUnread = listMessages.some((message) => {
        return message.tglBaca !== null
      })

      const filtered = listMessages.filter((message) => {
        const idPengirim = message.pengirim
        const idOpposeBaru = idPengirim === idUser ? message.penerima : message.pengirim
        return idOpposeBaru === idOppose
      })

      const data = filtered.map((message) => {
        const isPengirim = message.pengirim === idUser
        message.isPengirim = isPengirim
        delete message.pengirim
        delete message.penerima
        return message
      })

      const bidanOrder = await OrderController.checkBidanOrder(idUser)

      res.status(200).json({
        status: true,
        message: "Berhasil check pesanan",
        hasUnread,
        data,
        bidanOrder,
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

  static fullChatroomMessages = async (req, res) => {
    try {
      const { idUser } = req
      const { idOppose } = req.params

      const listMessages = await MessageModel.findAll({
        where: {
          [Op.and]: [
            {[Op.or]: [{ pengirim: idUser }, { penerima: idUser }]},
            {[Op.or]: [{ pengirim: idOppose }, { penerima: idOppose }]},
          ],
        },
        order: [["createdAt", "ASC"]],
        raw: true, nest: true,
      })
      this.markTerkirim(listMessages, idUser)

      const data = listMessages.map((message) => {
        const isPengirim = message.pengirim === idUser
        message.isPengirim = isPengirim
        delete message.pengirim
        delete message.penerima
        return message
      })

      res.status(200).json({
        status: true,
        message: "Berhasil mengambil data chatroom",
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

  static readMessage(req, res) {
    const penerima = req.idUser
    const { pengirim } = req.params

    const tglBaca = new Date()
    MessageModel.update({ tglBaca }, {
      where: {
        penerima,
        pengirim,
        tglBaca: null,
      }
    })
      .then((_) => {
        res.status(200).json({
          status: true,
          message: "Berhasil membaca pesan",
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

  static sendMessage = async (req, res)  => {
    try {
      const pengirim = req.idUser
      const message = req.body
      message.pengirim = pengirim

      const newMessage = await MessageModel.create(message, pengirim)
      const raw = await MessageModel.findByPk(newMessage.id, {
        include: ["pengirimData", "penerimaData"],
        raw: true, nest: true,
      })
      const data = this.parseMessage(raw, pengirim)

      res.status(201).json({
        status: true,
        message: "Berhasil mengirim pesan",
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

  static markTerkirim = (listMessages, idUser) => {
    const listMarkTerkirim = listMessages.filter((message) => {
      return message.penerima === idUser
    })
    const listId = listMarkTerkirim.map((message) => message.id)
    const tglTerkirim = new Date()
    MessageModel.update({ tglTerkirim }, {
      where: { id: listId }
    })
  }

  static parseMessage = (message, idUser) => {
    const isPengirim = message.pengirim === idUser
    const oppose = isPengirim ? message.penerimaData : message.pengirimData
    return {
      id: message.id,
      oppose: {
        id: oppose.id,
        nama: oppose.nama,
        gambar: oppose.gambar,
      },
      isPengirim,
      isi: message.isi,
      createdAt: message.createdAt,
      tglTerkirim: message.tglTerkirim,
      tglBaca: message.tglBaca,
    }
  }
}

module.exports = MessageController