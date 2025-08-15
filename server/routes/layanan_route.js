const express = require("express")
const authentication = require("../middlewares/authentication")
const LayananController = require("../controllers/layanan_controller")
const isBidan = require("../middlewares/is_bidan")
const uploadGambarLayanan = require("../middlewares/upload_gambar_layanan")
const router = express.Router()

router.put("/sync", authentication, isBidan, LayananController.syncLayanan)
router.get("/", authentication, isBidan, LayananController.getLayanan)

router.post("/", authentication, isBidan, LayananController.createLayanan)
router.put("/:id", authentication, isBidan, LayananController.updateLayanan)
router.put("/upload_gambar/:id", uploadGambarLayanan, LayananController.updateGambarLayanan)

router.delete("/:id", authentication, isBidan, LayananController.deleteLayanan)
router.get("/kategori", authentication, isBidan, LayananController.getKategoriLayanan)

module.exports = router