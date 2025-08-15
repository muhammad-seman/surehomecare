const UserModel = require("../models/user_model")
const bcrypt = require("bcrypt")
const jwt = require("jsonwebtoken")
const { defaultExclude } = require("../utils/constants")
const nodemailer = require("nodemailer")
const BidanModel = require("../models/bidan_model")
const fs = require("fs")

const secret = process.env.BCRYPT_SECRET
const saltRounds = parseInt(process.env.BCRYPT_SALT_ROUNDS)

class UserController {
  static async getProfile(req, res) {
    try {
      const id = req.idUser
      
      const user = await UserModel.findOne({
        where: { id },
        include: [{
          association: "kecamatan",
          include: ["provinsi"],
        }],
        attributes: defaultExclude,
        raw: true, nest: true,
      })

      let bidan = await BidanModel.findOne({
        where: { idBidan: user.id },
        attributes: ["keterangan", "bersedia"],
      })
      user.isBidan = bidan != null
    
      res.status(200).json({
        status: true,
        message: "Berhasil mengambil profil user",
        data: user,
        bidan,
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

  static async registerUser(req, res) {
    try {

      const data = req.body
      const { email } = data

      delete data.alamat[0].id

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
  
      const user = await UserModel.create(data)
      const { id } = user
      const token = jwt.sign({ id }, secret)
      await user.update({ token })

      UserModel.findOne({
        where: { id },
        include: [{
          association: "kecamatan",
          include: ["provinsi"],
        }],
        attributes: defaultExclude,
      })
        .then((userData) => {
          const data = userData.get()
          data.isBidan = false
          res.status(200).json({
            status: true,
            message: "Berhasil menambahkan user",
            data: userData,
          })
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

  static loginUser = async (req, res) => {
    try {
      const { email, password } = req.body
  
      const user = await UserModel.findOne({
        where: { email },
      })
      if (user === null) {
        res.status(401).json({
          status: false,
          message: "Email belum terdaftar",
          data: {},
        })
        return
      }
  
      const validation = bcrypt.compareSync(password, user.password)
      if (!validation) {
        res.status(401).json({
          status: false,
          message: "Password yang Anda masukkan salah",
          data: {},
        })
        return
      }
  
      const id = user.id
      const token = jwt.sign({ id }, secret)
      await user.update({ token })

      const userBaru = (await UserModel.findOne({
        where: { id },
        include: [{
          association: "kecamatan",
          include: ["provinsi"],
        }],
        attributes: defaultExclude,
      })).get()

      let bidan = await BidanModel.findOne({
        where: { idBidan: user.id },
        attributes: ["keterangan", "bersedia"],
      })
      userBaru.isBidan = bidan != null

      res.status(200).json({
        status: true,
        message: "Berhasil login",
        data: userBaru,
        bidan,
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

  static logoutUser(req, res) {
    const id = req.idUser

    UserModel.update({ token: null }, {
      where: { id }
    })
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

  static async requestUbahPassword(req, res) {
    const { email } = req.body
    const kodeOTP = Math.floor(Math.random() * 1000000)

    const rows = await UserModel.update({ kodeOTP }, {
      where: { email }
    }).catch((err) => {
      console.log(err)
      res.status(500).json({
        status: false,
        message: "Gagal ubah password: Internal server error",
        data: {},
      })
    })

    if (rows[0] === 0) {
      res.status(404).json({
        status: false,
        message: "Email Anda tidak terdaftar",
        data: {},
      })
      return
    }

    const emailPengirim = process.env.NODEMAILER_SENDER_EMAIL
    const passwordPengirim = process.env.NODEMAILER_SENDER_PASSWORD
    const hostPengirim = process.env.NODEMAILER_SENDER_HOST

    const transporter = nodemailer.createTransport({
      host: hostPengirim,
      port: 465,
      secure: true,
      auth: {
        user: emailPengirim,
        pass: passwordPengirim,
      }
    })

    const mailOptions = {
      from: emailPengirim,
      to: email,
      subject: 'Ubah password iCare',
      text: `Kode OTP Anda adalah ${kodeOTP}`
    }

    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.log(error);
        res.status(500).json({
          status: false,
          message: "Gagal kirim kode OTP: Internal server error",
          data: {},
        })
        return
      }
      res.status(200).json({
        status: true,
        message: "Kode OTP telah dikirim ke email Anda",
        data: {},
      })
    });
  }

  static checkOTP(req, res) {
    const { email, kodeOTP } = req.body

    UserModel.findOne({ where: { email, kodeOTP } })
      .then((data) => {
        if (data === null) {
          res.status(404).json({
            status: false,
            message: "Kode OTP salah",
            data: {},
          })
          return
        }
        res.status(200).json({
          status: true,
          message: "Email dan kode OTP sudah benar",
          data: {},
        })
      })
      .catch((err) => {
        console.log(err)
        res.status(500).json({
          status: false,
          message: "Gagal check OTP: Internal server error",
          data: {},
        })
      })
  }

  static ubahPasswordOTP(req, res) {
    const { email, kodeOTP, password: passwordRaw } = req.body
    const password = bcrypt.hashSync(passwordRaw, saltRounds)

    UserModel.update({ password, kodeOTP: null }, { where: { email, kodeOTP } })
      .then((rows) => {
        if (rows[0] === 0) {
          res.status(404).json({
            status: false,
            message: "Email atau kode OTP salah",
            data: {},
          })
          return
        }
        res.status(200).json({
          status: true,
          message: "Password berhasil diubah",
          data: {},
        })
      })
      .catch((err) => {
        console.log(err)
        res.status(500).json({
          status: false,
          message: "Gagal ubah password: Internal server error",
          data: {},
        })
      })
  }

  static ubahPassword = async (req, res)  => {
    try {
      const { idUser: id } = req
      const { passwordLama, password: passwordRaw } = req.body
      const password = bcrypt.hashSync(passwordRaw, saltRounds)

      const user = await UserModel.findByPk(id)
      const validation = bcrypt.compareSync(passwordLama, user.password)
      if (!validation) {
        return res.status(403).json({
          status: false,
          message: "Password lama salah",
          data: {},
        })
      }

      await user.update({ password })

      res.status(200).json({
        status: true,
        message: "Password berhasil diubah",
        data: {},
      })
    } catch (err) {
      console.log(err)
      res.status(500).json({
        status: false,
        message: "Gagal ubah password: Internal server error",
        data: {},
      })
    }
  }

  static updateProfil(req, res) {
    const profil = req.body
    const { idUser: id } = req

    UserModel.update(profil, {
      where: { id }
    })
      .then((_) => {
        res.status(200).json({
          status: true,
          message: "Password update profil",
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

  static async updateFotoProfil(req, res) {
    const { idUser } = req
    const file = req.file
    const fileName = file.filename

    try {
      if (!req.file) {
        return res.status(400).json({
          status: false,
          message: "Tidak ada file yang di upload",
          data: {},
        })
      }
  
      const user = await UserModel.findByPk(idUser)
      const gambarLama = user.gambar
      fs.unlink(`images/${gambarLama}`, (error) => {
        if (error && error.errno !== -4058) console.log(error)
      })

      await user.update({ gambar: fileName })
      res.status(200).json({
        status: true,
        message: "Foto profil berhasil di update",
        data: {
          gambar: fileName
        },
      })
    } catch (err) {
      console.log(err)
      fs.unlink(file.path)
      res.status(500).json({
        status: false,
        message: "Terjadi kesalahan, silahkan coba lagi",
        data: {},
      })
    }
  }

  static async hapusFotoProfil(req, res) {
    try {
      const { idUser } = req
      
      const user = await UserModel.findByPk(idUser)
      const gambar = user.gambar
      fs.unlink(`images/${gambar}`, (error) => {
        if (error && error.errno !== -4058) console.log(error)
      })
      await user.update({ gambar: null })
      res.status(200).json({
        status: true,
        message: "Foto profil berhasil dihapus",
        data: {}
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
}

module.exports = UserController