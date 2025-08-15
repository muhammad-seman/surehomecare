const express = require("express")
const DaerahController = require("../controllers/daerah_controller")
const router = express.Router()

router.get("/provinsi", DaerahController.getProvinsi)
router.get("/kecamatan", DaerahController.getKecamatan)
router.get("/kecamatan/:idProvinsi", DaerahController.getKecamatan)

module.exports = router