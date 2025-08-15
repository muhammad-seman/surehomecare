const express = require("express")
const UserController = require("../controllers/user_controller")
const authentication = require("../middlewares/authentication")
const uploadGambarProfil = require("../middlewares/upload_gambar_profil")
const router = express.Router()

router.get("/profile", authentication, UserController.getProfile)
router.post("/register", UserController.registerUser)
router.post("/login", UserController.loginUser)
router.get("/logout", authentication, UserController.logoutUser)
router.post("/request_ubah_password", UserController.requestUbahPassword)
router.post("/check_otp", UserController.checkOTP)
router.post("/ubah_password_otp", UserController.ubahPasswordOTP)
router.put("/ubah_password", authentication, UserController.ubahPassword)
router.put("/user/update_foto", authentication, uploadGambarProfil, UserController.updateFotoProfil)
router.put("/profile", authentication, UserController.updateProfil)
router.delete("/user/hapus_foto", authentication, uploadGambarProfil, UserController.hapusFotoProfil)

module.exports = router