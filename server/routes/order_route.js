const express = require("express")
const authentication = require("../middlewares/authentication")
const OrderController = require("../controllers/order_controller")
const isBidan = require("../middlewares/is_bidan")
const router = express.Router()

router.post("/pesan", authentication, OrderController.createOrder)
router.get("/riwayat", authentication, OrderController.getRiwayat)
router.get("/riwayat_pelayanan", authentication, isBidan, OrderController.riwayatPelayanan)
router.put("/update_status/:id", authentication, OrderController.updateStatus)

module.exports = router